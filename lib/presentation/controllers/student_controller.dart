import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/domian/models/student_model.dart';

class StudentController extends GetxController {
  var students = <StudentModel>[].obs;
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var imagePath = ''.obs;
  var imageFile = Rx<File?>(null);
  var isLoading = false.obs;
  var isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    clearFields();
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
    students.add(student);
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
}
