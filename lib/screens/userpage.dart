import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:week_18/helper/helper.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String name = '';

  var notes = <String>[];
  final ref = FirebaseDatabase.instance.ref().child('notes');

  Future<void> _initUsername() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      name = email;
    });
  }

  void _initData() {
    FirebaseHelper.getNotes().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        setState(() {
          notes = map.values.map((e) => e as String).toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initUsername();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              FirebaseHelper.logout();
              Navigator.pushReplacementNamed(context, '/loginpage');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(children: [
              const Text(
                'Name:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Notes'),
            Expanded(
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, i) => ListTile(
                          title: Text(notes[i]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    FirebaseHelper.delete(notes[i]);

                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final note = nameController.text;
                  FirebaseHelper.write(note);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );
}
