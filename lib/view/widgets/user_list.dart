import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/student_controller.dart';
import 'package:myapp/services/student_service.dart';
import 'package:myapp/models/student_model.dart';
import 'package:myapp/view/pages/student_details.dart';
import 'package:myapp/utils/font/font_color.dart';
import 'package:myapp/utils/text/modified_text.dart';

class UserlistSection extends StatefulWidget {
  final ScrollController scrollController;
  final List<StudentModel> list;
  const UserlistSection(
      {super.key, required this.scrollController, required this.list});

  @override
  State<UserlistSection> createState() => _UserlistSectionState();
}

class _UserlistSectionState extends State<UserlistSection> {
  StudentService studentService = StudentService();
  @override
  Widget build(BuildContext context) {
    final studentController = Get.find<StudentController>();
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          StudentModel student = widget.list[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
            child: IntrinsicHeight(
              child: OpenContainer(
                openColor: Colors.white,
                transitionDuration: Durations.long2,
                transitionType: ContainerTransitionType
                    .fadeThrough, // Adjust the transition type as needed
                openBuilder: (BuildContext context, VoidCallback _) {
                  return StudentDetails(
                    name: student.name!,
                    age: student.age!,
                    imageUrl: student.imageUrl!,
                    id: student.id!,
                  );
                },
                closedElevation: 1,
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                closedColor: Colors.white,
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return ListTile(
                    onTap: () {
                      openContainer();
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(student.imageUrl!),
                    ),
                    subtitle: ModifiedText(
                        text: student.age.toString(),
                        size: 13,
                        color: Colors.black),
                    title: ModifiedText(
                      text: student.name!,
                      size: 15,
                      color: AppColor.fontColor,
                      fontWeight: FontWeight.w700,
                    ),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                                  studentController
                                          .deleteStudent(student.id!);
                                      Get.back();
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return MyAlertDialog(
                              //       onYes: () {
                              //         studentController
                              //             .deleteStudent(student.id!);
                              //         Get.back();
                              //       },
                              //       message:
                              //           'Are you sure you want to proceed?',
                              //       context: context,
                              //     );
                              //   },
                              // );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // void editButton(BuildContext context, StudentModel student) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AddUserDialog(
  //         studentModel: student,
  //         onSave: (StudentModel studentModel) async {
  //           StudentService studentService = StudentService();
  //           final result = await studentService.newStudent(studentModel);
  //           _showMessage(result!, isError: result.startsWith('Error'));
  //         },
  //       );
  //     },
  //   );
  // }

  // void _showMessage(String message, {bool isError = false}) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: isError ? Colors.red : Colors.green,
  //     ),
  //   );
  // }
}
