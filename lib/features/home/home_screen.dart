import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/locale_scope.dart';
import '../../models/recording_filter_tab.dart';
import '../../models/recording_item.dart';
import '../../models/recording_sort.dart';
import '../../services/app_preferences_service.dart';
import '../../services/recordings_repository.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/recording_list_tile.dart';
import '../recording/playback_sheet.dart';
import '../recording/recording_flow.dart';
import '../recording/recording_type.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = RecordingsRepository();
  late final RecordingFlow _flow;
  final _searchController = TextEditingController();
  RecordingFilterTab _tab = RecordingFilterTab.incoming;
  RecordingSort _sort = RecordingSort.newest;
  RecordingModePreference _mode = RecordingModePreference.manual;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _flow = RecordingFlow(repository: _repository);
    _repository.addListener(_refresh);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final mode = await AppPreferencesService().getRecordingMode();
    await _repository.loadRecordings();
    if (!mounted) return;
    setState(() {
      _mode = mode;
      _loading = false;
    });
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _searchController.dispose();
    _repository.removeListener(_refresh);
    _repository.dispose();
    super.dispose();
  }

  List<RecordingItem> get _visible => _repository.forTab(
        _tab,
        query: _searchController.text,
        sort: _sort,
      );

  String _titleForTab() {
    switch (_tab) {
      case RecordingFilterTab.all:
        return context.l10n.tabAll;
      case RecordingFilterTab.incoming:
        return context.l10n.tabIncoming;
      case RecordingFilterTab.outgoing:
        return context.l10n.tabOutgoing;
      case RecordingFilterTab.favorites:
        return context.l10n.tabFavorites;
    }
  }

  Future<void> _quickRecord() async {
    switch (_mode) {
      case RecordingModePreference.callNote:
        await _flow.startCallNote(context);
      case RecordingModePreference.meeting:
        await _flow.startMeeting(context);
      case RecordingModePreference.manual:
        await _flow.startMeeting(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.crimsonDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text(
            _titleForTab(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          actions: [
            IconButton(
              tooltip: l10n.language,
              onPressed: () => showLanguageSelector(context),
              icon: const Icon(Icons.translate_rounded),
            ),
            IconButton(
              tooltip: l10n.settings,
              onPressed: () async {
                await Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      onRecordingModeChanged: (mode) {
                        setState(() => _mode = mode);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton(
              tooltip: l10n.newRecording,
              onPressed: _quickRecord,
              icon: const Icon(Icons.phone_in_talk_outlined),
            ),
          ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.crimson),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: l10n.sort,
                        onPressed: _pickSort,
                        icon: const Icon(Icons.sort_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.newRecording,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ActionGrid(
                    onMeeting: () => _flow.startMeeting(context),
                    onCallNote: () => _flow.startCallNote(context),
                    onLogCall: () => _flow.logCall(context),
                    onIncoming: () => _flow.startType(
                      context,
                      RecordingType.incomingNote,
                    ),
                    onOutgoing: () => _flow.startType(
                      context,
                      RecordingType.outgoingNote,
                    ),
                    onVoice: () => _flow.startType(
                      context,
                      RecordingType.voiceNote,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildListContent(),
                ],
              ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
            color: AppColors.surface,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.description_outlined,
                    selectedIcon: Icons.description,
                    label: l10n.tabAllNav,
                    selected: _tab == RecordingFilterTab.all,
                    onTap: () =>
                        setState(() => _tab = RecordingFilterTab.all),
                  ),
                  _NavItem(
                    icon: Icons.phone_outlined,
                    selectedIcon: Icons.phone,
                    label: l10n.tabIncoming,
                    selected: _tab == RecordingFilterTab.incoming,
                    onTap: () =>
                        setState(() => _tab = RecordingFilterTab.incoming),
                  ),
                  _NavItem(
                    icon: Icons.star_border_rounded,
                    selectedIcon: Icons.star_rounded,
                    label: l10n.tabFavorites,
                    selected: _tab == RecordingFilterTab.favorites,
                    onTap: () =>
                        setState(() => _tab = RecordingFilterTab.favorites),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListContent() {
    final l10n = context.l10n;
    final items = _visible;
    final searching = _searchController.text.trim().isNotEmpty;

    if (items.isEmpty && !searching && _tab == RecordingFilterTab.incoming) {
      return Column(
        children: [
          _InfoRow(
            icon: Icons.folder_open_outlined,
            title: l10n.featureOrganizeTitle,
            subtitle: l10n.featureOrganizeBody,
          ),
          _InfoRow(
            icon: Icons.phone_outlined,
            title: l10n.featureIncomingTitle,
            subtitle: l10n.featureIncomingBody,
          ),
          _InfoRow(
            icon: Icons.auto_awesome_outlined,
            title: l10n.featureSimpleTitle,
            subtitle: l10n.featureSimpleBody,
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          searching ? l10n.noSearchResults : l10n.emptyCategory,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 1, indent: 72),
          RecordingListTile(
            item: items[i],
            onTap: () => _openItem(items[i]),
            onFavoriteToggle: () => _repository.toggleFavorite(items[i].id),
            onDelete: () => _flow.confirmDelete(context, items[i]),
          ),
        ],
      ],
    );
  }

  void _openItem(RecordingItem item) {
    showPlaybackSheet(
      context,
      item: item,
      repository: _repository,
      onDeleted: _refresh,
      onUpdated: _refresh,
    );
  }

  Future<void> _pickSort() async {
    final selected = await showModalBottomSheet<RecordingSort>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: RecordingSort.values
                .map(
                  (sort) => ListTile(
                    title: Text(context.l10n.sortLabel(sort)),
                    trailing: sort == _sort
                        ? const Icon(Icons.check, color: AppColors.crimson)
                        : null,
                    onTap: () => Navigator.pop(sheetContext, sort),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    if (selected != null) setState(() => _sort = selected);
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.onMeeting,
    required this.onCallNote,
    required this.onLogCall,
    required this.onIncoming,
    required this.onOutgoing,
    required this.onVoice,
  });

  final VoidCallback onMeeting;
  final VoidCallback onCallNote;
  final VoidCallback onLogCall;
  final VoidCallback onIncoming;
  final VoidCallback onOutgoing;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      _ActionData(Icons.groups_outlined, l10n.recordMeeting, onMeeting),
      _ActionData(Icons.phone_in_talk_outlined, l10n.callNoteAfter, onCallNote),
      _ActionData(Icons.event_note_outlined, l10n.logCall, onLogCall),
      _ActionData(
        Icons.call_received_rounded,
        l10n.recordingTypeIncoming,
        onIncoming,
      ),
      _ActionData(
        Icons.call_made_rounded,
        l10n.recordingTypeOutgoing,
        onOutgoing,
      ),
      _ActionData(Icons.mic_none_rounded, l10n.recordingTypeVoice, onVoice),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.15,
      children: actions
          .map(
            (action) => Material(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: action.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(action.icon, color: AppColors.crimson),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          action.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActionData {
  const _ActionData(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: AppColors.chipBackground,
        child: Icon(icon, color: AppColors.crimson),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.crimson : AppColors.iconMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? selectedIcon : icon, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
