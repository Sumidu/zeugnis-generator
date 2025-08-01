# German Grammar Debug App - Usage Instructions

## Purpose

This app helps you identify and fix German grammar issues in the Arbeitszeugnis template sentences. It shows you exactly which files contain problems and highlights the issues with suggestions.

## How to Run

```r
# In R console or RStudio:
shiny::runApp('grammar_debug_app.R', host='127.0.0.1', port=3838)
```

## Features

### 1. Grammar Issues Tab

- **Automatically detects** common German grammar problems
- **Shows filename** and line information for each issue
- **Provides suggestions** for fixes
- **Highlights problems** with colored backgrounds
- **Hover over sentences** to see filename tooltips

### 2. Template Tester Tab

- **Shows all sentences** with template replacements
- **Highlights template variables** in yellow
- **Highlights replaced text** in blue
- **File information** displayed for each sentence
- **Test different genders** to see how templates change

## Current Grammar Checks

1. **Verhalten + Possessive**: Detects `{POSSESSIVE_ACC_MN} Verhalten` (should be `{POSSESSIVE}`)
2. **Aufgrund + Genitive**: Detects `Aufgrund {possessive_dat_mn}` (should be `{possessive_gen}`)
3. **Subject Case**: Detects `{possessive_dat_mn} Bereich war` (should be `{POSSESSIVE}`)
4. **Vorgesetzten Context**: Flags potential case issues with "Vorgesetzten"
5. **Adjective Agreement**: Detects gender/case mismatches like `{possessive_acc_fn} guten`

## Workflow

1. **Start Grammar Analysis** - Click "Grammatik analysieren"
2. **Review Issues** - Each issue shows:
   - 📁 Filename and line number
   - Problem description
   - Suggested fix
   - Original sentence
   - How it looks with replacements
3. **Edit Files** - Open the data files and fix the issues manually
4. **Re-test** - Run analysis again to verify fixes

## Files to Edit

The app will show you exactly which files need fixes:

- `050_Bereitschaft.txt`
- `120_Fachkompetenz.txt`
- `400_Sozialverhalten.txt`
- etc.

## Tips

- **Hover over sentences** to see filename tooltips
- **Use both tabs** - Grammar Issues for problems, Template Tester for verification
- **Test both genders** (Männlich/Weiblich) to ensure templates work correctly
- **Check replacements** - The blue highlighted text shows what users will see

## German Cases Quick Reference

- **Nominativ** (who/what): der/die/das, ein/eine/ein
- **Akkusativ** (whom/what): den/die/das, einen/eine/ein
- **Dativ** (to/for whom): dem/der/dem, einem/einer/einem
- **Genitiv** (whose): des/der/des, eines/einer/eines

## Template Variables Available

- `{POSSESSIVE}` - Sein/Ihr (nominative)
- `{possessive_gen}` - seines/ihres (genitive) - **NEW!**
- `{possessive_dat_mn}` - seinem/ihrem (dative masc/neut)
- `{POSSESSIVE_ACC_MN}` - Seinen/Ihren (accusative masc/neut)
- And many more...
