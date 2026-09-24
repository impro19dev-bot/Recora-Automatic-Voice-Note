import '../features/recording/recording_type.dart';

class RecordingItem {
  RecordingItem({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.createdAt,
    required this.filePath,
    this.contactName,
    this.note,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final RecordingType type;
  final Duration duration;
  final DateTime createdAt;
  final String filePath;
  final String? contactName;
  final String? note;
  final bool isFavorite;

  bool get hasAudio => type.hasAudio && filePath.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'contact': contactName,
      'note': note,
      'filePath': filePath,
      'durationMs': duration.inMilliseconds,
      'date': createdAt.toIso8601String(),
      'type': type.name,
      'favorite': isFavorite,
    };
  }

  factory RecordingItem.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String?;
    final type =
        RecordingType.fromName(typeName ?? '') ?? RecordingType.voiceNote;

    return RecordingItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      type: type,
      duration: Duration(
        milliseconds: (json['durationMs'] as num?)?.toInt() ?? 0,
      ),
      createdAt:
          DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      filePath: json['filePath'] as String? ?? '',
      contactName: json['contact'] as String?,
      note: json['note'] as String?,
      isFavorite: json['favorite'] as bool? ?? false,
    );
  }

  RecordingItem copyWith({
    String? title,
    RecordingType? type,
    Duration? duration,
    String? contactName,
    String? note,
    bool? isFavorite,
  }) {
    return RecordingItem(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      createdAt: createdAt,
      filePath: filePath,
      contactName: contactName ?? this.contactName,
      note: note ?? this.note,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
