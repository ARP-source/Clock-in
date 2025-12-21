import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:focustrophy/core/models/subject.dart';

class SubjectSelector extends StatelessWidget {
  final Subject? selectedSubject;
  final Function(Subject?) onSubjectSelected;

  const SubjectSelector({
    super.key,
    this.selectedSubject,
    required this.onSubjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => _showAddSubjectDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ValueListenableBuilder<Box<Subject>>(
            valueListenable: Hive.box<Subject>('subjects').listenable(),
            builder: (context, box, _) {
              final subjects = box.values.toList();
              
              if (subjects.isEmpty) {
                return Center(
                  child: TextButton(
                    onPressed: () => _showAddSubjectDialog(context),
                    child: const Text('Add your first subject'),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length + 1, // +1 for "No subject" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildSubjectChip(
                      context,
                      null,
                      'No Subject',
                      Colors.grey,
                      selectedSubject == null,
                    );
                  }
                  
                  final subject = subjects[index - 1];
                  return _buildSubjectChip(
                    context,
                    subject,
                    subject.name,
                    Color(subject.colorHex),
                    selectedSubject?.id == subject.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectChip(
    BuildContext context,
    Subject? subject,
    String label,
    Color color,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: color,
        side: BorderSide(
          color: color,
          width: 2,
        ),
        onSelected: (selected) {
          if (selected) {
            onSubjectSelected(subject);
          }
        },
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      hintText: 'e.g., Mathematics',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Color',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Colors.blue,
                      Colors.red,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.pink,
                      Colors.teal,
                      Colors.indigo,
                      Colors.amber,
                      Colors.cyan,
                    ].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color 
                                  ? Colors.black 
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final subject = Subject(
                        id: Subject.generateId(),
                        name: nameController.text,
                        colorHex: selectedColor.value,
                      );
                      
                      Hive.box<Subject>('subjects').put(subject.id, subject);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Subject'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}