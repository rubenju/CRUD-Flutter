import 'package:flutter/material.dart';
import 'package:flutter_application_1/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  List<Map<String, dynamic>> notes = [];

  void refreshNotes() async {
    final data = await DbHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(notes);
    const Color mainColor = Color(0xff8c5b6b);
    const Color cardColor = Color(0xffbd8999);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "CRUD App",
          ),
        ),
        backgroundColor: mainColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalForm(cardColor, null);
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: cardColor,
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(notes[index]['title']),
              subtitle: Text(notes[index]['description']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        modalForm(cardColor, notes[index]['id']);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white70,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteNotes(notes[index]['id']);
                      },
                      icon: const Icon(
                        Icons.delete_outlined,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Container(
              //       margin: const EdgeInsets.symmetric(vertical: 10),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(7),
              //         color: cardColor,
              //       ),
              //       width: 450,
              //       padding: const EdgeInsets.all(5),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(15.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: <Widget>[
              //                 Text(
              //                   notes[index]['title'],
              //                   textAlign: TextAlign.left,
              //                   style: const TextStyle(
              //                     color: Colors.white70,
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.w400,
              //                   ),
              //                 ),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       notes[index]['description'],
              //                       textAlign: TextAlign.left,
              //                       style: const TextStyle(
              //                         color: Colors.white70,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Row(),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addNotes() async {
    await DbHelper.addNotes(titleController.text, descController.text);
    refreshNotes();
  }

  Future<void> editNotes(int id) async {
    await DbHelper.editNotes(id, titleController.text, descController.text);
    refreshNotes();
  }

  void deleteNotes(int id) async {
    await DbHelper.deleteNotes(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Delete notes success')));
    refreshNotes();
  }

  void modalForm(Color cardColor, int? id) async {
    if (id != null) {
      final datanotes = notes.firstWhere((element) => element['id'] == id);
      titleController.text = datanotes['title'];
      descController.text = datanotes['description'];
    }

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Judul',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Deskripsi',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(cardColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(id == null ? 'Tambah' : 'Ubah'),
                      ),
                      onPressed: () async {
                        if (id == null) {
                          await addNotes();
                        } else {
                          await editNotes(id);
                        }

                        titleController.text = '';
                        descController.text = '';
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
