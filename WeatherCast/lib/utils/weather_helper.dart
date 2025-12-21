// Manual date formatting to avoid intl locale initialization issues

class WeatherHelper {
  // Day names
  static const List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  
  // Month names
  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  
  static const List<String> _monthNamesFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Format temperature
  static String formatTemperature(double temp, {bool showUnit = true}) {
    return '${temp.round()}${showUnit ? '°' : ''}';
  }

  // Format date
  static String formatDate(DateTime date) {
    final dayName = _dayNames[date.weekday - 1];
    final monthName = _monthNamesFull[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  // Format time
  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Format hour
  static String formatHour(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    return '$hour:00';
  }

  // Format day
  static String formatDay(DateTime date) {
    return _dayNames[date.weekday - 1];
  }

  // Format short date
  static String formatShortDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]}';
  }

  // Get weather icon based on condition
  static String getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  // Get weather emoji
  static String getWeatherEmoji(String iconCode) {
    if (iconCode.startsWith('01')) return '☀️';
    if (iconCode.startsWith('02')) return '⛅';
    if (iconCode.startsWith('03')) return '☁️';
    if (iconCode.startsWith('04')) return '☁️';
    if (iconCode.startsWith('09')) return '🌧️';
    if (iconCode.startsWith('10')) return '🌦️';
    if (iconCode.startsWith('11')) return '⛈️';
    if (iconCode.startsWith('13')) return '❄️';
    if (iconCode.startsWith('50')) return '🌫️';
    return '🌤️';
  }

  // Get wind direction
  static String getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    if (degrees >= 292.5 && degrees < 337.5) return 'NW';
    return 'N';
  }

  // Format visibility
  static String formatVisibility(int visibility) {
    final km = visibility / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  // Format wind speed
  static String formatWindSpeed(double speed) {
    return '${speed.toStringAsFixed(1)} m/s';
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
