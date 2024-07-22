import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/student_controller.dart';
import 'package:myapp/view/widgets/bottom_sheet.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  TextEditingController searchController = TextEditingController();
  final StudentController studentController = Get.put(StudentController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(22)),
              child: TextFormField(
                controller: searchController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                cursorWidth: 0,
                cursorHeight: 0,
                onChanged: (value) {
                  studentController.debouncer.run(() {
                    studentController.searchStudents(value);
                  });
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    hintText: 'Search by name',
                    hintStyle: TextStyle()),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              showBottomSheet(context);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return const BottomSheetWidget();
      },
    );
  }
}
