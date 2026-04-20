import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:peticare/features/groom_appointments/presentation/controllers/add_new_groom_appointment_page_controller.dart';

Widget reviewAndPayPage(
  Size screenSize,
  AddNewGroomAppointmentPageController controller,
) {
  final storage = const FlutterSecureStorage();

  /// 🔥 STATE GLOBAL (NO RECREAR)
  final RxInt reservationFee = 0.obs;
  final RxBool isLoadingPrice = true.obs;
  final RxString currency = "PYG".obs;

  /// 🔥 GROOMER SEGURO
  final groomer = controller.groomersList.firstWhereOrNull(
    (g) => g['id'].toString() == controller.selectedGroomerID,
  );

  final bool isMobile = controller.isMobileGrooming ?? false;

  /// 🔥 FETCH CONTROLADO (SOLO UNA VEZ)
  void fetchPriceOnce() async {
    if (!isLoadingPrice.value) return;

    try {
      final token = await storage.read(key: 'access_token');

      final api = GetConnect();

      final response = await api.get(
        "http://192.168.40.54:8000/api/v1/pricing/base"
        "?service_type=grooming"
        "&is_mobile=$isMobile",
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 && response.body != null) {
        reservationFee.value = response.body["price"] ?? 0;
        currency.value = response.body["currency"] ?? "PYG";
      }
    } catch (e) {
      print("ERROR PRICE: $e");
    } finally {
      isLoadingPrice.value = false;
    }
  }

  /// 🔥 EJECUCIÓN SEGURA
  WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchPriceOnce();
  });

  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [

            VerticalSpacing.md(context),

            /// 🔙 BACK
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedIconButton(
                iconData: Icons.arrow_back_rounded,
                foregroundColor: AppPalette.primaryText(context),
                onClick: controller.previousPage,
              ),
            ),

            /// 🏷 TITULO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: Text(
                "Revisar y confirmar",
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.textOnSecondaryBg(context),
                  fontSize: constraints.maxHeight > 580 ? 35 : 32,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            VerticalSpacing.xl(context),

            /// 📦 RESUMEN
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppPalette.primary.withValues(alpha: .05),
              ),
              child: Column(
                children: [

                  _row(context, 'Mascota', controller.selectedPet?['name'] ?? ''),
                  _divider(context),

                  _row(context, 'Servicio', controller.appointmentType ?? ''),
                  _divider(context),

                  _row(
                    context,
                    'Fecha',
                    DateFormat('EEEE, dd MMM yyyy')
                        .format(controller.appointmentDateTime),
                  ),
                  _divider(context),

                  _row(
                    context,
                    'Hora',
                    DateFormat("HH:mm")
                        .format(controller.appointmentDateTime),
                  ),
                  _divider(context),

                  _row(
                    context,
                    'Peluquería',
                    groomer != null ? groomer['name'] : 'No seleccionado',
                  ),
                  _divider(context),

                  _row(
                    context,
                    'Modalidad',
                    isMobile ? 'A domicilio' : 'En clínica',
                  ),
                  _divider(context),

                  /// 💰 PRECIO DINÁMICO REAL
                  Obx(() {
                    if (isLoadingPrice.value) {
                      return _row(context, 'Pago mínimo', 'Calculando...');
                    }

                    return _row(
                      context,
                      'Pago mínimo',
                      "Gs. ${reservationFee.value}",
                      isHighlight: true,
                    );
                  }),
                ],
              ),
            ),

            VerticalSpacing.lg(context),

            /// ⚠️ AVISO NEGOCIO (CLAVE)
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * .05),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "⚠️ Este pago corresponde a una reserva mínima del servicio.\n"
                "El precio final puede variar según el tamaño, tipo de mascota o servicios adicionales.\n"
                "Cualquier diferencia será abonada directamente en la clínica.",
                style: AppTextStyles.bodyRegular.copyWith(
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            VerticalSpacing.lg(context),

            /// 🔔 RECORDATORIO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * .05 + 16,
              ),
              child: Row(
                children: [
                  const Text('Agregar recordatorio'),
                  const Spacer(),
                  Switch(
                    value: controller.addReminder,
                    onChanged: controller.updateAddReminder,
                  ),
                ],
              ),
            ),

            /// 📅 CALENDARIO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * .05 + 16,
              ),
              child: Row(
                children: [
                  const Text('Agregar al calendario'),
                  const Spacer(),
                  Switch(
                    value: controller.addToCalendar,
                    onChanged: controller.updateAddToCalendar,
                  ),
                ],
              ),
            ),

            VerticalSpacing.lg(context),
          ],
        ),
      );
    },
  );
}

//////////////////////////////////////////////////////////////

Widget _row(
  BuildContext context,
  String label,
  String value, {
  bool isHighlight = false,
}) {
  return Row(
    children: [
      Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 24),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: isHighlight
              ? AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary,
                )
              : null,
        ),
      ),
    ],
  );
}

Widget _divider(BuildContext context) {
  return Divider(
    color: AppPalette.disabled(context).withValues(alpha: .3),
    indent: 24,
    endIndent: 24,
  );
}