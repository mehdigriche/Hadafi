import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadafi/components/hadafi_appbar.dart';
import 'package:hadafi/components/hadafi_drawer.dart';
import 'package:hadafi/components/hadafi_hadaf_item.dart';
import 'package:hadafi/components/hadafi_heat_map.dart';
import 'package:hadafi/database/hadafi_database.dart';
import 'package:hadafi/model/hadaf.dart';
import 'package:hadafi/util/hadafi_util.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _textController = TextEditingController();
  bool _isTyping = false;
  final _user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // read the existing hadafs on app startup
    Provider.of<HadafiDatabase>(context, listen: false).readHadafs();

    super.initState();
  }

  // create new hadaf
  void createNewHadaf() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              content: TextField(
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    _isTyping = value.isEmpty ? false : true;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Create a new Hadaf',
                ),
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: _isTyping
                      ? () {
                          _handleHadafAdd(_textController.text);
                        }
                      : null,
                  child: const Text('Save'),
                ),

                // cancel button
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    _textController.clear();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          });
        });
  }

  // Check if input empty before add hadaf
  void _handleHadafAdd(String hadafName) {
    setState(() {
      if (hadafName != "") {
        _isTyping = false;
        // get the new hadaf name
        String newHadafName = hadafName;

        // save it to db
        context.read<HadafiDatabase>().addHadaf(newHadafName);

        // pop box
        Navigator.pop(context);
      }
    });
    // clear controller
    _textController.clear();
  }

  // edit Hadaf
  void editHadafBox(Hadaf hadaf) {
    // set the controller's text to the hadaf's current name
    _textController.text = hadaf.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Enter the Hadaf\'s name',
          ),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new hadaf name
              String newHadafName = _textController.text;

              // save it to db
              context
                  .read<HadafiDatabase>()
                  .updateHadafName(hadaf.id, newHadafName);

              // pop box
              Navigator.pop(context);

              // clear controller
              _textController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              _textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete Hadaf
  void deleteHadafBox(Hadaf hadaf) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // save it to db
              context.read<HadafiDatabase>().deleteHadaf(hadaf.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Icon(Icons.check),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              _textController.clear();
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  // check hadaf on or off
  void checkHadafOnOff(bool? value, Hadaf hadaf) {
    // update the hadaf completion status
    if (value != null) {
      context.read<HadafiDatabase>().updateHadafCompletion(hadaf.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const HadafiAppBar(),
      drawer: HadafiDrawer(username: _user.email!),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHadaf,
        elevation: 3,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: ListView(
        children: [
          // Heatmap
          _buildHeatMap(),

          // Hadaf List
          _buildHadafList(),
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // hadaf database
    final hadafiDatabase = context.watch<HadafiDatabase>();
    // current hadafs
    List<Hadaf> currentHadafs = hadafiDatabase.currentHadafs;

    // return heat map UI
    return FutureBuilder<DateTime?>(
      future: hadafiDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heatmap
        if (snapshot.hasData) {
          return HadafiHeatMap(
            startDate: snapshot.data!,
            dataSets: prepHeatMapDataset(currentHadafs),
          );
        }

        // handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // build hadaf list
  Widget _buildHadafList() {
    // habit db
    final hadafiDatabase = context.watch<HadafiDatabase>();
    // current hadafs
    List<Hadaf> currentHadafs = hadafiDatabase.currentHadafs;

    // return list of hadafs UI
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentHadafs.length,
      itemBuilder: (context, index) {
        // get each individual hadaf
        final hadaf = currentHadafs[index];

        // check if the hadaf is completed today
        bool isCompletedToday = isHadafCompletedToday(hadaf.completedDays);

        // return tile UI
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          title: HadafiHadafItem(
            isCompleted: isCompletedToday,
            text: hadaf.name,
            onChanged: (value) => checkHadafOnOff(value, hadaf),
            editHadaf: (context) => editHadafBox(hadaf),
            deleteHadaf: (context) => deleteHadafBox(hadaf),
          ),
        );
      },
    );
  }
}
