import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/models/student_model.dart';

class StudentController extends GetxController {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('student');
  // var students = <StudentModel>[].obs;
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var imagePath = ''.obs;
  var imageFile = Rx<File?>(null);
  // var isLoading = false.obs;
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

  void addStudent(StudentModel student) {
    // students.add(student);
    studentlists.add(student);
    update();
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
      studentlists.clear(); // Clear the list before adding new data
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
