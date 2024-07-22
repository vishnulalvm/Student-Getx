import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/student_model.dart';

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
  Future<List<StudentModel>> getStudent() async {
    List<StudentModel> studentList = [];
    try {
      final snapshot = await _collectionReference.get();
      for (var element in snapshot.docs) {
        studentList.add(StudentModel.fromJson(element));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return [];
    }
    return studentList;
  }

  // update
  Future<String> updateStudent(StudentModel student) async {
    try {
      final studentMap = student.toMap();
      await _collectionReference.doc(student.id).update(studentMap);
      return 'sucessfull';
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      return 'Error updating student: $e';
    }
  }

  // delete

  Future<String> deleteStudent(String? id) async {
    try {
      await _collectionReference.doc(id).delete();
      return 'Student deleted successfully';
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      return 'Error deleting student: $e';
    }
  }

  // search
}
