// ---------------------------------------------------------------------------
// File: global_consts.dart
// Description:
// Contains global constants and mock data used across the app.
//
// This file defines reusable constant values that are not tied to a specific
// feature but are instead used globally. These constants help keep the codebase
// clean, consistent, and easy to maintain.
//
// Since this is a UI kit, these constants serve as placeholder or reference data
// that simulate real-world app values — for example, predefined energy levels or
// reminder categories with corresponding asset icons.
//
// ---------------------------------------------------------------------------

// A list of predefined pet energy levels used to describe a pet’s activity type.
//
// Each entry provides a short description that could be shown in forms,
// pet profiles, or recommendation sections.
List<String> energyLevels = [
  'Alta Energía - Siempre en movimiento, ama jugar y requiere mucho ejercicio.',
  'Energía Moderada - Disfruta la actividad y también descansa; energía equilibrada.',
  'Baja Energía - Prefiere descansar, poco movimiento y entornos tranquilos.',
];

// A map of reminder types to their associated SVG asset paths.
//
// Used for displaying visual icons in reminder-related features such as
// notifications, schedules, and dashboards.
//
// Example usage:
// ```dart
// Image.asset(reminderTypes['Feeding']!)
// ```
Map<String, String> reminderTypes = {
  'Feeding': 'assets/illustrations/food_bowl.svg',
  'Medication': 'assets/illustrations/medecines2.svg',
  'Hydration': 'assets/illustrations/hydration.svg',
  'Grooming': 'assets/illustrations/bathtub.svg',
  'Playtime': 'assets/illustrations/ball_toy.svg',
  'Vet Visit': 'assets/illustrations/vet_visite.svg',
  'Vaccination': 'assets/illustrations/vaccination.svg',
  'Dental Care': 'assets/illustrations/dental_care.svg',
  'Rest Check': 'assets/illustrations/sleep.svg',
};
