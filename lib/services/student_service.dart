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
    final snapshot = await _collectionReference.get();
    for (var element in snapshot.docs) {
      studentList.add(StudentModel.fromJson(element));
    }
    return studentList;
  }

  // Stream<List<StudentModel>> getStudent() {
  //   try {
  //     return _collectionReference.snapshots().map((QuerySnapshot snapshot) {
  //       return snapshot.docs.map((DocumentSnapshot doc) {
  //         return StudentModel.fromJson(doc);
  //       }).toList();
  //     });
  //   } on FirebaseException catch (e) {
  //     'Error creating student: ${e.message}';
  //     rethrow;
  //   }
  // }
  // update

  Future<void> updateStudent(StudentModel student) async {
    try {
      final studentMap = student.toMap();
      await _collectionReference.doc(student.id).update(studentMap);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // delete

  Future<void> deleteStudent(String? id) async {
    try {
      await _collectionReference.doc(id).delete();
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // search
}
