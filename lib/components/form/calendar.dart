
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';

class CalendarDay {
  final int day; // 날짜
  final int weekday; // 요일
  final DateTime? dateTime; // 날짜객체
  
  CalendarDay({
    required this.day,
    required this.weekday,
    this.dateTime,
  });
}

class QisCalendar extends StatefulWidget {
  const QisCalendar({
    super.key,
    required this.title,
    required this.initialDate,
    required this.controller,
    this.onTapOutside,
    this.onSelectedDate,
    this.onCancel,
  });

  final String title;
  final DateTime initialDate;
  final QisCalendarController controller;
  final VoidCallback? onTapOutside;
  final Function(DateTime date)? onSelectedDate;
  final VoidCallback? onCancel;

  @override
  State<QisCalendar> createState() => _QisCalendarState();
}

class _QisCalendarState extends State<QisCalendar>
 with SingleTickerProviderStateMixin {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late DateTime _selectedDate;

  List<CalendarDay> _calendarDays = [];
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _selectedDate = widget.initialDate.copyWith();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDays();
      _fadeController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;

    double calendarHeight = 408;
    double calendarWidth = 300;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          Container(     
            color: QisColors.barrier.color,
            child: GestureDetector(
              onTap: () {
                _fadeController.reverse().then((value) {
                  widget.onTapOutside?.call();
                });
              },
            ),
          ),
          Positioned(
            top: (mediaHeight - calendarHeight) / 2,
            left: (mediaWidth - calendarWidth) / 2,
            child: Container(
              width: calendarWidth,
              height: calendarHeight,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 18),
              decoration: BoxDecoration(
                color: QisColors.white.color,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: PretendardStyle.bold.textStyle.copyWith(
                      fontSize: 16,
                      color: QisColors.gray900.color
                    )
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgIconButton(
                              icon: SvgImageAsset.icoArrowLeft,
                              size: const Size(36, 28),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month - 1,
                                    1,
                                  );
                                  _setDays();
                                });
                              },
                            ),
                            Text(
                              DateFormat('common.dateFormatMonth'.tr()).format(_selectedDate),
                              style: PretendardStyle.bold.textStyle.copyWith(
                                fontSize: 16,
                                color: QisColors.gray900.color
                              )
                            ),
                            SvgIconButton(
                              icon: SvgImageAsset.icoArrowRight,
                              size: const Size(36, 28),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month + 1,
                                    1,
                                  );
                                  _setDays();
                                });
                              },
                            ),
                          ],
                        ),
                        ..._buildDays()
                      ]
                    )
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SimpleButton(
                        text: "common.cancel".tr(),
                        width: 125,
                        height: 44,
                        radius: 6,
                        backgroundColor: QisColors.gray400.color,
                        textStyle: PretendardStyle.bold.textStyle.copyWith(
                          fontSize: 14,
                          color: QisColors.white.color
                        ),
                        onPressed: () {
                          if(null != widget.onCancel) {
                            widget.onCancel!();
                          }

                          _fadeController.reverse().then((value) {
                            widget.onTapOutside?.call();
                          });
                        }
                      ),
                      SimpleButton(
                        text: "common.save".tr(),
                        width: 125,
                        height: 44,
                        radius: 6,
                        backgroundColor: QisColors.btnBlue.color,
                        textStyle: PretendardStyle.bold.textStyle.copyWith(
                          fontSize: 16,
                          color: QisColors.white.color
                        ),
                        onPressed: () {
                          if(null != widget.onSelectedDate) {
                            widget.onSelectedDate!(_selectedDate.copyWith());
                          }

                          _fadeController.reverse().then((value) {
                            widget.onTapOutside?.call();
                          });
                        }
                      )
                    ]
                  )
                ],
              )
            )
          )
        ]
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  void _setDays() {
    DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    int firstWeekday = firstDayOfMonth.weekday;
    int lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    
    List<CalendarDay> days = [];

    if(firstWeekday != 7) {
      for (int i = 0; i < firstWeekday; i++) {
        days.add(CalendarDay(
          day: 0,
          weekday: i,
          dateTime: null,
        ));
      }
    }

    for (int i = 1; i <= lastDayOfMonth; i++) {
      days.add(CalendarDay(
        day: i,
        weekday: (firstWeekday + i - 1) % 7,
        dateTime: DateTime(_selectedDate.year, _selectedDate.month, i),
      ));
    }

    setState(() {
      _calendarDays = days;
    });
  }

  //-------------------------------------
  // PRIVATE METHODS : BUILDER
  //-------------------------------------
  /// 일자를 표시하는 버튼을 생성하는 메서드
  List<Widget> _buildDays() {
    List<Widget> dayButtons = [];
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildWeekday()
    );

    dayButtons.add(row);
    
    for(int i = 0; i < _calendarDays.length; i++) {
      CalendarDay day = _calendarDays[i];
      Widget dayButton = _buildDayButton(day);

      if(i % 7 == 0) {
        row = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: []
        );
      }

      if(row.children.isNotEmpty) {
        row.children.add(const SizedBox(width: 15.32));
      }

      row.children.add(dayButton);

      if((i % 7 == 0)) {
        dayButtons.add(const SizedBox(height: 10.1));
        dayButtons.add(row);
      }
    }

    return dayButtons;
  }

  /// 요일 표시 영역 생성하는 메서드
  List<Widget> _buildWeekday() {
    Color dayColor = QisColors.gray700.color;
    List<Widget> weekdayList = [];
    String weekday = "";

    for(int i = 0; i < 7; i++) {
      switch(i) {
        case 0:
          dayColor = QisColors.weekBlue.color;
          weekday = "common.sunday".tr();
          break;
        case 1:
          dayColor = QisColors.gray700.color;
          weekday = "common.monday".tr();
          break;
        case 2:
          dayColor = QisColors.gray700.color;
          weekday = "common.tuesday".tr();
          break;
        case 3:
          dayColor = QisColors.gray700.color;
          weekday = "common.wednesday".tr();
          break;
        case 4:
          dayColor = QisColors.gray700.color;
          weekday = "common.thursday".tr();
          break;
        case 5:
          dayColor = QisColors.gray700.color;
          weekday = "common.friday".tr();
          break;
        case 6:
          dayColor = QisColors.gray700.color;
          weekday = "common.saturday".tr();
          break;
      }

      if(weekdayList.isNotEmpty) {
        weekdayList.add(const SizedBox(width: 15.32));
      }

      weekdayList.add(
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: Text(
            weekday,
            textAlign: TextAlign.center,
            style: PretendardStyle.regular.textStyle.copyWith(
              fontSize: 14,
              color: dayColor
            )
          )
        )
      );
    }

    return weekdayList;
  }

  Widget _buildDayButton(CalendarDay day) {
    if(null == day.dateTime) {
      return const SizedBox(width: 24, height: 24);
    }

    Color dayColor = QisColors.gray700.color;

    switch(day.dateTime!.weekday) {
      case 6:
        dayColor = QisColors.weekBlue.color;
        break;
      case 7:
        dayColor = QisColors.weekBlue.color;
        break;
      default:
        if(DateTime.now().year == day.dateTime!.year &&
          DateTime.now().month == day.dateTime!.month &&
          DateTime.now().day == day.dateTime!.day) {
          dayColor = QisColors.today.color;
        } else {
          dayColor = QisColors.gray700.color;
        }
        break;
    }

    return GestureDetector(
      onTap: () {
        widget.controller.selectDate(day.dateTime!);
        setState((){
          _selectedDate = day.dateTime!;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _selectedDate.day == day.day
            ? QisColors.btnBlue.color
            : CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          day.day.toString(),
          style: PretendardStyle.regular.textStyle.copyWith(
            fontSize: 14,
            color: _selectedDate.day == day.day
              ? QisColors.white.color
              : dayColor
          )
        ),
      ),
    );
  }
}

/// @description
/// @date 2023-10-12
/// @author 전종호
/// @details
/// - QisCalendar를 Overlay로 띄우기 위한 클래스
/// - QisOverlayCalendar.show() 메서드를 사용하여 달력을 모달창으로 띄울 수 있다.
class QisOverlayCalendar {
  static OverlayEntry? _overlayEntry;
  
  static void show(BuildContext context, {
    required String title,
    required DateTime initialDate,
    required QisCalendarController controller,
    Function(DateTime date)? onSelectedDate,
    Function()? onCancel,
  }) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return QisCalendar(
          title: title,
          initialDate: initialDate,
          controller: controller,
          onTapOutside: () {
            _overlayEntry?.remove();
          },
          onSelectedDate: onSelectedDate,
          onCancel: onCancel,
        );
      }
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}

class QisCalendarController extends ChangeNotifier {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  DateTime _selectedDate = DateTime.now();

  //-------------------------------------
  // PUBLIC METHOD
  //-------------------------------------
  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime date, {bool isInitial = false}) {
    _selectedDate = date;
    isInitial ? null : notifyListeners();
  }
}