import 'package:flutter/material.dart';
import 'package:flutter_gemini/providers/chat_provider.dart';
import 'package:flutter_gemini/screens/chat_history_screen.dart';
import 'package:flutter_gemini/screens/chat_screen.dart';
import 'package:flutter_gemini/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of screens
  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          body: PageView(
            controller: chatProvider.pageController,
            children: _screens,
            onPageChanged: (index) {
              chatProvider.setCurrentIndex(newIndex: index);
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // More opaque shadow
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Padding from bottom
              child: BottomNavigationBar(
                currentIndex: chatProvider.currentIndex,
                elevation: 10,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                onTap: (index) {
                  chatProvider.setCurrentIndex(newIndex: index);
                  chatProvider.pageController.jumpToPage(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Chat History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
