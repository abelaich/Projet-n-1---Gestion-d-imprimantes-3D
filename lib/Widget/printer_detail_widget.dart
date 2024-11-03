import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:project_n1/data/product.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/presenter/stock_presenter.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterDetailWidget extends StatefulWidget {
  final Product product;

  const PrinterDetailWidget({super.key, required this.product});

  @override
  _PrinterDetailWidgetState createState() => _PrinterDetailWidgetState();
}

class _PrinterDetailWidgetState extends State<PrinterDetailWidget> {
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.product.date.toLocal().toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockPresenter = context.watch<StockPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product.title} #${widget.product.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Identification Number
            TextFormField(
              initialValue: '${widget.product.id}',
              decoration: const InputDecoration(labelText: 'Identification Number'),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                if (text.isNotEmpty) {
                  try {
                    final newId = int.parse(text);
                    stockPresenter.setProductId(widget.product, newId, (errorMessage) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    });
                  } on FormatException {
                    // Handle format error if needed
                  }
                }
              },
            ),

            // Dropdown for printer type
            DropdownButton<String>(
              value: widget.product.title,
              items: <String>['Powder printer', 'Wire printer', 'Resin printer']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  stockPresenter.setProductType(widget.product, newValue);
                }
              },
            ),

            // Service Date
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Service Date'),
              controller: _dateController,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.product.date,
                  firstDate: DateTime(2000),  // Changed to a more reasonable first date
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  stockPresenter.setProductDate(widget.product, selectedDate);
                  _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                }
              },
            ),

            // Schedule Maintenance Button
            ElevatedButton(
              onPressed: () async {
                // Request calendar permission
                PermissionStatus status = await _requestCalendarPermission();

                if (status.isGranted) {
                  scheduleMaintenance(context, widget.product);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calendar permission denied')),
                  );
                }
              },
              child: const Text('Schedule Maintenance'),
            ),
          ],
        ),
      ),
    );
  }

  Future<PermissionStatus> _requestCalendarPermission() async {
    PermissionStatus permission = await Permission.calendar.status;

    if (permission == PermissionStatus.denied) {
      permission = await Permission.calendar.request();
      if (permission != PermissionStatus.granted) {
        return Future.error('Calendar permissions are denied');
      }
    }

    if (permission == PermissionStatus.permanentlyDenied) {
      return Future.error('Calendar permissions are permanently denied.');
    }

    return permission;
  }

  void scheduleMaintenance(BuildContext context, Product product) {
    DateTime nextMonday = _getNextMonday();
    // Set the time to 8 AM next Monday
    DateTime startDateTime = DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 8, 0);
    DateTime endDateTime = startDateTime.add(const Duration(hours: 4)); // Set for four hour duration

    String title = '${product.title} #${product.id}';
    final event = Event(
      title: title,
      description: 'Revision',
      startDate: startDateTime,
      endDate: endDateTime,
      iosParams: const IOSParams(reminder: Duration(minutes: 40)),
      androidParams: const AndroidParams(emailInvites: []),
    );

    Add2Calendar.addEvent2Cal(event).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance scheduled successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $error')),
      );
    });
    print('Event Details: Title: $title, Start: $startDateTime, End: $endDateTime');
  }


  DateTime _getNextMonday() {
    DateTime now = DateTime.now();
    int daysToAdd = (DateTime.monday - now.weekday + 7) % 7;
    if (daysToAdd == 0) daysToAdd = 7; // If today is already Monday, go to next Monday
    return now.add(Duration(days: daysToAdd));
  }
}
