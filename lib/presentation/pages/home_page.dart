import 'package:flutter/material.dart';
import 'package:myapp/application/services/student_service.dart';
import 'package:myapp/domian/models/student_model.dart';
import 'package:myapp/presentation/widgets/scroll_to_hide.dart';
import 'package:myapp/presentation/widgets/search_section.dart';
import 'package:myapp/presentation/widgets/show_dialog.dart';
import 'package:myapp/presentation/widgets/user_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentService studentService = StudentService();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(16, 14, 9, 1),
        title: const Row(
          children: [
            Icon(
              Icons.people_alt_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Student List',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SearchSection(),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
            child: Text(
              'User List',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          StreamBuilder<List<StudentModel>>(
              stream: studentService.getStudent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.data == null) {
                  return const Center(child: Text('No data found'));
                }
                if (snapshot.hashCode != 0 && snapshot.data != null) {
                  List<StudentModel> list = snapshot.data ?? [];
                  list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                  return UserlistSection(
                    scrollController: scrollController,
                    list: list,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
      floatingActionButton: ScrollToHide(
        height: 60,
        hideDirection: Axis.vertical,
        scrollController: scrollController,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            showLogoutDialog(context);
          },
          child: const Icon(
            Icons.add,
            weight: 800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUserDialog(
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
