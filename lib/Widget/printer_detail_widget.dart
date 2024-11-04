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
    // Initialize the date controller with the product's date
    _dateController = TextEditingController(
      text: widget.product.date.toLocal().toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    // Dispose of the date controller
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

            // Dropdown for selecting type
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                value: widget.product.title,
                isExpanded: true,
                dropdownColor: AppColors.secondaryColor,  // Dropdown background color
                items: <String>['Powder printer', 'Wire printer', 'Resin printer']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Type : $value'),         //label
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

            // Text field for ID
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                initialValue: '${widget.product.id}',
                decoration: const InputDecoration(
                  labelText: 'Identification Number',
                  labelStyle: TextStyle(color: AppColors.primaryColor), // Label color
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits
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

            // Start Date text field
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                readOnly: true, // This field should not be editable with keyboard
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
                  // Show date picker when the field is tapped
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.product.date,
                    firstDate: DateTime(1830), //The very first mechanical printer was invented by Charles Babbage in the 19th century, around the 1830s
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: AppColors.primaryColor,
                          hintColor: AppColors.secondaryColor,
                          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor), // Light mode color scheme
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
                width: 200, // Set a fixed width for the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor, // Button text color
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Square corners for a bold look
                    ),
                  ),
                  onPressed: () async {
                    // Request calendar permission before scheduling
                    PermissionStatus status = await _requestCalendarPermission();

                    if (status.isGranted) {
                      Add2Calendar.addEvent2Cal(
                        buildEvent(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calendar permission denied')),
                      );
                    }
                  },
                  child: const Text('Schedule Maintenance'), // Button label
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
      // If denied, request AGAIN permission
      permission = await Permission.calendar.request();

      if (permission != PermissionStatus.granted) {
        // If denied, request AGAIN and AGAIN permission
        permission = await Permission.calendar.request();

        if (permission != PermissionStatus.granted) {
          // If denied, request AGAIN and AGAIN and AGAIN permission
          permission = await Permission.calendar.request();

          if (permission != PermissionStatus.granted) {
            // If denied, request AGAIN and AGAIN and AGAIN and AGAIN permission
            permission = await Permission.calendar.request();

            if (permission != PermissionStatus.granted) {
              // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
              permission = await Permission.calendar.request();

              if (permission != PermissionStatus.granted) {
                // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
                permission = await Permission.calendar.request();

                if (permission != PermissionStatus.granted) {
                  // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
                  permission = await Permission.calendar.request();

                  if (permission != PermissionStatus.granted) {
                    // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
                    permission = await Permission.calendar.request();

                    if (permission != PermissionStatus.granted) {
                      // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
                      permission = await Permission.calendar.request();

                      if (permission != PermissionStatus.granted) {
                        // If denied, request AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN permission
                        permission = await Permission.calendar.request();

                        if (permission != PermissionStatus.granted) {
                          return Future.error('Calendar permissions are denied after AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN and AGAIN attempts');
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    if (permission == PermissionStatus.permanentlyDenied) {
      return Future.error('Calendar permissions are permanently denied.');
    }

    return permission;
  }

  Event buildEvent({Recurrence? recurrence}) {
      DateTime nextMonday = _getNextMonday(); // Get the date of next Monday

      // Set the time to 8 AM next Monday
      DateTime startDateTime = DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 8, 0);

      String title = '${widget.product.title} #${widget.product.id}'; // Event title

      print(title);
      return Event(
        title: title,
        description: 'Revision',
        location: 'Université de Rouen Normandie',
        startDate: startDateTime,
        endDate: startDateTime.add(const Duration(minutes: 240)),
        allDay: false,
        recurrence: recurrence,
      );
    }



  DateTime _getNextMonday() {
    DateTime now = DateTime.now(); // Get current date
    int daysToAdd = (DateTime.monday - now.weekday + 7) % 7; // Calculate days until next Monday
    if (daysToAdd == 0) daysToAdd = 7; // If today is already Monday, move to next Monday
    return now.add(Duration(days: daysToAdd)); // Return the next Monday's date
  }
}
