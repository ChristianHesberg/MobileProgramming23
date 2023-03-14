import 'dart:io';

/// "stack" for numbers entered and result of operations
typedef Registry = List<num>;

/// Function to undo a command
typedef UndoFunction = Registry Function(Registry);

/// Application state is a stack of numbers (registry) and stack of undo functions (history)
class CalcState {
  final Registry registry;
  final List<UndoFunction> history;
  const CalcState({required this.registry, required this.history});
  CalcState.empty() : this(registry: [], history: []);
  copy({required Registry registry, required UndoFunction undo}) =>
      CalcState(registry: registry, history: [...history, undo]);
}

/// Factory functions for commands
const commands = [
  Enter.new,
  Print.new,
  Exit.new,
  Clear.new,
  Add.new,
  Subtract.new,
  Multiply.new,
  Divide.new,
  Undo.new,
];

/// "interface" for all commands
abstract class Command {
  CalcState execute(CalcState state);
}

class Enter extends Command {
  final num? number;
  Enter(this.number);
  accept(registry) => number != null;
  execute(state) => state.copy(
        registry: [...state.registry, number!],
        undo: (registry) => [...registry.take(registry.length - 1)],
      );
}

class Clear extends Command {
  execute(state) => state.copy(registry: [], undo: (_) => state.registry);
}

class Print extends Command {
  execute(state) {
    print(state.registry);
    return state;
  }
}

class Exit extends Command {
  execute(state) => exit(1);
}

class Undo extends Command {
  execute(state) => CalcState(
        registry: state.history.last(state.registry),
        history: [...state.history.take(state.history.length - 1)],
      );
}

/// Base class for arithmetic operation consuming two operants from registry
abstract class Operator extends Command {
  apply(num val1, num val2);
  /// Throws RangeError if registry.length < 2
  execute(state) {
    final arg1 = state.registry.elementAt(state.registry.length - 2);
    final arg2 = state.registry.last;
    final result = apply(arg1, arg2);
    return state.copy(
      registry: [...state.registry.take(state.registry.length - 2), result],
      undo: (registry) => [...registry.take(registry.length - 1), arg1, arg2],
    );
  }
}

class Add extends Operator {
  apply(val1, val2) => val1 + val2;
}

class Subtract extends Operator {
  apply(val1, val2) => val1 - val2;
}

class Multiply extends Operator {
  apply(val1, val2) => val1 * val2;
}

class Divide extends Operator {
  apply(val1, val2) => val1 / val2;
}