# Question bank format

The version 1 bank is UTF-8 JSON with one root object and a `questions` array.
All displayed copy is a locale-to-text map using BCP 47 tags; include `es-ES`
for the initial release. Question and answer IDs are stable identifiers and
must not be reused for different content.

```json
{
  "schemaVersion": 1,
  "questions": [
    {
      "id": "music-1990-0001",
      "categoryId": "music",
      "decade": 1990,
      "prompt": { "es-ES": "¿Qué grupo publicó ...?" },
      "answers": [
        { "id": "a", "text": { "es-ES": "Opción A" }, "isCorrect": true },
        { "id": "b", "text": { "es-ES": "Opción B" }, "isCorrect": false },
        { "id": "c", "text": { "es-ES": "Opción C" }, "isCorrect": false },
        { "id": "d", "text": { "es-ES": "Opción D" }, "isCorrect": false }
      ],
      "explanation": { "es-ES": "La respuesta es ..." }
    }
  ]
}
```

Required question fields are `id`, `categoryId`, `decade`, `prompt`, `answers`,
and `explanation`. Answers require `id`, `text`, and boolean `isCorrect`.
Exactly four answers and exactly one correct answer are required. IDs must be
non-empty and question IDs unique across the bank. Text maps must contain at
least one non-empty locale and value.

The V0.1 category IDs are `television`, `music`, `cinema`,
`video_games_technology`, and `everyday_culture`. Supported decades are
`1980`, `1990`, and `2000`. Additions require an intentional update to the
validator and this catalogue.

The initial bank is stored at `assets/questions.json` and contains 500
questions: 125 television, 100 music, 100 cinema, 75 video games and
technology, and 100 everyday culture. Questions are spread across the three
supported decades, with a full-bank target of approximately 166 or 167 each.

Validate a bank with:

```powershell
dart run tool/validate_questions.dart assets/questions.json
```

The bank is generated reproducibly by `python tool/generate_question_bank.py`.
The Dart validator uses only the Dart SDK and returns detected issues with
their JSON paths.
