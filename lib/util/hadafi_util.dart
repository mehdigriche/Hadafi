// given a hadaf list of completion days
// is the hadaf completed today
import 'package:hadafi/model/hadaf.dart';

bool isHadafCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Hadaf> hadafs) {
  Map<DateTime, int> dataset = {};

  for (var hadaf in hadafs) {
    for (var date in hadaf.completedDays) {
      // normalize date to avoid time mismatch
      final normalizeDate = DateTime(date.year, date.month, date.day);

      // if the date already exist in dataset
      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        // else initialize it with a count of 1
        dataset[normalizeDate] = 1;
      }
    }
  }
  return dataset;
}
