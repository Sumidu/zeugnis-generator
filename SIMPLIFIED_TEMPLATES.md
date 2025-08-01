# Simplified Template System Documentation

## Overview

The new template system uses a **Male_Female** format that is much simpler and more intuitive than the previous complex grammatical system. Templates now directly show what will be replaced, making them easy to read and edit.

## Template Format

### Basic Templates

- `{ANREDE}` → "Herr Max Mustermann" / "Frau Anna Schmidt"
- `{TITEL}` → "Herr" / "Frau"
- `{VORNAME}` → First name
- `{NACHNAME}` → Last name
- `{NAME}` → Full name without title

### Male_Female Templates

Format: `{Male_Female}` where:

- **Male** = Word used for masculine gender
- **Female** = Word used for feminine gender

Examples:

- `{Er_Sie}` → "Er" / "Sie"
- `{er_sie}` → "er" / "sie"
- `{sein_ihr}` → "sein" / "ihr"
- `{seines_ihres}` → "seines" / "ihres" (genitive)
- `{seinem_ihrem}` → "seinem" / "ihrem" (dative)
- `{seine_ihre}` → "seine" / "ihre"
- `{einen_eine}` → "einen" / "eine"
- `{guter_gute}` → "guter" / "gute"

## Advantages

1. **Human Readable**: You can see exactly what will be replaced
2. **Easy to Edit**: No need to understand complex German grammar rules
3. **Self-Documenting**: The template shows both options directly
4. **No Grammar Errors**: Users write the correct forms themselves
5. **Flexible**: Can handle any word pair, not just predefined cases

## Example Usage

### Before (Complex)

```
{POSSESSIVE_ACC_MN} Verhalten gegenüber Vorgesetzten war {adjective_agreement_complex}.
```

### After (Simple)

```
{Sein_Ihr} Verhalten gegenüber Vorgesetzten war {vorbildlich_vorbildlich}.
```

### Results

- **Male**: "Sein Verhalten gegenüber Vorgesetzten war vorbildlich."
- **Female**: "Ihr Verhalten gegenüber Vorgesetzten war vorbildlich."

## Common Patterns

### Pronouns

- `{Er_Sie}` / `{er_sie}` - Subject pronouns
- `{ihn_sie}` - Accusative object pronouns
- `{ihm_ihr}` - Dative object pronouns

### Possessives

- `{sein_ihr}` - Nominative possessive
- `{seines_ihres}` - Genitive possessive (Aufgrund seines/ihres...)
- `{seinem_ihrem}` - Dative possessive (mit seinem/ihrem...)
- `{seine_ihre}` - Accusative/Feminine possessive

### Articles & Adjectives

- `{ein_eine}` - Indefinite articles
- `{einen_eine}` - Accusative indefinite articles
- `{guter_gute}` - Adjective endings
- `{Mitarbeiter_Mitarbeiterin}` - Job titles

## Migration from Old System

Old complex templates have been converted:

- `{POSSESSIVE_ACC_MN}` → `{Sein_Ihr}` (for subjects)
- `{possessive_dat_mn}` → `{seinem_ihrem}` (readable dative)
- `{possessive_gen}` → `{seines_ihres}` (readable genitive)
- `{ER_SIE}` → `{Er_Sie}` (same but more consistent naming)

## How It Works

1. System finds all `{Word1_Word2}` patterns
2. Based on gender setting:
   - Male (m): Uses Word1
   - Female (w): Uses Word2
   - Diverse (d): Uses Word2 (default)
3. Replaces template with chosen word

## For End Users

You can now easily:

- **See** what will be replaced by reading the template
- **Edit** templates by changing the Male_Female pairs
- **Add** new templates using the `{Male_Female}` format
- **Fix** grammar by writing the correct forms directly

No more guessing about complex grammatical rules!
