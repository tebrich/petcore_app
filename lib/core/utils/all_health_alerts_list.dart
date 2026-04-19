/// ============================================================================
/// 🩺 All Health Alerts List
/// ============================================================================
///
/// This file contains a centralized list of predefined **health alerts** used
/// throughout the Peticare app. Each alert entry includes:
///
/// - **severity** → Indicates the urgency level (e.g., Urgent, Medium, Mild)
/// - **description** → Short summary shown in alert cards or notifications
/// - **icon** → Path to the corresponding SVG illustration asset
/// - **possible_causes** → Descriptive paragraph explaining what might trigger
///   the condition or symptom
/// - **recommended_actions** → A list of actionable steps the user can take
///   based on the symptom or issue
/// - **CTA** → Suggested quick actions (e.g., "Book Vet Appointment")
///
/// The structure follows this format:
/// ```dart
/// Map<String, Map<String, dynamic>> allHealthAlerts = {
///   "AlertName": {
///     "severity": "Urgent",
///     "description": "Brief summary",
///     "icon": "assets/illustrations/health_alerts/filename.svg",
///     "possible_causes": "Detailed explanation",
///     "recommended_actions": [
///       "Step 1",
///       "Step 2",
///     ],
///     "CTA": ["Primary CTA", "Secondary CTA"],
///   },
/// };
/// ```
///
/// ⚠️ **Note:**
/// - This data is intended as **placeholder/demo content** and should be
///   customized, localized, or extended as needed for production use.
/// - For maintainability and scalability, consider refactoring this static map
///   into a dedicated **HealthAlertModel** class with proper typing, and
///   eventually fetching this data dynamically from your backend or CMS.
///
/// ============================================================================
library;

Map<String, Map<String, dynamic>> allHealthAlerts = {
  /// Urgent Alerts
  "Vomiting": {
    "severity": "Urgent",
    "description": "More than 2–3 times in a short period",
    "icon": "assets/illustrations/health_alerts/vomiting.svg",
    "possible_causes":
        "This may be caused by food intolerance, sudden diet changes, motion sickness, ingestion of toxic substances, or underlying infections affecting the stomach or intestines. Occasional vomiting may be harmless, but frequent or severe episodes can indicate a serious condition.",
    "recommended_actions": [
      "Withhold food for 8–12 hours, but keep providing small amounts of water to prevent dehydration.",

      "Avoid giving any human food or treats during this period.",

      "Check if your pet might have eaten something toxic or spoiled.",

      "Monitor for additional symptoms like lethargy, diarrhea, or blood in vomit.",

      "If vomiting persists beyond 24 hours or your pet seems weak, contact a veterinarian immediately.",

      "Bring a sample of the vomit if you visit the vet (for easier diagnosis).",
    ],
    "CTA": ["Book Vet Appointment", "Buy Eye Drops"],
  },
  "Diarrhea": {
    "severity": "Urgent",
    "description": "Dehydration risk, could indicate infection",
    "icon": "assets/illustrations/health_alerts/diarrhea.svg",

    "possible_causes":
        "This may be caused by sudden dietary changes, stress, food intolerance, bacterial or viral infections, or ingestion of spoiled or contaminated food. It can also signal underlying issues like intestinal parasites or inflammatory bowel disease. Persistent diarrhea can quickly lead to dehydration, especially in small pets or young animals.",
    "recommended_actions": [
      "Ensure your pet has constant access to clean, fresh water.",

      "Withhold food for 12–24 hours, then reintroduce a bland diet (e.g., boiled chicken and rice).",

      "Avoid giving dairy, table scraps, or rich treats.",

      "Check for other symptoms such as vomiting, blood in stool, or lethargy.",

      "If diarrhea continues beyond 24 hours, or your pet seems weak or refuses water, consult a veterinarian immediately.",

      "Bring a stool sample to the vet if possible — it can help with diagnosis.",
    ],
    "CTA": [
      "Book Vet Appointment",
      "Buy Digestive Support or Electrolyte Solution",
    ],
  },
  "Lethargy": {
    "severity": "Urgent",
    "description": "Sudden drop in activity or collapse",
    "icon": "assets/illustrations/health_alerts/less_active.svg",

    "possible_causes":
        "This may be caused by fever, dehydration, anemia, infection, or metabolic conditions such as diabetes or low blood sugar. In some cases, lethargy can result from pain, poisoning, or even emotional distress. A sudden or severe loss of energy—especially if your pet refuses food or water—requires prompt attention.",
    "recommended_actions": [
      "Check your pet’s gums and nose for dryness or discoloration (possible dehydration or poor circulation).",

      "Ensure your pet is resting in a calm, comfortable, and shaded environment.",

      "Offer water frequently, but avoid forcing it if your pet resists.",

      "Look for additional warning signs such as vomiting, diarrhea, labored breathing, or trembling.",

      "If lethargy appeared suddenly or lasts more than a few hours, seek veterinary care immediately — especially if your pet collapses or becomes unresponsive.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Loss of Appetite": {
    "severity": "Urgent",
    "description": "Could be a symptom of serious illness",
    "icon": "assets/illustrations/health_alerts/appetite_loss.svg",

    "possible_causes":
        "Loss of appetite in pets can result from mild digestive upset, dental discomfort, stress, or sudden changes in diet or environment. It may also indicate a reaction to new medication or, in more serious cases, an underlying condition such as kidney, liver, or hormonal disease.",
    "recommended_actions": [
      "Check for other symptoms like vomiting or lethargy.",

      "Ensure fresh water and a calm feeding environment.",

      "Avoid forcing food — try warming meals slightly to increase smell.",

      "If appetite loss lasts more than 24 hours, contact a vet immediately.",

      "Keep note of appetite patterns to share during consultation.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Difficulty Breathing / Heavy Panting": {
    "severity": "Urgent",
    "description": "May indicate heatstroke or heart issues",
    "icon": "assets/illustrations/health_alerts/heavy_panting.svg",

    "possible_causes":
        "Difficulty breathing or excessive panting can be caused by heat exhaustion, allergic reactions, anxiety, or airway obstruction. It may also stem from more serious issues such as respiratory infections, heart disease, or fluid buildup in the lungs. Overexertion in hot weather or stress can further worsen the condition, especially in brachycephalic (flat-faced) breeds.",
    "recommended_actions": [
      "Move your pet to a cool, well-ventilated area immediately.",

      "Offer small amounts of water and avoid physical activity.",

      "Check for signs of pale gums or wheezing.",

      "Avoid exposing your pet to high temperatures or stressful environments.",

      "Contact a vet urgently if breathing doesn’t normalize within minutes or if gums appear blue/pale.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Seizure": {
    "severity": "Urgent",
    "description": "Could be neurological",

    "icon": "assets/illustrations/health_alerts/seizure.svg",
    "possible_causes":
        "Seizures in pets are often linked to neurological disorders such as epilepsy, but they can also result from toxin exposure, metabolic imbalances (like low blood sugar or liver issues), head trauma, or infections affecting the brain. In some cases, severe stress, overheating, or ingestion of harmful substances like chocolate or pesticides can trigger sudden convulsions.",
    "recommended_actions": [
      "Keep your pet away from sharp objects and prevent injury during the seizure.",

      "Do not try to restrain your pet or place anything in its mouth.",

      "After the seizure, keep the environment quiet and dimly lit.",

      "Monitor the duration and frequency of seizures for your vet.",

      "Seek immediate veterinary attention if the seizure lasts more than 2–3 minutes or occurs repeatedly.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Trembling": {
    "severity": "Urgent",
    "description": "Could be neurological",

    "icon": "assets/illustrations/health_alerts/trembling.svg",

    "possible_causes":
        "Trembling or shaking in pets can result from a variety of causes, ranging from anxiety, fear, or cold temperatures to more serious issues like pain, poisoning, low blood sugar, or neurological disorders. It may also indicate muscle weakness, fever, or a reaction to certain medications. If trembling appears suddenly or is accompanied by other symptoms such as lethargy, vomiting, or confusion, it could signal an underlying health emergency.",
    "recommended_actions": [
      "Move your pet to a calm, warm environment and monitor for additional symptoms.",

      "Check for signs of pain, injury, or toxic exposure.",

      "Offer fresh water and avoid over-stimulation until the trembling subsides.",

      "Note how long the trembling lasts and what triggered it.",

      "Seek immediate veterinary care if trembling is persistent or accompanied by disorientation or loss of balance.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Limping / Dragging Legs": {
    "severity": "Urgent",
    "description": "May be injury or spinal issue",
    "icon": "assets/illustrations/health_alerts/limping.svg",

    "possible_causes":
        "Limping or dragging legs can stem from muscle strains, sprains, or joint injuries caused by sudden movement, falls, or overexertion. It may also indicate broken bones, ligament tears, arthritis, or nerve and spinal cord problems that affect coordination. In some cases, it can be linked to infections, tick-borne diseases, or neurological disorders impacting mobility. Persistent or severe limping should always be treated as a sign of potential pain or nerve damage.",
    "recommended_actions": [
      "Limit your pet’s movement and prevent further strain on the affected limb.",

      "Gently check for swelling, cuts, or visible deformities — avoid applying pressure.",

      "Keep your pet comfortable and discourage jumping or running.",

      "Apply a cool compress if there’s swelling, and monitor for pain reactions.",

      "Seek veterinary attention immediately if your pet can’t bear weight or drags its leg continuously.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Bleeding Gums / Nose / Wounds": {
    "severity": "Urgent",
    "description": "Sign of trauma or infection",
    "icon": "assets/illustrations/health_alerts/bleeding.svg",

    "possible_causes":
        "Bleeding from the gums, nose, or wounds may result from oral infections, dental disease, or physical trauma such as cuts or falls. It can also signal clotting disorders, toxin ingestion (like rat poison), or immune-related conditions that affect platelet function. In some cases, frequent nosebleeds or gum bleeding may point to systemic illnesses like liver disease, anemia, or severe infections. Persistent or unexplained bleeding should be treated as a veterinary emergency.",
    "recommended_actions": [
      "Apply gentle pressure to stop external bleeding and keep your pet calm.",

      "Avoid using human antiseptics or medication unless directed by a vet.",

      "Check your pet’s mouth and nose for foreign objects or swelling.",

      "Keep your pet hydrated and monitor for pale gums, which may indicate blood loss.",

      "Contact your vet immediately if bleeding doesn’t stop within a few minutes or recurs frequently.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Overdue Vaccination": {
    "severity": "Urgent",
    "description": "High risk of preventable disease",
    "icon": "assets/illustrations/health_alerts/Overduevaccination.svg",

    "possible_causes":
        "An overdue vaccination often occurs due to missed vet appointments, relocation, or lack of access to veterinary care. However, delaying essential vaccines can significantly increase your pet’s vulnerability to preventable diseases such as rabies, parvovirus, distemper, or leptospirosis. In young pets, skipped booster shots may compromise developing immunity, while adult pets may lose their protection over time, leaving them exposed to infections spread by other animals or the environment.",
    "recommended_actions": [
      "Check your pet’s vaccination record and identify which vaccines are overdue.",

      "Book an appointment with a licensed veterinarian for immediate catch-up shots.",

      "Avoid contact with unfamiliar animals or public places until your pet is vaccinated.",

      "Set up automatic vaccination reminders through your app or vet clinic.",

      "Discuss with your vet about annual or biannual booster schedules to stay up to date.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Overdue Medication": {
    "severity": "Urgent",
    "description": "High risk of preventable disease",
    "icon": "assets/illustrations/health_alerts/overdue_medication.svg",

    "possible_causes":
        "Missing or delaying a prescribed medication dose can reduce its effectiveness and cause the recurrence or worsening of the underlying condition. This may happen due to forgetfulness, difficulty administering medication, or running out of supply. In chronic cases such as heart disease, diabetes, infections, or parasite prevention, overdue medication can quickly lead to complications, resistance to treatment, or a higher risk of reinfection.",
    "recommended_actions": [
      "Check when the last dose was administered and resume medication as soon as possible (unless instructed otherwise by your vet).",

      "Never double the next dose to “make up” for a missed one.",

      "Contact your vet if more than one dose has been missed or if your pet shows symptoms related to the condition.",

      "Set up in-app reminders or refill alerts to avoid future lapses.",

      "Refill prescriptions before the current supply runs out.",
    ],
    "CTA": ["Book Vet Appointment", "Order Medication Refill"],
  },

  /// Medium Alerts
  "Eye Discharge": {
    "description": "Common sign of conjunctivitis or allergies",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/eye_discharge.svg",

    "possible_causes":
        "Eye discharge in pets can be caused by mild irritations such as dust, allergies, or blocked tear ducts, but it can also signal infections like conjunctivitis or corneal ulcers. Breeds with protruding eyes or long hair around the face are more prone to eye irritation. Persistent or colored discharge (yellow, green, or bloody) may indicate bacterial or viral infection that requires veterinary care. Left untreated, these conditions can lead to discomfort or even vision loss.",
    "recommended_actions": [
      "Gently clean the eye area using a soft cloth and warm water.",

      "Avoid using human eye drops or medication without veterinary advice.",

      "Monitor for redness, swelling, or changes in discharge color.",

      "Keep hair trimmed around the eyes to prevent further irritation.",

      "Visit a veterinarian if discharge persists for more than 24–48 hours or becomes thick or colored.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
  "Red Eyes": {
    "description": "Common sign of conjunctivitis or allergies",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/red_eye.svg",

    "possible_causes":
        "Red eyes in pets are often caused by eye irritation, allergies, or mild infections like conjunctivitis. However, they can also indicate more serious issues such as corneal ulcers, glaucoma, or high blood pressure. Environmental irritants—like smoke, dust, or strong cleaning products—can also trigger redness and inflammation. In some pets, eye redness may result from dry eyes or blocked tear ducts, especially in breeds prone to ocular conditions. Persistent redness or swelling usually signals an underlying infection or inflammation requiring veterinary attention.",
    "recommended_actions": [
      "Keep your pet away from smoke, dust, and chemical fumes.",

      "Gently clean any discharge with a sterile, damp cloth.",

      "Prevent your pet from scratching or rubbing its eyes.",

      "Use an Elizabethan collar if irritation persists to avoid injury.",

      "Visit your veterinarian if redness lasts more than 24 hours or is accompanied by swelling, discharge, or light sensitivity.",
    ],
    "CTA": ["Book Vet Appointment"],
  },

  "Coughing / Sneezing": {
    "description": "May indicate respiratory infection",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/sneezing.svg",

    "possible_causes":
        "Coughing or sneezing in pets is often triggered by mild respiratory irritation from dust, allergies, or dry air, but it can also signal infections such as kennel cough, feline upper respiratory infection, or even early signs of pneumonia. Other possible causes include throat irritation, dental disease, heart issues, or inhaled foreign particles. Environmental factors—like cigarette smoke, perfume, or air conditioning—can worsen symptoms, especially in smaller breeds or short-nosed pets. Persistent or worsening coughing should always be evaluated by a vet.",
    "recommended_actions": [
      "Keep your pet in a clean, dust-free environment and ensure proper ventilation.",

      "Monitor the frequency and pattern of coughing or sneezing.",

      "Avoid exposing your pet to smoke, perfumes, or strong cleaning products.",

      "Ensure your pet is up to date on vaccinations, especially for kennel cough.",

      "Visit your vet if coughing lasts more than a few days, becomes harsh, or is accompanied by lethargy or nasal discharge.",
    ],
    "CTA": ["Book Vet Appointment", "Shop Air Purifiers & Pet Humidifiers"],
  },

  /// Mild Alerts
  "Dry Skin": {
    "description": "Coat	May be nutrition or hydration issue",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/dry_skin.svg",

    "possible_causes":
        "Dry skin in pets is often caused by environmental factors like low humidity, frequent bathing, or exposure to harsh grooming products. However, it can also stem from poor diet, dehydration, allergies, or underlying conditions such as dermatitis or thyroid imbalance. Parasites like fleas or mites may further irritate the skin, leading to itching and flaking. Inadequate grooming or a lack of essential fatty acids in the diet can also make the coat dull and dry over time.",
    "recommended_actions": [
      "Ensure your pet is well-hydrated and fed a balanced diet rich in omega-3 and omega-6 fatty acids.",

      "Avoid excessive bathing or using human shampoos on your pet.",

      "Brush regularly to remove dead skin and distribute natural oils.",

      "Use a vet-approved moisturizing shampoo or conditioner.",

      "Schedule a vet visit if dryness persists or is accompanied by itching, redness, or hair loss.",
    ],
    "CTA": ["Book Vet Appointment", "Shop Skin & Coat Care Products"],
  },
  "Mild Bad Breath": {
    "description": "Early dental hygiene issue",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/bad_breath.svg",

    "possible_causes":
        "Mild bad breath in pets is commonly caused by the buildup of plaque and bacteria in the mouth due to infrequent brushing or poor dental hygiene. It can also result from leftover food particles, mild gum inflammation, or diet-related factors. Occasionally, digestive issues, dehydration, or early signs of tartar accumulation may contribute to the odor. While mild at first, untreated bad breath can progress to periodontal disease if not properly managed through consistent care.",
    "recommended_actions": [
      "Brush your pet’s teeth regularly using pet-safe toothpaste.",

      "Offer dental chews or toys designed to reduce plaque buildup.",

      "Ensure your pet has access to clean water throughout the day.",

      "Schedule routine dental cleanings with your veterinarian.",

      "Monitor for worsening odor, drooling, or visible tartar, which may indicate gum disease.",
    ],
    "CTA": ["Shop Dental Care Essentials", "Book Dental Cleaning Appointment"],
  },
  "Eye Watering": {
    "description": "Dust or seasonal irritation",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/eye_watering.svg",

    "possible_causes":
        "Eye watering in pets is often a response to mild irritation caused by dust, pollen, wind, or seasonal allergies. It can also occur when small particles enter the eye, or from minor scratches on the cornea. Certain breeds with prominent eyes or shallow eye sockets are naturally more prone to tear overflow. In some cases, watery eyes may indicate a mild infection, tear duct blockage, or early conjunctivitis. While usually harmless, persistent tearing or discoloration around the eyes may require veterinary evaluation.",
    "recommended_actions": [
      "Gently wipe the area around your pet’s eyes with a clean, damp cloth.",

      "Keep your pet’s environment free of dust, smoke, and strong fragrances.",

      "Avoid letting hair around the eyes grow too long or obstruct vision.",

      "Monitor for redness, swelling, or thick discharge that could indicate infection.",

      "Visit a vet if watering persists for more than 48 hours or worsens suddenly.",
    ],
    "CTA": ["Book Vet Appointment", "Shop Pet Eye Wipes & Cleansers"],
  },
  /*
  "Mild Appetite Change": {
    "description": "Could be heat or stress",
    "severity": "Mild",
  
    "possible_causes":,
    "recommended_actions":,
    },*/
  "Excessive Paw Licking": {
    "description": "	Often due to boredom or minor irritation",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/paw_licking.svg",

    "possible_causes":
        "Excessive paw licking is commonly linked to mild irritation from dust, grass, or small debris caught between the paw pads. It can also be a sign of dry skin, insect bites, mild allergies, or contact with irritants like cleaning products or road salt. In some cases, pets lick their paws out of boredom, anxiety, or as a self-soothing behavior. Persistent licking, redness, or hair loss around the area may indicate an underlying infection or allergy that requires attention.",
    "recommended_actions": [
      "Gently inspect and clean your pet’s paws after walks.",

      "Keep the area dry and free of dirt or irritants.",

      "Provide toys or mental stimulation to reduce boredom-related licking.",

      "Avoid harsh floor cleaners or outdoor chemicals that can irritate paws.",

      "Consult a vet if licking persists, or if you notice swelling, sores, or odor.",
    ],
    "CTA": ["Book Vet Appointment", "Shop Paw Balms & Protective Sprays"],
  },
  "Slightly Less Active": {
    "description": "May vary naturally, worth monitoring",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/less_active.svg",

    "possible_causes":
        "A slight decrease in activity can often be a normal variation due to changes in weather, age, or daily routine. Pets may also become less active after a heavy meal, mild fatigue, or emotional shifts such as boredom or minor stress. However, if the reduced activity persists, it could indicate early signs of discomfort, pain, minor illness, or even emotional distress. Monitoring patterns over a few days helps determine whether the change is temporary or a sign of an underlying issue.",
    "recommended_actions": [
      "Observe your pet’s behavior and energy levels for 2–3 days.",

      "Ensure they’re eating, drinking, and sleeping normally.",

      "Encourage light play or short walks to boost engagement.",

      "Check for other mild symptoms like loss of appetite or limping.",

      "Contact a vet if lethargy continues or worsens.",
    ],
    "CTA": ["Book Vet Appointment"],
  },
};
