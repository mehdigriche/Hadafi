import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'hadaf.g.dart';

@Collection()
class Hadaf {
  // Hadaf id
  Id id = Isar.autoIncrement;

  // Hadaf name
  late String name;

  // completed days
  List<DateTime> completedDays = [
    // DateTime(year, month, day),
    // DateTime(2024, 1, 1),
  ];
}
