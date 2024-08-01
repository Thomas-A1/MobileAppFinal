import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/authentication/screens/BookingPage/successful_booking.dart';
import 'package:doconnect/data/repositories/doctors/doctor_repository.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:doconnect/utils/components/converted_booktimes.dart';
import 'package:doconnect/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart'; // Import if you use TableCalendar

// class BookingPage extends StatefulWidget {
//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   CalendarFormat _format = CalendarFormat.month;
//   DateTime _focusDay = DateTime.now();
//   DateTime _currentDay = DateTime.now();
//   int? _currentIndex;
//   bool _isWeekend = false;
//   bool _dateSelected = false;
//   bool _timeSelected = false;
//   String? token; // Token for inserting booking date and time into the database
//   String? doctorId; // Doctor ID for booking

//   Future<void> getToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('token') ?? '';
//   }

//   @override
//   void initState() {
//     super.initState();
//     getToken();

//     // Get arguments passed from the previous page
//     doctorId = Get.arguments?['doctor_id'] as String?;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: Text('Appointment'),
//         showBackArrow: true,
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverToBoxAdapter(
//             child: Column(
//               children: <Widget>[
//                 _tableCalendar(),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
//                   child: Center(
//                     child: Text(
//                       'Select Consultation Time',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _isWeekend
//               ? SliverToBoxAdapter(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Weekend is not available, please select another date',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 )
//               : SliverGrid(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return InkWell(
//                         splashColor: Colors.transparent,
//                         onTap: () {
//                           setState(() {
//                             _currentIndex = index;
//                             _timeSelected = true;
//                           });
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _currentIndex == index
//                                   ? Colors.white
//                                   : Colors.black,
//                             ),
//                             borderRadius: BorderRadius.circular(15),
//                             color: _currentIndex == index
//                                 ? Colors.greenAccent
//                                 : null,
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: _currentIndex == index ? Colors.white : null,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: 8,
//                   ),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4, childAspectRatio: 1.5),
//                 ),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
//               child: Button(
//                 width: double.infinity,
//                 title: 'Make Appointment',
//                 onPressed: () async {
//                   if (doctorId == null) {
//                     Get.snackbar('Error', 'Doctor ID is not available');
//                     return;
//                   }

//                   // Convert date/day/time into string first
//                   final getDate = DateConverted.getDate(_currentDay);
//                   final getDay = DateConverted.getDay(_currentDay.weekday);
//                   final getTime = DateConverted.getTime(_currentIndex!);

//                   final booking = await DioProvider().bookAppointment(
//                       getDate, getDay, getTime, doctorId!, token!);

//                   // If booking returns status code 200, then redirect to success booking page
//                   if (booking == 200) {
//                     Get.off(() => SuccessBookingPage());
//                   }
//                 },
//                 disable: _timeSelected && _dateSelected ? false : true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Table calendar
//   Widget _tableCalendar() {
//     return TableCalendar(
//       focusedDay: _focusDay,
//       firstDay: DateTime.now(),
//       lastDay: DateTime(2023, 12, 31),
//       calendarFormat: _format,
//       currentDay: _currentDay,
//       rowHeight: 48,
//       calendarStyle: const CalendarStyle(
//         todayDecoration:
//             BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
//       ),
//       availableCalendarFormats: const {
//         CalendarFormat.month: 'Month',
//       },
//       onFormatChanged: (format) {
//         setState(() {
//           _format = format;
//         });
//       },
//       onDaySelected: ((selectedDay, focusedDay) {
//         setState(() {
//           _currentDay = selectedDay;
//           _focusDay = focusedDay;
//           _dateSelected = true;

//           // Check if weekend is selected
//           if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
//             _isWeekend = true;
//             _timeSelected = false;
//             _currentIndex = null;
//           } else {
//             _isWeekend = false;
//           }
//         });
//       }),
//     );
//   }
// }



// class BookingPage extends StatefulWidget {
//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   CalendarFormat _format = CalendarFormat.month;
//   DateTime _focusDay = DateTime.now();
//   DateTime _currentDay = DateTime.now();
//   int? _currentIndex;
//   bool _isWeekend = false;
//   bool _dateSelected = false;
//   bool _timeSelected = false;
//   String? doctorId;
//   String? doctorName;

//   @override
//   void initState() {
//     super.initState();
//     print("BookingPage initState called");

//     // Initialize doctorId and doctorName from Get.arguments
//     final args = Get.arguments as Map<String, dynamic>?;
//     doctorId = args?['doctor_id'] as String?;
//     doctorName = args?['doctor_name'] as String?;

//     print("doctorId: $doctorId");
//     print("doctorName: $doctorName");

//     if (doctorId == null || doctorName == null) {
//       // If arguments are not available, show an error message and navigate back
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Get.snackbar('Error', 'Doctor ID or Name is not available');
//         Navigator.pop(context);
//       });
//     }
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _currentDay = selectedDay;
//       _focusDay = focusedDay;
//       _dateSelected = true;
//       _isWeekend = (selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday);
//       if (_isWeekend) {
//         _timeSelected = false;
//         _currentIndex = null;
//       }
//     });
//   }

//   void _onTimeSelected(int index) {
//     setState(() {
//       _currentIndex = index;
//       _timeSelected = true;
//     });
//   }

//   Future<void> _bookAppointment() async {
//     if (doctorId == null || doctorName == null) {
//       Get.snackbar('Error', 'Doctor ID or Name is not available');
//       return;
//     }

//     if (!_dateSelected || !_timeSelected) {
//       Get.snackbar('Error', 'Please select a date and time');
//       return;
//     }

//     final getDate = DateConverted.getDate(_currentDay);
//     final getDay = DateConverted.getDay(_currentDay.weekday);
//     final getTime = DateConverted.getTime(_currentIndex!);

//     try {
//       await bookAppointment(getDate, getDay, getTime, doctorId!, doctorName!);
//       Get.off(() => AppointmentBooked());
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   Future<void> bookAppointment(
//     String date, 
//     String day, 
//     String time, 
//     String doctorId, 
//     String doctorName
//   ) async {
//     try {
//       final userController = Get.find<UserController>();
//       final userId = userController.userId;

//       if (userId == null) {
//         throw 'User not authenticated';
//       }

//       // Save booking details for user
//       await UserRepository.instance.addAppointment(
//         doctorId, doctorName, date, day, time
//       );

//       // Save booking details for doctor
//       await DoctorRepository.instance.updateDoctorAppointment(
//         doctorId, doctorName, date, day, time, userId
//       );

//       // Show a success message
//       Get.snackbar('Success', 'Appointment booked successfully');

//       // Navigate to the success page
//       Get.off(() => AppointmentBooked());
//     } catch (e) {
//       // Handle errors
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   Widget _tableCalendar() {
//     return TableCalendar(
//       focusedDay: _focusDay,
//       firstDay: DateTime.now(),
//       lastDay: DateTime(2023, 12, 31),
//       calendarFormat: _format,
//       currentDay: _currentDay,
//       rowHeight: 48,
//       calendarStyle: const CalendarStyle(
//         todayDecoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
//       ),
//       availableCalendarFormats: const {
//         CalendarFormat.month: 'Month',
//       },
//       onFormatChanged: (format) {
//         setState(() {
//           _format = format;
//         });
//       },
//       onDaySelected: _onDaySelected,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (doctorId == null || doctorName == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Appointment'),
//         ),
//         body: Center(
//           child: Text('Doctor ID or Name is not available'),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Appointment'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverToBoxAdapter(
//             child: Column(
//               children: <Widget>[
//                 _tableCalendar(),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
//                   child: Center(
//                     child: Text(
//                       'Select Consultation Time',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _isWeekend
//               ? SliverToBoxAdapter(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
//                     alignment: Alignment.center,
//                     child: const Text(
//                       'Weekend is not available, please select another date',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 )
//               : SliverGrid(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return InkWell(
//                         splashColor: Colors.transparent,
//                         onTap: () => _onTimeSelected(index),
//                         child: Container(
//                           margin: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _currentIndex == index ? Colors.white : Colors.black,
//                             ),
//                             borderRadius: BorderRadius.circular(15),
//                             color: _currentIndex == index ? Colors.greenAccent : null,
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: _currentIndex == index ? Colors.white : null,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: 8,
//                   ),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4, childAspectRatio: 1.5),
//                 ),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: _bookAppointment,
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     'Make Appointment with $doctorName',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? doctorId;
  String? doctorName;

  @override
  void initState() {
    super.initState();
    print("BookingPage initState called");

    // Initialize doctorId and doctorName from Get.arguments
    final args = Get.arguments as Map<String, dynamic>?;
    doctorId = args?['doctor_id'] as String?;
    doctorName = args?['doctor_name'] as String?;

    print("doctorId: $doctorId");
    print("doctorName: $doctorName");

    if (doctorId == null || doctorName == null) {
      // If arguments are not available, show an error message and navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Doctor ID or Name is not available');
        Navigator.pop(context);
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _currentDay = selectedDay;
      _focusDay = focusedDay;
      _dateSelected = true;
      _isWeekend = (selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday);
      if (_isWeekend) {
        _timeSelected = false;
        _currentIndex = null;
      }
    });
  }

  void _onTimeSelected(int index) {
    setState(() {
      _currentIndex = index;
      _timeSelected = true;
    });
  }

  Future<void> _bookAppointment() async {
    if (doctorId == null || doctorName == null) {
      Get.snackbar('Error', 'Doctor ID or Name is not available');
      return;
    }

    if (!_dateSelected || !_timeSelected) {
      Get.snackbar('Error', 'Please select a date and time');
      return;
    }

    final getDate = DateConverted.getDate(_currentDay);
    final getDay = DateConverted.getDay(_currentDay.weekday);
    final getTime = DateConverted.getTime(_currentIndex!);

    try {
      await bookAppointment(getDate, getDay, getTime, doctorId!, doctorName!);
      Get.off(() => AppointmentBooked());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> bookAppointment(
    String date, 
    String day, 
    String time, 
    String doctorId, 
    String doctorName
  ) async {
    try {
      final userController = Get.find<UserController>();
      final userId = userController.userId;

      if (userId == null) {
        throw 'User not authenticated';
      }

      // Save booking details for user
      await UserRepository.instance.addAppointment(
        doctorId, doctorName, date, day, time
      );

      // Save booking details for doctor
      await DoctorRepository.instance.updateDoctorAppointment(
        doctorId, doctorName, date, day, time, userId
      );

      // Show a success message
      Get.snackbar('Success', 'Appointment booked successfully');

      // Navigate to the success page
      Get.off(() => AppointmentBooked());
    } catch (e) {
      // Handle errors
      Get.snackbar('Error', e.toString());
    }
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: _onDaySelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      'Weekend is not available, please select another date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => _onTimeSelected(index),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index ? Colors.white : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index ? Colors.greenAccent : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5),
                ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Book Appointment with Dr. $doctorName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
