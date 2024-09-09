import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventLocationController = TextEditingController();
  String _selectedColor = 'Red'; // Default color
  final _eventTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _eventDescriptionController,
              decoration: const InputDecoration(labelText: 'Event Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _eventLocationController,
              decoration: const InputDecoration(
                labelText: 'Event Location',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              items: ['Red', 'Green', 'Blue', 'Yellow']
                  .map((color) => DropdownMenuItem(
                        child: Text(color),
                        value: color,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Priority Color'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _eventTimeController,
              decoration: const InputDecoration(labelText: 'Event Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addEvent,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent() {
    // Implement event addition logic here
    // You can access the data from controllers
    print('Event Name: ${_eventNameController.text}');
    print('Event Description: ${_eventDescriptionController.text}');
    print('Event Location: ${_eventLocationController.text}');
    print('Priority Color: $_selectedColor');
    print('Event Time: ${_eventTimeController.text}');

    // Clear fields after adding
    _eventNameController.clear();
    _eventDescriptionController.clear();
    _eventLocationController.clear();
    _eventTimeController.clear();
  }
}
