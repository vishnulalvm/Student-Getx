import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/data_controller.dart';
import 'package:myapp/services/student_service.dart';
import 'package:myapp/utils/text/modified_text.dart';
import 'package:myapp/view/widgets/confirm_dialogbox.dart';
import 'package:myapp/view/widgets/custom_button.dart';
import 'package:myapp/view/widgets/widget_space.dart';

class StudentDetails extends StatefulWidget {
  final String name;
  final int age;
  final String imageUrl;
  final String id;
  const StudentDetails(
      {super.key, required this.name, required this.age, required this.imageUrl, required this.id});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  StudentService studentService = StudentService();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataController());
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                    space(height: 20),
                    ModifiedText(
                        text: widget.name,
                        size: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                    space(height: 20),
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: ModifiedText(
                            text: "Age : ${widget.age.toString()}",
                            size: 17,
                            color: Colors.black),
                      ),
                    ),
                    space(height: 20),
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: ModifiedText(
                            text: "Shoping Details",
                            size: 17,
                            color: Colors.black),
                      ),
                    ),
                    space(height: 20),
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Obx(() {
                        if (controller.apiDataModel.value.id != null) {
                          return  ModifiedText(
                              text: "${controller.apiDataModel.value.id}",
                              size: 17,
                              color: Colors.black);
                        }
                        return const ModifiedText(
                            text: "Shoping Details",
                            size: 17,
                            color: Colors.black);
                      })),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttons(
                      height: 50,
                      width: 150,
                      onTap: () {
                        MyAlertDialog(
                          message: 'Are you sure you want to delete this user?',
                          context: context,
                        );
                      },
                      buttonName: "Edit",
                      textColor: Colors.white,
                      color: Colors.grey),
                  buttons(
                      height: 50,
                      width: 150,
                      onTap: () {
                        studentService.deleteStudent(widget.id);
                        Get.back();
                      },
                      buttonName: "delete",
                      textColor: Colors.white,
                      color: Colors.red)
                ],
              ),
            ],
          ),
        ));
  }
}
