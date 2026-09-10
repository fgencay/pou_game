Source: https://pub.dev/packages/tetris_engine/versions/1.1.0
Archive SHA256: f7a86f85bb19815d4ce7e8891f98b5e396211d260c8cd94dc634bbfe70c18910

MIT license retained in LICENSE. Local SDK constraint lowered to Dart 3.9;
only lib, tests, and license vendored. Documentation screenshot asset omitted.
Development lint version aligned with the host app. Engine code is unchanged.

Corrected two upstream board test fixtures: horizontal I cells are offset one row below the anchor, so the anchor must be targetRow - 1. Production engine code remains unchanged.