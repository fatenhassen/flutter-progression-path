import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/supabase_service.dart';
import 'dart:async';
import 'package:notes_app1/widgets/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const NotesScreen({required this.onThemeToggle, super.key});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _searchController = TextEditingController();
  bool _showWelcomeMessage = true;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showWelcomeMessage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _searchController.dispose();
    super.dispose();
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'work':
        return Colors.blue[300]!;
      case 'personal':
        return Colors.green[300]!;
      case 'ideas':
        return Colors.purple[300]!;
      case 'todo':
        return Colors.orange[300]!;
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final textColor = isDarkMode ? Colors.white : Colors.deepPurple;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey;
    final noteTitleColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.deepPurple, Colors.pink],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.description, color: Colors.white, size: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black54,
            ),
            onPressed: widget.onThemeToggle,
          ),
          Container(
            width: 35,
            height: 35,
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('T', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, secondBackgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
             
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Your Notes',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      StreamBuilder<List<Note>>(
                        stream: _supabaseService.getNotes(),
                        builder: (context, snapshot) {
                          final noteCount = snapshot.data?.length ?? 0;
                          return Center(
                            child: Text(
                              '$noteCount notes ready to inspire',
                              style: TextStyle(color: hintColor, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSearchField(noteTitleColor, hintColor),
                      const SizedBox(height: 16),
                      _buildCategoriesSection(cardColor, textColor),
                      const SizedBox(height: 16),
                      _buildAddNoteButton(),
                      const SizedBox(height: 24),
                      StreamBuilder<List<Note>>(
                        stream: _supabaseService.getNotes(
                          category: _selectedCategory == 'All'
                              ? null
                              : _selectedCategory,
                          searchQuery: _searchController.text,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No notes yet. Add one!',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              ),
                            );
                          }
                          final notes = snapshot.data!;
                          return Column(
                            children: notes.map((note) {
                              return _buildNoteCard(
                                note,
                                cardColor,
                                noteTitleColor,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_showWelcomeMessage)
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Welcome back!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(Color noteTitleColor, Color? hintColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: noteTitleColor),
        decoration: InputDecoration(
          hintText: 'Search your thoughts...',
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.search, color: hintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryChip('All'),
            const SizedBox(width: 8),
            _buildCategoryChip('Work'),
            const SizedBox(width: 8),
            _buildCategoryChip('Personal'),
            const SizedBox(width: 8),
            _buildCategoryChip('Ideas'),
            const SizedBox(width: 8),
            _buildCategoryChip('Todo'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected =
        _selectedCategory == category ||
        (category == 'All' && _selectedCategory == null);
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category == 'All' ? null : category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _getTagColor(category)
              : _getTagColor(category).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : _getTagColor(category),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAddNoteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showNoteDialog(context: context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.pink],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: const Text(
              '+ New Note',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note, Color cardColor, Color noteTitleColor) {
    return InkWell(
      onTap: () {
        showNoteDialog(
          context: context,
          initialTitle: note.title,
          initialContent: note.content,
          initialCategory: note.category,
          noteId: note.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: noteTitleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: _getTagColor(note.category),
                        size: 20,
                      ),
                      onPressed: () {
                        showNoteDialog(
                          context: context,
                          initialTitle: note.title,
                          initialContent: note.content,
                          initialCategory: note.category,
                          noteId: note.id,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () async {
                        await _supabaseService.deleteNote(note.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getTagColor(note.category).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                note.category,
                style: TextStyle(
                  color: _getTagColor(note.category),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: noteTitleColor.withOpacity(0.54)),
            ),
          ],
        ),
      ),
    );
  }
}
