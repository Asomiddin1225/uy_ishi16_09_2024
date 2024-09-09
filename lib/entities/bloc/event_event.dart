abstract class EventEvent {}

class LoadEvents extends EventEvent {
  final String date;
  LoadEvents(this.date);
}

class AddEvent extends EventEvent {
  final Map<String, dynamic> event;
  AddEvent(this.event);
}

class DeleteEvent extends EventEvent {
  final int id;
  DeleteEvent(this.id);
}

class UpdateEvent extends EventEvent {
  final int id;
  final Map<String, dynamic> event;
  UpdateEvent(this.id, this.event);
}
