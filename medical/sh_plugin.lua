local PLUGIN = PLUGIN

PLUGIN.name = "Médicale"
PLUGIN.author = "Scott Crane"
PLUGIN.desc = "Ajoute un systéme médicale.."

nut.util.Include("sh_medical.lua")

nut.util.Include("cl_showspare.lua")

--- Enregistre les conditions medicale
PLUGIN:RegisterMedicalCondition("fracture", "splint", "Fracture", {4,5,6,7}) -- Attelle
PLUGIN:RegisterMedicalCondition("bleeding", "bandage", "Hémorragie", {1,2,3,4,5,6,7}) -- bandages
PLUGIN:RegisterMedicalCondition("lacerations", "suture", "Coupure profondes", {1,2,3,4,5,6,7}) -- Aiguille de suture
PLUGIN:RegisterMedicalCondition("burned2", "burncream", "Brûlures au second degré", {1,2,3,4,5,6,7}) -- Crême Anti-Brulure
PLUGIN:RegisterMedicalCondition("burned", "burncream", "Brûlures au troisième degré", {1,2,3,4,5,6,7}) -- Crême Anti-Brulure
PLUGIN:RegisterMedicalCondition("gunshot", "tweezers", "Blessures par balle", {1,2,3,4,5,6,7}) -- Pince Chirurgicale + Aiguille de suture
PLUGIN:RegisterMedicalCondition("crippled", "docbag", "Estropié", {1,2,3,4,5,6,7}) -- Sac de médecin
PLUGIN:RegisterMedicalCondition("shrapnel", "tweezers", "Shrapnel", {1,2,3,4,5,6,7}) -- Pince Chirurgicale + Aiguille de suture
PLUGIN:RegisterMedicalCondition("plasma", "burncream", "Brûlures de plasma", {1,2,3,4,5,6,7}) -- Crême Anti-Brulure
PLUGIN:RegisterMedicalCondition("laser", "burncream", "Brûlures au laser", {1,2,3,4,5,6,7}) -- Crême Anti-Brulure
PLUGIN:RegisterMedicalCondition("bruise", "painkillers", "Ecchymoses légères", {1,2,3,4,5,6,7}) -- analgésiques
PLUGIN:RegisterMedicalCondition("bruiseh", "painkillers", "Ecchymoses lourdes", {1,2,3,4,5,6,7}) -- analgésiques
PLUGIN:RegisterMedicalCondition("nosebreak", "painkillers", "Nez cassé", {1}) -- analgésiques

