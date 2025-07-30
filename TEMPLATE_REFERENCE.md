# Template-Variablen Referenz

Der Zeugnis Generator unterstützt ein umfassendes Template-System mit verschiedenen Variablen für geschlechtsgerechte Formulierungen.

## Grundlegende Angaben

| Variable     | Beschreibung        | Beispiel (m/w/d)                                     |
| ------------ | ------------------- | ---------------------------------------------------- |
| `{ANREDE}`   | Vollständige Anrede | Herr Max Mustermann / Frau Anna Schmidt / Alex Weber |
| `{TITEL}`    | Nur der Titel       | Herr / Frau / (leer)                                 |
| `{VORNAME}`  | Vorname             | Max / Anna / Alex                                    |
| `{NACHNAME}` | Nachname            | Mustermann / Schmidt / Weber                         |
| `{NAME}`     | Vollständiger Name  | Max Mustermann / Anna Schmidt / Alex Weber           |

## Pronomen - Nominativ (Wer?)

| Variable                    | Beschreibung    | Beispiel (m/w/d) |
| --------------------------- | --------------- | ---------------- |
| `{PRONOUN}` oder `{ER_SIE}` | Großschreibung  | Er / Sie / Sie   |
| `{pronoun}` oder `{er_sie}` | Kleinschreibung | er / sie / sie   |

## Pronomen - Akkusativ (Wen?)

| Variable                         | Beschreibung    | Beispiel (m/w/d) |
| -------------------------------- | --------------- | ---------------- |
| `{PRONOUN_ACC}` oder `{IHN_SIE}` | Großschreibung  | Ihn / Sie / Sie  |
| `{pronoun_acc}` oder `{ihn_sie}` | Kleinschreibung | ihn / sie / sie  |

## Pronomen - Dativ (Wem?)

| Variable                         | Beschreibung    | Beispiel (m/w/d)  |
| -------------------------------- | --------------- | ----------------- |
| `{PRONOUN_DAT}` oder `{IHM_IHR}` | Großschreibung  | Ihm / Ihr / Ihnen |
| `{pronoun_dat}` oder `{ihm_ihr}` | Kleinschreibung | ihm / ihr / ihnen |

## Possessivpronomen (Wessen?)

### Nominativ

| Variable                         | Beschreibung    | Beispiel (m/w/d) |
| -------------------------------- | --------------- | ---------------- |
| `{POSSESSIVE}` oder `{SEIN_IHR}` | Großschreibung  | Sein / Ihr / Ihr |
| `{possessive}` oder `{sein_ihr}` | Kleinschreibung | sein / ihr / ihr |

### Akkusativ

#### Maskulinum

| Variable                                   | Beschreibung    | Beispiel (m/w/d)       |
| ------------------------------------------ | --------------- | ---------------------- |
| `{POSSESSIVE_ACC_M}` oder `{SEINEN_IHREN}` | Großschreibung  | Seinen / Ihren / Ihren |
| `{possessive_acc_m}` oder `{seinen_ihren}` | Kleinschreibung | seinen / ihren / ihren |

#### Femininum & Neutrum

| Variable                                  | Beschreibung    | Beispiel (m/w/d)    |
| ----------------------------------------- | --------------- | ------------------- |
| `{POSSESSIVE_ACC_FN}` oder `{SEINE_IHRE}` | Großschreibung  | Seine / Ihre / Ihre |
| `{possessive_acc_fn}` oder `{seine_ihre}` | Kleinschreibung | seine / ihre / ihre |

### Dativ

#### Maskulinum & Neutrum

| Variable                                    | Beschreibung    | Beispiel (m/w/d)       |
| ------------------------------------------- | --------------- | ---------------------- |
| `{POSSESSIVE_DAT_MN}` oder `{SEINEM_IHREM}` | Großschreibung  | Seinem / Ihrem / Ihrem |
| `{possessive_dat_mn}` oder `{seinem_ihrem}` | Kleinschreibung | seinem / ihrem / ihrem |

#### Femininum

| Variable                                   | Beschreibung    | Beispiel (m/w/d)       |
| ------------------------------------------ | --------------- | ---------------------- |
| `{POSSESSIVE_DAT_F}` oder `{SEINER_IHRER}` | Großschreibung  | Seiner / Ihrer / Ihrer |
| `{possessive_dat_f}` oder `{seiner_ihrer}` | Kleinschreibung | seiner / ihrer / ihrer |

## Beispielsätze

### Beispiel 1 - Nominativ

```
{ANREDE} zeigte großes Engagement. {PRONOUN} übertraf stets unsere Erwartungen.
```

**Ausgabe:**

- Männlich: "Herr Max Mustermann zeigte großes Engagement. Er übertraf stets unsere Erwartungen."
- Weiblich: "Frau Anna Schmidt zeigte großes Engagement. Sie übertraf stets unsere Erwartungen."

### Beispiel 2 - Akkusativ

```
Wir schätzten {possessive_acc_m} Kollegen und {POSSESSIVE_ACC_FN} Zuverlässigkeit.
```

**Ausgabe:**

- Männlich: "Wir schätzten seinen Kollegen und Seine Zuverlässigkeit."
- Weiblich: "Wir schätzten ihren Kollegen und Ihre Zuverlässigkeit."

### Beispiel 3 - Dativ

```
Das Team arbeitete gerne mit {IHM_IHR} zusammen. {possessive_dat_f} Führung vertrauten alle.
```

**Ausgabe:**

- Männlich: "Das Team arbeitete gerne mit Ihm zusammen. seiner Führung vertrauten alle."
- Weiblich: "Das Team arbeitete gerne mit Ihr zusammen. ihrer Führung vertrauten alle."

### Beispiel 4 - Possessivpronomen mit verschiedenen Genera

```
{ANREDE} teilte {POSSESSIVE_ACC_FN} Erfahrung gerne mit {seinem_ihrem} Team.
```

**Ausgabe:**

- Männlich: "Herr Max Mustermann teilte Seine Erfahrung gerne mit seinem Team."
- Weiblich: "Frau Anna Schmidt teilte Ihre Erfahrung gerne mit ihrem Team."

## Diverse Geschlechtsangabe

Für die Geschlechtsangabe "divers" (d) wird standardmäßig die respektvolle Sie-Form verwendet:

- Pronomen: Sie/sie
- Dativ: Ihnen/ihnen
- Possessiv: Ihr/ihr
- Keine Titel-Anrede (nur Vor- und Nachname)

## Verwendung in Datendateien

Erstellen Sie `.txt` Dateien im `data/` Ordner mit folgendem Format:

```
1 - {ANREDE} zeigte außergewöhnliche Leistungen. {PRONOUN} übertraf stets die Erwartungen.
2 - Die Arbeitsleistung war gut. {possessive} Engagement war erkennbar.
3 - {TITEL} {NACHNAME} erfüllte die Aufgaben zufriedenstellend.
```

Das System ersetzt automatisch alle Template-Variablen basierend auf den eingegebenen persönlichen Daten.
