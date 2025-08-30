part of 'generics.dart';

// String translate(BuildContext context, String key) {
//   return Localization.of(context)?.translate(key) ?? "Undefined translation";
// }

String formattedDateDMY(DateTime dateTime) {
  String twoDigitString(int value) => value.toString().padLeft(2, '0');

  return '${twoDigitString(dateTime.day)}-${twoDigitString(dateTime.month)}-${dateTime.year}';
}

String formatDateZone(DateTime dateTime) {
  final formattedDate =
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}T00:00:00Z";

  return formattedDate;
}


String formatDateDMY(DateTime date) {
  final months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return '${date.day} ${months[date.month - 1]}, ${date.year}';
}
String formatTime(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String formatDay(String durationString) {
  RegExp regex = RegExp(r'(\d+)d');
  Iterable<Match> matches = regex.allMatches(durationString);

  if (matches.isNotEmpty) {
    int days = int.parse(matches.elementAt(0).group(1)!);
    return days.toStringAsFixed(0);
  } else {
    return '0';
  }
}


String formatDateTimeDMYT(String? isoDateString) {
  if (isoDateString == null || isoDateString.isEmpty) {
    return 'Unknown Date';
  }

  try {
    final DateTime date = DateTime.parse(isoDateString).toLocal();

    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    int day = date.day;
    String month = monthNames[date.month - 1];
    String year = date.year.toString().substring(2);
    int hour = date.hour;
    int minute = date.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    String formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}$period';

    return '$day $month, $year - $formattedTime';
  } catch (e) {
    return 'Invalid Date';
  }
}


String formatDate(String dateString) {
  DateTime parsedDate = DateTime.parse(dateString);
  return '${parsedDate.year}/${parsedDate.month}/${parsedDate.day}';
}

double squareMetersToAcres(double squareMeters) {
  const double squareMetersPerAcre = 4046.85642;
  return squareMeters / squareMetersPerAcre;
}

double metersToFeet(double meters) {
  return meters * 3.28084;
}
