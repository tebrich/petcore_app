import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'vet_panel_page.dart';
import 'vet_appointments_page.dart';
import 'groom_vet_appointments_page.dart';

class VetHomePage extends StatelessWidget {
  const VetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Veterinario')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * .06, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top illustration
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Center(
                child: SvgPicture.asset(
                  'assets/illustrations/background_shape.svg',
                  height: size.height * 0.22,
                  colorFilter: ColorFilter.mode(AppPalette.primary.withValues(alpha: .12), BlendMode.srcATop),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 12),
                child: SvgPicture.asset(
                  'assets/illustrations/add_new_vet_appointment.svg',
                  height: size.height * 0.18,
                ),
              ),
            ),

            VerticalSpacing.lg(context),

            Text(
              'Bienvenido',
              style: AppTextStyles.headingLarge.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              'Seleccione una opción para comenzar',
              style: AppTextStyles.bodyRegular.copyWith(color: AppPalette.disabled(context)),
            ),

            VerticalSpacing.xl(context),

            // Menu buttons
            _menuButton(
              context,
              icon: Icons.calendar_month,
              label: 'Panel clínico',
              subtitle: 'Ver citas de la clínica',
              onTap: () => Get.to(() => const VetPanelPage()),
            ),

            VerticalSpacing.md(context),

            _menuButton(
              context,
              icon: Icons.medical_services,
              label: 'Mis citas (Veterinaria)',
              subtitle: 'Ver y gestionar citas veterinarias',
              onTap: () => Get.to(() => const VetAppointmentsPage()),
            ),

            VerticalSpacing.md(context),

            _menuButton(
              context,
              icon: Icons.cut,
              label: 'Citas Peluquería',
              subtitle: 'Ver y gestionar citas de peluquería',
              onTap: () => Get.to(() => const GroomVetAppointmentsPage()),
            ),

            VerticalSpacing.md(context),

            _menuButton(
              context,
              icon: Icons.calendar_today_outlined,
              label: 'Calendario',
              subtitle: 'Vista calendario (ocupación)',
              onTap: () {
                // placeholder navigation: implement calendar page later
                Get.snackbar('Próximamente', 'Calendario pronto a implementarse');
              },
            ),

            VerticalSpacing.xl(context),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, {required IconData icon, required String label, required String subtitle, required VoidCallback onTap}) {
    return Material(
      color: AppPalette.surfaces(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppPalette.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodyRegular.copyWith(color: AppPalette.disabled(context), fontSize: 13)),
                ]),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

