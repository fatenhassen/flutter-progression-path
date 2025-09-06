import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

void showNoteDialog({
  required BuildContext context,
  String? initialTitle,
  String? initialContent,
  String? initialCategory,
  String? noteId,
  VoidCallback? onNoteAdded,
}) {
  final _titleController = TextEditingController(text: initialTitle);
  final _contentController = TextEditingController(text: initialContent);
  final _supabaseService = SupabaseService();
  String selectedCategory = initialCategory ?? 'General';

  final List<String> categories = [
    'General',
    'Work',
    'Todo',
    'Ideas',
    'Personal',
  ];

  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final backgroundColor = isDarkMode
      ? const Color(0xFF192b43)
      : const Color(0xFFE4F2FB);
  final secondBackgroundColor = isDarkMode
      ? const Color(0xFF37294d)
      : const Color(0xFFF1DDF5);
  final cardColor = isDarkMode
      ? const Color(0xFF192b43).withOpacity(0.8)
      : Colors.white.withOpacity(0.8);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor, secondBackgroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.deepPurple,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              noteId == null ? 'Create New Note' : 'Edit Note',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.deepPurple,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _contentController.text.isNotEmpty) {
                                if (noteId == null) {
                                  await _supabaseService.createNote(
                                    _titleController.text,
                                    _contentController.text,
                                    selectedCategory,
                                  );
                                } else {
                                  await _supabaseService.updateNote(
                                    id: noteId,
                                    title: _titleController.text,
                                    content: _contentController.text,
                                    category: selectedCategory,
                                  );
                                }
                                Navigator.of(context).pop();
                                if (onNoteAdded != null) {
                                  onNoteAdded();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.deepPurple, Colors.pink],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                noteId == null ? 'Save' : 'Update',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        noteId == null
                            ? 'Capture your brilliant thoughts'
                            : 'Polish your thoughts and ideas',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _titleController,
                        label: 'Title',
                        icon: Icons.notes,
                        isDarkMode: isDarkMode,
                        cardColor: cardColor,
                      ),
                      const SizedBox(height: 16),

                      _buildCategoryDropdown(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        isDarkMode: isDarkMode,
                        cardColor: cardColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              selectedCategory = newValue;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _contentController,
                        label: 'Content',
                        icon: Icons.text_fields,
                        maxLines: 6,
                        isDarkMode: isDarkMode,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  int maxLines = 1,
  required bool isDarkMode,
  required Color cardColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white70 : Colors.deepPurple),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCategoryDropdown({
  required List<String> categories,
  required String selectedCategory,
  required ValueChanged<String?> onChanged,
  required bool isDarkMode,
  required Color cardColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          Icons.category,
          color: isDarkMode ? Colors.white70 : Colors.deepPurple,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDarkMode ? Colors.white70 : Colors.deepPurple,
              ),
              dropdownColor: isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : Colors.white,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              onChanged: onChanged,
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ),
  );
}
