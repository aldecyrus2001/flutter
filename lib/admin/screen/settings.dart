import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/admin/components/appBar.dart';
import '../../assets/global/global.dart';
import '../../global/model/my_position.dart';
import '../services/fetchPositions.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Position> positions = [];
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    fetchPositions(
          (fetchedPositions) {
        setState(() {
          positions = fetchedPositions;

          for (var position in positions) {
            _controllers[position.positionID] = TextEditingController(
              text: position.maxCandidate.toString(),
            );
          }
        });
      },
          (errorMessage) {
        print(errorMessage);
      },
    );
  }

  void _increment(String positionID) {
    setState(() {
      int currentValue = int.parse(_controllers[positionID]!.text);
      currentValue++;
      _controllers[positionID]!.text = currentValue.toString();
    });
  }

  void _decrement(String positionID) {
    setState(() {
      int currentValue = int.parse(_controllers[positionID]!.text);
      if (currentValue > 0) {
        currentValue--;
      }
      _controllers[positionID]!.text = currentValue.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      body: positions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                    children: [
            Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Expanded(
              child: ListView.builder(
                itemCount: positions.length,
                itemBuilder: (context, index) {
                  var position = positions[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            position.positionTitle,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              iconSize: 15.0,
                              onPressed: () => _decrement(position.positionID),
                            ),
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: TextField(
                                controller: _controllers[position.positionID],
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(
                                  fontSize: 10.0,

                                ),

                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              iconSize: 15.0,
                              onPressed: () => _increment(position.positionID),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _controllers.forEach((positionID, controller) {
                    print('Position ID: $positionID, Value: ${controller.text}');
                  });
                },
                child: const Text('Save'),
              ),
            ),
                    ],
                  ),
          ),
    );
  }
}
