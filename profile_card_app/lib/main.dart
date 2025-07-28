import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatefulWidget {
  const ProfileCardApp({super.key});

  @override
  State<ProfileCardApp> createState() => _ProfileCardAppState();
}

class _ProfileCardAppState extends State<ProfileCardApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Profile',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF111314),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF2C2C3A),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              cardColor: const Color(0xFF3B3B4A),
              textTheme: TextTheme(
                bodyLarge: GoogleFonts.roboto(color: Colors.white),
                bodyMedium: GoogleFonts.roboto(color: Colors.white70),
                titleLarge: GoogleFonts.roboto(color: Colors.white),
                titleMedium: GoogleFonts.roboto(color: Colors.white),
              ),
            )
          : ThemeData.light().copyWith(
              // Light Mode Theme
              scaffoldBackgroundColor: const Color(0xFF4e6ca2),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF4e6ca2),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              cardColor: const Color(0xFF4A7ABF),
              textTheme: TextTheme(
                bodyLarge: GoogleFonts.roboto(color: Colors.black),
                bodyMedium: GoogleFonts.roboto(color: Colors.black87),
                titleLarge: GoogleFonts.roboto(color: Colors.black),
                titleMedium: GoogleFonts.roboto(color: Colors.black),
              ),
            ),
      home: ProfilePage(isDarkMode: _isDarkMode, toggleTheme: _toggleTheme),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  final String _myName = 'Faten Hassan .';
  final String _myTitle = 'Mansoura , cairo';

  final String _linkedinUrl =
      'https://www.linkedin.com/in/faten-hassan-321114336/';
  final String _githubUrl = 'https://github.com/fatenhassen';
  final String _emailAddress = 'fatenh381.gmail.com';

  final List<String> _portfolioImages = const [
    'assets/Screenshot_1750346743.png',
    'assets/Screenshot_1750348286.png',
    'assets/photo_2025-06-20_13-05-44.jpg',
    'assets/photo_2025-06-20_12-07-24.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final String backgroundImagePath = isDarkMode
        ? 'assets/download.jpg'
        : 'assets/خلفيات جبلية ثلجية.jpg';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: const Text('Candidate profile'),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              backgroundImagePath,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: Text('', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),

          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/photo_2025-07-25_23-38-26.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            _myName,
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                          ),
                          Text(
                            _myTitle,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isDarkMode ? Colors.grey[600] : Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.more_horiz,
                            color: isDarkMode ? Colors.grey[600] : Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                _buildInfoSection(
                  context,
                  title: 'SKILLS',
                  content: Text(' Flutter & Dart, Kotlin , Android, iOS'),
                ),
                _buildInfoSection(
                  context,
                  title: 'DOMAIN',
                  content: Text('Mobile App Development (Android & iOS)'),
                ),
                _buildInfoSection(
                  context,
                  title: 'EXPERIENCE',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Graduation Project – "Heart Guardian" App.. , Designed and developed a mobile app to monitor child heart rate using IoT.., Implemented real-time alerts and data visualization using Flutter.. , Integrated backend APIs and Firebase for cloud data storage',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInfoSection(
                  context,
                  title: 'PORTFOLIO',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take a look at a few samples of my mobile work.',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: _portfolioImages.length,
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              _portfolioImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFF4A4A5C),
                                    child: Center(
                                      child: Text(
                                        'Image ${index + 1} Failed',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 40,
                        color: isDarkMode
                            ? Colors.blueAccent
                            : Colors.blue[700],
                      ),
                      onPressed: () {
                        _launchURL(_linkedinUrl);
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.github,
                        size: 40,
                        color: isDarkMode ? Colors.grey : Colors.black,
                      ),
                      onPressed: () {
                        _launchURL(_githubUrl);
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        Icons.email,
                        size: 40,
                        color: isDarkMode ? Colors.redAccent : Colors.red[700],
                      ),
                      onPressed: () {
                        _launchURL('mailto:$_emailAddress');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  size: 30,
                  color: isDarkMode ? Colors.grey : Colors.black,
                ),
                onPressed: toggleTheme,
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: isDarkMode ? Colors.grey : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: isDarkMode ? Colors.grey : Colors.black,
              ),
              Container(width: 2, height: 80, color: Colors.grey[800]),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                DefaultTextStyle(
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  child: content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('تعذر فتح الرابط: $url');
    }
  }
}
