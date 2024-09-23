import 'package:intl/intl.dart';

class TFormatter {
  static List<int> divideListIntoParts(List<int> numbers) {
    // Calculate the total number of elements in the list
    int totalElements = numbers.length;

    // Calculate the number of elements in each part
    int elementsPerPart = (totalElements / 7).ceil();

    // Initialize the list to store the averages of each part
    List<int> averages = [];

    // Divide the list into parts and calculate the average for each part
    for (int i = 0; i < 7; i++) {
      int startIndex = i * elementsPerPart;
      int endIndex = (i + 1) * elementsPerPart;
      if (endIndex > totalElements) {
        endIndex = totalElements;
      }

      int sum = 0;
      for (int j = startIndex; j < endIndex; j++) {
        sum += numbers[j];
      }

      int average;
      if (endIndex - startIndex > 0) {
        average = (sum / (endIndex - startIndex)).round();
      } else {
        average = 0;
      }
      averages.add(average);
    }

    return averages;
  }

  static List<String> getDaysOfWeek(DateTime startDate, DateTime endDate) {
    List<String> daysOfWeek = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      if (date.isAfter(endDate)) {
        break;
      }
      String day = DateFormat('E').format(date);
      daysOfWeek.add(day);
    }
    return daysOfWeek;
  }

  static List<String> divideDateRange(DateTime startDate, DateTime endDate) {
    // Calculate total number of days between start and end date
    int totalDays = endDate.difference(startDate).inDays;

    // Calculate the interval between each part
    int interval = (totalDays / 7).ceil();

    // Initialize the list to store the formatted date strings
    List<String> dateStrings = [];

    // Generate date strings at intervals
    for (int i = 0; i < 7; i++) {
      DateTime partStartDate = startDate.add(Duration(days: i * interval));
      DateTime partEndDate = startDate.add(Duration(days: (i + 1) * interval));
      if (partEndDate.isAfter(endDate)) {
        partEndDate = endDate;
      }
      String formattedStartDate = DateFormat('dd/MM').format(partStartDate);
      dateStrings.add(formattedStartDate);
    }

    return dateStrings;
  }
}
