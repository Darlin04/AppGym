// lib/features/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:gym_app/common/theme/app_theme.dart';
import 'package:gym_app/features/onboarding/questionnaire_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Darlin!', style: textTheme.headlineSmall),
                const SizedBox(height: 30),
                
                _buildActionCard(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  title: 'Crear Plan de Entrenamiento',
                  subtitle: 'Personaliza tu rutina',
                  color: AppColors.primaryPurple,
                  iconColor: AppColors.primaryPurpleDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                _buildActionCard(
                  context: context,
                  icon: Icons.casino_outlined,
                  title: 'Rutina Aleatoria',
                  subtitle: 'Una opción rápida',
                  color: AppColors.secondaryGreen,
                  iconColor: Colors.green.shade800,
                  onTap: () {
                    // Navegación a la pantalla de selección de rutina aleatoria
                  },
                ),
                const SizedBox(height: 30),
                
                
                _buildProgressCard(context),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mi Progreso', style: Theme.of(context).textTheme.titleLarge),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(height: 40, color: AppColors.chartBarPurple),
                _buildChartBar(height: 60, color: AppColors.chartBarPurple),
                _buildChartBar(height: 50, color: AppColors.chartBarPurple),
                _buildChartBar(height: 80, color: AppColors.chartBarGreen),
                _buildChartBar(height: 30, color: AppColors.chartBarGreen),
                _buildChartBar(height: 60, color: AppColors.chartBarPurple),
                _buildChartBar(height: 20, color: AppColors.chartBarPurple),
                _buildChartBar(height: 90, color: AppColors.chartBarPurple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar({required double height, required Color color}) {
    return Container(
      width: 12,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }



  Widget _buildInfoCard({required BuildContext context, required String title, required Widget content}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
            const Spacer(),
            SizedBox(height: 40, child: content),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}