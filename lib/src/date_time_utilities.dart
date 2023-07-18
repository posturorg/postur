List monthList = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
]; //Rather verbose means of doing this, but it works.

String amPmString(int hour) {
  if (hour < 12) {
    return 'a.m.';
  } else {
    return 'p.m.';
  }
} //Also verbose, but works

int hourRectifier(int hour) {
  if (hour == 0) {
    return 12;
  } else if (hour <= 12) {
    return hour;
  } else {
    return hour - 12;
  }
}
