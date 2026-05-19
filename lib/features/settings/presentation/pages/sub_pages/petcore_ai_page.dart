import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

class PetCoreAIPage extends StatelessWidget {
  const PetCoreAIPage({super.key});

  @override
  Widget build(BuildContext context) {

    Size screenSize =
        MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(

        automaticallyImplyLeading: true,

        title: Text(

          'PetCore AI',

          style: AppTextStyles.headingMedium.copyWith(

            color:
                AppPalette.textOnSecondaryBg(context),

            fontSize: 22,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * .07,
            ),

            child: Column(

              children: [

                VerticalSpacing.xxl(context),

                Container(

                  height: 110,
                  width: 110,

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    gradient: LinearGradient(

                      colors: [

                        Colors.purpleAccent,

                        AppPalette.primary,
                      ],
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.purpleAccent
                            .withValues(alpha: .35),

                        blurRadius: 25,

                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Icon(

                    Icons.auto_awesome,

                    size: 55,

                    color: Colors.white,
                  ),
                ),

                VerticalSpacing.xl(context),

                Text(

                  'Asistente Inteligente PetCore',

                  textAlign: TextAlign.center,

                  style: AppTextStyles.headingLarge.copyWith(

                    color:
                        AppPalette.textOnSecondaryBg(context),

                    fontSize: 28,
                  ),
                ),

                VerticalSpacing.md(context),

                Text(

                  'Próximamente podrás acceder a herramientas inteligentes y recomendaciones personalizadas para el cuidado de tus mascotas.',

                  textAlign: TextAlign.center,

                  style: AppTextStyles.bodyRegular.copyWith(

                    color:
                        AppPalette.secondaryText(context),

                    fontSize: 14,
                  ),
                ),

                VerticalSpacing.xxl(context),

                _featureTile(
                  context,
                  Icons.health_and_safety_outlined,
                  'Consejos inteligentes de salud',
                ),

                _featureTile(
                  context,
                  Icons.restaurant_menu,
                  'Recomendaciones de alimentación',
                ),

                _featureTile(
                  context,
                  Icons.notifications_active_outlined,
                  'Alertas y recordatorios avanzados',
                ),

                _featureTile(
                  context,
                  Icons.shopping_bag_outlined,
                  'Sugerencias personalizadas de productos',
                ),

                _featureTile(
                  context,
                  Icons.pets,
                  'Asistencia inteligente para mascotas',
                ),

                VerticalSpacing.xxl(context),

                Container(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.purpleAccent
                        .withValues(alpha: .12),

                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: Text(

                    'Disponible próximamente',

                    style: AppTextStyles.bodyMedium.copyWith(

                      color: Colors.purpleAccent,

                      fontSize: 14,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                VerticalSpacing.xxl(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureTile(
    BuildContext context,
    IconData icon,
    String text,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(

        color: AppPalette.surfaces(context)
            .withValues(alpha: .5),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(

          color:
              AppPalette.disabled(context)
                  .withValues(alpha: .15),
        ),
      ),

      child: Row(

        children: [

          Icon(
            icon,
            color: Colors.purpleAccent,
            size: 22,
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Text(

              text,

              style: AppTextStyles.bodyMedium.copyWith(

                color:
                    AppPalette.textOnSecondaryBg(context),

                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
