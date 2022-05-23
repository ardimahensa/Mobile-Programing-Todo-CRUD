// ignore_for_file: use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Pembuatan controller
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  //Sambungan ke database firestore
  final CollectionReference _todo =
      FirebaseFirestore.instance.collection('todo');

  //Trigger untuk floating action button
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _judulController.text = documentSnapshot['judul'];
      _deskripsiController.text = documentSnapshot['deskripsi'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                //Input Textfield
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(labelText: 'judul'),
                ),
                TextField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(
                    labelText: 'deskripsi',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Fungsi untuk Create dan Update
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? judul = _judulController.text;
                    final String? deskripsi = _deskripsiController.text;
                    if (judul != null && deskripsi != null) {
                      if (action == 'create') {
                        // Mengirim ke collection
                        await _todo
                            .add({"judul": judul, "deskripsi": deskripsi});
                      }

                      if (action == 'update') {
                        // Perintah update
                        await _todo
                            .doc(documentSnapshot!.id)
                            .update({"judul": judul, "deskripsi": deskripsi});
                      }

                      // Menghapus textfield
                      _judulController.text = '';
                      _deskripsiController.text = '';

                      // Menghilangkan bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Fungsi untuk delete
  Future<void> _deleteProduct(String todoId) async {
    await _todo.doc(todoId).delete();

    // Tampulan jika data terhapus
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fungsi Read real-time
      body: StreamBuilder(
        stream: _todo.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['judul']),
                    subtitle: Text(documentSnapshot['deskripsi']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          //Icon untuk Update
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          //Icon untuk Delete
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Menambah data
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
