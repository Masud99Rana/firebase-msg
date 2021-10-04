import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  String description;

  Note(this.title, this.description);
}

class Data {
  Data();
  // Future<void> addData(Note note) {
  Future<void> addData(Map note) {
    // auto create
    final notes = FirebaseFirestore.instance.collection('notes');
    return notes.add({
      'title': note['title'],
      'description': note['description'],
    });
  }

  getData() async {
    return await FirebaseFirestore.instance
        .collection('notes')
        // .orderBy('title', descending: false)
        .get();
  }
}
