import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/student_controller.dart';
import 'package:myapp/models/student_model.dart';
import 'package:myapp/view/pages/student_details.dart';
import 'package:myapp/view/widgets/custom_button.dart';
import 'package:myapp/view/widgets/widget_space.dart';

class EditStudent extends StatefulWidget {
  final StudentDetails studentModel;
  const EditStudent({super.key, required this.studentModel});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _studentKey = GlobalKey<FormState>();
  late StudentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StudentController>();
    // Populate the form with existing student data
    controller.nameController.text = widget.studentModel.name;
    controller.ageController.text = widget.studentModel.age.toString();
    controller.imagePath.value = widget.studentModel.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(16, 14, 9, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _studentKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        if (controller.imageFile.value != null) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                FileImage(controller.imageFile.value!),
                          );
                        } else if (controller.imagePath.value.isNotEmpty) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(controller.imagePath.value),
                          );
                        } else {
                          return const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person,
                                size: 60, color: Colors.white),
                          );
                        }
                      }),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20,
                        child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: controller.pickProfileImage,
                        ),
                      ),
                    ],
                  ),
                ),
                space(height: 20),
                const Text('Name',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                space(height: 8),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Name is required' : null,
                ),
                space(height: 20),
                const Text('Age',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                space(height: 8),
                TextFormField(
                  controller: controller.ageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Age is required' : null,
                ),
                space(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buttons(
                      onTap: () => Get.back(),
                      buttonName: 'Cancel',
                      textColor: Colors.white,
                      color: Colors.grey,
                      height: 50,
                      width: 150,
                    ),
                    buttons(
                      onTap: () {
                        if (_studentKey.currentState!.validate()) {
                          updateStudent();
                        }
                      },
                      buttonName: 'Update',
                      textColor: Colors.white,
                      color: Colors.black,
                      height: 50,
                      width: 150,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateStudent() {
    final updatedStudent = StudentModel(
      id: widget.studentModel.id,
      name: controller.nameController.text,
      age: int.parse(controller.ageController.text),
      imageUrl: controller.imagePath.value,
      createdAt: null,
    );
    controller.updateStudent(updatedStudent);
  }
}
