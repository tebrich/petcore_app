// ---------------------------------------------------------------------------
// File: tips.dart
// Description:
// Contains a list of general pet care tips used throughout the UI kit.
//
// This file provides helpful and educational tips that can be displayed inside
// the app’s home screen, onboarding, or informational widgets. Each tip includes
// a short piece of advice and a corresponding illustrative icon.
//
// Since this is a UI kit, these values serve as placeholder examples of what
// dynamically fetched tips or localized content might look like in a real app.
//
// ---------------------------------------------------------------------------

class Constants {
  /// A static list of pet care tips with short, friendly advice and an icon path.
  ///
  /// Each entry in this list contains:
  /// - `tip`: A short, educational message related to pet health or behavior.
  /// - `icon`: The SVG asset representing the tip visually.
  ///
  /// Example usage:
  /// ```dart
  /// final tip = Constants.tipsList[index]['tip'];
  /// final iconPath = Constants.tipsList[index]['icon'];
  /// ```
  static const List<Map<String, dynamic>> tipsList = [
    {
      'tip':
          'Masticar ayuda a reducir la placa y mantiene los dientes de tu mascota fuertes y saludables. ¡Asegúrate de que siempre tenga juguetes seguros para morder!',
      'icon': 'assets/illustrations/blue_bone.svg',
    },
    {
      'tip':
          '¡Las mascotas aman las rutinas! Alimentarlas, pasearlas y hacerlas dormir a la misma hora todos los días ayuda a reducir la ansiedad y mejora su comportamiento.',
      'icon': 'assets/illustrations/shield.svg',
    },
    {
      'tip':
          'Mantén siempre agua fresca disponible. La deshidratación puede provocar problemas de salud graves, especialmente en climas calurosos.',
      'icon': 'assets/illustrations/shield.svg',
    },
    {
      'tip':
          'Después de los paseos o del tiempo de juego en el césped, revisa el pelaje de tu mascota en busca de garrapatas o pulgas, especialmente en orejas, patas y cola.',
      'icon': 'assets/illustrations/sampoo.svg',
    },
    {
      'tip':
          'Recompensa el buen comportamiento con premios, caricias o tiempo de juego. Esto fortalece la confianza y ayuda a que tu mascota aprenda más rápido.',
      'icon': 'assets/illustrations/badge.svg',
    },
    {
      'tip':
          'Si tu mascota se muestra inusualmente cansada, agresiva o se esconde más de lo normal, podría ser una señal de que algo no está bien. No lo ignores.',
      'icon': 'assets/illustrations/badge.svg',
    },
  ];
}
