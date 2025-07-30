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

## Kategorien hinzufügen

Neue Kategorien können durch .txt-Dateien im `data/` Ordner hinzugefügt werden:

```
1 - {ANREDE} zeigte hervorragende Leistungen...
2 - {ANREDE} arbeitete stets zuverlässig...
3 - {ANREDE} erfüllte die Aufgaben zufriedenstellend...
4 - {ANREDE} bemühte sich um ordnungsgemäße Arbeit...
5 - {ANREDE} erledigte die Aufgaben nach Anweisung...
```

## Template-Variablen

- `{ANREDE}`: Automatische Anrede (Herr/Frau + Name)
- `{VORNAME}`: Vorname
- `{NACHNAME}`: Nachname
- `{NAME}`: Vollständiger Name

## Lizenz

Dieses Projekt ist für den internen Gebrauch bestimmt.
