import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  final int _maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const HomePage(),
      const PipelinePage(),
      const ContactsPage(),
      const CompaniesPage(),
    ];

    final double iconSize = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      bottomNavigationBar: bottomBarPages.length <= _maxCount
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: Colors.blueAccent,
              removeMargins: false,
              bottomBarWidth: MediaQuery.of(context).size.width,
              showShadow: true,
              durationInMilliSeconds: 300,
              itemLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              elevation: 2,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(Icons.home_outlined, color: Colors.grey),
                  activeItem: Icon(Icons.home, color: Colors.white),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.stacked_line_chart_outlined,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.stacked_line_chart,
                    color: Colors.white,
                  ),
                  itemLabel: 'Pipeline',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.contacts_outlined,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(Icons.contacts, color: Colors.white),
                  itemLabel: 'Contacts',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.apartment_outlined,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(Icons.apartment, color: Colors.white),
                  itemLabel: 'Companies',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                setState(() {
                  _controller.index = index;
                  _pageController.jumpToPage(index);
                });
              },
              kIconSize: iconSize,
            )
          : null,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: const Center(
        child: Text(
          '🏠 Home Screen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class PipelinePage extends StatelessWidget {
  const PipelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: const Center(
        child: Text(
          '📋 Pipeline Screen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[50],
      child: const Center(
        child: Text(
          '👥 Contacts Screen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[50],
      child: const Center(
        child: Text(
          '🏢 Companies Screen',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
