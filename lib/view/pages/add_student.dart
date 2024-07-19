import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/student_controller.dart';
import 'package:myapp/models/student_model.dart';
import 'package:myapp/services/student_service.dart';
import 'package:myapp/view/widgets/custom_button.dart';
import 'package:myapp/view/widgets/widget_space.dart';
import 'package:uuid/uuid.dart';

class AddStudent extends StatefulWidget {
  final Function(StudentModel)? onSave;
  final StudentModel? studentModel;
  const AddStudent({super.key, this.onSave, this.studentModel});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _studentKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(16, 14, 9, 1),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 20),
        child: Form(
          key: _studentKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
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
                                radius: 60,
                                backgroundImage:
                                    FileImage(controller.imageFile.value!),
                              );
                            } else if (controller.imagePath.value.isNotEmpty) {
                              return CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(controller.imagePath.value),
                              );
                            } else {
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.person,
                                    size: 40, color: Colors.white),
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
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, .4)),
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
                        hintStyle: const TextStyle(
                            color: Colors.black54, fontSize: 13),
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
              space(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttons(
                      onTap: () {
                        Get.back();
                      },
                      buttonName: 'Cancel',
                      textColor: Colors.white,
                      color: Colors.grey,
                      height: 50,
                      width: 150),
                  buttons(
                      onTap: () {
                        if (_studentKey.currentState!.validate()) {
                          addOrUpdateStudent(controller);
                          Get.back();
                        }
                      },
                      buttonName: 'Save',
                      textColor: Colors.white,
                      color: Colors.black,
                      height: 50,
                      width: 150),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addOrUpdateStudent(StudentController controller) async {
    if (controller.nameController.text.isEmpty ||
        controller.ageController.text.isEmpty) {
      controller.showMessage('Please fill all fields', isError: true);
      return;
    }
    var id = const Uuid().v1();
    StudentModel newStudent = StudentModel(
      name: controller.nameController.text,
      age: int.parse(controller.ageController.text),
      id: id,
      imageUrl: controller.imagePath.value,
      createdAt: DateTime.now(),
    );
    StudentService studentService = StudentService();
    final result = await studentService.newStudent(newStudent);
    _showMessage(result!, isError: result.startsWith('Error'));
    controller.clearFields();
  }
    void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
