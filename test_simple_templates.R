# Test the new simplified Male_Female template system
source("R/helpers.R")

# Test the new template system
replacements_m <- generate_template_replacements("Max", "Mustermann", "m")
replacements_w <- generate_template_replacements("Anna", "Schmidt", "w")

cat("=== New Simplified Template System Test ===\n")

# Test sentences with the new Male_Female format
test_sentences <- c(
  "{Er_Sie} arbeitet sehr gut in der Firma.",
  "{ANREDE} ist {ein_eine} {guter_gute} Mitarbeiter{_in}.",
  "Aufgrund {seines_ihres} umfangreichen Fachwissens erzielte {er_sie} große Erfolge.",
  "{Sein_Ihr} Verhalten gegenüber Kollegen war {vorbildlich_vorbildlich}.",
  "{Er_Sie} zeigte {seinen_ihren} Einsatz und {seine_ihre} Kompetenz."
)

for (i in seq_along(test_sentences)) {
  original <- test_sentences[i]
  
  cat(sprintf("\n--- Test Sentence %d ---\n", i))
  cat(sprintf("Original:    %s\n", original))
  
  # Test with male
  replaced_m <- replace_templates(original, replacements_m, "m")
  cat(sprintf("Male (Max):  %s\n", replaced_m))
  
  # Test with female  
  replaced_w <- replace_templates(original, replacements_w, "w")
  cat(sprintf("Female (Anna): %s\n", replaced_w))
}

cat("\n=== Template Variables Available ===\n")
cat("Basic templates:\n")
for (name in names(replacements_m)) {
  cat(sprintf("  {%s} -> %s / %s\n", name, replacements_m[[name]], replacements_w[[name]]))
}

cat("\nMale_Female templates (examples):\n")
cat("  {Er_Sie} -> Er / Sie\n")
cat("  {er_sie} -> er / sie\n") 
cat("  {sein_ihr} -> sein / ihr\n")
cat("  {seines_ihres} -> seines / ihres\n")
cat("  {einen_eine} -> einen / eine\n")
cat("  {guter_gute} -> guter / gute\n")
cat("  {Mitarbeiter_Mitarbeiterin} -> Mitarbeiter / Mitarbeiterin\n")
