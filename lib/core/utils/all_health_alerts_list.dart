/// ============================================================================
/// 🩺 All Health Alerts List (traducido al español)
/// ============================================================================
///
/// Map<String, Map<String, dynamic>> allHealthAlerts
///
/// Cada entrada contiene:
/// - severity (Urgent|Medium|Mild) — se mantiene en inglés para lógica interna.
/// - description — resumen breve en español.
/// - icon — ruta al asset SVG.
/// - possible_causes — causas posibles en español.
/// - recommended_actions — lista de acciones recomendadas en español.
/// - CTA — lista de CTAs en español.
///
/// Mantén este archivo como fuente única del catálogo en la app.
/// ============================================================================
Map<String, Map<String, dynamic>> allHealthAlerts = {
  /// Urgent Alerts
  "Vomiting": {
    "severity": "Urgent",
    "description": "Más de 2–3 vómitos en un corto periodo",
    "icon": "assets/illustrations/health_alerts/vomiting.svg",
    "possible_causes":
        "Puede ser causado por intolerancia alimentaria, cambios bruscos de dieta, mareo por movimiento, ingestión de sustancias tóxicas o infecciones gastrointestinales. Vómitos ocasionales pueden ser benignos, pero episodios frecuentes o severos pueden indicar una condición grave.",
    "recommended_actions": [
      "Suspender la alimentación por 8–12 horas, pero ofrecer pequeñas cantidades de agua para evitar deshidratación.",
      "Evitar dar comida humana o golosinas durante este periodo.",
      "Comprobar si la mascota pudo ingerir algo tóxico o en mal estado.",
      "Vigilar síntomas adicionales como letargo, diarrea o sangre en el vómito.",
      "Si los vómitos persisten más de 24 horas o la mascota está débil, contactar urgentemente al veterinario.",
      "Si acudes al veterinario, lleva una muestra del vómito si es posible para facilitar el diagnóstico.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar colirio"],
  },

  "Diarrhea": {
    "severity": "Urgent",
    "description": "Riesgo de deshidratación; puede indicar infección",
    "icon": "assets/illustrations/health_alerts/diarrhea.svg",
    "possible_causes":
        "Puede deberse a cambios bruscos en la dieta, estrés, intolerancia alimentaria, infecciones bacterianas o virales, o ingestión de alimentos en mal estado. También puede indicar parásitos intestinales o enfermedades inflamatorias. La diarrea persistente puede causar deshidratación, especialmente en cachorros o mascotas pequeñas.",
    "recommended_actions": [
      "Asegurar acceso constante a agua fresca y limpia.",
      "Suspender la alimentación por 12–24 horas y luego reintroducir una dieta blanda (ej.: pollo hervido y arroz).",
      "Evitar lácteos, sobras o alimentos ricos.",
      "Comprobar otros síntomas como vómito, sangre en las heces o letargo.",
      "Si la diarrea continúa más de 24 horas o la mascota se muestra débil o rehúsa agua, consultar al veterinario inmediatamente.",
      "Si es posible, llevar una muestra de heces al veterinario para ayudar en el diagnóstico.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar soporte digestivo o solución electrolítica"],
  },

  "Lethargy": {
    "severity": "Urgent",
    "description": "Caída súbita de actividad o colapso",
    "icon": "assets/illustrations/health_alerts/less_active.svg",
    "possible_causes":
        "Puede ser causado por fiebre, deshidratación, anemia, infecciones o alteraciones metabólicas como diabetes o hipoglucemia. En ocasiones puede deberse a dolor, envenenamiento o estrés extremo. Una pérdida severa de energía, especialmente si la mascota no come ni bebe, requiere atención inmediata.",
    "recommended_actions": [
      "Revisar mucosas (encías) y nariz por resequedad o coloración anómala (posible deshidratación o mala circulación).",
      "Mantener a la mascota en un ambiente tranquilo, cómodo y a la sombra.",
      "Ofrecer agua con frecuencia, sin forzar la ingesta.",
      "Observar por otros signos como vómito, diarrea, respiración dificultosa o temblores.",
      "Si el letargo apareció de forma súbita o dura más de unas horas, buscar atención veterinaria inmediatamente — especialmente si hay colapso o inconsistencia.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Loss of Appetite": {
    "severity": "Urgent",
    "description": "Pérdida de apetito — puede ser síntoma de enfermedad",
    "icon": "assets/illustrations/health_alerts/appetite_loss.svg",
    "possible_causes":
        "La pérdida de apetito puede deberse a malestar digestivo, dolor dental, estrés o cambios en la dieta o el entorno. También puede indicar reacción a un medicamento o, en casos más graves, afecciones de riñón, hígado u hormonales.",
    "recommended_actions": [
      "Buscar otros síntomas como vómito o letargo.",
      "Asegurar agua fresca y un ambiente tranquilo para comer.",
      "No forzar la alimentación; probar calentar ligeramente la comida para aumentar el olor.",
      "Si la falta de apetito dura más de 24 horas, contactar con el veterinario inmediatamente.",
      "Registrar los patrones de apetito para compartir en la consulta.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Difficulty Breathing / Heavy Panting": {
    "severity": "Urgent",
    "description": "Dificultad para respirar o jadeo intenso — posible golpe de calor o problema cardíaco",
    "icon": "assets/illustrations/health_alerts/heavy_panting.svg",
    "possible_causes":
        "El jadeo excesivo o la dificultad respiratoria pueden deberse a golpe de calor, reacciones alérgicas, ansiedad u obstrucción de las vías aéreas. También pueden indicar infecciones respiratorias, enfermedades cardíacas o acumulación de líquido en los pulmones. Razas braquicéfalas (cara chata) son más susceptibles.",
    "recommended_actions": [
      "Trasladar a la mascota a un lugar fresco y ventilado de inmediato.",
      "Ofrecer pequeñas cantidades de agua y evitar actividad física.",
      "Revisar si las encías están pálidas o si hay sibilancias.",
      "Evitar exponer al animal a altas temperaturas o ambientes estresantes.",
      "Contactar con el veterinario con urgencia si la respiración no mejora en minutos o las encías están azuladas/pálidas.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Seizure": {
    "severity": "Urgent",
    "description": "Convulsiones — posible origen neurológico",
    "icon": "assets/illustrations/health_alerts/seizure.svg",
    "possible_causes":
        "Las convulsiones suelen relacionarse con trastornos neurológicos como epilepsia, pero también pueden derivar de exposición a toxinas, desequilibrios metabólicos (p. ej. hipoglucemia), traumatismos craneales o infecciones cerebrales. En algunos casos, estrés intenso, sobrecalentamiento o ingestión de sustancias tóxicas pueden desencadenarlas.",
    "recommended_actions": [
      "Alejar objetos punzantes y prevenir lesiones durante la convulsión.",
      "No intentar sujetar al animal ni introducir objetos en su boca.",
      "Tras la convulsión, mantener el entorno tranquilo y con baja iluminación.",
      "Registrar duración y frecuencia de las convulsiones para informar al veterinario.",
      "Buscar atención veterinaria inmediata si la convulsión dura más de 2–3 minutos o se repite.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Trembling": {
    "severity": "Urgent",
    "description": "Temblores — posible causa neurológica o dolor",
    "icon": "assets/illustrations/health_alerts/trembling.svg",
    "possible_causes":
        "Los temblores pueden provenir de ansiedad, frío, dolor, intoxicación, hipoglucemia o trastornos neurológicos. También pueden indicar debilidad muscular o fiebre. Si aparecen de forma súbita o van acompañados de otros signos como letargo o vómito, pueden señalar una emergencia.",
    "recommended_actions": [
      "Trasladar a la mascota a un lugar cálido y tranquilo y vigilar otros síntomas.",
      "Comprobar si hay signos de dolor, lesión o exposición a toxinas.",
      "Ofrecer agua y evitar sobreestimular al animal hasta que pase.",
      "Anotar duración y desencadenantes del temblor.",
      "Consultar al veterinario si los temblores persisten o van acompañados de desorientación o pérdida de equilibrio.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Limping / Dragging Legs": {
    "severity": "Urgent",
    "description": "Cojeo o arrastre de patas — posible lesión o problema de columna",
    "icon": "assets/illustrations/health_alerts/limping.svg",
    "possible_causes":
        "Puede deberse a esguinces, distensiones, fracturas, desgarros de ligamentos, artritis o problemas neurológicos que afectan la coordinación. También puede relacionarse con infecciones o enfermedades transmitidas por garrapatas. El cojeo persistente puede indicar dolor significativo.",
    "recommended_actions": [
      "Limitar el movimiento de la mascota para evitar más daño.",
      "Revisar suavemente si hay hinchazón, cortes o deformidades visibles — sin presionar.",
      "Mantener cómodo al animal y evitar saltos o ejercicio intenso.",
      "Aplicar compresas frías si hay hinchazón y vigilar la respuesta al dolor.",
      "Acudir al veterinario inmediatamente si la mascota no apoya la pata o arrastra continuamente.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Bleeding Gums / Nose / Wounds": {
    "severity": "Urgent",
    "description": "Sangrado de encías, nariz o heridas — posible trauma o infección",
    "icon": "assets/illustrations/health_alerts/bleeding.svg",
    "possible_causes":
        "El sangrado puede originarse por infecciones orales, enfermedad dental, traumatismos, trastornos de coagulación o ingestión de toxinas (p. ej. raticida). También puede indicar enfermedades sistémicas como problemas hepáticos o anemia.",
    "recommended_actions": [
      "Aplicar presión suave para detener sangrado externo y mantener a la mascota tranquila.",
      "No usar antisépticos humanos ni medicamentos sin indicación veterinaria.",
      "Revisar cavidad oral y nariz por objetos extraños o hinchazón.",
      "Vigilar signos de palidez en mucosas que indiquen pérdida de sangre.",
      "Contactar al veterinario inmediatamente si el sangrado no cesa o reaparece frecuentemente.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Overdue Vaccination": {
    "severity": "Urgent",
    "description": "Vacunación vencida — riesgo de enfermedades prevenibles",
    "icon": "assets/illustrations/health_alerts/Overduevaccination.svg",
    "possible_causes":
        "La vacunación vencida suele ser consecuencia de citas perdidas, mudanzas o falta de acceso a atención veterinaria. Retrasar vacunas incrementa la vulnerabilidad ante enfermedades como rabia, parvovirus, moquillo o leptospirosis.",
    "recommended_actions": [
      "Revisar el historial de vacunación y detectar qué vacunas faltan.",
      "Reservar cita con un veterinario para actualizar vacunaciones cuanto antes.",
      "Evitar contacto con animales desconocidos o áreas públicas hasta estar al día.",
      "Configurar recordatorios automáticos para futuras dosis de refuerzo.",
      "Consultar con el veterinario la periodicidad de refuerzos recomendada.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Overdue Medication": {
    "severity": "Urgent",
    "description": "Medicación atrasada — riesgo de complicaciones",
    "icon": "assets/illustrations/health_alerts/overdue_medication.svg",
    "possible_causes":
        "Omitir o retrasar dosis puede reducir la eficacia del tratamiento y causar recurrencia o empeoramiento de la condición. Suele ocurrir por olvido, dificultad para administrar medicación o falta de suministro.",
    "recommended_actions": [
      "Comprobar cuándo fue la última dosis y reanudar según indicaciones veterinarias.",
      "No duplicar dosis para compensar omisiones a menos que lo indique el profesional.",
      "Contactar al veterinario si faltaron múltiples dosis o aparecen síntomas relacionados.",
      "Configurar recordatorios o alertas de suministro en la app.",
      "Reponer recetas antes de que se agoten.",
    ],
    "CTA": ["Reservar cita veterinaria", "Solicitar reposición de medicación"],
  },

  /// Medium Alerts
  "Eye Discharge": {
    "description": "Secreción ocular — posible conjuntivitis o alergia",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/eye_discharge.svg",
    "possible_causes":
        "La secreción ocular puede deberse a irritación por polvo, alergias, conductos lagrimales obstruidos o infecciones. Si la secreción es persistente, espesa o de color (amarilla/verde), puede indicar infección.",
    "recommended_actions": [
      "Limpiar suavemente el área ocular con un paño húmedo y limpio.",
      "No usar colirios humanos sin indicación veterinaria.",
      "Vigilar enrojecimiento, hinchazón o cambio en el color de la secreción.",
      "Recortar el pelo alrededor de los ojos para evitar irritación.",
      "Visitar al veterinario si la secreción persiste más de 24–48 horas o empeora.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Red Eyes": {
    "description": "Ojos enrojecidos — posible irritación o infección",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/red_eye.svg",
    "possible_causes":
        "El enrojecimiento puede venir de irritantes ambientales, alergias, conjuntivitis o problemas más serios como úlceras corneales o glaucoma.",
    "recommended_actions": [
      "Evitar humo, polvo y productos químicos fuertes cerca de la mascota.",
      "Limpiar la secreción con cuidado y mantener la zona seca.",
      "Impedir que la mascota se rasque o frote los ojos.",
      "Usar collar isabelino si es necesario para prevenir lesiones.",
      "Consultar al veterinario si el enrojecimiento dura más de 24 horas o hay secreción anómala.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },

  "Coughing / Sneezing": {
    "description": "Tos o estornudos — posible infección respiratoria",
    "severity": "Medium",
    "icon": "assets/illustrations/health_alerts/sneezing.svg",
    "possible_causes":
        "Podría deberse a irritación por polvo, alergias, aire seco, o infecciones como tos de las perreras o infecciones respiratorias felinas. También puede relacionarse con problemas dentales o cardiacos.",
    "recommended_actions": [
      "Mantener un ambiente limpio y bien ventilado.",
      "Observar frecuencia y patrón de la tos o estornudos.",
      "Evitar exposición a humo, perfumes o productos irritantes.",
      "Asegurar vacunas al día según recomendaciones veterinarias.",
      "Consultar al veterinario si la tos persiste o viene con letargo o secreción nasal.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar purificadores de aire y humidificadores"],
  },

  /// Mild Alerts
  "Dry Skin": {
    "description": "Piel seca — puede ser por nutrición o hidratación",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/dry_skin.svg",
    "possible_causes":
        "La piel seca puede ser por baja humedad, baños frecuentes, productos de aseo agresivos, dieta pobre o deshidratación. Parásitos o dermatitis también pueden causar sequedad y picor.",
    "recommended_actions": [
      "Asegurar buena hidratación y dieta equilibrada rica en ácidos grasos omega.",
      "Evitar baños excesivos y productos no aptos para mascotas.",
      "Cepillar regularmente para distribuir los aceites naturales del pelaje.",
      "Usar champús o acondicionadores recomendados por el veterinario.",
      "Visitar al veterinario si la sequedad persiste o hay pérdida de pelo.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar productos para piel y pelaje"],
  },

  "Mild Bad Breath": {
    "description": "Mal aliento leve — higiene dental inicial",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/bad_breath.svg",
    "possible_causes":
        "Generalmente causado por acumulación de placa, restos de comida o higiene dental insuficiente. Puede evolucionar a enfermedad periodontal si no se trata.",
    "recommended_actions": [
      "Cepillar los dientes regularmente con pasta para mascotas.",
      "Ofrecer juguetes o golosinas dentales que ayuden a reducir sarro.",
      "Asegurar agua fresca disponible en todo momento.",
      "Programar limpiezas dentales periódicas con el veterinario.",
      "Consultar si el mal aliento empeora o aparece dolor al comer.",
    ],
    "CTA": ["Comprar productos dentales", "Reservar limpieza dental"],
  },

  "Eye Watering": {
    "description": "Lagrimeo — irritación por polvo o alergias",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/eye_watering.svg",
    "possible_causes":
        "Suele deberse a irritantes ambientales, pelo en la zona ocular o conductos lagrimales parcialmente obstruidos. Si es persistente, podría indicar infección o problema ocular.",
    "recommended_actions": [
      "Limpiar suavemente con paño húmedo y mantener el área limpia.",
      "Evitar exposición a polvo y alérgenos cuando sea posible.",
      "Recortar pelo alrededor de los ojos si molesta.",
      "Vigilar cambios en color o consistencia de la secreción.",
      "Consultar al veterinario si persiste más de 48 horas o empeora.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar toallitas oculares para mascotas"],
  },

  "Excessive Paw Licking": {
    "description": "Lamerse las patas en exceso — irritación o conducta",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/paw_licking.svg",
    "possible_causes":
        "Puede deberse a irritación por suciedad, pequeños objetos entre almohadillas, alergias, aburrimiento o estrés. También puede indicar dermatitis o infección si es persistente.",
    "recommended_actions": [
      "Inspeccionar y limpiar las patas después de paseos.",
      "Mantener las almohadillas secas y libres de objetos.",
      "Ofrecer estimulación mental y juguetes para reducir aburrimiento.",
      "Evitar productos de limpieza agresivos en suelos por donde camina.",
      "Consultar al veterinario si hay enrojecimiento, pérdida de pelo o mal olor.",
    ],
    "CTA": ["Reservar cita veterinaria", "Comprar bálsamos para patas"],
  },

  "Slightly Less Active": {
    "description": "Actividad ligeramente reducida — vigilar",
    "severity": "Mild",
    "icon": "assets/illustrations/health_alerts/less_active.svg",
    "possible_causes":
        "Una ligera disminución de actividad puede ser normal por edad, clima o rutina. Si persiste, podría indicar malestar, dolor o enfermedad incipiente.",
    "recommended_actions": [
      "Observar comportamiento y nivel de energía por 2–3 días.",
      "Asegurar que come, bebe y duerme con normalidad.",
      "Fomentar paseos cortos o juego ligero para recuperar actividad.",
      "Vigilar otros síntomas como pérdida de apetito o cojera.",
      "Consultar al veterinario si la reducción de actividad continúa o empeora.",
    ],
    "CTA": ["Reservar cita veterinaria"],
  },
};