import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

import 'package:peticare/features/vet/presentation/pages/vet_appointments_page.dart';
import 'package:peticare/features/vet/presentation/pages/groom_vet_appointments_page.dart';

class VetPanelPage extends StatelessWidget {
  const VetPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _VetTabConfig(
        label: "Citas vet",
        svgAsset: "assets/illustrations/blood_tests_results.svg",
      ),
      _VetTabConfig(
        label: "Citas de pelu",
        svgAsset: "assets/illustrations/grooming_appointment.svg",
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Panel de la clínica"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: _TabsHeader(tabs: tabs),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VetAppointmentsPage(),
            GroomVetAppointmentsPage(),
          ],
        ),
      ),
    );
  }
}

class _VetTabConfig {
  final String label;
  final String svgAsset;

  _VetTabConfig({
    required this.label,
    required this.svgAsset,
  });
}

class _TabsHeader extends StatelessWidget {
  final List<_VetTabConfig> tabs;

  const _TabsHeader({required this.tabs});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppPalette.background(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalSpacing.sm(context),
          TabBar(
            indicatorColor: AppPalette.primary,
            indicatorWeight: 3,
            labelPadding: EdgeInsets.zero,
            tabs: tabs
                .map(
                  (t) => _TabButton(
                    label: t.label,
                    svgAsset: t.svgAsset,
                  ),
                )
                .toList(),
          ),
          VerticalSpacing.sm(context),
        ],
      ),
    );
  }
}

/// Botón/tab con SVG + texto en una fila, con texto de 2 líneas máximo
class _TabButton extends StatelessWidget {
  final String label;
  final String svgAsset;

  const _TabButton({
    required this.label,
    required this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = AppPalette.textOnSecondaryBg(context);

    return Tab(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppPalette.surfaces(context).withValues(
            alpha: isDark ? 0.25 : 0.9,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              height: 22,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
