import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:intl/intl.dart';

enum WeekStartFrom {
  sunday,
  monday,
}

class HorizontalWeekCalendar extends StatefulWidget {
  final WeekStartFrom? weekStartFrom;
  final Function(DateTime)? onDateChange;
  final Function(List<DateTime>)? onWeekChange;
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? disabledTextColor;
  final Color? activeNavigatorColor;
  final Color? inactiveNavigatorColor;
  final Color? monthColor;
  final BorderRadiusGeometry? borderRadius;
  final ScrollPhysics? scrollPhysics;
  final bool? showNavigationButtons;
  final String? monthFormat;
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime initialDate;
  final bool showTopNavbar;
  final HorizontalWeekCalendarController? controller;

  HorizontalWeekCalendar({
    super.key,
    this.onDateChange,
    this.onWeekChange,
    this.activeBackgroundColor,
    this.controller,
    this.inactiveBackgroundColor,
    this.disabledBackgroundColor = Colors.grey,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.white,
    this.disabledTextColor = Colors.white,
    this.activeNavigatorColor,
    this.inactiveNavigatorColor,
    this.monthColor,
    this.weekStartFrom = WeekStartFrom.monday,
    this.borderRadius,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.showNavigationButtons = true,
    this.monthFormat,
    required this.minDate,
    required this.maxDate,
    required this.initialDate,
    this.showTopNavbar = false,
  })  : assert(minDate.isBefore(maxDate)),
        assert(minDate.isBefore(initialDate) && (initialDate).isBefore(maxDate)),
        super();

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  late final CarouselSliderController carouselController;
  final int _initialPage = 1;

  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = <DateTime>[];
  int currentWeekIndex = 0;
  List<List<DateTime>> listOfWeeks = <List<DateTime>>[];

  @override
  void initState() {
    carouselController = CarouselSliderController();
    initCalendar();
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void initCalendar() {
    final date = widget.initialDate;
    selectedDate = widget.initialDate;

    DateTime startOfCurrentWeek = widget.weekStartFrom == WeekStartFrom.monday ? getDate(date.subtract(Duration(days: date.weekday - 1))) : getDate(date.subtract(Duration(days: date.weekday % 7)));

    currentWeek.add(startOfCurrentWeek);
    for (int index = 0; index < 6; index++) {
      DateTime addDate = startOfCurrentWeek.add(Duration(days: (index + 1)));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);
    _getMorePreviousWeeks();
    _getMoreNextWeeks();

    if (widget.controller != null) {
      widget.controller?._stateChangerPre.addListener(() => _onBackClick());
      widget.controller?._stateChangerNex.addListener(() => _onNextClick());
    }
  }

  void _getMorePreviousWeeks() {
    List<DateTime> minus7Days = [];
    DateTime startFrom = listOfWeeks[currentWeekIndex].first;

    bool canAdd = false;
    for (int index = 0; index < 7; index++) {
      DateTime minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
      if (minusDate.add(const Duration(days: 1)).isAfter(widget.minDate)) {
        canAdd = true;
      }
    }
    if (canAdd) {
      listOfWeeks.add(minus7Days.reversed.toList());
    }
    setState(() {});
  }

  void _getMoreNextWeeks() {
    List<DateTime> plus7Days = [];
    DateTime startFrom = listOfWeeks[currentWeekIndex].last;

    for (int index = 0; index < 7; index++) {
      DateTime addDate = startFrom.add(Duration(days: (index + 1)));
      plus7Days.add(addDate);
    }

    listOfWeeks.insert(0, plus7Days);
    currentWeekIndex = 1;
    setState(() {});
  }

  void _onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  void _onBackClick() {
    carouselController.nextPage();
  }

  void _onNextClick() {
    carouselController.previousPage();
  }

  void onWeekChange(int index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      _getMorePreviousWeeks();
    }

    if (index == 0) {
      _getMoreNextWeeks();
      carouselController.nextPage();
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  bool _isReachMinimum(DateTime dateTime) {
    return widget.minDate.add(const Duration(days: -1)).isBefore(dateTime);
  }

  bool _isReachMaximum(DateTime dateTime) {
    return widget.maxDate.add(const Duration(days: 1)).isAfter(dateTime);
  }

  bool _isNextDisabled() {
    DateTime lastDate = listOfWeeks[currentWeekIndex].last;
    String lastDateFormatted = DateFormat('yyyy/MM/dd').format(lastDate);
    String maxDateFormatted = DateFormat('yyyy/MM/dd').format(widget.maxDate);
    if (lastDateFormatted == maxDateFormatted) return true;

    bool isAfter = lastDate.isAfter(widget.maxDate);
    return isAfter;
  }

  bool isBackDisabled() {
    DateTime firstDate = listOfWeeks[currentWeekIndex].first;
    String firstDateFormatted = DateFormat('yyyy/MM/dd').format(firstDate);
    String minDateFormatted = DateFormat('yyyy/MM/dd').format(widget.minDate);
    if (firstDateFormatted == minDateFormatted) return true;

    bool isBefore = firstDate.isBefore(widget.minDate);
    return isBefore;
  }

  bool isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek.first) == DateFormat('yyyy').format(today);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              if (widget.showTopNavbar)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: isBackDisabled() ? null : () => _onBackClick(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 17,
                                  color: isBackDisabled() ? (widget.inactiveNavigatorColor ?? Colors.grey) : theme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Back",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isBackDisabled() ? (widget.inactiveNavigatorColor ?? Colors.grey) : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      widget.monthFormat?.isEmpty ?? true
                          ? (isCurrentYear() ? DateFormat('MMMM').format(currentWeek.first) : DateFormat('MMMM yyyy').format(currentWeek.first))
                          : DateFormat(widget.monthFormat).format(currentWeek.first),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.monthColor ?? theme.primaryColor,
                      ),
                    ),
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: _isNextDisabled() ? null : () => _onNextClick(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: _isNextDisabled() ? (widget.inactiveNavigatorColor ?? Colors.grey) : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 17,
                                  color: _isNextDisabled() ? (widget.inactiveNavigatorColor ?? Colors.grey) : theme.primaryColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              if (widget.showTopNavbar) const SizedBox(height: 12),
              CarouselSlider(
                controller: carouselController,
                items: [
                  if (listOfWeeks.isNotEmpty)
                    for (int ind = 0; ind < listOfWeeks.length; ind++)
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int weekIndex = 0; weekIndex < listOfWeeks[ind].length; weekIndex++)
                              Builder(builder: (_) {
                                DateTime currentDate = listOfWeeks[ind][weekIndex];
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: _isReachMaximum(currentDate) && _isReachMinimum(currentDate) ? () => _onDateSelect(listOfWeeks[ind][weekIndex]) : null,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3.0).copyWith(bottom: 10.0,top: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: widget.borderRadius,
                                        color: DateFormat('dd-MM-yyyy').format(currentDate) == DateFormat('dd-MM-yyyy').format(selectedDate)
                                            ? widget.activeBackgroundColor ?? theme.primaryColor
                                            : _isReachMaximum(currentDate) && _isReachMinimum(currentDate)
                                                ? widget.inactiveBackgroundColor ?? theme.primaryColor.withOpacity(.2)
                                                : widget.disabledBackgroundColor ?? Colors.grey,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat('EEE').format(listOfWeeks[ind][weekIndex]),
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: DateFormat('dd-MM-yyyy').format(currentDate) == DateFormat('dd-MM-yyyy').format(selectedDate)
                                                  ? widget.activeTextColor ?? Colors.white
                                                  : _isReachMaximum(currentDate) && _isReachMinimum(currentDate)
                                                      ? widget.inactiveTextColor ?? Colors.white.withOpacity(.2)
                                                      : widget.disabledTextColor ?? Colors.white,
                                            ),
                                          ),
                                          Container(
                                            height: 41,
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: widget.borderRadius,
                                              color: DateFormat('dd-MM-yyyy').format(currentDate) == DateFormat('dd-MM-yyyy').format(selectedDate)
                                                  ? const Color(0XFF318FFF)
                                                  : _isReachMaximum(currentDate) && _isReachMinimum(currentDate)
                                                      ? const Color(0XFFDDECFF)
                                                      : widget.disabledBackgroundColor ?? Colors.grey,
                                            ),
                                            child: Text(
                                              "${currentDate.day}",
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.titleLarge?.copyWith(
                                                color: DateFormat('dd-MM-yyyy').format(currentDate) == DateFormat('dd-MM-yyyy').format(selectedDate)
                                                    ? widget.activeTextColor ?? Colors.white
                                                    : _isReachMaximum(currentDate) && _isReachMinimum(currentDate)
                                                        ? widget.inactiveTextColor ?? Colors.white.withOpacity(.2)
                                                        : widget.disabledTextColor ?? Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                ],
                options: CarouselOptions(
                  initialPage: _initialPage,
                  scrollPhysics: widget.scrollPhysics ?? const ClampingScrollPhysics(),
                  height: 90,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: true,
                  onPageChanged: (index, reason) => onWeekChange(index),
                ),
              ),
            ],
          );
  }
}

class HorizontalWeekCalendarController {
  final ValueNotifier<int> _stateChangerPre = ValueNotifier<int>(0);
  final ValueNotifier<int> _stateChangerNex = ValueNotifier<int>(0);

  void jumpPre() {
    _stateChangerPre.value = _stateChangerPre.value + 1;
  }

  void jumpNext() {
    _stateChangerNex.value = _stateChangerNex.value + 1;
  }
}
