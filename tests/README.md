# Tests Directory

This directory contains test scripts for the German Arbeitszeugnis Generator.

## Test Files

### `test_fachkompetenz.R`

Tests the comprehensive template system with declined possessive pronouns using the Fachkompetenz category.

**Usage:**

```r
cd tests
Rscript test_fachkompetenz.R
```

### `test_templates.R`

Tests the enhanced template system across all German genders and grammatical cases.

**Usage:**

```r
cd tests
Rscript test_templates.R
```

### `test_data.R`

Verifies data loading and structure integrity for all categories.

**Usage:**

```r
cd tests
Rscript test_data.R
```

### `test_app.R`

Simple Shiny test application for debugging UI components.

**Usage:**

```r
cd tests
Rscript test_app.R
```

## Running Tests

From the project root directory:

```bash
cd tests
Rscript test_fachkompetenz.R  # Test German grammar
Rscript test_data.R           # Test data loading
```

Or from the tests directory:

```bash
Rscript test_fachkompetenz.R
```

## Notes

- All test files use relative paths (`../R/helpers.R`, `../data/`) to access the main project files
- Tests verify German grammatical declensions for masculine, feminine, and diverse genders
- The template system supports Nominativ, Akkusativ, and Dativ cases for possessive pronouns
