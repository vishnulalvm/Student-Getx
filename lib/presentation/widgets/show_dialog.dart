import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myapp/domian/models/student_model.dart';
import 'package:myapp/presentation/widgets/custom_button.dart';
import 'package:myapp/presentation/widgets/widget_space.dart';
import 'package:myapp/utils/text/modified_text.dart';
import 'package:uuid/uuid.dart';

class AddUserDialog extends StatefulWidget {
  final Function(StudentModel) onSave;
  final StudentModel? studentModel;

  const AddUserDialog({super.key, required this.onSave, this.studentModel});

  @override
  AddUserDialogState createState() => AddUserDialogState();
}

class AddUserDialogState extends State<AddUserDialog> {
  final _studentKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String? imagePath = '';
  BuildContext? _context;
  bool isLoading = false;

  editStudent() {
    if (widget.studentModel != null) {
      setState(() {
        nameController.text = widget.studentModel!.name!;
        ageController.text = widget.studentModel!.age.toString();
        imagePath = widget.studentModel!.imageUrl;
        isLoading = true;
      });
      
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title:isLoading? const ModifiedText(
          text: 'Update User', size: 13, color: Colors.black): const ModifiedText(
          text: 'Add New User', size: 13, color: Colors.black),
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
                       const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        // backgroundImage: NetworkImage(imagePath!),
                      ),
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
                              onPressed: () {
                                pickProfileImage();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 24,
                                color: Colors.white,
                              )),
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
                  controller: nameController,
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
                  controller: ageController,
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
          buttonName: 'Cancel',
          textColor: Colors.black87,
          color: const Color.fromRGBO(204, 204, 204, 1),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        buttons(
          buttonName: isLoading ? 'Update' : 'Save',
          textColor: Colors.white,
          color: const Color.fromRGBO(23, 130, 225, 1),
          onTap: () {
            if (_studentKey.currentState!.validate()) {
              _addStudent();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Future<String?> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imageUrl = await uploadImageToFirebaseStorage(pickedFile);
      setState(() {
        imagePath = imageUrl;
      });
      return imageUrl;
    }

    return null;
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
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return '';
    }
  }

  void _addStudent() {
    if (nameController.text.isEmpty || ageController.text.isEmpty) {
      _showMessage('Please fill all fields', isError: true);
      return;
    }
    var id = const Uuid().v1();
    StudentModel studentModel = StudentModel(
      name: nameController.text,
      age: int.parse(ageController.text),
      id: id,
      imageUrl: imagePath ?? '',
      createdAt: DateTime.now(),
    );
    widget.onSave(studentModel);
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
