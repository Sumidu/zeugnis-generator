# Zeugnis Generator

Ein Shiny Dashboard zur Erstellung von deutschen Arbeitszeugnissen.

## Funktionen

- **Kategoriebasierte Bewertung**: Verschiedene Kategorien wie Sozialverhalten, Pünktlichkeit, Arbeitsqualität
- **Notensystem**: 5-stufiges deutsches Notensystem (1=Sehr gut bis 5=Mangelhaft)
- **Personalisierung**: Automatische Anrede basierend auf Name und Geschlecht
- **Template-System**: Flexible Satzvorlagen mit Platzhaltern
- **Copy-to-Clipboard**: Einfaches Kopieren des generierten Textes

## Installation

1. R und RStudio installieren
2. Required packages installieren:
   ```r
   source("_install.r")
   ```

## Nutzung

1. App starten:

   ```r
   shiny::runApp()
   ```

2. Persönliche Angaben eingeben (Name, Geschlecht)
3. Gewünschte Kategorien aktivieren
4. Für jede Kategorie Note und Satz auswählen
5. "Zeugnis generieren" klicken
6. Text kopieren und in Word einfügen

## Dateistruktur

```
├── app.R                 # Hauptapplikation
├── R/
│   └── helpers.R         # Hilfsfunktionen
├── data/                 # Kategoriedateien (.txt)
│   ├── Sozialverhalten.txt
│   ├── Pünktlichkeit.txt
│   └── Arbeitsqualität.txt
├── www/                  # Statische Dateien
│   └── styles.css
└── _install.r           # Package Installation
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
