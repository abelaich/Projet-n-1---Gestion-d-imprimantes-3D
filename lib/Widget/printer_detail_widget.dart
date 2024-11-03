import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_n1/data/product.dart';
import 'package:provider/provider.dart';
import 'package:project_n1/presenter/stock_presenter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_n1/resources/app_colors.dart';

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


            // Dropdown for printer type
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                value: widget.product.title,
                isExpanded: true,
                dropdownColor: AppColors.secondaryColor, // Dropdown background color
                items: <String>['Powder printer', 'Wire printer', 'Resin printer']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Type : $value'), // Dropdown text color
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    stockPresenter.setProductType(widget.product, newValue);
                  }
                },
                underline: Container(
                  height: 0.6,
                  color: AppColors.primaryColor, // Underline color
                ),
              ),
            ),

            const SizedBox(height:20), // Space of 20 pixels

            // Identification Number
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                initialValue: '${widget.product.id}',
                decoration: const InputDecoration(
                  labelText: 'Identification Number',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Label color
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      // Error handling for invalid format
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid ID format")),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height:30), // Space of 30 pixels
            // Service Date
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Service Date',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor), // Border color when enabled
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor), // Border color when focused
                  ),
                ),
                controller: _dateController,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.product.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: AppColors.primaryColor, // Header color
                          hintColor: AppColors.secondaryColor, // Selected color
                          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor), // Color scheme for light mode
                          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary), // Button theme
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedDate != null) {
                    stockPresenter.setProductDate(widget.product, selectedDate);
                    _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ),


            // Schedule Maintenance Button
            Padding(
              padding: const EdgeInsets.only(top: 40), // Adjust padding to move it lower
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor, // Button text color
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Square corners
                    ),
                  ),
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
              ),
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
