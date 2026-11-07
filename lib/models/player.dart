import 'package:flutter/foundation.dart';

/// A single player in a round.
/// [id] is the stable identity used for ALL game logic.
/// [name] is the display text shown in the UI.
@immutable
class Player {
  /// Monotonic counter — guarantees unique IDs within a session.
  static int _nextId = 0;

  /// Stable identity for this player. Never changes for a Player instance.
  final int id;

  /// Display name. Must be unique within a round (enforced in setup).
  final String name;

  Player({required this.name}) : id = _nextId++;

  /// Two players are equal only if they share the same stable [id].
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Player && other.id == id);

  @override
  int get hashCode => id;

  @override
  String toString() => 'Player(id: $id, name: $name)';
}