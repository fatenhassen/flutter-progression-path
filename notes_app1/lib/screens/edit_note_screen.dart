 
import 'package:flutter/material.dart';

class EditNoteDialog extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final Function(String, String) onSave;

  const EditNoteDialog({
    super.key,
    required this.initialTitle,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Card(
        color: theme.cardColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Note",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Content",
                  labelStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final title = _titleController.text.trim();
                      final content = _contentController.text.trim();
                      if (title.isNotEmpty && content.isNotEmpty) {
                        widget.onSave(title, content);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
