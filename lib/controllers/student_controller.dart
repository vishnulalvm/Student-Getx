import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/models/student_model.dart';
import 'package:myapp/services/student_service.dart';

class StudentController extends GetxController {
  final StudentService studentService = StudentService();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('student');
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var imagePath = ''.obs;
  var imageFile = Rx<File?>(null);
  var isInitialized = false;

  final RxList<StudentModel> studentlists = <StudentModel>[].obs;
  final RxBool isLoading = false.obs;
  final debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    clearFields();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
  }

  void initializeForEdit(StudentModel student) {
    nameController.text = student.name ?? '';
    ageController.text = student.age?.toString() ?? '';
    imagePath.value = student.imageUrl ?? '';
    isLoading.value = true;
    isInitialized = true;
    update();
  }

  Future<void> addStudent(StudentModel student) async {
    final result = await studentService.newStudent(student);
    if (result == 'Student created successfully') {
      showMessage('Student added successfully');
      studentlists.add(student);
      update();
    } else {
      showMessage('Failed to add student: $result', isError: true);
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      final result = await studentService.deleteStudent(id);
      if (result == 'Student deleted successfully') {
        // Remove the student from the local list
        studentlists.removeWhere((student) => student.id == id);
        showMessage('Student deleted successfully');
        print("delete 9999");
      } else {
        showMessage('Failed to delete student: $result', isError: true);
        print("delete 0000");
      }
    } catch (e) {
      showMessage('Error deleting student: $e', isError: true);
    }
  }

   Future<void> updateStudent(StudentModel student) async {
    try {
      await studentService.updateStudent(student);
      int index = studentlists.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        studentlists[index] = student;
      }
      Get.back();
      showMessage('Student updated successfully');
    } catch (e) {
      showMessage('Error updating student: $e', isError: true);
    }
  }

  void updateImagePath(String path) {
    imagePath.value = path;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void clearFields() {
    nameController.clear();
    ageController.clear();
    imagePath.value = '';
    imageFile.value = null;
    isLoading.value = false;
    isInitialized = false;
    update();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      String imageUrl = await uploadImageToFirebaseStorage(pickedFile);
      updateImagePath(imageUrl);
    }
  }

  Future<String> uploadImageToFirebaseStorage(XFile pickedImage) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      File file = File(pickedImage.path);
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      showMessage('Error uploading image: $e', isError: true);
      return '';
    }
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> searchStudents(String searchText) async {
    isLoading.value = true;
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where("name", isNotEqualTo: searchText)
          .orderBy("name")
          .startAt([searchText]).endAt(['$searchText\uf8ff']).get();
      List<StudentModel> studentList =
          querySnapshot.docs.map((doc) => StudentModel.fromJson(doc)).toList();

      studentlists.value = studentList;
    } catch (e) {
      // ignore: avoid_print
      print('Error searching students: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      final snapshot = await collectionReference.get();
      studentlists.clear();
      for (var element in snapshot.docs) {
        studentlists.add(StudentModel.fromJson(element));
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching students: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
