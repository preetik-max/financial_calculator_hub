import 'age_model.dart';

class AgeCalculator {
  const AgeCalculator();

  AgeResult calculate({
    required DateTime dateOfBirth,
    required DateTime ageAtDate,
  }) {
    if (ageAtDate.isBefore(dateOfBirth)) {
      throw ArgumentError('Age at date cannot be before date of birth.');
    }

    int years = ageAtDate.year - dateOfBirth.year;
    int months = ageAtDate.month - dateOfBirth.month;
    int days = ageAtDate.day - dateOfBirth.day;

    if (days < 0) {
      months--;

      final previousMonth = DateTime(ageAtDate.year, ageAtDate.month, 0);

      days += previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = ageAtDate.difference(dateOfBirth).inDays;

    final totalWeeks = totalDays ~/ 7;
    final remainingWeeksDays = totalDays % 7;

    final totalMonths = (years * 12) + months;

    final totalHours = totalDays * 24;
    final totalMinutes = totalHours * 60;
    final totalSeconds = totalMinutes * 60;

    final nextBirthday = _getNextBirthday(dateOfBirth, ageAtDate);

    final daysUntilBirthday = nextBirthday.difference(ageAtDate).inDays;

    return AgeResult(
      years: years,
      months: months,
      days: days,
      totalMonths: totalMonths,
      totalDays: totalDays,
      totalWeeks: totalWeeks,
      remainingWeeksDays: remainingWeeksDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
      nextBirthday: nextBirthday,
      daysUntilBirthday: daysUntilBirthday,
    );
  }

  DateTime _getNextBirthday(DateTime dateOfBirth, DateTime ageAtDate) {
    var year = ageAtDate.year;

    DateTime birthday;

    if (dateOfBirth.month == 2 && dateOfBirth.day == 29 && !_isLeapYear(year)) {
      birthday = DateTime(year, 2, 28);
    } else {
      birthday = DateTime(year, dateOfBirth.month, dateOfBirth.day);
    }

    if (!birthday.isAfter(ageAtDate)) {
      year++;

      if (dateOfBirth.month == 2 &&
          dateOfBirth.day == 29 &&
          !_isLeapYear(year)) {
        birthday = DateTime(year, 2, 28);
      } else {
        birthday = DateTime(year, dateOfBirth.month, dateOfBirth.day);
      }
    }

    return birthday;
  }

  bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }
}
