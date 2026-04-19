// ------------------------------------------------------------
// 🐾 Peticare UI Kit — Dummy Data File
// ------------------------------------------------------------
// This file contains all the **static data** used throughout the Peticare UI Kit.
// Since this project is designed as a **UI Kit** and not a fully functional backend app,
// all values here serve as **placeholder (mock) data** that simulate real API responses.
//
// > 💡 **Note:**
// In a production app, this data should be **fetched dynamically** from a backend service
// (e.g., Firebase, Supabase, REST API, or GraphQL).
// You can replace or extend this file with your actual data models and data sources.
//
// **Purpose:**
// - Provide dummy data for UI previews, widgets, and screens.
// - Allow developers to visualize how the app looks with sample content.
// - Ensure consistent testing and demonstration of layout states.
//
// **Contains:**
// - Mock user profiles
// - Pets data (species, breeds, appointments)
// - Health alerts and reminders
// - Shop products and cart samples
// - Notification examples
//
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/utils/pet_avatars_list.dart';
import 'package:peticare/core/utils/random_functions.dart';

class DummyData {
  static List<Color> colorsList(BuildContext context) {
    return [
      AppPalette.primary,
      AppPalette.secondary(context),
      AppPalette.success(context),
      AppPalette.danger(context),
      AppPalette.warning(context),
    ];
  }

  /// Dashboad Details
  /// /// To-Dos List
  static const List<Map<String, dynamic>> todosList = [
    {'title': 'Feed Luna', 'time': '09:00 am', 'type': 'Food'},
    {'title': 'Walk Time', 'time': '30 mins', 'type': 'Walk'},
    {'title': 'Bull Pills', 'time': 'before dinner', 'type': 'Medocs'},
    {'title': 'Clean Litter Box', 'time': null, 'type': 'Clean-Cage'},
  ];

  /// /// Upcoming events
  static const List<Map<String, dynamic>> remindersList = [
    {
      'title': 'Vet Appointment',
      'time': '10:00 AM',
      'date': 'June 20',
      'icon': 'assets/illustrations/vet_appointment.svg',
    },
    {
      'title': 'Vaccination',
      'time': '09:00 AM',
      'date': 'July 5',
      'icon': 'assets/illustrations/vaccine_appointment.svg',
    },
  ];

  /// /// health Alerts
  static List<Map<String, dynamic>> healthAlertsList(BuildContext context) {
    return [
      {'alert': 'Dry Skin', 'conerned_pet': lunaGeneralDetails(context)},
      {'alert': 'Eye Watering', 'conerned_pet': bullGeneralDetails(context)},
      {
        'alert': 'Loss of Appetite',
        'conerned_pet': lunaGeneralDetails(context),
      },
    ];
  }

  /// Vets List
  static List<Map<String, dynamic>> vetsList = [
    {
      "id": 0,
      "name": "Pine Valley Animal Clinic",
      "address": "1045 Maplewood Dr, Austin, TX 78752",
      "phone": "+1-512-555-1342",
      "rating": 4.7,
      "hours": "Mon–Sat, 9:00 AM – 6:00 PM",
      "services": ["Vaccinations", "Routine Checkups", "Dental Care"],
    },
    {
      "id": 1,
      "name": "GreenPaws Veterinary Center",
      "address": "2386 Elm St, San Diego, CA 92103",
      "phone": "+1-619-555-2083",
      "rating": 4.9,
      "hours": "Mon–Fri, 8:00 AM – 5:30 PM",
      "services": ["General Care", "Sick Visits", "Emergency"],
    },
    {
      "id": 2,
      "name": "Dr. Hannah Mason, DVM",
      "address": "4207 Birch Ave, Portland, OR 97205",
      "phone": "+1-503-555-7888",
      "rating": 4.8,
      "hours": "Tue–Sat, 10:00 AM – 6:00 PM",
      "services": ["Mobile Vet", "Vaccinations", "Chronic Illness"],
      "avatar": 'assets/avatars/vets/vet5.svg',
    },
    {
      "id": 3,
      "name": "TailWaggers Animal Hospital",
      "address": "7792 Riverside Dr, Columbus, OH 43215",
      "phone": "+1-614-555-9021",
      "rating": 4.6,
      "hours": "Mon–Sun, 8:30 AM – 8:00 PM",
      "services": ["Surgery", "Diagnostics", "Wellness Exams"],
    },
    {
      "id": 4,
      "name": "Happy Tails Veterinary Care",
      "address": "305 Sunnybrook Rd, Raleigh, NC 27610",
      "phone": "+1-919-555-6702",
      "rating": 5.0,
      "hours": "Mon–Fri, 9:00 AM – 6:00 PM",
      "services": ["Dental", "Vaccines", "Preventive Care"],
    },
    {
      "id": 5,
      "name": "Dr. Jonathan Rhodes, DVM",
      "address": "1123 Westfield Ln, Denver, CO 80204",
      "phone": "+1-303-555-2244",
      "rating": 4.5,
      "hours": "Mon–Fri, 8:00 AM – 4:30 PM",
      "services": ["Routine Checkups", "Behavioral Consultation"],
      "avatar": 'assets/avatars/vets/vet3.svg',
    },
    {
      "id": 6,
      "name": "Brookline Animal Wellness",
      "address": "87 Commonwealth Ave, Boston, MA 02116",
      "phone": "+1-617-555-1199",
      "rating": 4.9,
      "hours": "Mon–Sat, 9:00 AM – 5:00 PM",
      "services": ["Exams", "Sick Visits", "Emergency"],
    },
    {
      "id": 7,
      "name": "Sunset Pet Hospital",
      "address": "3025 Sunset Blvd, Los Angeles, CA 90026",
      "phone": "+1-213-555-3322",
      "rating": 4.6,
      "hours": "Mon–Sun, 9:00 AM – 7:00 PM",
      "services": ["Surgery", "Flea Control", "Nutrition Consulting"],
    },
    {
      "id": 8,
      "name": "Northside Veterinary Group",
      "address": "215 Forest St, Chicago, IL 60610",
      "phone": "+1-312-555-8890",
      "rating": 4.8,
      "hours": "Mon–Fri, 8:00 AM – 6:00 PM",
      "services": ["Vaccinations", "Lab Work", "Physical Therapy"],
    },
    {
      "id": 9,
      "name": "Dr. Lila Greene, DVM - Exotic Pets",
      "address": "99 Eastwood Ct, Seattle, WA 98102",
      "phone": "+1-206-555-7841",
      "rating": 4.7,
      "hours": "Tue–Sat, 10:00 AM – 5:00 PM",
      "services": ["Birds", "Reptiles", "Rodents"],
      "avatar": 'assets/avatars/vets/vet4.svg',
    },
  ];

  /// Groomers List
  static List<Map<String, dynamic>> groomersList = [
    {
      "id": 'm1',
      "name": "Pawfect Mobile Spa",
      "type": "mobile",
      "phone": "+1 (213) 555-7832",
      "address": "1000 N Main St, Los Angeles, CA 90012",
      "rating": 4.8,
      "services": ["Full Grooming", "Nail Trim", "Ear Cleaning"],
    },
    {
      "id": 'm2',
      "name": "Wag’n Wash Mobile",
      "type": "mobile",
      "phone": "+1 (512) 555-1123",
      "rating": 4.6,
      "address": "2201 S Lamar Blvd, Austin, TX 78704",
      "services": ["Bath & Brush", "Deshedding", "Haircut"],
    },
    {
      "id": 'm3',
      "name": "Zoom Groom Van",
      "type": "mobile",
      "phone": "+1 (415) 555-7890",
      "rating": 4.7,
      "address": "789 Market St, San Francisco, CA 94103",
      "services": ["Grooming", "Sanitary Trim", "Flea Treatment"],
    },
    {
      "id": 'm4',
      "name": "Furry Wheels",
      "type": "mobile",
      "phone": "+1 (702) 555-1456",
      "rating": 4.9,
      "address": "500 Fremont St, Las Vegas, NV 89101",
      "services": ["Nail Clipping", "De-Matting", "Full Service"],
    },
    {
      "id": 'm5',
      "name": "Tail Waggin’ Mobile",
      "type": "mobile",
      "phone": "+1 (404) 555-9912",
      "rating": 4.5,
      "address": "123 Peachtree St NE, Atlanta, GA 30303",
      "services": ["Basic Grooming", "Tick Bath", "Ear Plucking"],
    },
    {
      "id": 'm6',
      "name": "PupShine Mobile",
      "type": "mobile",
      "phone": "+1 (718) 555-3412",
      "rating": 4.8,
      "address": "890 Flatbush Ave, Brooklyn, NY 11226",
      "services": ["Breed Cut", "Shampoo", "Paw Cleaning"],
    },
    {
      "id": 'm7',
      "name": "Rover Revamp",
      "type": "mobile",
      "phone": "+1 (206) 555-7788",
      "rating": 4.8,
      "address": "1501 Pike St, Seattle, WA 98101",
      "services": ["Groom & Go", "Anal Gland Cleaning", "Blow Dry"],
    },
    {
      "id": 'm8',
      "name": "Bark Mobile Spa",
      "type": "mobile",
      "phone": "+1 (786) 555-2299",
      "rating": 4.7,
      "address": "100 Ocean Dr, Miami Beach, FL 33139",
      "services": ["Hydro Bath", "Pawdicure", "Face Trim"],
    },
    {
      "id": 'm9',
      "name": "Mobile Mutts",
      "type": "mobile",
      "phone": "+1 (303) 555-9382",
      "rating": 4.6,
      "address": "777 Broadway, Denver, CO 80203",
      "services": ["Wash & Trim", "Nail Buffing", "Facial Scrub"],
    },
    {
      "id": 'm10',
      "name": "Go Groom Go!",
      "type": "mobile",
      "phone": "+1 (773) 555-6680",
      "rating": 4.7,
      "address": "2200 W Devon Ave, Chicago, IL 60659",
      "services": ["Shave Down", "Fragrance", "Ear Flushing"],
    },
    {
      "id": 'd1',
      "name": "Happy Paws Grooming",
      "type": "in_clinic",
      "phone": "+1 (310) 555-9021",
      "rating": 4.6,
      "address": "3030 Wilshire Blvd, Santa Monica, CA 90403",
      "services": ["Hair Styling", "Teeth Brushing", "Bath"],
    },
    {
      "id": 'c2',
      "name": "Canine Cuts Studio",
      "type": "in_clinic",
      "phone": "+1 (646) 555-1982",
      "rating": 4.6,
      "address": "45 W 34th St, New York, NY 10001",
      "services": ["Breed Trim", "Anal Gland", "Full Service"],
    },
    {
      "id": 'c3',
      "name": "Paw Palace",
      "type": "in_clinic",
      "phone": "+1 (602) 555-3728",
      "rating": 4.7,
      "address": "1010 N Central Ave, Phoenix, AZ 85004",
      "services": ["Luxury Grooming", "Blueberry Facial", "Ear Clean"],
    },
    {
      "id": 'c4',
      "name": "The Bark Boutique",
      "type": "in_clinic",
      "phone": "+1 (704) 555-8891",
      "rating": 4.5,
      "address": "150 S Tryon St, Charlotte, NC 28202",
      "services": ["Mini Groom", "Blow Out", "Nail Polish"],
    },
    {
      "id": 'c5',
      "name": "Doggie Style Groomers",
      "type": "in_clinic",
      "phone": "+1 (214) 555-6762",
      "rating": 4.6,
      "address": "500 N Akard St, Dallas, TX 75201",
      "services": ["Deshedding", "Pet Cologne", "Paw Balm"],
    },
    {
      "id": 'c6',
      "name": "Paws & Relax",
      "type": "in_clinic",
      "phone": "+1 (503) 555-1912",
      "rating": 4.9,
      "address": "909 SW Washington St, Portland, OR 97205",
      "services": ["Relax Bath", "Scissoring", "Ear Plucking"],
    },
    {
      "id": 'c7',
      "name": "Tailored Tails",
      "type": "in_clinic",
      "phone": "+1 (615) 555-2231",
      "rating": 4.7,
      "address": "800 Broadway, Nashville, TN 37203",
      "services": ["Custom Styling", "Spa Bath", "Nail Dremel"],
    },
    {
      "id": 'c8',
      "name": "Shiny Coat Clinic",
      "type": "in_clinic",
      "phone": "+1 (813) 555-4049",
      "rating": 4.9,
      "address": "2020 E 7th Ave, Tampa, FL 33605",
      "services": ["Pet Massage", "Hydrotherapy", "Shampoo & Conditioner"],
    },
    {
      "id": 'c9',
      "name": "Bubbles & Barks",
      "type": "in_clinic",
      "phone": "+1 (617) 555-9923",
      "rating": 4.8,
      "address": "99 Summer St, Boston, MA 02110",
      "services": ["Fur Trim", "Drying", "Tidy Up"],
    },
    {
      "id": 'c10',
      "name": "Pampered Pet Grooming",
      "type": "in_clinic",
      "phone": "+1 (312) 555-8890",
      "rating": 4.6,
      "address": "120 N LaSalle St, Chicago, IL 60602",
      "services": ["Luxury Wash", "Nail Painting", "Aromatherapy"],
    },
  ];

  /// Pets Details
  /// /// Luna

  static Map<String, dynamic> lunaGeneralDetails(BuildContext context) {
    return {
      'name': 'Luna',
      'type': 'Cat',
      'race': 'Ragdoll',
      'avatar': petAvatars(context)["Cat"]!.values.elementAt(3),
      'age': 2,
      'birthdate': DateTime(2023, 07, 09),
      'gender': 'Female',
      'energy': 3,
      'weight': 4,
    };
  }

  static List<Map<String, dynamic>> lunaApointments(BuildContext context) {
    return [
      {
        'title': 'General checkup',
        'date': DateTime.now()
            .add(const Duration(days: 4))
            .copyWith(hour: 10, minute: 00),
        'location': "Healthy Paw's Clinic",
        'icon': "assets/illustrations/vet_appointment.svg",
        'color': AppPalette.success(context),
        'note': 'General health assessment.',
      },
      {
        'title': 'Training Session (Behavioral)',
        'date': DateTime.now()
            .add(const Duration(days: 1))
            .copyWith(hour: 15, minute: 00),
        'location': "SmartPets Academy",
        'icon': "assets/illustrations/training_session.svg",
        'color': AppPalette.secondary(context),
        'note': 'Socialization & obedience practice.',
      },
      {
        'title': 'Grooming & Nail Trim',
        'date': DateTime(2025, 05, 14, 09, 00),
        'location': "Paws & Whiskers Spa, 89 Fur Lane",
        'icon': "assets/illustrations/grooming_appointment.svg",
        'color': AppPalette.primary,
        'note': ' Bath, brushing, ear cleaning included.',
      },
      {
        'title': 'Annual Vaccination',
        'date': DateTime(2025, 02, 23, 14, 00),
        'location': "Happy Tails Vet Clinic, 12 Main St.",
        'icon': "assets/illustrations/vaccine_appointment.svg",
        'color': AppPalette.secondary(context),
        'note': 'Booster shot and general check-up.',
      },
      {
        'title': 'Dental Cleaning',
        'date': DateTime(2024, 12, 02, 09, 00),
        'location': "PetSmile Dental Care, 45 Paw Avenue",
        'icon': "assets/illustrations/dental_appointment.svg",
        'color': AppPalette.success(context),
        'note': 'Includes full dental scaling and oral hygiene review.',
      },
      {
        'title': 'Emergency – Limping',
        'date': DateTime(2024, 10, 29, 08, 00),
        'location': "24h Vet Emergency, Zone 4",
        'icon': "assets/illustrations/vet_appointment.svg",
        'color': AppPalette.danger(context),
        'note': 'Sudden limping on rear left leg.',
      },
    ];
  }

  static const List<String> lunaGallery = [
    'https://cdn.pixabay.com/photo/2016/10/09/15/39/cat-1726023_1280.jpg',
    'https://cdn.pixabay.com/photo/2020/03/16/11/46/cat-4936769_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/07/08/13/01/ragdoll-3523834_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/07/21/16/26/ragdoll-8141955_1280.jpg',
    'https://cdn.pixabay.com/photo/2019/06/25/12/47/cat-4298133_1280.jpg',
    'https://cdn.pixabay.com/photo/2020/04/02/21/52/ragdoll-4996798_1280.jpg',
    'https://cdn.pixabay.com/photo/2020/04/05/18/24/kitten-5007269_1280.jpg',
  ];

  /// /// Bull
  static Map<String, dynamic> bullGeneralDetails(BuildContext context) {
    return {
      'name': 'Bull',
      'type': 'Dog',
      'race': 'Yorkshire terrier',
      'avatar': petAvatars(context)["Dog"]!.values.elementAt(6),
      'age': 5,
      'birthdate': DateTime(2020, 10, 13),
      'gender': 'Male',
      'energy': 2,
      'weight': 3.9,
    };
  }

  /// User Details
  static Map<String, dynamic> userProfileDetails = {
    'first_name': 'Mila',
    'last_name': 'Hartley',
    'email': 'mila.hart@example.com',
    'birth_date': DateTime(2005, 07, 09),
    'phone': '+1 (555) 238-9012',
    'address': 'Greenfield, CA',
    'account_created': DateTime(2025, 06, 25),
    'profile_pic':
        'https://i.pinimg.com/736x/fb/5a/df/fb5adf83dc40648b0b7309ec1621a029.jpg',

    //https://i.pinimg.com/736x/95/6b/62/956b62756adf71f7a6e8d34ebb32c781.jpg
    //https://i.pinimg.com/736x/86/e1/cb/86e1cb3736f8e76cc8c0d491b050fb1d.jpg
  };

  static List<Map<String, dynamic>> petsList(BuildContext context) {
    return [lunaGeneralDetails(context), bullGeneralDetails(context)];
  }

  /// Settings
  static List<Map<String, dynamic>> loginHistory = [
    {
      "id": "lh001",
      "device": "iPhone 14 Pro",
      "location": "Greenfield, CA",
      "status": "Connected",
      "timestamp": getRandomDateTimeLast6Months(),
    },
    {
      "id": "lh002",
      "device": "Samsung Galaxy S22",
      "location": "Greenfield, CA",
      "status": "Logged Out",
      "timestamp": getRandomDateTimeLast6Months(),
    },
    {
      "id": "lh003",
      "device": "Google Pixel 7",
      "location": "San Francisco, CA",
      "status": "Connected",
      "timestamp": getRandomDateTimeLast6Months(),
    },
    {
      "id": "lh005",
      "device": "iPhone 13 Mini",
      "location": "Unknown",
      "status": "Revoked Access",
      "timestamp": getRandomDateTimeLast6Months(),
    },
  ];

  /// Notifications
  /// /// Alerts
  static List<Map<String, dynamic>> listOfAlerts = [
    {
      "id": "notif_001",
      "title": "Vaccination Reminder",
      "message": "Don’t forget: Luna’s rabies shot is due next week!",
      "type": "reminder",
      "date": DateTime.now()
          .subtract(const Duration(days: 9))
          .copyWith(hour: 09, minute: 34),
      "read": false,
    },
    {
      "id": "notif_002",
      "title": "New Health Tip for Summer",
      "message":
          "Keep your pets hydrated! Read our latest tips for summer care.",
      "type": "tip",
      "subtype": 'hydratation',
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 09, minute: 34),
      "read": false,
    },
    {
      "id": "notif_003",
      "title": "Profile Update Successful",
      "message": "You’ve successfully updated Bull’s profile picture.",
      "type": "info",
      "subtype": 'profile_pic',
      "date": DateTime.now()
          .subtract(const Duration(days: 3))
          .copyWith(hour: 20, minute: 45),
      "read": true,
    },
    {
      "id": "notif_004",
      "title": "Vet Availability Update",
      "message": "Dr. Saidi is now available for emergency calls this weekend.",
      "type": "update",
      "subtype": 'vet_availability',
      "date": DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 09, minute: 34),
      "read": false,
    },
    {
      "id": "notif_005",
      "title": "New Message from Dr. Amal",
      "message":
          "Dr. Amal sent a message regarding Rocky’s latest lab results.",
      "type": "message",
      "date": DateTime.now()
          .subtract(const Duration(days: 9))
          .copyWith(hour: 14, minute: 14),
      "read": true,
    },
    {
      "id": "notif_006",
      "title": "Adoption Event Nearby",
      "message": "Join us at the local pet adoption fair this Sunday!",
      "type": "event",
      "date": DateTime.now()
          .subtract(const Duration(days: 23))
          .copyWith(hour: 10, minute: 40),
      "read": false,
    },
    {
      "id": "notif_007",
      "title": "Weekly Summary Ready",
      "message": "View Luna’s weekly health & activity summary now.",
      "type": "summary",
      "date": DateTime.now()
          .subtract(const Duration(days: 6))
          .copyWith(hour: 19, minute: 12),
      "read": true,
    },
    {
      "id": "notif_008",
      "title": "Food Reorder Alert",
      "message": "You’re almost out of Bull’s favorite dry food. Reorder now?",
      "type": "alert",
      "subtype": 'out_of_food',
      "date": DateTime.now().copyWith(hour: 07, minute: 30),
      "read": false,
    },
    {
      "id": "notif_009",
      "title": "New Blog Post: Cat Anxiety",
      "message": "Learn how to spot and ease anxiety symptoms in your cat.",
      "type": "tip",
      "date": DateTime.now()
          .subtract(const Duration(days: 14))
          .copyWith(hour: 11, minute: 15),
      "read": true,
    },
    {
      "id": "notif_010",
      "title": "Pet Weight Check Reminder",
      "message": "It’s time for Luna’s monthly weight check.",
      "type": "reminder",
      "subtype": 'weight_check',
      "date": DateTime.now()
          .subtract(const Duration(days: 10))
          .copyWith(hour: 12, minute: 40),
      "read": false,
    },
    {
      "id": "notif_011",
      "title": "Grooming Tips for Summer",
      "message": "Keep your furry friend cool with proper grooming.",
      "type": "tip",
      "subtype": 'groom_tip',
      "date": DateTime.now()
          .subtract(const Duration(days: 8))
          .copyWith(hour: 10, minute: 20),
      "read": false,
    },
    {
      "id": "notif_012",
      "title": "Lab Test Results Ready",
      "message": "Bull’s blood work is available for review.",
      "type": "test results",
      "date": DateTime.now()
          .subtract(const Duration(days: 8))
          .copyWith(hour: 15, minute: 40),
      "read": true,
    },
    {
      "id": "notif_013",
      "title": "Behavioral Training Webinar",
      "message":
          "Join our free webinar on managing pet aggression this Friday.",
      "type": "event",
      "date": DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 09, minute: 00),
      "read": false,
    },
    {
      "id": "notif_014",
      "title": "App Update Available",
      "message": "Get the latest features and bug fixes in version 2.4.1.",
      "type": "update",
      "date": DateTime.now()
          .subtract(const Duration(days: 3))
          .copyWith(hour: 17, minute: 25),
      "read": false,
    },
    {
      "id": "notif_015",
      "title": "Congrats! Pet of the Month",
      "message":
          "Your pet Luna has been featured as our July Pet of the Month!",
      "type": "info",
      "subtype": 'pet_of_month',
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 20, minute: 10),
      "read": true,
    },
    {
      "id": "notif_016",
      "title": "Missing Pet Alert Nearby",
      "message": "Be on the lookout for a missing black Labrador in your area.",
      "type": "alert",
      "subtype": 'warning',
      "date": DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 8, minute: 00),
      "read": false,
    },

    ////
    {
      "id": "notif_017",
      "title": "Dog Park Rules Update",
      "message": "New safety measures have been added to Central Bark.",
      "type": "update",
      "date": DateTime(2025, 07, 01, 14, 50),
      "read": true,
    },
    {
      "id": "notif_018",
      "title": "Check-In Reminder",
      "message": "Time to check in on Luna’s activity level today.",
      "type": "reminder",
      "date": DateTime.now()
          .subtract(const Duration(days: 14))
          .copyWith(hour: 12, minute: 00),
      "read": false,
    },
    {
      "id": "notif_019",
      "title": "Summer Contest Ends Soon",
      "message": "Submit your pet photo before July 20 for a chance to win!",
      "type": "event",
      "subtype": 'photos_event',
      "date": DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 11, minute: 00),
      "read": false,
    },
    {
      "id": "notif_020",
      "title": "Daily Feeding Log Reminder",
      "message": "Don’t forget to log your pet’s meals for today.",
      "type": "reminder",
      "subtype": 'food_reminder',
      "date": DateTime.now().copyWith(hour: 07, minute: 10),
      "read": true,
    },
    {
      "id": "notif_021",
      "title": "New Feature Released!",
      "message":
          "We're excited to announce the release of Dark Mode. You can now customize your app experience from the settings panel.",
      "type": "announcement",
      "date": DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 15, minute: 00),
      "read": false,
    },
  ];

  /// /// Appointments
  static List<Map<String, dynamic>> listOfAppointments = [
    {
      "id": "appt_001",
      "title": "Vet Appointment: Check-Up",
      "message": "Luna has a general check-up scheduled with Dr. Karim.",
      "type": "appointment",
      "subtype": "vet_appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 10, minute: 00),
      "read": false,
    },
    {
      "id": "appt_002",
      "title": "Dental Cleaning for Max",
      "message":
          "Time for Max’s annual dental cleaning. Don’t forget his toothbrush!",
      "type": "appointment",
      "subtype": "dent_appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 14, minute: 30),
      "read": false,
    },
    {
      "id": "appt_003",
      "title": "Surgery Consultation",
      "message": "Bruno has a consultation scheduled for his leg surgery.",
      "type": "appointment",
      "subtype": "vet_surgery",
      "date": DateTime.now()
          .subtract(const Duration(days: 7))
          .copyWith(hour: 11, minute: 15),
      "read": false,
    },

    {
      "id": "appt_005",
      "title": "Grooming Session for Coco",
      "message": "Luna’s full grooming session is booked at PetSpa.",
      "type": "appointment",
      "subtype": "spa_appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 15, minute: 45),
      "read": false,
    },
    {
      "id": "appt_006",
      "title": "Post-Surgery Check for Rocky",
      "message": "Rocky has a post-surgery wound check-up scheduled.",
      "type": "appointment",
      "subtype": "vet_appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 6))
          .copyWith(hour: 13, minute: 30),
      "read": false,
    },
    {
      "id": "appt_007",
      "title": "Wellness Exam: Bella",
      "message":
          "Bella’s annual wellness exam is scheduled. Bring her vaccination records.",
      "type": "appointment",
      "subtype": "vaccination",
      "date": DateTime.now()
          .subtract(const Duration(days: 4))
          .copyWith(hour: 08, minute: 30),
      "read": true,
    },
    {
      "id": "appt_008",
      "title": "Skin Allergy Test: Simba",
      "message": "Simba has an allergy skin test appointment this week.",
      "type": "appointment",
      "subtype": "skin_vet",
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 16, minute: 00),
      "read": false,
    },
    {
      "id": "appt_009",
      "title": "Orthopedic Exam",
      "message": "Leo has an orthopedic exam at the city vet center.",
      "type": "appointment",
      "subtype": "ortho_vet",
      "date": DateTime.now()
          .subtract(const Duration(days: 8))
          .copyWith(hour: 10, minute: 45),
      "read": false,
    },
    {
      "id": "appt_010",
      "title": "Ear Infection Recheck",
      "message": "Milo has a recheck for his ear infection treatment.",
      "type": "appointment",
      "subtype": "orl_vet",
      "date": DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 13, minute: 00),
      "read": true,
    },
    {
      "id": "appt_011",
      "title": "Spay Surgery for Daisy",
      "message":
          "Daisy’s spay procedure is scheduled next Monday. Don’t feed her after midnight!",
      "type": "appointment",
      "subtype": "medecines",
      "date": DateTime.now()
          .subtract(const Duration(days: 6))
          .copyWith(hour: 09, minute: 30),
      "read": false,
    },
    {
      "id": "appt_012",
      "title": "Heartworm Test",
      "message": "Mochi has a heartworm test scheduled this weekend.",
      "type": "appointment",
      "subtype": "test",
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 12, minute: 00),
      "read": false,
    },

    {
      "id": "appt_014",
      "title": "Weight Management Check",
      "message":
          "Ginger’s weight and diet progress check is scheduled for this Friday.",
      "type": "appointment",
      "subtype": "diet",
      "date": DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 17, minute: 30),
      "read": false,
    },
    {
      "id": "appt_015",
      "title": "Microchip Implantation",
      "message": "Time to get Miso microchipped. A short visit at the clinic.",
      "type": "appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 4))
          .copyWith(hour: 09, minute: 15),
      "read": false,
    },
    {
      "id": "appt_016",
      "title": "Puppy Vaccination: Stage 2",
      "message": "Luna has her second round of puppy vaccines coming up.",
      "type": "appointment",
      "subtype": "vaccination",
      "date": DateTime.now()
          .subtract(const Duration(days: 3))
          .copyWith(hour: 11, minute: 00),
      "read": false,
    },
    {
      "id": "appt_017",
      "title": "Check-Up: Golden Years Program",
      "message":
          "Duke has his geriatric wellness check under the Golden Years program.",
      "type": "appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 9))
          .copyWith(hour: 14, minute: 00),
      "read": false,
    },
    {
      "id": "appt_018",
      "title": "Vaccination Review",
      "message":
          "Zara has an appointment to review her vaccine history and plan boosters.",
      "type": "appointment",
      "subtype": "vaccination",
      "date": DateTime.now()
          .subtract(const Duration(days: 6))
          .copyWith(hour: 16, minute: 30),
      "read": true,
    },
    {
      "id": "appt_019",
      "title": "Eye Irritation Evaluation",
      "message":
          "Spot’s eyes are irritated again. A quick evaluation is scheduled.",
      "type": "appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 2))
          .copyWith(hour: 13, minute: 15),
      "read": false,
    },
    {
      "id": "appt_020",
      "title": "Parasite Control Consultation",
      "message":
          "Toby is due for a deworming and parasite control consultation.",
      "type": "appointment",
      "date": DateTime.now()
          .subtract(const Duration(days: 5))
          .copyWith(hour: 10, minute: 30),
      "read": false,
    },
  ];

  /// Store

  static List<Map<String, dynamic>> listOfToys = [
    {
      "id": "toy_001",
      "name": "Chewy Bone Squeaker",
      "type": "toy",
      "price": 8.99,
      "quantity": 30,
      "description":
          "A durable rubber bone toy that squeaks when chewed, ideal for puppies and small dogs. Keeps your pet engaged for hours.",
      "image":
          "https://cdn.shoplightspeed.com/shops/633980/files/61185728/1600x2048x2/haute-diggity-dog-white-chewy-vuiton-bone-squeaker.jpg",
    },
    {
      "id": "toy_002",
      "name": "Fluffy Plush Duck",
      "type": "toy",
      "price": 6.50,
      "quantity": 15,
      "description":
          "A soft plush duck with hidden squeakers inside. Perfect cuddle buddy for small to medium-sized dogs.",
      "image":
          "https://img4.dhresource.com/webp/m/0x0/f3/albu/jc/g/17/1fa97335-4f0b-47ba-866e-6f22de58d791.jpg",
    },
    {
      "id": "toy_003",
      "name": "Tug of War Rope",
      "type": "toy",
      "price": 7.25,
      "quantity": 50,
      "description":
          "Heavy-duty cotton rope ideal for tug-of-war games. Great for dental health and interactive play.",
      "image": "https://bulltug.com/cdn/shop/products/spiral.jpg",
    },
    {
      "id": "toy_004",
      "name": "Interactive Treat Ball",
      "type": "toy",
      "price": 10.99,
      "quantity": 20,
      "description":
          "A treat-dispensing ball that rewards pets with snacks as they play, stimulating their mental agility.",
      "image":
          "https://letspawty.au/cdn/shop/products/interactive-dog-toys-fur-babies-australia-pooch-pups-enrichment-ball.png",
    },
    {
      "id": "toy_005",
      "name": "Bouncy Tennis Balls (Set of 3)",
      "type": "toy",
      "price": 5.99,
      "quantity": 60,
      "description":
          "Three soft, pet-safe tennis balls that bounce high and are perfect for fetch games.",
      "image": "https://www.sportspet.com.au/cdn/shop/files/SPTENB002.jpg",
    },
    {
      "id": "toy_006",
      "name": "Rubber Tug Ring",
      "type": "toy",
      "price": 9.99,
      "quantity": 40,
      "description":
          "A strong circular ring made of tough rubber. Easy to grip and perfect for solo or owner-dog tug sessions.",
      "image": "https://messymutts.ca/cdn/shop/products/webreadyTP301_1.jpg",
    },
    {
      "id": "toy_007",
      "name": "Cat Feather Wand",
      "type": "toy",
      "price": 4.50,
      "quantity": 100,
      "description":
          "Classic feather wand toy that flutters and tempts your feline friends into a frenzy of fun.",
      "image":
          "https://m.media-amazon.com/images/I/71jfov709KL._AC_SL1500_.jpg",
    },
    {
      "id": "toy_008",
      "name": "Crinkle Tunnel",
      "type": "toy",
      "price": 13.75,
      "quantity": 18,
      "description":
          "Collapsible tunnel that crinkles as your pet runs through it. Great hide-and-seek toy for cats.",
      "image":
          "https://m.media-amazon.com/images/I/71oQCS4rTNL._AC_SL1500_.jpg",
    },
    {
      "id": "toy_009",
      "name": "Interactive Laser Pointer",
      "type": "toy",
      "price": 12.90,
      "quantity": 25,
      "description":
          "Chase fun! This USB-rechargeable laser pointer keeps your cats entertained and agile.",
      "image":
          "https://www.modernpet.com.au/cdn/shop/products/modern-pets-cat-toy-interactive-cat-laser-pointer-31999862341831_2000x.png?v=1635838377",
    },
    {
      "id": "toy_010",
      "name": "Treat Puzzle Board",
      "type": "toy",
      "price": 15.50,
      "quantity": 12,
      "description":
          "A brain-teasing puzzle for dogs to unlock hidden treats, encourages problem-solving and reduces boredom.",
      "image":
          "https://media.istockphoto.com/id/1219357045/photo/dog-playing-intellectual-game-training-game-for-dogs.jpg?s=1024x1024&w=is&k=20&c=srgEmFDyeNhhMtWIEFC74bstNniM4LSlIRi_8A0E6NI=",
    },
    {
      "id": "toy_011",
      "name": "Catnip Plush Mouse",
      "type": "toy",
      "price": 3.30,
      "quantity": 70,
      "description":
          "Mini plush mice infused with organic catnip. Lightweight, tossable, and irresistible to cats.",
      "image":
          "https://media.istockphoto.com/id/909433510/photo/fabric-rat-doll-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=FPtfPTK281qFQe12r2HRn3JqgH3NcZxoW2o-L7ufM8o=",
    },
    {
      "id": "toy_012",
      "name": "Floating Duck Toy",
      "type": "toy",
      "price": 6.80,
      "quantity": 45,
      "description":
          "Great for bath time or pool play. This floating duck toy is made from soft but waterproof fabric.",
      "image":
          "https://media.istockphoto.com/id/164922078/photo/rubber-duck.jpg?s=1024x1024&w=is&k=20&c=Pp7tGsHfQjCIKoiiL-Z8LLfB4j7VGfVTqiDGrTeoPxc=",
    },
    {
      "id": "toy_013",
      "name": "Rattle Ball",
      "type": "toy",
      "price": 5.20,
      "quantity": 80,
      "description":
          "Hard plastic ball with rattles inside. Rolls and makes noise that keeps pets curious and active.",
      "image":
          "https://media.istockphoto.com/id/1227198466/photo/colorful-plastic-rattle-ball-for-developing-motor-skills-isolated-on-blue-background-flat-lay.jpg?s=1024x1024&w=is&k=20&c=KelVFMiCjh9Kgv_DcynQqi0vBHoIOGnB_60bPpjadRc=",
      //https://media.istockphoto.com/id/1286168493/photo/colorful-plastic-rattle-ball-for-developing-motor-skills-isolated-on-pink-background-flat-lay.jpg?s=1024x1024&w=is&k=20&c=i6vdx_X-4WpdeodACPI6BdddFeWe_k13YmcmEbLOf9Y=
    },
    {
      "id": "toy_014",
      "name": "Snuffle Mat",
      "type": "toy",
      "price": 16.99,
      "quantity": 10,
      "description":
          "Mimics grass to let dogs sniff and find hidden treats. Encourages natural foraging behavior.",
      "image":
          "https://media.istockphoto.com/id/1264342769/photo/soft-washable-textile-training-snuffle-mat-for-nose-work-for-pet-intellectual-games-with-pet.jpg?s=1024x1024&w=is&k=20&c=zpt2B1f3YFN0tSShY3GVhWcR8pF6L6u8xOdk3s5qEOg=",
    },

    {
      "id": "toy_016",
      "name": "Chuckit! Ring Chaser Dog Ball Launcher",
      "type": "toy",
      "price": 18.00,
      "quantity": 16,
      "description":
          "Lightweight ring launcher with foam rings that soar far and bounce upon landing. Great for large dogs.",
      "image": "https://www.thevetshed.com.au/assets/full/92-32138.webp",
    },
    {
      "id": "toy_017",
      "name": "Teething Ring for Puppies",
      "type": "toy",
      "price": 6.20,
      "quantity": 90,
      "description":
          "A soft silicone teething ring designed to soothe puppies’ gums during their chewing phase.",
      "image": "https://s7d2.scene7.com/is/image/PetSmart/5350508?fmt=webp",
    },

    {
      "id": "toy_019",
      "name": "Cat Chaser Ball Track",
      "type": "toy",
      "price": 9.40,
      "quantity": 38,
      "description":
          "Plastic tower with spinning ball inside a track. Keeps cats entertained for hours.",
      "image":
          "https://m.media-amazon.com/images/I/71b0LpxT2RL._AC_SL1500_.jpg",
    },
    {
      "id": "toy_020",
      "name": "Bite Resistant Dinosaur",
      "type": "toy",
      "price": 13.90,
      "quantity": 20,
      "description":
          "Dinosaur-shaped rubber toy designed to withstand heavy chewers. Vibrant, fun, and safe.",
      "image":
          "https://i5.walmartimages.com/seo/Bite-resistant-Teething-Dog-Toys-Cotton-Knotted-Small-Dinosaur-Animal-Shaped-Pet-Supplies-Wholesale-Suitable-Thanksgiving-Christmas-Decoration_5ca72648-5327-4491-b001-30251aa3a79f.1d4f5b895ebe04f74172a74ce1a3291a.jpeg?odnHeight=640&odnWidth=640&odnBg=FFFFFF",
    },
  ];

  static List<Map<String, dynamic>> listOfGrommingProducts = [
    {
      "id": "groom_001",
      "name": "Pet Gentle Grooming Brush",
      "type": "grooming",
      "price": 12.99,
      "quantity": 45,
      "description":
          "Soft-bristle grooming brush designed for cats and dogs. Removes loose hair and reduces shedding while being gentle on the skin.",
      "image":
          "https://media.istockphoto.com/id/471058010/photo/pet-grooming-brush.jpg",
    },
    {
      "id": "groom_002",
      "name": "Dog Shampoo with Aloe",
      "type": "grooming",
      "price": 8.50,
      "quantity": 30,
      "description":
          "Hypoallergenic dog shampoo enriched with aloe vera and oatmeal. Keeps coat shiny and skin moisturized.",
      "image":
          "https://media.istockphoto.com/id/1433506264/vector/cosmetic-for-pets-shampoo-and-spray-for-dog-and-puppy-illustration-vector.jpg",
    },
    {
      "id": "groom_003",
      "name": "Nail Clipper for Pets",
      "type": "grooming",
      "price": 6.99,
      "quantity": 60,
      "description":
          "Ergonomic pet nail clippers with safety guard to prevent over-cutting. Suitable for all small and medium-sized pets.",
      "image":
          "https://media.istockphoto.com/id/524374325/photo/clippers-claws.jpg",

      //https://media.istockphoto.com/id/2022480613/photo/nail-clipper-for-pets-isolated-on-a-white-background.jpg
    },
    {
      "id": "groom_004",
      "name": "Ear Cleaning Wipes",
      "type": "grooming",
      "price": 5.25,
      "quantity": 80,
      "description":
          "Gentle and alcohol-free wipes for cleaning your pet's ears. Helps prevent infections and removes wax buildup.",
      "image":
          "https://vetnique.com/cdn/shop/files/1-717932350294-720x720-09df8e80-2413-448d-9ad1-9919875b8cdf_1800x1800.png",
    },
    {
      "id": "groom_005",
      "name": "Deshedding Tool",
      "type": "grooming",
      "price": 15.99,
      "quantity": 22,
      "description":
          "Professional-grade deshedding tool to remove undercoat fur without damaging the topcoat.",
      "image":
          "https://media.istockphoto.com/id/543198128/photo/furminator-for-cat-and-dog.jpg",
    },
    {
      "id": "groom_006",
      "name": "Pet Cologne Spray",
      "type": "grooming",
      "price": 9.75,
      "quantity": 35,
      "description":
          "Fresh-scent cologne spray for pets. Keeps your pet smelling clean between baths.",
      "image":
          "https://newellbrands.imgix.net/6c7677aa-75e7-32c2-afb7-fd0e13f3101b/6c7677aa-75e7-32c2-afb7-fd0e13f3101b.jpg",
    },
    {
      "id": "groom_007",
      "name": "Paw Balm for Dogs",
      "type": "grooming",
      "price": 7.50,
      "quantity": 50,
      "description":
          "All-natural paw balm that soothes and heals cracked paw pads, especially during dry or cold weather.",
      "image":
          "https://image.chewy.com/catalog/general/images/natural-dog-company-paw-soother-dog-paw-balm-1fl-oz-tin/img-241466._AC_SL600_V1_.jpg",
    },
    {
      "id": "groom_008",
      "name": "Dog Toothbrush & Toothpaste Set",
      "type": "grooming",
      "price": 10.99,
      "quantity": 40,
      "description":
          "Veterinarian-approved toothbrush and chicken-flavored toothpaste to promote healthy teeth and gums.",
      "image":
          "https://www.twosaltydogs.net/media/tc-dog-toothbrush-toothpaste-kit.jpg",
    },
    {
      "id": "groom_009",
      "name": "Cat Grooming Glove",
      "type": "grooming",
      "price": 6.25,
      "quantity": 55,
      "description":
          "Five-finger grooming glove that makes removing loose fur a bonding moment with your cat.",
      "image":
          "https://media.istockphoto.com/id/1134768286/photo/girl-with-cat-shedding-bathing-grooming-deshedding-glove-the-glove-with-cats-hair-on-it.jpg",
    },
    {
      "id": "groom_010",
      "name": "Pet Hair Trimmer Kit",
      "type": "grooming",
      "price": 129.95,
      "quantity": 18,
      "description":
          "Cordless electric trimmer for safe at-home pet grooming. Includes multiple guards and a quiet motor.",
      "image":
          "https://mypetcommand.com/cdn/shop/files/cordless-professional-dog-grooming-clippers-kit-for-pets-with-heavy-duty-blades-pet-products-412524.jpg",
    },
    {
      "id": "groom_011",
      "name": "Anti-Flea Shampoo",
      "type": "grooming",
      "price": 11.80,
      "quantity": 27,
      "description":
          "Medicated flea and tick shampoo that kills pests on contact while being gentle on sensitive skin.",
      "image":
          "https://www.canaanalpha.com/wp-content/uploads/2023/05/Aniflea_.png",
    },
    {
      "id": "groom_012",
      "name": "Pet Bath Towel",
      "type": "grooming",
      "price": 5.99,
      "quantity": 70,
      "description":
          "Super absorbent microfiber towel specially designed for drying pets quickly and comfortably.",
      "image":
          "https://m.media-amazon.com/images/I/81BT4PsSPSL._AC_SL1500_.jpg",
    },
    {
      "id": "groom_013",
      "name": "Detangling Spray for Long Fur",
      "type": "grooming",
      "price": 19.20,
      "quantity": 33,
      "description":
          "Leave-in detangling and conditioning spray ideal for pets with long or curly coats.",
      "image":
          "https://freshlybailey.com/cdn/shop/files/7_f4658b9b-e5fb-43ad-9d14-6dad22ffc830.png?v=1736289683&width=600",
    },

    {
      "id": "groom_015",
      "name": "Pet Grooming Scissors Set",
      "type": "grooming",
      "price": 14.40,
      "quantity": 25,
      "description":
          "Stainless steel scissors set with rounded tips for safe trimming around face, paws, and tail.",
      "image":
          "https://m.media-amazon.com/images/I/81jOmeHDdgL._AC_SL1500_.jpg",
    },
    {
      "id": "groom_016",
      "name": "Foaming Pet Cleanser (No Rinse)",
      "type": "grooming",
      "price": 7.89,
      "quantity": 22,
      "description":
          "Waterless pet cleanser ideal for in-between baths and spot cleaning. Fresh lavender scent.",
      "image":
          "https://www.citrusmagic.com/wp-content/uploads/2023/05/613472330-Citrus-Magic-Pet-Foaming-Pet-Cleanser.jpg",
    },
    {
      "id": "groom_017",
      "name": "Pet Eye Wipes",
      "type": "grooming",
      "price": 4.99,
      "quantity": 36,
      "description":
          "Safe wipes for cleaning around pet eyes and removing tear stains.",
      "image":
          "https://m.media-amazon.com/images/I/71k8OruyeZL._AC_SL1500_.jpg",
    },
    {
      "id": "groom_018",
      "name": "Paw Washer Cup",
      "type": "grooming",
      "price": 13.95,
      "quantity": 19,
      "description":
          "Portable paw cleaner with soft silicone bristles. Just add water and twist!",
      "image":
          "https://media.istockphoto.com/id/1225587196/photo/mug-for-cleaning-the-paws-of-a-dog.jpg",
      //https://m.media-amazon.com/images/I/61KSuLNFoOL._SL1500_.jpg
    },
    {
      "id": "groom_019",
      "name": "Pet Grooming Apron",
      "type": "grooming",
      "price": 11.20,
      "quantity": 28,
      "description":
          "Waterproof and fur-resistant grooming apron with handy pockets for tools.",
      "image":
          "https://www.mutneys.com/wp-content/uploads/2024/06/Wahl_Dog_Grooming_Paw_Prints_Apron_Mutneys.png",
    },
    {
      "id": "groom_020",
      "name": "Pet Comb for Sensitive Skin",
      "type": "grooming",
      "price": 16.70,
      "quantity": 31,
      "description":
          "Stainless steel comb designed to gently untangle knots without irritating the skin.",
      "image": "https://m.media-amazon.com/images/I/71YZCFPjf3L._SL1500_.jpg",
    },
  ];

  static List<Map<String, dynamic>> listOfFood = [
    {
      "id": "food_001",
      "name": "Organic Chicken Kibble",
      "description":
          "High-protein dry dog food made from organic chicken, brown rice, and vegetables. Supports digestive health and energy.",
      "price": 32.99,
      "quantity": 40,
      "type": "food",
      "image":
          "https://cateredbowl.com/app/uploads/2018/02/food-bag-dog-organicturkey@2x.png",
    },
    {
      "id": "food_002",
      "name": "Salmon Delight Wet Food",
      "description":
          "Grain-free wet food rich in Omega-3 to promote healthy skin and a shiny coat. Ideal for adult dogs and cats.",
      "price": 3.99,
      "quantity": 90,
      "type": "food",
      "image":
          "https://www.bpetcare.com/wp-content/uploads/2024/04/KF-pate-deilight-cat-90g.png",
    },
    {
      "id": "food_003",
      "name": "Puppy Growth Formula",
      "description":
          "Complete and balanced nutrition for puppies under 1 year. Contains DHA for brain and vision development.",
      "price": 27.49,
      "quantity": 65,
      "type": "food",
      "image": "https://fidele.co/cdn/shop/files/GFF.jpg?v=1696399879",
    },
    {
      "id": "food_004",
      "name": "Senior Support Meal",
      "description":
          "Specially crafted for older pets with joint support and antioxidants. Made with turkey and sweet potato.",
      "price": 29.99,
      "quantity": 28,
      "type": "food",
      "image":
          "https://natureshug.com/cdn/shop/files/Natures_hug_pet_food_senior_cat_front_bag.jpg",
    },
    {
      "id": "food_005",
      "name": "Lamb & Rice Dry Mix",
      "description":
          "Premium dry food blend of lamb and rice for sensitive stomachs. Contains essential vitamins and minerals.",
      "price": 31.50,
      "quantity": 50,
      "type": "food",
      "image":
          "https://www.purina.com/.netlify/images?url=https%3A%2F%2Flive.purina.com%2Fsites%2Fdefault%2Ffiles%2Fproducts%2Fpurina-one-dry-dog-food-lamb-rice-new.png",
    },
    {
      "id": "food_006",
      "name": "Freeze-Dried Chicken Treats",
      "description":
          "All-natural freeze-dried chicken treats. Great as training rewards and rich in protein.",
      "price": 8.99,
      "quantity": 100,
      "type": "food",
      "image": "https://s7d2.scene7.com/is/image/PetSmart/5349656?fmt=webp",
    },
    {
      "id": "food_007",
      "name": "Tuna & Rice Cat Food",
      "description":
          "Wet food packed with high-quality tuna, rice, and taurine to support heart and eye health.",
      "price": 16.49,
      "quantity": 70,
      "type": "food",
      "image":
          "https://www.kohepets.com.sg/cdn/shop/products/fancy-feast-inspirations-tuna-courgette-wholegrain-rice.jpg",
    },
    {
      "id": "food_008",
      "name": "Beef Bites Jerky",
      "description":
          "Delicious and chewy beef jerky bites made from 100% real meat. No preservatives.",
      "price": 9.75,
      "quantity": 75,
      "type": "food",
      "image":
          "https://www.jacklinksfritolay.com/sites/jacklinks.com/files//2023-02/original-steak-bites-each_0.png",
    },

    {
      "id": "food_009",
      "name": "Vegetarian Pet Biscuits",
      "description":
          "Crunchy vegetarian snacks made with oats, carrots, and flaxseeds. Hypoallergenic and healthy.",
      "price": 7.99,
      "quantity": 45,
      "type": "food",
      "image":
          "https://www.laughingdogfood.com/wp-content/uploads/2021/06/LaughingDog-Food-Treat-Fruit.webp",
    },
    {
      "id": "food_011",
      "name": "Dental Care Sticks",
      "description":
          "Tasty dental chews that reduce tartar and freshen breath. Vet-approved formula.",
      "price": 6.50,
      "quantity": 85,
      "type": "food",
      "image":
          "https://ipet.ch/media/catalog/product/thumbnail/d46e22d4812a591a7fdf2b5b347ba14c402cb77728aed97fb7622b9b/image/0/1000x1000/111/98/1/0/100150_sparrow_dentalcare_sticks.jpg",
    },
    {
      "id": "food_012",
      "name": "Salmon Oil Booster",
      "description":
          "Liquid salmon oil supplement to promote healthy joints, coat, and immune system.",
      "price": 14.80,
      "quantity": 55,
      "type": "food",
      "image": "https://m.media-amazon.com/images/I/81sxeNz0+BL._AC_SX679_.jpg",
    },
    {
      "id": "food_013",
      "name": "Hypoallergenic Turkey Pâté",
      "description":
          "Single protein formula ideal for pets with allergies. Made with lean turkey and herbs.",
      "price": 5.20,
      "quantity": 48,
      "type": "food",
      "image":
          "https://healthypaws.co.uk/cdn/shop/files/38025TurkeyPate1_1024x1024.png",
    },
    {
      "id": "food_014",
      "name": "Vitamin-Boosted Soft Chews",
      "description":
          "Tasty soft chews enriched with multivitamins, taurine, and antioxidants for daily health.",
      "price": 11.99,
      "quantity": 72,
      "type": "food",
      "image":
          "https://m.media-amazon.com/images/I/71cdEatiOZL._AC_SL1500_.jpg",
    },
    {
      "id": "food_015",
      "name": "Duck & Sweet Potato Roll",
      "description":
          "Natural roll treat for chewing. Made with real duck, sweet potatoes, and flax oil.",
      "price": 12.35,
      "quantity": 38,
      "type": "food",
      "image":
          "https://cdn11.bigcommerce.com/s-ucjiusw7rc/images/stencil/1280x1280/products/4437/15795/PRIME_100_DUCK_POT__24047.1731283583.png",
    },
    {
      "id": "food_016",
      "name": "Kitten Nutrition Mix",
      "description":
          "Specially balanced formula for kittens. Supports bone development and immune function.",
      "price": 22.49,
      "quantity": 67,
      "type": "food",
      "image":
          "https://image.chewy.com/catalog/general/images/moe/067d1658-3a7b-7eaa-8000-3449ef654cd2._AC_SL600_V1_.jpg",
    },
    {
      "id": "food_017",
      "name": "Catnip-Infused Crunchies",
      "description":
          "Crunchy treats flavored with natural catnip extract. Great for play rewards and bonding.",
      "price": 5.99,
      "quantity": 120,
      "type": "food",
      "image":
          "https://m.media-amazon.com/images/I/71rYyTGV9pL._AC_SL1500_.jpg",
    },
    {
      "id": "food_018",
      "name": "Goat Milk Meal Topper",
      "description":
          "Powdered goat milk blend to mix with dry food. Adds taste and digestive benefits.",
      "price": 13.99,
      "quantity": 29,
      "type": "food",
      "image": "https://m.media-amazon.com/images/I/81u96YNha8L._AC_SX679_.jpg",
    },
    {
      "id": "food_019",
      "name": "Raw Bites Chicken Formula",
      "description":
          "Frozen raw food chunks with organic chicken, bones, and liver for biologically appropriate meals.",
      "price": 24.99,
      "quantity": 35,
      "type": "food",
      "image":
          "https://cdn.prod.website-files.com/66559920e522ff6d0d3e643c/66c1db466f222dbea2911aef_Big-Dog-Bites-Chicken.png",
    },
    {
      "id": "food_020",
      "name": "Rabbit & Kale Meal",
      "description":
          "Exotic protein option with rabbit, kale, and quinoa. Packed with iron and B12.",
      "price": 37.00,
      "quantity": 20,
      "type": "food",
      "image": "https://m.media-amazon.com/images/I/61W1mzu01mL._SL1200_.jpg",
    },
    {
      "id": "food_021",
      "name": "Mini Bites for Small Breeds",
      "description":
          "Dry food tailored for small breed dogs with smaller kibble size and high-calorie density.",
      "price": 26.60,
      "quantity": 54,
      "type": "food",
      "image":
          "https://www.kibblesnbits.com/wp-content/uploads/2024/04/Kibblesn-Bits-Mini-Bits-Small-Breed-Beef-Chicken-Dry-Dog-Food-3LB-1024x1024.png",
    },
    {
      "id": "food_022",
      "name": "Energy Boost Performance Blend",
      "description":
          "Ideal for active pets, this food is enriched with extra protein, fats, and taurine.",
      "price": 38.99,
      "quantity": 22,
      "type": "food",
      "image": "https://m.media-amazon.com/images/I/71tm+kYzuFL._SY606_.jpg",
    },
    {
      "id": "food_023",
      "name": "Digestive Care Mix",
      "description":
          "Nutritionally complete meal designed for pets with sensitive stomachs. Infused with pumpkin and probiotics.",
      "price": 28.70,
      "quantity": 36,
      "type": "food",
      "image": "https://m.media-amazon.com/images/I/712zBI8SivL._AC_SY879_.jpg",
    },
    {
      "id": "food_024",
      "name": "Holistic Duck Nuggets",
      "description":
          "Bite-sized duck nuggets formulated with brown rice and carrots for daily meals or rewards.",
      "price": 19.90,
      "quantity": 49,
      "type": "food",
      "image":
          "https://www.naturesmenu.co.uk/dw/image/v2/BDGX_PRD/on/demandware.static/-/Sites-NATURES-MENU-m-catalog/default/dwc4838006/images/967680/NM_CB_80DuckChicken20Fruits_2D.png",
    },
  ];

  static List<Map<String, dynamic>> listOfMedecines = [
    {
      "id": "health_001",
      "name": "Joint Health Chews",
      "type": "health",
      "price": 19.99,
      "quantity": 50,
      "description":
          "Soft chews designed to support joint flexibility and mobility in dogs. Contains glucosamine, MSM, and chondroitin to ease discomfort from daily activities.",
      "image":
          "https://m.media-amazon.com/images/I/71sMfYQOM7L._AC_SL1500_.jpg",
    },
    {
      "id": "health_002",
      "name": "Flea & Tick Prevention Drops",
      "type": "health",
      "price": 24.50,
      "quantity": 80,
      "description":
          "Fast-acting topical treatment that kills fleas, ticks, and lice. Suitable for pets over 12 weeks old. Water-resistant formula lasts for up to 30 days.",
      "image":
          "https://m.media-amazon.com/images/I/81q6GeUdkUL._AC_SL1500_.jpg",
    },
    {
      "id": "health_003",
      "name": "Pet Ear Cleaner",
      "type": "health",
      "price": 13.49,
      "quantity": 30,
      "description":
          "Gentle and effective formula that removes wax, dirt, and debris from your pet's ears while reducing odor and irritation. Alcohol-free and vet-approved.",
      "image":
          "https://m.media-amazon.com/images/I/71SQ54yDKcL._AC_SL1500_.jpg",
    },
    {
      "id": "health_004",
      "name": "Digestive Support Powder",
      "type": "health",
      "price": 17.99,
      "quantity": 45,
      "description":
          "Natural supplement promoting gut health with probiotics and digestive enzymes. Ideal for pets with sensitive stomachs or transitioning diets.",
      "image":
          "https://m.media-amazon.com/images/I/71+IGgd1TuL._AC_SL1500_.jpg",
    },
    {
      "id": "health_005",
      "name": "Paw Balm",
      "type": "health",
      "price": 10.95,
      "quantity": 60,
      "description":
          "Soothing balm made with organic shea butter and coconut oil to heal dry or cracked paws and noses. Safe if licked.",
      "image":
          "https://m.media-amazon.com/images/I/71wXi5KMjKL._AC_SL1500_.jpg",
    },
    {
      "id": "health_006",
      "name": "Antibacterial Wipes",
      "type": "health",
      "price": 9.75,
      "quantity": 100,
      "description":
          "Alcohol-free wipes infused with aloe and vitamin E for gentle cleansing of fur, paws, and skin. Helps reduce bacteria and odor.",
      "image":
          "https://petsdomain.com.au/cdn/shop/files/11573-1AbsorbPlusAntibacterialDogWipesFloral.jpg",
    },
    {
      "id": "health_007",
      "name": "Tear Stain Remover",
      "type": "health",
      "price": 11.00,
      "quantity": 35,
      "description":
          "Removes tear stains and prevents future buildup around the eyes. Safe for daily use and non-irritating to pets.",
      "image":
          "https://d7rh5s3nxmpy4.cloudfront.net/CMP9365/1/5021284175661_01.jpg",
    },
    {
      "id": "health_008",
      "name": "Dog Toothbrush Set",
      "type": "health",
      "price": 8.99,
      "quantity": 85,
      "description":
          "Three-piece dental hygiene set including dual-head brush, finger brush, and tongue scraper. Helps prevent plaque and gingivitis.",
      "image":
          "https://ke.jumia.is/unsafe/fit-in/680x680/filters:fill(white)/product/22/8122321/1.jpg",
    },
    {
      "id": "health_009",
      "name": "Omega-3 Fish Oil Supplement",
      "type": "health",
      "price": 21.00,
      "quantity": 42,
      "description":
          "High-quality fish oil to support skin, coat, heart, and joint health. Includes EPA and DHA in softgel form.",
      "image":
          "https://m.media-amazon.com/images/I/811shC-r4cL._AC_SL1500_.jpg",
    },
    {
      "id": "health_010",
      "name": "Worm Treatment Tablets",
      "type": "health",
      "price": 16.80,
      "quantity": 28,
      "description":
          "Broad-spectrum dewormer effective against roundworms, tapeworms, and hookworms. Easy-to-give chewable tablets.",
      "image":
          "https://cdn.petsathome.com/public/images/products/2000_P50008.jpg",
    },
    {
      "id": "health_011",
      "name": "Pet First Aid Kit",
      "type": "health",
      "price": 29.99,
      "quantity": 20,
      "description":
          "Comprehensive kit with gauze, antiseptic wipes, tweezers, bandages, and scissors. Ideal for emergencies at home or on the go.",
      "image":
          "https://m.media-amazon.com/images/I/71ESWcyaa2L._AC_SL1079_.jpg",
    },
    {
      "id": "health_012",
      "name": "Hot Spot Spray",
      "type": "health",
      "price": 14.95,
      "quantity": 33,
      "description":
          "Anti-itch and cooling relief spray for hot spots, skin irritation, and allergies. Contains tea tree and aloe vera.",
      "image":
          "https://m.media-amazon.com/images/I/719xEk8V-KL._AC_SL1500_.jpg",
    },
    {
      "id": "health_013",
      "name": "Calming Chews",
      "type": "health",
      "price": 18.75,
      "quantity": 70,
      "description":
          "Natural calming chews with chamomile and L-theanine to reduce anxiety during travel, storms, or vet visits.",
      "image":
          "https://zestypaws.com/cdn/shop/products/API2.0CalmingTurkey-01.png",
    },
    {
      "id": "health_014",
      "name": "Pet Thermometer",
      "type": "health",
      "price": 12.60,
      "quantity": 40,
      "description":
          "Digital rectal thermometer for accurate and fast body temperature readings. Waterproof and easy to disinfect.",
      "image": "https://m.media-amazon.com/images/I/71VxS1egy4L._SL1500_.jpg",
    },
    {
      "id": "health_015",
      "name": "Skin & Coat Supplement",
      "type": "health",
      "price": 22.40,
      "quantity": 48,
      "description":
          "Rich in omega fatty acids, biotin, and zinc to support healthy skin and a shiny coat. Great for dry, itchy skin.",
      "image":
          "https://m.media-amazon.com/images/I/81inUlX372L._AC_SL1500_.jpg",
    },
    {
      "id": "health_016",
      "name": "Pet Eye Wash",
      "type": "health",
      "price": 10.25,
      "quantity": 55,
      "description":
          "Saline-based formula for gently flushing debris, allergens, or irritants from your pet’s eyes. Non-stinging and pH balanced.",
      "image":
          "https://m.media-amazon.com/images/I/61Rl292QCxL._AC_SL1500_.jpg",
    },
    {
      "id": "health_017",
      "name": "Dental Water Additive",
      "type": "health",
      "price": 15.00,
      "quantity": 60,
      "description":
          "Flavorless liquid added to water to reduce plaque, freshen breath, and promote oral hygiene without brushing.",
      "image":
          "https://cdn.petsathome.com/public/images/products/3000_7152609.jpg",
    },
    {
      "id": "health_018",
      "name": "Allergy Relief Tablets",
      "type": "health",
      "price": 19.90,
      "quantity": 22,
      "description":
          "Relieves itching, sneezing, and skin rashes caused by seasonal allergies or food sensitivities.",
      "image": "https://m.media-amazon.com/images/I/51oe62hqUgL._SL1500_.jpg",
    },
    {
      "id": "health_019",
      "name": "Natural Deworming Powder",
      "type": "health",
      "price": 16.40,
      "quantity": 37,
      "description":
          "Herbal formula for gently eliminating parasites and improving digestive health in both dogs and cats.",
      "image":
          "https://m.media-amazon.com/images/I/71m2EKX4WeL._AC_SL1500_.jpg",
    },
    {
      "id": "health_020",
      "name": "Veterinary Vitamin Mix",
      "type": "health",
      "price": 20.00,
      "quantity": 43,
      "description":
          "Multivitamin supplement designed by vets to support energy, immune function, and overall health. Includes A, D, E, B-complex.",
      "image": "Veterinary Vitamin Mix",
    },
    {
      "id": "health_021",
      "name": "Healthy Gut Probiotic Mix",
      "description":
          "Nutritional powder supplement that boosts digestion with probiotics and prebiotics.",
      "price": 18.25,
      "quantity": 60,
      "type": "health",
      "image":
          "https://m.media-amazon.com/images/I/81lTMlXYHXL._AC_SL1500_.jpg",
    },
  ];
}
