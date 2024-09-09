import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uy_ishi_calendar/frameworks_and_Drivers/screens/calendar_screen.dart';
import 'package:uy_ishi_calendar/entities/bloc/event_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kalendar Misoli',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CalendarScreen(),
      ),
    );
  }
}
