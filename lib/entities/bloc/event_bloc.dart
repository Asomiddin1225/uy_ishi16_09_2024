import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_event.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_state.dart';
import 'package:uy_ishi_calendar/interface_adapters/data_base_helper.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  EventBloc() : super(EventInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await _dbHelper.getEventsForDate(event.date);
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError("Error loading events: ${e.toString()}"));
      }
    });

    on<AddEvent>((event, emit) async {
      try {
        await _dbHelper.insertEvent(event.event);
        // Reload events after adding
        add(LoadEvents(event.event['eventDate']));
      } catch (e) {
        emit(EventError("Error adding event: ${e.toString()}"));
      }
    });

    on<DeleteEvent>((event, emit) async {
      try {
        await _dbHelper.deleteEvent(event.id);
        // Reload events after deletion
        final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        add(LoadEvents(currentDate));
      } catch (e) {
        emit(EventError("Error deleting event: ${e.toString()}"));
      }
    });

    on<UpdateEvent>((event, emit) async {
      try {
        await _dbHelper.updateEvent(event.id, event.event);
        // Reload events after update
        add(LoadEvents(event.event['eventDate']));
      } catch (e) {
        emit(EventError("Error updating event: ${e.toString()}"));
      }
    });
  }
}
