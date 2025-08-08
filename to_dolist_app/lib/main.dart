// lib/main.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/task.dart';
import 'services/local_storage_service.dart';
import 'widgets/info_card.dart';
import 'widgets/task_list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade300),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomePage(toggleTheme: toggleTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _searchController = TextEditingController();
  final _localStorageService = LocalStorageService();
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isSearching = false;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTasks);
    _searchController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _loadTasks() async {
    final loadedTasks = await _localStorageService.loadTasks();
    setState(() {
      _tasks = loadedTasks;
      _sortTasks();
      _filteredTasks = _tasks;
    });
  }

  void _saveTasks() {
    _localStorageService.saveTasks(_tasks);
  }

  void _addTask() {
    if (_textController.text.isNotEmpty) {
      final newTask = Task(
        id: _uuid.v4(),
        text: _textController.text,
        creationTime: DateTime.now(),
      );
      setState(() {
        _tasks.add(newTask);
        _sortTasks();
        _filterTasks();
        _textController.clear();
      });
      _saveTasks();
    }
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      _sortTasks();
      _filterTasks();
    });
    _saveTasks();
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
      _filterTasks();
    });
    _saveTasks();
  }

  void _clearCompletedTasks() {
    setState(() {
      _tasks.removeWhere((task) => task.isCompleted);
      _filterTasks();
    });
    _saveTasks();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return b.creationTime.compareTo(a.creationTime);
      }
      return a.isCompleted ? 1 : -1;
    });
  }

  void _filterTasks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _tasks.where((task) {
        return task.text.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = _tasks.length;
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final leftTasks = totalTasks - completedTasks;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final hasCompletedTasks = completedTasks > 0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bottomBarColor = isDarkMode
        ? const Color(0xFF4f1697)
        : const Color(0xFFeef2fe);

    return Scaffold(
      backgroundColor: bottomBarColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1a1a34), const Color(0xFF4f1697)]
                : [const Color(0xFFeef5ff), const Color(0xFFeef2fe)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(isDarkMode),
                const SizedBox(height: 16),
                _buildProgressSection(
                  progress,
                  totalTasks,
                  completedTasks,
                  leftTasks,
                ),
                const SizedBox(height: 24),
                _buildInputSection(isDarkMode),
                const SizedBox(height: 24),
                if (hasCompletedTasks)
                  _buildClearCompletedButton(completedTasks),
                const SizedBox(height: 16),
                _isSearching
                    ? _buildSearchResults(isDarkMode)
                    : _buildTaskList(isDarkMode),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomBarColor,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
     
    final gradientColors = isDarkMode
        ? [const Color(0xFF5e1b9e), const Color(0xFF2c40a3)]
        : [Colors.purple.shade200, Colors.blue.shade200];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            print('Menu button pressed');
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradientColors,
              ),
            ),
            child: const Icon(Icons.menu, color: Colors.white),
          ),
        ),

        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: gradientColors,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            'TaskFlow',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: isDarkMode
                    ? const Color(0xFF7d5dbe)
                    : const Color(0xFF7d5dbe),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filterTasks();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDarkMode ? Colors.yellow : const Color(0xFF7d5dbe),
              ),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection(double progress, int total, int done, int left) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 15,
            backgroundColor: Colors.grey.shade300,
            color: Colors.purple.shade400,
          ),
        ),
        const SizedBox(height: 16),
        _buildTaskSummaryCards(total, done, left),
      ],
    );
  }

  Widget _buildTaskSummaryCards(int total, int done, int left) {
    return Row(
      children: [
        InfoCard(
          icon: Icons.assignment,
          title: 'Total',
          count: total,
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        InfoCard(
          icon: Icons.check_circle,
          title: 'Done',
          count: done,
          color: Colors.green,
        ),
        const SizedBox(width: 8),
        InfoCard(
          icon: Icons.access_time_filled,
          title: 'Left',
          count: left,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildInputSection(bool isDarkMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _isSearching ? _searchController : _textController,
              decoration: InputDecoration(
                hintText: _isSearching
                    ? 'Search tasks...'
                    : 'What needs to be done?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onSubmitted: _isSearching ? null : (_) => _addTask(),
            ),
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: _addTask,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: isDarkMode
                            ? [const Color(0xFF5e1b9e), const Color(0xFF2c40a3)]
                            : [Colors.purple.shade200, Colors.blue.shade200],
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Add Task',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearCompletedButton(int completedCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: _clearCompletedTasks,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: Text(
          'Clear $completedCount Completed Tasks',
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(bool isDarkMode) {
    if (_filteredTasks.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${_filteredTasks.length} result for "${_searchController.text}"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildTaskListWidget(_filteredTasks, isDarkMode),
      ],
    );
  }

  Widget _buildTaskList(bool isDarkMode) {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [const Color(0xFF2c40a3), const Color(0xFF5e1b9e)]
                      : [Colors.purple.shade200, Colors.blue.shade200],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.add, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ready to start?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Add your first task above!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return _buildTaskListWidget(_tasks, isDarkMode);
  }

  Widget _buildTaskListWidget(List<Task> tasks, bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(
          task: task,
          onToggle: _toggleTaskCompletion,
          onDelete: _deleteTask,
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}
