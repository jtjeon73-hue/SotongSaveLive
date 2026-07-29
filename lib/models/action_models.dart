import 'enums.dart';

class ActionStep {
  const ActionStep({
    required this.id,
    required this.title,
    required this.instruction,
    this.priority = 0,
    this.isImmediate = false,
    this.status = ActionStatus.pending,
  });

  final String id;
  final String title;
  final String instruction;
  final int priority;
  final bool isImmediate;
  final ActionStatus status;

  ActionStep copyWith({ActionStatus? status}) {
    return ActionStep(
      id: id,
      title: title,
      instruction: instruction,
      priority: priority,
      isImmediate: isImmediate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instruction': instruction,
    'priority': priority,
    'isImmediate': isImmediate,
    'status': status.name,
  };

  factory ActionStep.fromJson(Map<String, dynamic> json) => ActionStep(
    id: json['id'] as String,
    title: json['title'] as String,
    instruction: json['instruction'] as String,
    priority: json['priority'] as int? ?? 0,
    isImmediate: json['isImmediate'] as bool? ?? false,
    status: ActionStatus.values.byName(json['status'] as String),
  );
}

class ProhibitedAction {
  const ProhibitedAction({
    required this.id,
    required this.label,
    required this.reason,
  });

  final String id;
  final String label;
  final String reason;

  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'reason': reason};

  factory ProhibitedAction.fromJson(Map<String, dynamic> json) =>
      ProhibitedAction(
        id: json['id'] as String,
        label: json['label'] as String,
        reason: json['reason'] as String,
      );
}
