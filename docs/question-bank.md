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

The V0.1 category IDs are `music`, `film_tv`, `sports`, `technology`,
`toys_games`, and `news_events`. Supported decades are `1980`, `1990`, and
`2000`. Additions require an intentional update to the validator and this
catalogue.

Validate a bank with:

```powershell
dart run tool/validate_questions.dart assets/questions.json
```

The bank file is not included until authored separately. The validator uses
only the Dart SDK and returns all detected issues with their JSON paths.
