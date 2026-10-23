# Progress Storage

The V0.1 progress store persists a complete `StoredProgress` snapshot as JSON
in a local file. The application composition layer supplies a file inside the
platform's application-support directory to `FileProgressStorage`; callers and
domain logic depend on the `ProgressStorage` interface instead of `dart:io`.
This keeps the store replaceable by an in-memory implementation and avoids a
path-provider or database dependency until the app needs one.

## Format version 1

The top-level JSON object contains:

- `formatVersion`: integer format version, currently `1`.
- `quizResults`: a list of `QuizResult` JSON values.
- `dailyProgress`: a list of `DailyProgress` JSON values.
- `statistics`: a `GameStatistics` JSON value.

The nested values use the existing `toJson` and `fromJson` contracts in
`lib/features/quiz/domain/models.dart`. A missing file loads as an empty
snapshot: no quiz results or daily progress, and zeroed game statistics.

Version 1 has no migration path from other versions. A version other than 1
raises `UnsupportedProgressFormatVersionException`; malformed JSON, missing or
invalid fields, and values that cannot construct the domain models raise
`MalformedProgressDataException`. File-system failures raise
`ProgressStorageIoException`. The storage boundary does not silently replace
corrupt or newer data with an empty state, so callers can surface or recover
from the error deliberately.

When the persisted shape changes, increment `currentFormatVersion` and add an
explicit migration for each older version that must remain readable. Keep the
domain model JSON contracts and storage envelope versioning conceptually
separate: `formatVersion` versions the progress file, not the question bank.
