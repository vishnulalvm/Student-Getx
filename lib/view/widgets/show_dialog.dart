// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/models/student_model.dart';
import 'package:myapp/controllers/student_controller.dart';
import 'package:myapp/view/widgets/custom_button.dart';
import 'package:myapp/view/widgets/widget_space.dart';
import 'package:myapp/utils/text/modified_text.dart';
import 'package:uuid/uuid.dart';

class AddUserDialog extends GetWidget<StudentController> {
  final Function(StudentModel) onSave;
  final StudentModel? studentModel;

  AddUserDialog({super.key, required this.onSave, this.studentModel}) {
    Get.put(StudentController());
    editStudent();
  }

  final _studentKey = GlobalKey<FormState>();

  void editStudent() {
    if (studentModel != null) {
      controller.nameController.text = studentModel!.name!;
      controller.ageController.text = studentModel!.age.toString();
      controller.updateImagePath(studentModel!.imageUrl ?? '');
      controller.setLoading(true);
    }
  }

  @override
  Widget build(BuildContext context) {
return GetBuilder<StudentController>(
      init: StudentController(),
      builder: (controller) {
        // Initialize the controller with student data if editing
        if (studentModel != null && !controller.isInitialized) {
          controller.initializeForEdit(studentModel!);
        }
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Obx(() => ModifiedText(
            text: controller.isLoading.value ? 'Update User' : 'Add New User',
            size: 13,
            color: Colors.black,
          )),



          
          content: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _studentKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Obx(() {
                            if (controller.imageFile.value != null) {
                              return CircleAvatar(
                                radius: 40,
                                backgroundImage: FileImage(controller.imageFile.value!),
                              );
                            } else if (controller.imagePath.value.isNotEmpty) {
                              return CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(controller.imagePath.value),
                              );
                            } else {
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.person, size: 40, color: Colors.white),
                              );
                            }
                          }),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 74,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(1, 40, 95, .75),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => controller.pickProfileImage(),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    space(height: 12),
                    const Text(
                      'Name',
                      style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                    space(height: 12),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: controller.nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Add A New User ',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              const BorderSide(color: Color.fromRGBO(0, 0, 0, .4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    space(height: 12),
                    const Text(
                      'Age',
                      style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                    space(height: 12),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                      controller: controller.ageController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Enter Age ',
                        hintStyle:
                            const TextStyle(color: Colors.black54, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            buttons(
              height: 28,
              width: 95,
              buttonName: 'Cancel',
              textColor: Colors.black87,
              color: const Color.fromRGBO(204, 204, 204, 1),
              onTap: () {
                Get.back();
              },
            ),
            Obx(() => buttons(
                height: 28,
              width: 95,
              buttonName: controller.isLoading.value ? 'Update' : 'Save',
              textColor: Colors.white,
              color: const Color.fromRGBO(23, 130, 225, 1),
              onTap: () {
                if (_studentKey.currentState!.validate()) {
                  _addOrUpdateStudent(controller);
                  Get.back();
                }
              },
            )),
          ],
        );
      }
    );
  }

   void _addOrUpdateStudent(StudentController controller) {
    if (controller.nameController.text.isEmpty || controller.ageController.text.isEmpty) {
      controller.showMessage('Please fill all fields', isError: true);
      return;
    }
    var id = studentModel?.id ?? const Uuid().v1();
    StudentModel newStudent = StudentModel(
      name: controller.nameController.text,
      age: int.parse(controller.ageController.text),
      id: id,
      imageUrl: controller.imagePath.value,
      createdAt: studentModel?.createdAt ?? DateTime.now(),
    );
    onSave(newStudent);
    controller.clearFields();
  }
}