import '../features/recording/recording_type.dart';
import '../models/recording_sort.dart';
import '../services/app_preferences_service.dart';
import 'app_locale.dart';

class AppStrings {
  AppStrings._(this.locale, this._m);

  final AppLocale locale;
  final Map<String, String> _m;

  String _t(String key) => _m[key] ?? key;

  // --- Home & tabs ---
  String get tabAll => _t('tabAll');
  String get tabAllNav => _t('tabAllNav');
  String get tabIncoming => _t('tabIncoming');
  String get tabOutgoing => _t('tabOutgoing');
  String get tabFavorites => _t('tabFavorites');
  String get emptyList => _t('emptyList');
  String get myRecordings => _t('myRecordings');
  String get emptySubtitle => _t('emptySubtitle');
  String get recordMeeting => _t('recordMeeting');
  String get recordMeetingSubtitle => _t('recordMeetingSubtitle');
  String get callNoteAfter => _t('callNoteAfter');
  String get callNoteAfterSubtitle => _t('callNoteAfterSubtitle');
  String get defaultBadge => _t('defaultBadge');
  String get emptyCategory => _t('emptyCategory');
  String get language => _t('language');
  String get selectLanguage => _t('selectLanguage');

  // --- Snackbars ---
  String get micPermissionRequired => _t('micPermissionRequired');
  String get audioSaveFailed => _t('audioSaveFailed');
  String get recordingSaved => _t('recordingSaved');
  String get recordingDeleted => _t('recordingDeleted');
  String get recordingRemovedFromList => _t('recordingRemovedFromList');
  String get fileNotFound => _t('fileNotFound');
  String get ratingUnavailable => _t('ratingUnavailable');

  // --- Recording types ---
  String recordingTypeTitle(RecordingType type) {
    switch (type) {
      case RecordingType.meeting:
        return recordingTypeMeeting;
      case RecordingType.incomingNote:
        return recordingTypeIncoming;
      case RecordingType.outgoingNote:
        return recordingTypeOutgoing;
      case RecordingType.voiceNote:
        return recordingTypeVoice;
      case RecordingType.loggedCall:
        return recordingTypeLogged;
    }
  }

  String recordingTypeBadge(RecordingType type) {
    switch (type) {
      case RecordingType.meeting:
        return badgeMeeting;
      case RecordingType.incomingNote:
        return badgeIncoming;
      case RecordingType.outgoingNote:
        return badgeOutgoing;
      case RecordingType.voiceNote:
        return badgeVoice;
      case RecordingType.loggedCall:
        return badgeLogged;
    }
  }

  String get recordingTypeMeeting => _t('recordingTypeMeeting');
  String get recordingTypeIncoming => _t('recordingTypeIncoming');
  String get recordingTypeOutgoing => _t('recordingTypeOutgoing');
  String get recordingTypeVoice => _t('recordingTypeVoice');
  String get recordingTypeLogged => _t('recordingTypeLogged');
  String get badgeMeeting => _t('badgeMeeting');
  String get badgeIncoming => _t('badgeIncoming');
  String get badgeOutgoing => _t('badgeOutgoing');
  String get badgeVoice => _t('badgeVoice');
  String get badgeLogged => _t('badgeLogged');

  // --- Call note sheet ---
  String get callNoteSheetTitle => _t('callNoteSheetTitle');
  String get callNoteSheetSubtitle => _t('callNoteSheetSubtitle');
  String get callNoteIncomingSubtitle => _t('callNoteIncomingSubtitle');
  String get callNoteOutgoingSubtitle => _t('callNoteOutgoingSubtitle');
  String get callNoteVoiceSubtitle => _t('callNoteVoiceSubtitle');

  // --- Recording screen ---
  String get micPermissionShort => _t('micPermissionShort');
  String get recordingStartFailed => _t('recordingStartFailed');
  String get recordingStopFailed => _t('recordingStopFailed');
  String get recordingTooShort => _t('recordingTooShort');
  String get recordingInProgress => _t('recordingInProgress');
  String get stopAndLeave => _t('stopAndLeave');
  String get continueAction => _t('continueAction');
  String get leave => _t('leave');
  String get consentBeforeRecord => _t('consentBeforeRecord');
  String get start => _t('start');
  String get stop => _t('stop');
  String get resume => _t('resume');
  String get skipBack => _t('skipBack');
  String get skipForward => _t('skipForward');
  String get speed => _t('speed');
  String get searchHint => _t('searchHint');
  String get sort => _t('sort');
  String get sortNewest => _t('sortNewest');
  String get sortOldest => _t('sortOldest');
  String get sortLongest => _t('sortLongest');
  String get sortTitle => _t('sortTitle');
  String get noSearchResults => _t('noSearchResults');
  String get logCall => _t('logCall');
  String get logCallSubtitle => _t('logCallSubtitle');
  String get callLogged => _t('callLogged');
  String get autoStart => _t('autoStart');
  String get autoStartBody => _t('autoStartBody');
  String get audioQuality => _t('audioQuality');
  String get qualityLow => _t('qualityLow');
  String get qualityStandard => _t('qualityStandard');
  String get qualityHigh => _t('qualityHigh');
  String get featureOrganizeTitle => _t('featureOrganizeTitle');
  String get featureOrganizeBody => _t('featureOrganizeBody');
  String get featureIncomingTitle => _t('featureIncomingTitle');
  String get featureIncomingBody => _t('featureIncomingBody');
  String get featureSimpleTitle => _t('featureSimpleTitle');
  String get featureSimpleBody => _t('featureSimpleBody');
  String get statsRecordings => _t('statsRecordings');
  String get statsTime => _t('statsTime');
  String get newRecording => _t('newRecording');

  // --- Save / edit sheets ---
  String get save => _t('save');
  String get edit => _t('edit');
  String get durationLabel => _t('durationLabel');
  String get duration => _t('duration');
  String get titleLabel => _t('titleLabel');
  String get contactOptional => _t('contactOptional');
  String get contact => _t('contact');
  String get noteOptional => _t('noteOptional');
  String get note => _t('note');
  String get type => _t('type');
  String get addToFavorites => _t('addToFavorites');
  String get favorite => _t('favorite');
  String get cancel => _t('cancel');
  String get date => _t('date');

  // --- Playback ---
  String get audioFileMissing => _t('audioFileMissing');
  String get playbackFailed => _t('playbackFailed');
  String get removeFromList => _t('removeFromList');
  String get play => _t('play');
  String get pause => _t('pause');
  String get share => _t('share');
  String get delete => _t('delete');
  String get favoriteTooltip => _t('favoriteTooltip');
  String get deleteTooltip => _t('deleteTooltip');

  // --- Dialogs ---
  String get micRequired => _t('micRequired');
  String get micRequiredBody => _t('micRequiredBody');
  String get allow => _t('allow');
  String get deleteRecordingTitle => _t('deleteRecordingTitle');
  String get deleteRecordingBody => _t('deleteRecordingBody');
  String get confirm => _t('confirm');

  // --- Disclaimer ---
  String get disclaimer => _t('disclaimer');

  // --- Settings drawer ---
  String get settings => _t('settings');
  String get recordingMode => _t('recordingMode');
  String get loading => _t('loading');
  String get audioSource => _t('audioSource');
  String get microphone => _t('microphone');
  String get audioChannel => _t('audioChannel');
  String get mono => _t('mono');
  String get audioRate => _t('audioRate');
  String get audioBitrate => _t('audioBitrate');
  String get privacyPolicy => _t('privacyPolicy');
  String get recordingConsent => _t('recordingConsent');
  String get about => _t('about');
  String get rateFiveStars => _t('rateFiveStars');
  String get drawerSafetyBanner => _t('drawerSafetyBanner');
  String get shareAppText => _t('shareAppText');

  // --- Recording mode ---
  String get modeManual => _t('modeManual');
  String get modeMeeting => _t('modeMeeting');
  String get modeCallNote => _t('modeCallNote');

  String recordingModeLabel(RecordingModePreference mode) {
    switch (mode) {
      case RecordingModePreference.manual:
        return modeManual;
      case RecordingModePreference.meeting:
        return modeMeeting;
      case RecordingModePreference.callNote:
        return modeCallNote;
    }
  }

  String qualityLabel(AudioQualityPreference quality) {
    switch (quality) {
      case AudioQualityPreference.low:
        return qualityLow;
      case AudioQualityPreference.standard:
        return qualityStandard;
      case AudioQualityPreference.high:
        return qualityHigh;
    }
  }

  String sortLabel(RecordingSort sort) {
    switch (sort) {
      case RecordingSort.newest:
        return sortNewest;
      case RecordingSort.oldest:
        return sortOldest;
      case RecordingSort.longest:
        return sortLongest;
      case RecordingSort.title:
        return sortTitle;
    }
  }

  // --- Onboarding ---
  String get appName => _t('appName');
  String get onboardingTagline => _t('onboardingTagline');
  String get onboardingManualTitle => _t('onboardingManualTitle');
  String get onboardingManualBody => _t('onboardingManualBody');
  String get onboardingMicTitle => _t('onboardingMicTitle');
  String get onboardingMicBody => _t('onboardingMicBody');
  String get onboardingImportantTitle => _t('onboardingImportantTitle');
  String get onboardingImportantBody => _t('onboardingImportantBody');
  String get onboardingCheckbox => _t('onboardingCheckbox');

  // --- Legal ---
  String get safetyStatement => _t('safetyStatement');
  String get localStorage => _t('localStorage');
  String get sharingPolicy => _t('sharingPolicy');
  String get consentResponsibility => _t('consentResponsibility');
  String get privacyIntro => _t('privacyIntro');
  String get consentIntro => _t('consentIntro');
  String get consentManualStart => _t('consentManualStart');
  String get consentUseFor => _t('consentUseFor');
  String get consentUseBullets => _t('consentUseBullets');
  String get aboutDescription => _t('aboutDescription');
  String get version => _t('version');

  String formatDurationLabel(Duration duration) =>
      '$durationLabel ${formatDuration(duration)}';

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String formatRecordingDate(DateTime date) {
    final months = _monthAbbreviations;
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }

  List<String> get _monthAbbreviations {
    switch (locale) {
      case AppLocale.fr:
        return [
          'janv.',
          'févr.',
          'mars',
          'avr.',
          'mai',
          'juin',
          'juil.',
          'août',
          'sept.',
          'oct.',
          'nov.',
          'déc.',
        ];
      case AppLocale.en:
        return [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
      case AppLocale.ar:
        return [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ];
      case AppLocale.es:
        return [
          'ene.',
          'feb.',
          'mar.',
          'abr.',
          'may.',
          'jun.',
          'jul.',
          'ago.',
          'sep.',
          'oct.',
          'nov.',
          'dic.',
        ];
    }
  }

  static final _instances = {
    for (final locale in AppLocale.values)
      locale: AppStrings._(locale, _maps[locale]!),
  };

  factory AppStrings(AppLocale locale) => _instances[locale]!;

  static final _maps = {
    AppLocale.fr: _fr,
    AppLocale.en: _en,
    AppLocale.ar: _ar,
    AppLocale.es: _es,
  };
}

const _fr = {
  'tabAll': 'Tous les enregistrements',
  'tabAllNav': 'Tous les enregi...',
  'tabIncoming': 'Entrant',
  'tabOutgoing': 'Sortant',
  'tabFavorites': 'Préféré',
  'emptyList': 'Liste vide',
  'myRecordings': 'Mes enregistrements',
  'emptySubtitle': 'Commencez un enregistrement manuel avec votre microphone.',
  'recordMeeting': 'Enregistrer réunion',
  'recordMeetingSubtitle':
      'Enregistrez des réunions ou conversations avec votre microphone',
  'callNoteAfter': 'Note après appel',
  'callNoteAfterSubtitle':
      'Sauvegardez une note vocale ou un résumé après un appel',
  'defaultBadge': 'Par défaut',
  'emptyCategory': 'Aucun enregistrement dans cette catégorie.',
  'language': 'Langue',
  'selectLanguage': 'Choisir la langue',
  'micPermissionRequired':
      'Autorisation du microphone requise pour enregistrer.',
  'audioSaveFailed': 'Le fichier audio n\'a pas pu être sauvegardé.',
  'recordingSaved': 'Enregistrement sauvegardé.',
  'recordingDeleted': 'Enregistrement supprimé.',
  'recordingRemovedFromList': 'Enregistrement retiré de la liste.',
  'fileNotFound': 'Fichier introuvable.',
  'ratingUnavailable':
      'La notation sera disponible après la publication de l\'application.',
  'recordingTypeMeeting': 'Enregistrement réunion',
  'recordingTypeIncoming': 'Note appel entrant',
  'recordingTypeOutgoing': 'Note appel sortant',
  'recordingTypeVoice': 'Note vocale',
  'recordingTypeLogged': 'Journal d\'appel',
  'badgeMeeting': 'Réunion',
  'badgeIncoming': 'Entrant',
  'badgeOutgoing': 'Sortant',
  'badgeVoice': 'Vocale',
  'badgeLogged': 'Journal',
  'callNoteSheetTitle': 'Enregistrer une note d\'appel',
  'callNoteSheetSubtitle':
      'Choisissez le type de note que vous souhaitez enregistrer '
      'manuellement après un appel.',
  'callNoteIncomingSubtitle': 'Résumé ou note après un appel reçu',
  'callNoteOutgoingSubtitle': 'Résumé ou note après un appel passé',
  'callNoteVoiceSubtitle': 'Note vocale générale',
  'micPermissionShort': 'Autorisation du microphone requise.',
  'recordingStartFailed': 'Impossible de démarrer l\'enregistrement.',
  'recordingStopFailed': 'Erreur lors de l\'arrêt de l\'enregistrement.',
  'recordingTooShort': 'Enregistrement trop court ou invalide.',
  'recordingInProgress': 'Enregistrement en cours',
  'stopAndLeave': 'Voulez-vous arrêter et quitter sans enregistrer ?',
  'continueAction': 'Continuer',
  'leave': 'Quitter',
  'consentBeforeRecord':
      'Assurez-vous que tout le monde est d\'accord avant d\'enregistrer.',
  'start': 'Démarrer',
  'stop': 'Arrêter',
  'save': 'Enregistrer',
  'edit': 'Modifier',
  'durationLabel': 'Durée :',
  'duration': 'Durée',
  'titleLabel': 'Titre',
  'contactOptional': 'Nom du contact (optionnel)',
  'contact': 'Contact',
  'noteOptional': 'Note (optionnelle)',
  'note': 'Note',
  'type': 'Type',
  'addToFavorites': 'Ajouter aux préférés',
  'favorite': 'Favori',
  'cancel': 'Annuler',
  'date': 'Date',
  'audioFileMissing': 'Fichier audio introuvable.',
  'playbackFailed': 'Impossible de lire cet enregistrement.',
  'removeFromList': 'Supprimer de la liste',
  'play': 'Lire',
  'pause': 'Pause',
  'share': 'Partager',
  'delete': 'Supprimer',
  'favoriteTooltip': 'Préféré',
  'deleteTooltip': 'Supprimer',
  'micRequired': 'Microphone requis',
  'micRequiredBody':
      'L\'accès au microphone est nécessaire pour enregistrer '
      'des notes vocales et des réunions.',
  'allow': 'Autoriser',
  'deleteRecordingTitle': 'Supprimer l\'enregistrement ?',
  'deleteRecordingBody': 'Cette action est irréversible.',
  'confirm': 'Confirmer',
  'disclaimer':
      'Cette application enregistre des notes vocales et des réunions '
      'via votre microphone. Elle n\'enregistre pas automatiquement '
      'les appels cellulaires iPhone. Obtenez toujours le '
      'consentement avant d\'enregistrer des conversations.',
  'settings': 'Paramètres',
  'recordingMode': 'Mode d\'enregistrement',
  'loading': 'Chargement...',
  'audioSource': 'Source audio',
  'microphone': 'Microphone',
  'audioChannel': 'Canal audio',
  'mono': 'Mono',
  'audioRate': 'Taux audio',
  'audioBitrate': 'Bitrate audio',
  'privacyPolicy': 'Politique de confidentialité',
  'recordingConsent': 'Consentement d\'enregistrement',
  'about': 'À propos',
  'rateFiveStars': 'Note 5 étoiles',
  'drawerSafetyBanner':
      'Cette application n\'enregistre pas automatiquement les appels '
      'cellulaires iPhone.',
  'shareAppText':
      'Recora Automatic Voice Note - Enregistrez des réunions, des notes vocales '
      'et des résumés après appel.',
  'modeManual': 'Enregistrement manuel',
  'modeMeeting': 'Réunion',
  'modeCallNote': 'Note après appel',
  'appName': 'Recora Automatic Voice Note',
  'onboardingTagline':
      'Enregistrez des réunions, des notes vocales et des résumés après appel.',
  'onboardingManualTitle': 'Enregistrement manuel',
  'onboardingManualBody':
      'L\'enregistrement démarre uniquement lorsque vous appuyez sur le bouton Démarrer.',
  'onboardingMicTitle': 'Microphone uniquement',
  'onboardingMicBody':
      'L\'application utilise le microphone pour enregistrer des notes vocales, '
      'des réunions et des conversations avec consentement.',
  'onboardingImportantTitle': 'Important',
  'onboardingImportantBody':
      'Cette application n\'enregistre pas automatiquement les appels cellulaires iPhone.',
  'onboardingCheckbox':
      'J\'ai compris que l\'application n\'enregistre pas automatiquement '
      'les appels téléphoniques iPhone.',
  'safetyStatement':
      'Cette application n\'enregistre pas automatiquement les appels cellulaires iPhone.',
  'localStorage':
      'Les enregistrements audio sont stockés localement sur votre appareil.',
  'sharingPolicy':
      'Le partage ne se produit que lorsque vous appuyez sur Partager.',
  'consentResponsibility':
      'Vous êtes responsable d\'obtenir le consentement des personnes '
      'présentes avant d\'enregistrer une conversation.',
  'privacyIntro':
      'Recora Automatic Voice Note enregistre des notes vocales, des réunions '
      'et des résumés après appel uniquement via le microphone de votre '
      'appareil, lorsque vous appuyez sur le bouton Démarrer.',
  'consentIntro':
      'Avant chaque enregistrement, assurez-vous que toutes les personnes '
      'concernées acceptent d\'être enregistrées.',
  'consentManualStart':
      'L\'enregistrement démarre uniquement lorsque vous appuyez sur '
      'Démarrer. L\'application ne fonctionne pas en arrière-plan.',
  'consentUseFor': 'Utilisez cette application pour :',
  'consentUseBullets':
      '• Enregistrer des réunions avec le microphone\n'
      '• Sauvegarder des notes vocales après un appel\n'
      '• Organiser vos enregistrements et notes',
  'aboutDescription':
      'Enregistrez des réunions, des notes vocales et des résumés après '
      'appel avec votre microphone.',
  'resume': 'Reprendre',
  'skipBack': '-10 s',
  'skipForward': '+10 s',
  'speed': 'Vitesse',
  'searchHint': 'Rechercher un enregistrement',
  'sort': 'Trier',
  'sortNewest': 'Plus récent',
  'sortOldest': 'Plus ancien',
  'sortLongest': 'Plus long',
  'sortTitle': 'Titre',
  'noSearchResults': 'Aucun résultat.',
  'logCall': 'Journal d\'appel',
  'logCallSubtitle': 'Enregistrer un appel sans audio',
  'callLogged': 'Appel ajouté au journal.',
  'autoStart': 'Démarrage automatique',
  'autoStartBody': 'Lancer l\'enregistrement dès l\'ouverture de l\'écran.',
  'audioQuality': 'Qualité audio',
  'qualityLow': 'Basse · 22 kHz',
  'qualityStandard': 'Standard · 44 kHz',
  'qualityHigh': 'Haute · 48 kHz',
  'featureOrganizeTitle': 'Organisation simple',
  'featureOrganizeBody': 'Classez et retrouvez vos notes rapidement.',
  'featureIncomingTitle': 'Notes d\'appel',
  'featureIncomingBody': 'Gardez tous vos résumés au même endroit.',
  'featureSimpleTitle': 'Interface claire',
  'featureSimpleBody': 'Un design simple pour une utilisation rapide.',
  'statsRecordings': 'Notes',
  'statsTime': 'Durée',
  'newRecording': 'Nouvelle note',
  'version': 'Version 1.0.0',
};

const _en = {
  'tabAll': 'All recordings',
  'tabAllNav': 'All recordi...',
  'tabIncoming': 'Incoming',
  'tabOutgoing': 'Outgoing',
  'tabFavorites': 'Favorite',
  'emptyList': 'Empty list',
  'myRecordings': 'My recordings',
  'emptySubtitle': 'Start a manual recording with your microphone.',
  'recordMeeting': 'Record meeting',
  'recordMeetingSubtitle':
      'Record meetings or conversations with your microphone',
  'callNoteAfter': 'Post-call note',
  'callNoteAfterSubtitle': 'Save a voice note or summary after a call',
  'defaultBadge': 'Default',
  'emptyCategory': 'No recordings in this category.',
  'language': 'Language',
  'selectLanguage': 'Choose language',
  'micPermissionRequired': 'Microphone permission is required to record.',
  'audioSaveFailed': 'The audio file could not be saved.',
  'recordingSaved': 'Recording saved.',
  'recordingDeleted': 'Recording deleted.',
  'recordingRemovedFromList': 'Recording removed from list.',
  'fileNotFound': 'File not found.',
  'ratingUnavailable': 'Rating will be available after the app is published.',
  'recordingTypeMeeting': 'Meeting recording',
  'recordingTypeIncoming': 'Incoming call note',
  'recordingTypeOutgoing': 'Outgoing call note',
  'recordingTypeVoice': 'Voice note',
  'recordingTypeLogged': 'Call log',
  'badgeMeeting': 'Meeting',
  'badgeIncoming': 'Incoming',
  'badgeOutgoing': 'Outgoing',
  'badgeVoice': 'Voice',
  'badgeLogged': 'Log',
  'callNoteSheetTitle': 'Record a call note',
  'callNoteSheetSubtitle':
      'Choose the type of note you want to record manually after a call.',
  'callNoteIncomingSubtitle': 'Summary or note after a received call',
  'callNoteOutgoingSubtitle': 'Summary or note after an outgoing call',
  'callNoteVoiceSubtitle': 'General voice note',
  'micPermissionShort': 'Microphone permission required.',
  'recordingStartFailed': 'Unable to start recording.',
  'recordingStopFailed': 'Error while stopping recording.',
  'recordingTooShort': 'Recording too short or invalid.',
  'recordingInProgress': 'Recording in progress',
  'stopAndLeave': 'Stop and leave without saving?',
  'continueAction': 'Continue',
  'leave': 'Leave',
  'consentBeforeRecord': 'Make sure everyone agrees before recording.',
  'start': 'Start',
  'stop': 'Stop',
  'save': 'Save',
  'edit': 'Edit',
  'durationLabel': 'Duration:',
  'duration': 'Duration',
  'titleLabel': 'Title',
  'contactOptional': 'Contact name (optional)',
  'contact': 'Contact',
  'noteOptional': 'Note (optional)',
  'note': 'Note',
  'type': 'Type',
  'addToFavorites': 'Add to favorites',
  'favorite': 'Favorite',
  'cancel': 'Cancel',
  'date': 'Date',
  'audioFileMissing': 'Audio file not found.',
  'playbackFailed': 'Unable to play this recording.',
  'removeFromList': 'Remove from list',
  'play': 'Play',
  'pause': 'Pause',
  'share': 'Share',
  'delete': 'Delete',
  'favoriteTooltip': 'Favorite',
  'deleteTooltip': 'Delete',
  'micRequired': 'Microphone required',
  'micRequiredBody':
      'Microphone access is required to record voice notes and meetings.',
  'allow': 'Allow',
  'deleteRecordingTitle': 'Delete recording?',
  'deleteRecordingBody': 'This action cannot be undone.',
  'confirm': 'Confirm',
  'disclaimer':
      'This app records voice notes and meetings via your microphone. '
      'It does not automatically record iPhone cellular calls. '
      'Always obtain consent before recording conversations.',
  'settings': 'Settings',
  'recordingMode': 'Recording mode',
  'loading': 'Loading...',
  'audioSource': 'Audio source',
  'microphone': 'Microphone',
  'audioChannel': 'Audio channel',
  'mono': 'Mono',
  'audioRate': 'Sample rate',
  'audioBitrate': 'Audio bitrate',
  'privacyPolicy': 'Privacy policy',
  'recordingConsent': 'Recording consent',
  'about': 'About',
  'rateFiveStars': 'Rate 5 stars',
  'drawerSafetyBanner':
      'This app does not automatically record iPhone cellular calls.',
  'shareAppText':
      'Recora Automatic Voice Note - Record meetings, voice notes, and post-call summaries.',
  'modeManual': 'Manual recording',
  'modeMeeting': 'Meeting',
  'modeCallNote': 'Post-call note',
  'appName': 'Recora Automatic Voice Note',
  'onboardingTagline': 'Record meetings, voice notes, and post-call summaries.',
  'onboardingManualTitle': 'Manual recording',
  'onboardingManualBody':
      'Recording starts only when you tap the Start button.',
  'onboardingMicTitle': 'Microphone only',
  'onboardingMicBody':
      'The app uses the microphone to record voice notes, meetings, '
      'and conversations with consent.',
  'onboardingImportantTitle': 'Important',
  'onboardingImportantBody':
      'This app does not automatically record iPhone cellular calls.',
  'onboardingCheckbox':
      'I understand that the app does not automatically record iPhone phone calls.',
  'safetyStatement':
      'This app does not automatically record iPhone cellular calls.',
  'localStorage': 'Audio recordings are stored locally on your device.',
  'sharingPolicy': 'Sharing only happens when you tap Share.',
  'consentResponsibility':
      'You are responsible for obtaining consent from everyone present '
      'before recording a conversation.',
  'privacyIntro':
      'Recora Automatic Voice Note records voice notes, meetings, and post-call '
      'summaries only via your device microphone when you tap Start.',
  'consentIntro':
      'Before each recording, make sure everyone involved agrees to be recorded.',
  'consentManualStart':
      'Recording starts only when you tap Start. The app does not run in the background.',
  'consentUseFor': 'Use this app to:',
  'consentUseBullets':
      '• Record meetings with the microphone\n'
      '• Save voice notes after a call\n'
      '• Organize your recordings and notes',
  'aboutDescription':
      'Record meetings, voice notes, and post-call summaries with your microphone.',
  'resume': 'Resume',
  'skipBack': '-10s',
  'skipForward': '+10s',
  'speed': 'Speed',
  'searchHint': 'Search recordings',
  'sort': 'Sort',
  'sortNewest': 'Newest',
  'sortOldest': 'Oldest',
  'sortLongest': 'Longest',
  'sortTitle': 'Title',
  'noSearchResults': 'No matching recordings.',
  'logCall': 'Log a call',
  'logCallSubtitle': 'Save a call entry without audio',
  'callLogged': 'Call added to your log.',
  'autoStart': 'Auto-start recording',
  'autoStartBody': 'Start capturing as soon as the recorder opens.',
  'audioQuality': 'Audio quality',
  'qualityLow': 'Low · 22 kHz',
  'qualityStandard': 'Standard · 44 kHz',
  'qualityHigh': 'High · 48 kHz',
  'featureOrganizeTitle': 'Easy to organize',
  'featureOrganizeBody': 'Keep recordings nested and sorted.',
  'featureIncomingTitle': 'Incoming records',
  'featureIncomingBody': 'All your call notes in one place.',
  'featureSimpleTitle': 'Simple interface',
  'featureSimpleBody': 'Clean design for effortless use.',
  'statsRecordings': 'Notes',
  'statsTime': 'Time',
  'newRecording': 'New note',
  'version': 'Version 1.0.0',
};

const _ar = {
  'tabAll': 'كل التسجيلات',
  'tabAllNav': 'كل التسجيل...',
  'tabIncoming': 'واردة',
  'tabOutgoing': 'صادرة',
  'tabFavorites': 'مفضلة',
  'emptyList': 'قائمة فارغة',
  'myRecordings': 'تسجيلاتي',
  'emptySubtitle': 'ابدأ تسجيلاً يدوياً باستخدام الميكروفون.',
  'recordMeeting': 'تسجيل اجتماع',
  'recordMeetingSubtitle': 'سجّل الاجتماعات أو المحادثات باستخدام الميكروفون',
  'callNoteAfter': 'ملاحظة بعد المكالمة',
  'callNoteAfterSubtitle': 'احفظ ملاحظة صوتية أو ملخصاً بعد المكالمة',
  'defaultBadge': 'افتراضي',
  'emptyCategory': 'لا توجد تسجيلات في هذه الفئة.',
  'language': 'اللغة',
  'selectLanguage': 'اختر اللغة',
  'micPermissionRequired': 'إذن الميكروفون مطلوب للتسجيل.',
  'audioSaveFailed': 'تعذّر حفظ ملف الصوت.',
  'recordingSaved': 'تم حفظ التسجيل.',
  'recordingDeleted': 'تم حذف التسجيل.',
  'recordingRemovedFromList': 'تمت إزالة التسجيل من القائمة.',
  'fileNotFound': 'الملف غير موجود.',
  'ratingUnavailable': 'سيتوفر التقييم بعد نشر التطبيق.',
  'recordingTypeMeeting': 'تسجيل اجتماع',
  'recordingTypeIncoming': 'ملاحظة مكالمة واردة',
  'recordingTypeOutgoing': 'ملاحظة مكالمة صادرة',
  'recordingTypeVoice': 'ملاحظة صوتية',
  'recordingTypeLogged': 'سجل مكالمة',
  'badgeMeeting': 'اجتماع',
  'badgeIncoming': 'واردة',
  'badgeOutgoing': 'صادرة',
  'badgeVoice': 'صوتية',
  'badgeLogged': 'سجل',
  'callNoteSheetTitle': 'تسجيل ملاحظة مكالمة',
  'callNoteSheetSubtitle':
      'اختر نوع الملاحظة التي تريد تسجيلها يدوياً بعد المكالمة.',
  'callNoteIncomingSubtitle': 'ملخص أو ملاحظة بعد مكالمة واردة',
  'callNoteOutgoingSubtitle': 'ملخص أو ملاحظة بعد مكالمة صادرة',
  'callNoteVoiceSubtitle': 'ملاحظة صوتية عامة',
  'micPermissionShort': 'إذن الميكروفون مطلوب.',
  'recordingStartFailed': 'تعذّر بدء التسجيل.',
  'recordingStopFailed': 'خطأ أثناء إيقاف التسجيل.',
  'recordingTooShort': 'التسجيل قصير جداً أو غير صالح.',
  'recordingInProgress': 'التسجيل جارٍ',
  'stopAndLeave': 'هل تريد الإيقاف والخروج دون الحفظ؟',
  'continueAction': 'متابعة',
  'leave': 'خروج',
  'consentBeforeRecord': 'تأكد من موافقة الجميع قبل التسجيل.',
  'start': 'بدء',
  'stop': 'إيقاف',
  'save': 'حفظ',
  'edit': 'تعديل',
  'durationLabel': 'المدة:',
  'duration': 'المدة',
  'titleLabel': 'العنوان',
  'contactOptional': 'اسم جهة الاتصال (اختياري)',
  'contact': 'جهة الاتصال',
  'noteOptional': 'ملاحظة (اختيارية)',
  'note': 'ملاحظة',
  'type': 'النوع',
  'addToFavorites': 'إضافة إلى المفضلة',
  'favorite': 'مفضلة',
  'cancel': 'إلغاء',
  'date': 'التاريخ',
  'audioFileMissing': 'ملف الصوت غير موجود.',
  'playbackFailed': 'تعذّر تشغيل هذا التسجيل.',
  'removeFromList': 'إزالة من القائمة',
  'play': 'تشغيل',
  'pause': 'إيقاف مؤقت',
  'share': 'مشاركة',
  'delete': 'حذف',
  'favoriteTooltip': 'مفضلة',
  'deleteTooltip': 'حذف',
  'micRequired': 'الميكروفون مطلوب',
  'micRequiredBody':
      'الوصول إلى الميكروفون ضروري لتسجيل الملاحظات الصوتية والاجتماعات.',
  'allow': 'السماح',
  'deleteRecordingTitle': 'حذف التسجيل؟',
  'deleteRecordingBody': 'لا يمكن التراجع عن هذا الإجراء.',
  'confirm': 'تأكيد',
  'disclaimer':
      'يسجّل هذا التطبيق الملاحظات الصوتية والاجتماعات عبر الميكروفون. '
      'لا يسجّل تلقائياً مكالمات iPhone الخلوية. '
      'احصل دائماً على الموافقة قبل تسجيل المحادثات.',
  'settings': 'الإعدادات',
  'recordingMode': 'وضع التسجيل',
  'loading': 'جارٍ التحميل...',
  'audioSource': 'مصدر الصوت',
  'microphone': 'الميكروفون',
  'audioChannel': 'قناة الصوت',
  'mono': 'أحادي',
  'audioRate': 'معدل العيّنة',
  'audioBitrate': 'معدل البت',
  'privacyPolicy': 'سياسة الخصوصية',
  'recordingConsent': 'موافقة التسجيل',
  'about': 'حول',
  'rateFiveStars': 'تقييم 5 نجوم',
  'drawerSafetyBanner': 'لا يسجّل هذا التطبيق تلقائياً مكالمات iPhone الخلوية.',
  'shareAppText':
      'Recora Automatic Voice Note - سجّل الاجتماعات والملاحظات الصوتية وملخصات ما بعد المكالمة.',
  'modeManual': 'تسجيل يدوي',
  'modeMeeting': 'اجتماع',
  'modeCallNote': 'ملاحظة بعد المكالمة',
  'appName': 'Recora Automatic Voice Note',
  'onboardingTagline':
      'سجّل الاجتماعات والملاحظات الصوتية وملخصات ما بعد المكالمة.',
  'onboardingManualTitle': 'تسجيل يدوي',
  'onboardingManualBody': 'يبدأ التسجيل فقط عند الضغط على زر البدء.',
  'onboardingMicTitle': 'الميكروفون فقط',
  'onboardingMicBody':
      'يستخدم التطبيق الميكروفون لتسجيل الملاحظات الصوتية والاجتماعات '
      'والمحادثات بموافقة.',
  'onboardingImportantTitle': 'مهم',
  'onboardingImportantBody':
      'لا يسجّل هذا التطبيق تلقائياً مكالمات iPhone الخلوية.',
  'onboardingCheckbox':
      'أفهم أن التطبيق لا يسجّل تلقائياً مكالمات iPhone الهاتفية.',
  'safetyStatement': 'لا يسجّل هذا التطبيق تلقائياً مكالمات iPhone الخلوية.',
  'localStorage': 'تُخزَّن التسجيلات الصوتية محلياً على جهازك.',
  'sharingPolicy': 'المشاركة تحدث فقط عند الضغط على مشاركة.',
  'consentResponsibility':
      'أنت مسؤول عن الحصول على موافقة الحاضرين قبل تسجيل محادثة.',
  'privacyIntro':
      'يسجّل Recora Automatic Voice Note الملاحظات الصوتية والاجتماعات '
      'وملخصات ما بعد المكالمة فقط عبر ميكروفون جهازك عند الضغط على بدء.',
  'consentIntro': 'قبل كل تسجيل، تأكد من موافقة جميع المعنيين على التسجيل.',
  'consentManualStart':
      'يبدأ التسجيل فقط عند الضغط على بدء. لا يعمل التطبيق في الخلفية.',
  'consentUseFor': 'استخدم هذا التطبيق من أجل:',
  'consentUseBullets':
      '• تسجيل الاجتماعات بالميكروفون\n'
      '• حفظ ملاحظات صوتية بعد مكالمة\n'
      '• تنظيم تسجيلاتك وملاحظاتك',
  'aboutDescription':
      'سجّل الاجتماعات والملاحظات الصوتية وملخصات ما بعد المكالمة بميكروفونك.',
  'resume': 'استئناف',
  'skipBack': '-10 ث',
  'skipForward': '+10 ث',
  'speed': 'السرعة',
  'searchHint': 'ابحث في التسجيلات',
  'sort': 'ترتيب',
  'sortNewest': 'الأحدث',
  'sortOldest': 'الأقدم',
  'sortLongest': 'الأطول',
  'sortTitle': 'العنوان',
  'noSearchResults': 'لا توجد نتائج.',
  'logCall': 'سجل مكالمة',
  'logCallSubtitle': 'حفظ مكالمة بدون صوت',
  'callLogged': 'تمت إضافة المكالمة إلى السجل.',
  'autoStart': 'بدء تلقائي',
  'autoStartBody': 'ابدأ التسجيل فور فتح الشاشة.',
  'audioQuality': 'جودة الصوت',
  'qualityLow': 'منخفضة · 22 كيلوهرتز',
  'qualityStandard': 'قياسية · 44 كيلوهرتز',
  'qualityHigh': 'عالية · 48 كيلوهرتز',
  'featureOrganizeTitle': 'تنظيم سهل',
  'featureOrganizeBody': 'رتّب ملاحظاتك واعثر عليها بسرعة.',
  'featureIncomingTitle': 'سجلات المكالمات',
  'featureIncomingBody': 'كل ملاحظاتك في مكان واحد.',
  'featureSimpleTitle': 'واجهة بسيطة',
  'featureSimpleBody': 'تصميم واضح وسهل الاستخدام.',
  'statsRecordings': 'ملاحظات',
  'statsTime': 'المدة',
  'newRecording': 'ملاحظة جديدة',
  'version': 'الإصدار 1.0.0',
};

const _es = {
  'tabAll': 'Todas las grabaciones',
  'tabAllNav': 'Todas las grab...',
  'tabIncoming': 'Entrante',
  'tabOutgoing': 'Saliente',
  'tabFavorites': 'Favorito',
  'emptyList': 'Lista vacía',
  'myRecordings': 'Mis grabaciones',
  'emptySubtitle': 'Inicia una grabación manual con tu micrófono.',
  'recordMeeting': 'Grabar reunión',
  'recordMeetingSubtitle': 'Graba reuniones o conversaciones con tu micrófono',
  'callNoteAfter': 'Nota tras llamada',
  'callNoteAfterSubtitle':
      'Guarda una nota de voz o un resumen después de una llamada',
  'defaultBadge': 'Predeterminado',
  'emptyCategory': 'No hay grabaciones en esta categoría.',
  'language': 'Idioma',
  'selectLanguage': 'Elegir idioma',
  'micPermissionRequired': 'Se requiere permiso del micrófono para grabar.',
  'audioSaveFailed': 'No se pudo guardar el archivo de audio.',
  'recordingSaved': 'Grabación guardada.',
  'recordingDeleted': 'Grabación eliminada.',
  'recordingRemovedFromList': 'Grabación eliminada de la lista.',
  'fileNotFound': 'Archivo no encontrado.',
  'ratingUnavailable':
      'La valoración estará disponible después de publicar la aplicación.',
  'recordingTypeMeeting': 'Grabación de reunión',
  'recordingTypeIncoming': 'Nota de llamada entrante',
  'recordingTypeOutgoing': 'Nota de llamada saliente',
  'recordingTypeVoice': 'Nota de voz',
  'recordingTypeLogged': 'Registro de llamada',
  'badgeMeeting': 'Reunión',
  'badgeIncoming': 'Entrante',
  'badgeOutgoing': 'Saliente',
  'badgeVoice': 'Voz',
  'badgeLogged': 'Registro',
  'callNoteSheetTitle': 'Grabar una nota de llamada',
  'callNoteSheetSubtitle':
      'Elige el tipo de nota que deseas grabar manualmente después de una llamada.',
  'callNoteIncomingSubtitle': 'Resumen o nota tras una llamada recibida',
  'callNoteOutgoingSubtitle': 'Resumen o nota tras una llamada saliente',
  'callNoteVoiceSubtitle': 'Nota de voz general',
  'micPermissionShort': 'Se requiere permiso del micrófono.',
  'recordingStartFailed': 'No se pudo iniciar la grabación.',
  'recordingStopFailed': 'Error al detener la grabación.',
  'recordingTooShort': 'Grabación demasiado corta o no válida.',
  'recordingInProgress': 'Grabación en curso',
  'stopAndLeave': '¿Detener y salir sin guardar?',
  'continueAction': 'Continuar',
  'leave': 'Salir',
  'consentBeforeRecord':
      'Asegúrate de que todos estén de acuerdo antes de grabar.',
  'start': 'Iniciar',
  'stop': 'Detener',
  'save': 'Guardar',
  'edit': 'Editar',
  'durationLabel': 'Duración:',
  'duration': 'Duración',
  'titleLabel': 'Título',
  'contactOptional': 'Nombre del contacto (opcional)',
  'contact': 'Contacto',
  'noteOptional': 'Nota (opcional)',
  'note': 'Nota',
  'type': 'Tipo',
  'addToFavorites': 'Añadir a favoritos',
  'favorite': 'Favorito',
  'cancel': 'Cancelar',
  'date': 'Fecha',
  'audioFileMissing': 'Archivo de audio no encontrado.',
  'playbackFailed': 'No se puede reproducir esta grabación.',
  'removeFromList': 'Eliminar de la lista',
  'play': 'Reproducir',
  'pause': 'Pausa',
  'share': 'Compartir',
  'delete': 'Eliminar',
  'favoriteTooltip': 'Favorito',
  'deleteTooltip': 'Eliminar',
  'micRequired': 'Micrófono requerido',
  'micRequiredBody':
      'Se necesita acceso al micrófono para grabar notas de voz y reuniones.',
  'allow': 'Permitir',
  'deleteRecordingTitle': '¿Eliminar grabación?',
  'deleteRecordingBody': 'Esta acción no se puede deshacer.',
  'confirm': 'Confirmar',
  'disclaimer':
      'Esta aplicación graba notas de voz y reuniones con tu micrófono. '
      'No graba automáticamente llamadas celulares de iPhone. '
      'Obtén siempre el consentimiento antes de grabar conversaciones.',
  'settings': 'Ajustes',
  'recordingMode': 'Modo de grabación',
  'loading': 'Cargando...',
  'audioSource': 'Fuente de audio',
  'microphone': 'Micrófono',
  'audioChannel': 'Canal de audio',
  'mono': 'Mono',
  'audioRate': 'Frecuencia de muestreo',
  'audioBitrate': 'Bitrate de audio',
  'privacyPolicy': 'Política de privacidad',
  'recordingConsent': 'Consentimiento de grabación',
  'about': 'Acerca de',
  'rateFiveStars': 'Valorar 5 estrellas',
  'drawerSafetyBanner':
      'Esta aplicación no graba automáticamente llamadas celulares de iPhone.',
  'shareAppText':
      'Recora Automatic Voice Note - Graba reuniones, notas de voz y resúmenes tras llamadas.',
  'modeManual': 'Grabación manual',
  'modeMeeting': 'Reunión',
  'modeCallNote': 'Nota tras llamada',
  'appName': 'Recora Automatic Voice Note',
  'onboardingTagline':
      'Graba reuniones, notas de voz y resúmenes tras llamadas.',
  'onboardingManualTitle': 'Grabación manual',
  'onboardingManualBody':
      'La grabación comienza solo cuando pulsas el botón Iniciar.',
  'onboardingMicTitle': 'Solo micrófono',
  'onboardingMicBody':
      'La aplicación usa el micrófono para grabar notas de voz, reuniones '
      'y conversaciones con consentimiento.',
  'onboardingImportantTitle': 'Importante',
  'onboardingImportantBody':
      'Esta aplicación no graba automáticamente llamadas celulares de iPhone.',
  'onboardingCheckbox':
      'Entiendo que la aplicación no graba automáticamente las llamadas telefónicas de iPhone.',
  'safetyStatement':
      'Esta aplicación no graba automáticamente llamadas celulares de iPhone.',
  'localStorage':
      'Las grabaciones de audio se almacenan localmente en tu dispositivo.',
  'sharingPolicy': 'Compartir solo ocurre cuando pulsas Compartir.',
  'consentResponsibility':
      'Eres responsable de obtener el consentimiento de las personas presentes '
      'antes de grabar una conversación.',
  'privacyIntro':
      'Recora Automatic Voice Note graba notas de voz, reuniones y resúmenes tras '
      'llamadas solo con el micrófono de tu dispositivo cuando pulsas Iniciar.',
  'consentIntro':
      'Antes de cada grabación, asegúrate de que todas las personas involucradas acepten ser grabadas.',
  'consentManualStart':
      'La grabación comienza solo cuando pulsas Iniciar. La aplicación no funciona en segundo plano.',
  'consentUseFor': 'Usa esta aplicación para:',
  'consentUseBullets':
      '• Grabar reuniones con el micrófono\n'
      '• Guardar notas de voz después de una llamada\n'
      '• Organizar tus grabaciones y notas',
  'aboutDescription':
      'Graba reuniones, notas de voz y resúmenes tras llamadas con tu micrófono.',
  'resume': 'Reanudar',
  'skipBack': '-10 s',
  'skipForward': '+10 s',
  'speed': 'Velocidad',
  'searchHint': 'Buscar grabaciones',
  'sort': 'Ordenar',
  'sortNewest': 'Más reciente',
  'sortOldest': 'Más antiguo',
  'sortLongest': 'Más largo',
  'sortTitle': 'Título',
  'noSearchResults': 'Sin resultados.',
  'logCall': 'Registrar llamada',
  'logCallSubtitle': 'Guardar una llamada sin audio',
  'callLogged': 'Llamada añadida al registro.',
  'autoStart': 'Inicio automático',
  'autoStartBody': 'Empezar a grabar al abrir la pantalla.',
  'audioQuality': 'Calidad de audio',
  'qualityLow': 'Baja · 22 kHz',
  'qualityStandard': 'Estándar · 44 kHz',
  'qualityHigh': 'Alta · 48 kHz',
  'featureOrganizeTitle': 'Fácil de organizar',
  'featureOrganizeBody': 'Ordena y encuentra tus notas rápido.',
  'featureIncomingTitle': 'Notas de llamada',
  'featureIncomingBody': 'Todas tus notas en un solo lugar.',
  'featureSimpleTitle': 'Interfaz simple',
  'featureSimpleBody': 'Diseño limpio y fácil de usar.',
  'statsRecordings': 'Notas',
  'statsTime': 'Tiempo',
  'newRecording': 'Nueva nota',
  'version': 'Versión 1.0.0',
};
