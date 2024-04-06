import 'package:flutter/material.dart';
import 'package:hadafi/model/app_settings.dart';
import 'package:hadafi/model/hadaf.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HadafiDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
  S E T U P
  */

  // initialize - database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HadafSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /* C R U D X O P E R A T I O N S */

  // List of hadafs
  final List<Hadaf> currentHadafs = [];

  // C R E A TE -  add new hadaf
  Future<void> addHadaf(String hadafName) async {
    // create a new hadaf
    final newHadaf = Hadaf()..name = hadafName;

    // safe to db
    await isar.writeTxn(() => isar.hadafs.put(newHadaf));

    // re-read from db
    readHadafs();
  }

  // R E A D - read saved hadafs from db
  Future<void> readHadafs() async {
    // fetch all hadafs from db
    List<Hadaf> fetchedHadafs = await isar.hadafs.where().findAll();

    // give to current hadafs
    currentHadafs.clear();
    currentHadafs.addAll(fetchedHadafs);

    // update UI
    notifyListeners();
  }

  // U P D A T E - check hadaf on and off
  Future<void> updateHadafCompletion(int id, bool isCompleted) async {
    // find the specific hadaf
    final hadaf = await isar.hadafs.get(id);

    // update completion status
    if (hadaf != null) {
      await isar.writeTxn(() async {
        // if the hadaf is completed -> add the current date to the completedDays list
        if (isCompleted && !hadaf.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          // add the current date if it's not already in the list
          hadaf.completedDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        }
        // if hadaf is NOT completed -> remove the current date from the list
        else {
          // remove the current date if the hadaf is marked as not completed
          hadaf.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save the updated hadaf back to db
        await isar.hadafs.put(hadaf);
      });
    }

    // re-read from db
    readHadafs();
  }

  // U P D A T E - edit hadaf name
  Future<void> updateHadafName(int id, String newName) async {
    // find the specific hadaf
    final hadaf = await isar.hadafs.get(id);

    // update the habit name
    if (hadaf != null) {
      // update name
      await isar.writeTxn(() async {
        hadaf.name = newName;
        // save updated hadaf back to db
        await isar.hadafs.put(hadaf);
      });
    }

    // re-read from db
    readHadafs();
  }

  // D E L E T E - delede hadaf

  Future<void> deleteHadaf(int id) async {
    // find specific hadaf
    final hadaf = await isar.hadafs.get(id);

    // delete the hadaf
    if (hadaf != null) {
      await isar.writeTxn(() async {
        await isar.hadafs.delete(id);
      });
    }

    // re-read from db
    readHadafs();
  }
}
