import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gym_app/common/theme/app_theme.dart';
// Importamos la nueva pantalla de creación de planes
import 'package:gym_app/features/planning/create_plan_screen.dart';
import 'package:gym_app/features/auth/auth_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authViewModel = context.watch<AuthViewModel>();
    // He simplificado el nombre de usuario para evitar posibles nulos.
    final userName = authViewModel.user?.displayName ?? authViewModel.user?.email?.split('@').first ?? 'Bienvenido';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, $userName!', style: textTheme.headlineSmall),
                const SizedBox(height: 30),
                
                _buildActionCard(
                  context: context,
                  icon: Iconsax.edit,
                  title: 'Crear Plan de Entrenamiento',
                  subtitle: 'Construye tu plan semanal', // Subtítulo actualizado
                  color: AppColors.primaryPurple,
                  iconColor: AppColors.primaryPurpleDark,
                  onTap: () {
                    // Acción actualizada: Navega a la nueva pantalla de creación.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CreatePlanScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                _buildActionCard(
                  context: context,
                  icon: Iconsax.shuffle,
                  title: 'Rutina Aleatoria',
                  subtitle: 'Una opción rápida para empezar',
                  color: AppColors.secondaryGreen,
                  iconColor: Colors.green.shade800,
                  onTap: () {
                    // Lógica para rutina aleatoria (sin cambios)
                  },
                ),
                const SizedBox(height: 30),
                
                _buildProgressCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // El resto del código de DashboardScreen (_buildActionCard, _buildProgressCard, etc.)
  // permanece exactamente igual que antes, así que lo omito por brevedad.

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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 4),
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
              Text('Mi Progreso', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem(color: AppColors.primaryPurpleDark, text: 'Peso Levantado'),
              const SizedBox(width: 16),
              _buildLegendItem(color: AppColors.chartBarGreen, text: 'Calorías'),
            ],
          ),
          const SizedBox(height: 24),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
  
  Widget _buildChart() {
    return SizedBox(
      height: 140,
      child: CustomPaint(
        painter: _ProgressChartPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.primaryPurpleDark.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = AppColors.primaryPurpleDark
      ..style = PaintingStyle.fill;
    
    final barPaintPurple = Paint()..color = AppColors.chartBarPurple.withOpacity(0.8);
    final barPaintGreen = Paint()..color = AppColors.chartBarGreen.withOpacity(0.8);

    final path = Path();
    
    // Datos de ejemplo para la gráfica
    final dataPoints = [0.3, 0.5, 0.4, 0.6, 0.5, 0.8, 0.7, 0.9];
    final maxVal = 1.0; 

    final stepX = size.width / (dataPoints.length - 1);
    
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * stepX;
      final y = size.height - (dataPoints[i] / maxVal * size.height);

      // Dibujar barras
      final barPaint = i % 2 == 0 ? barPaintPurple : barPaintGreen;
      final barTop = y;
      final barBottom = size.height;
      final barLeft = x - 5;
      final barRight = x + 5;
      canvas.drawRRect(
        RRect.fromLTRBR(barLeft, barTop, barRight, barBottom, const Radius.circular(4)),
        barPaint
      );
      
      // Mover la línea y dibujar puntos
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4, fillPaint);
    }
    
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}