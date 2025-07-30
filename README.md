# Zeugnis Generator

Ein professioneller Shiny Dashboard zur Erstellung von deutschen Arbeitszeugnissen mit vollständiger Grammatikunterstützung.

## 🎯 Funktionen

- **Kategoriebasierte Bewertung**: 6 Bewertungskategorien (Arbeitsqualität, Fachkompetenz, Führungsverhalten, Leistungsbeurteilung, Pünktlichkeit, Sozialverhalten)
- **Deutsches Notensystem**: 5-stufiges System (1=Sehr gut bis 5=Mangelhaft)
- **Vollständige Grammatikunterstützung**: Korrekte deutsche Deklination für alle Geschlechter (m/w/d)
- **Erweiterte Template-Variablen**: Unterstützung für Nominativ, Akkusativ, Dativ
- **Personalisierung**: Automatische Anrede und Pronomen basierend auf Name und Geschlecht
- **Copy-to-Clipboard**: Einfaches Kopieren des generierten Textes

## 📋 Installation

1. R und RStudio installieren
2. Required packages installieren:
   ```r
   source("_install.r")
   ```
3. Das `here` Package wird für robuste Pfadauflösung verwendet

## 🚀 Nutzung

1. App starten:

   ```r
   shiny::runApp()
   ```

2. Persönliche Angaben eingeben (Vorname, Nachname, Geschlecht: m/w/d)
3. Gewünschte Kategorien aktivieren
4. Für jede Kategorie Note und Satz auswählen
5. "Zeugnis generieren" klicken
6. Text kopieren und in Word einfügen

## 📁 Dateistruktur

```
├── app.R                    # Hauptapplikation
├── R/
│   └── helpers.R           # Hilfsfunktionen & Template-System
├── data/                   # Kategoriedateien (.txt)
│   ├── Arbeitsqualität.txt
│   ├── Fachkompetenz.txt
│   ├── Führungsverhalten.txt
│   ├── Leistungsbeurteilung.txt
│   ├── Pünktlichkeit.txt
│   └── Sozialverhalten.txt
├── tests/                  # Test-Scripts
│   ├── README.md
│   ├── test_app.R
│   ├── test_data.R
│   ├── test_fachkompetenz.R
│   └── test_templates.R
├── www/                    # Statische Dateien
│   └── styles.css
├── TEMPLATE_REFERENCE.md   # Vollständige Template-Dokumentation
└── _install.r             # Package Installation
```

## 📋 Kategorien hinzufügen

Neue Kategorien können durch .txt-Dateien im `data/` Ordner hinzugefügt werden:

```plaintext
1 - {ANREDE} zeigte {POSSESSIVE_ACC_FN} hervorragende Leistungen...
2 - {ANREDE} arbeitete stets zuverlässig und {possessive_dat_mn} Bereich...
3 - {ANREDE} erfüllte die Aufgaben zufriedenstellend...
4 - {ANREDE} bemühte sich um ordnungsgemäße Arbeit...
5 - {ANREDE} erledigte die Aufgaben nach Anweisung...
```

## 🧪 Tests

Das Projekt enthält umfassende Tests im `tests/` Verzeichnis:

- **test_fachkompetenz.R**: Tests der deutschen Grammatik mit deklinierenden Possessivpronomen
- **test_templates.R**: Tests des Template-Systems für alle Geschlechter
- **test_data.R**: Verifikation der Datenstruktur
- **test_app.R**: Shiny App Debugging

Tests ausführen:

```bash
cd tests
Rscript test_fachkompetenz.R
```

## 📚 Template-Variablen

### Grundvariablen

- `{ANREDE}`: Automatische Anrede (Herr/Frau + Name oder nur Name für 'd')
- `{VORNAME}`: Vorname
- `{NACHNAME}`: Nachname
- `{PRONOUN}`: Personalpronomen (er/sie/sie)

### Possessivpronomen (Nominativ)

- `{SEIN_IHR}`: sein/ihr
- `{SEINE_IHRE}`: seine/ihre
- `{SEINEM_IHREM}`: seinem/ihrem
- `{SEINER_IHRER}`: seiner/ihrer

### Possessivpronomen (Akkusativ)

- `{POSSESSIVE_ACC_M}`: seinen/ihren (maskulin)
- `{POSSESSIVE_ACC_FN}`: Seine/Ihre (feminin/neutrum, kapitalisiert)

### Possessivpronomen (Dativ)

- `{POSSESSIVE_DAT_MN}`: seinem/ihrem (maskulin/neutrum)
- `{POSSESSIVE_DAT_F}`: Seiner/Ihrer (feminin, kapitalisiert)

Vollständige Dokumentation: `TEMPLATE_REFERENCE.md`

## 🔧 Technische Details

- **Shiny Dashboard**: Responsive Web-Interface
- **here Package**: Robuste Pfadauflösung für alle Betriebssysteme
- **German Grammar Engine**: Vollständige Unterstützung für deutsche Grammatikregeln
- **Reactive UI**: Dynamische Kategorieauswahl und Satzgenerierung

## 📄 Lizenz

Dieses Projekt ist für den internen Gebrauch bestimmt.
