import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/dashboard/dashboard_screen.dart';
import 'package:gym_app/features/exercises/exercise_list_screen.dart';
import 'package:gym_app/features/progress/progress_screen.dart';
import 'package:gym_app/features/settings/settings_screen.dart';
import 'package:gym_app/features/auth/auth_viewmodel.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Inicio' : 'Mi Progreso'),
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      drawer: _buildAppDrawer(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Progreso',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryPurpleDark,
        unselectedItemColor: AppColors.textSecondary,
        onTap: _onItemTapped,
        backgroundColor: AppColors.cardBackground,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Drawer _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: AppColors.primaryPurpleDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Ejercicios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ExerciseListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthViewModel>().signOut();
            },
          ),
        ],
      ),
    );
  }
}