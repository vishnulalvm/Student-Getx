import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:myapp/application/services/student_service.dart';
import 'package:myapp/domian/models/student_model.dart';
import 'package:myapp/presentation/widgets/show_dialog.dart';
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
                  return const SizedBox();
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
                        size: 12,
                        color: Colors.black),
                    title: ModifiedText(
                      text: student.name!,
                      size: 13,
                      color: AppColor.fontColor,
                      fontWeight: FontWeight.w700,
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editButton(context, student);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              studentService.deleteStudent(student.id);
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

  void editButton(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUserDialog(
          studentModel: student,
          onSave: (StudentModel studentModel) async {
            StudentService studentService = StudentService();
            final result = await studentService.newStudent(studentModel);
            _showMessage(result!, isError: result.startsWith('Error'));
          },
        );
      },
    );
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
