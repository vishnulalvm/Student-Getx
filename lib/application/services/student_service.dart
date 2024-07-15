import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/domian/models/student_model.dart';

class StudentService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('student');

  // create
  Future<String?> newStudent(StudentModel student) async {
    try {
      final studentMap = student.toMap();
      await _collectionReference.doc(student.id).set(studentMap);
      return 'Student created successfully';
    } on FirebaseException catch (e) {
      return 'Error creating student: ${e.message}';
    }
  }

  // read

  Stream<List<StudentModel>> getStudent() {
    try {
      return _collectionReference.snapshots().map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return StudentModel.fromJson(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      'Error creating student: ${e.message}';
      rethrow;
    }
  }
  // update

  Future<void> updateStudent(StudentModel student) async {
    try {
      final studentMap = student.toMap();
      await _collectionReference.doc(student.id).update(studentMap);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // delete

  Future<void> deleteStudent(String? id) async {
    try {
      await _collectionReference.doc(id).delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
