import 'event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /*Pinned.fromPins(
            Pin(size: 186.1, start: -22.2),
            Pin(size: 239.0, end: 4.9),
            child: SvgPicture.string(
              _svg_dn9h5m,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),*/
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(190),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(2, 4),
                  )
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.yellow),
              todayDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),

            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Add Event"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay].add(
                        Event(title: _eventController.text),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                    }
                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  setState(() {});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}

const String _svg_dn9h5m =
    '<svg viewBox="-22.2 652.2 186.1 239.0" ><path transform="translate(-23.74, 650.69)" d="M 152.285888671875 222.1495056152344 C 161.833984375 213.6091918945313 169.5562438964844 203.0859832763672 175.45263671875 190.5929412841797 C 181.3359527587891 178.0868377685547 185.1185455322266 164.219482421875 186.7807922363281 148.9909362792969 C 188.4495849609375 133.7427520751953 187.6053924560547 118.1215515136719 184.2416229248047 102.127326965332 C 180.8778381347656 86.11346435546875 175.3741149902344 71.48045349121094 167.7173004150391 58.20209503173828 C 160.0670318603516 44.91066741943359 151.0228424072266 33.73302459716797 140.617431640625 24.6691951751709 C 130.1923828125 15.58572959899902 118.8969573974609 9.07417106628418 106.7180480957031 5.0952467918396 C 94.51296997070313 1.116323232650757 82.21625518798828 0.429173469543457 69.8017578125 3.033798217773438 C 57.361083984375 5.651511192321777 46.36668395996094 11.22724056243896 36.82512664794922 19.78061676025391 C 27.2639274597168 28.32745361328125 19.54167175292969 38.83102416992188 13.65836143493652 51.33714294433594 C 7.761963844299316 63.82363891601563 3.992457389831543 77.69751739501953 2.323666095733643 92.93915557861328 C 0.6614174842834473 108.1677093505859 1.505630254745483 123.7823638916016 4.869391441345215 139.7962188720703 C 8.226607322692871 155.7904510498047 13.73689270019531 170.4300079345703 21.38716125488281 183.7214508056641 C 29.04397583007813 196.9932403564453 38.0750846862793 208.1708831787109 48.50012588500977 217.2543640136719 C 58.91207504272461 226.3247375488281 70.20751190185547 232.849365234375 82.39950561523438 236.8283081054688 C 94.57842254638672 240.8137817382813 106.8882064819336 241.5009307861328 119.315803527832 238.8897552490234 C 131.7303009033203 236.2785949707031 142.7116088867188 230.7028350830078 152.285888671875 222.1495056152344 Z" fill="none" fill-opacity="0.3" stroke="#ffb347" stroke-width="3" stroke-opacity="0.3" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
