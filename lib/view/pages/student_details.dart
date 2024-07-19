import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/view/widgets/widget_space.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({super.key});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/566/566985.png'),
            ),
            space(
              height: 20
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
        
            )
          ],
        ),
      )
      
    );
  }
}