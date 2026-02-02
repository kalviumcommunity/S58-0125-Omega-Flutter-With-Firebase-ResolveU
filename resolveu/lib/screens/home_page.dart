import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'report_issue_screen.dart';
import 'profile_screen.dart';
import 'faq_screen.dart';
import '../theme_manager.dart';
import '../widgets/gradient_background.dart';
import 'dart:async'; // For auto-scrolling carousel

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _currentHeroPage = 0;
  Timer? _timer;

  final List<String> _heroImages = [
    'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80', // Lounge/Common
    'https://images.unsplash.com/photo-1596276122653-651a3898309f?auto=format&fit=crop&w=800&q=80', // Room
    'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=800&q=80', // Workspace
    'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=800&q=80', // Exterior
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentHeroPage < _heroImages.length - 1) {
        _currentHeroPage++;
      } else {
        _currentHeroPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentHeroPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GradientBackground(
      extendBody: true, // Allow content to go behind FAB/Nav
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Row(
          children: [
            if (_selectedIndex == 0) ...[
              Icon(Icons.home_work_rounded, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
            ],
            Text(
              _selectedIndex == 0 ? 'ResolveU' : 'Help Center',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          _buildProfileMenu(context),
        ],
      ),
      // Pass FAB and BottomBar to GradientBackground (which passes to Scaffold)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
          );
        },
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_comment_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).cardTheme.color, // Use card color
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(1, Icons.help_outline_rounded, 'FAQ'),
            ],
          ),
        ),
      ),
      child: _selectedIndex == 0
          ? _buildHomeBody(context, user)
          : const FaqScreen(),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    // Use the primary color for selected, and a distinct but simpler color for unselected.
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 28,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context, User? user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Section
          // Hero Section (Replaces simple Welcome)
          _buildHeroSection(context, user),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About ResolveU',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.apartment,
                          title: 'Your Home Away From Home',
                          description:
                              'ResolveU is dedicated to providing a comfortable and safe living environment for all students. We strive to maintain high standards of cleanliness and facility management.',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Community Guidelines',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.volume_off,
                          title: 'Quiet Hours',
                          description:
                              'Please respect quiet hours from 10:00 PM to 7:00 AM to ensure everyone gets a good night\'s rest.',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.cleaning_services,
                          title: 'Cleanliness',
                          description:
                              'Help us keep the hostel clean. Please dispose of trash in designated bins and report any maintenance issues promptly.',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 3,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildInfoCard(
                          context,
                          icon: Icons.security,
                          title: 'Safety',
                          description:
                              'Do not share your access card or keys. Report any suspicious activity to the administration immediately.',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
           const SizedBox(height: 100), // Extra space for FAB and BottomBar
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, User? user) {
    return SizedBox(
      height: 320, // Taller for better impact
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentHeroPage = index;
              });
            },
            itemCount: _heroImages.length,
            itemBuilder: (context, index) {
              return Image.network(
                _heroImages[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white54, size: 50)),
                  );
                },
              );
            },
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3), // Slight dark at top for AppBar visibility
                  Colors.transparent,
                  Colors.black.withOpacity(0.8), // Dark at bottom for text
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back, ${user?.email?.split('@')[0] ?? 'Student'}! 👋',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your comfort, safe and sound.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                    shadows: const [
                       Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                        color: Colors.black45,
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
          // Indicators
          Positioned(
            bottom: 30,
            right: 20,
            child: Row(
              children: List.generate(_heroImages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(left: 6),
                  width: _currentHeroPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentHeroPage == index
                        ? Theme.of(context).primaryColor // Use primary color for active
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        ),
        child: const Icon(Icons.person_outline),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (value == 'theme') {
          ThemeManager().toggleTheme(!ThemeManager().isDarkMode);
        } else if (value == 'logout') {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout Confirmation'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          }
        }
      },
      itemBuilder: (BuildContext context) {
        final isDark = ThemeManager().isDarkMode;
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 12),
                const Text('My Profile'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'theme',
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.orange : Colors.purple,
                ),
                const SizedBox(width: 12),
                Text(isDark ? 'Light Mode' : 'Dark Mode'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.redAccent),
                SizedBox(width: 12),
                Text('Logout', style: TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          Theme.of(context).cardTheme.shadowColor != null 
             ? BoxShadow(
                color: Theme.of(context).cardTheme.shadowColor!,
                blurRadius: 20,
                offset: const Offset(0, 4),
               )
             : BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
             ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
