import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/student_model.dart';

class CustomSearchDelegate extends SearchDelegate<StudentModel> {
  final CollectionReference _studentsRef = FirebaseFirestore.instance.collection('students');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _studentsRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        final List<StudentModel> searchResults = snapshot.data!.docs
            .map((doc) => StudentModel.fromJson(doc))
            .toList();

        return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final student = searchResults[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(student.imageUrl ?? ''),
                radius: 25,
                backgroundColor: Colors.blue,
              ),
              title: Text(student.name ?? 'No name'),
              subtitle: Text('ID: ${student.id ?? 'No ID'}'),
              onTap: () {
                close(context, student);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _studentsRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No suggestions'));
        }

        final List<StudentModel> suggestions = snapshot.data!.docs
            .map((doc) => StudentModel.fromJson(doc))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final student = suggestions[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(student.imageUrl ?? ''),
                radius: 25,
                backgroundColor: Colors.blue,
              ),
              title: Text(student.name ?? 'No name'),
              subtitle: Text('ID: ${student.id ?? 'No ID'}'),
              onTap: () {
                query = student.name ?? '';
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}