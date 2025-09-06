 
import 'package:flutter/material.dart';

class CreateNoteDialog extends StatefulWidget {
  final Function(String, String) onSave;

  const CreateNoteDialog({super.key, required this.onSave});

  @override
  State<CreateNoteDialog> createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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
                "Create Note",
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
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
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
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
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
