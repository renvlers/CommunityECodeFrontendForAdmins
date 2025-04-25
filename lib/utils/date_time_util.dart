class DateTimeUtil {
  static String _pad(int value) => value.toString().padLeft(2, '0');
  static String getString(DateTime? dateTime) {
    if (dateTime == null) return '';
    return "${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} "
        "${_pad(dateTime.hour)}:${_pad(dateTime.minute)}";
  }
}
