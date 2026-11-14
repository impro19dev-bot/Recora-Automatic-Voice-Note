/// True while the recording screen is on screen.
///
/// App Open ads stay hidden so a recording, pause, or microphone prompt
/// is not covered.
abstract final class RecordingActivity {
  static bool isScreenOpen = false;
}
