enum RecordingType {
  meeting,
  incomingNote,
  outgoingNote,
  voiceNote,
  loggedCall;

  static RecordingType? fromName(String name) {
    for (final type in RecordingType.values) {
      if (type.name == name) return type;
    }
    return null;
  }

  bool get hasAudio => this != RecordingType.loggedCall;
}
