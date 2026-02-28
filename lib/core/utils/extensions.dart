/// Extension methods for common utilities

extension DoubleExtensions on double {
  /// Clamp double between 0.0 and 1.0
  double clamp01() => clamp(0.0, 1.0);
}

extension IntExtensions on int {
  /// Convert days to readable string
  String toDaysString() {
    if (this == 1) return '1 day';
    return '$this days';
  }
}
