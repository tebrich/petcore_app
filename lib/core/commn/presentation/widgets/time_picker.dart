import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// A customizable time picker widget that allows users to input hours and minutes
/// using text fields and an AM/PM selector.
///
/// This widget provides a more integrated UI experience compared to the standard
/// system time picker dialog. It's designed to be embedded directly within a form
/// or a page.
class CustomTimePicker extends StatefulWidget {
  /// The initial time to display when the widget is first built.
  /// Defaults to the current time if not provided.
  final TimeOfDay? initialTime;

  /// A callback function that is invoked whenever the selected time changes.
  final Function(TimeOfDay)? onTimeChanged;

  /// The text style for the hour and minute input fields.
  final TextStyle? textStyle;

  /// The background color of the container when [enableParent] is true.
  final Color? backgroundColor;

  /// The border color of the container when [enableParent] is true.
  final Color? borderColor;

  /// The border radius of the container when [enableParent] is true.
  final double? borderRadius;

  /// If true, wraps the time picker in a styled [Container].
  final bool enableParent;

  /// If true, the hour and minute input fields will expand to fill available space.
  final bool expandInput;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.enableParent = true,
    this.expandInput = false,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

/// The state for the [CustomTimePicker] widget.
///
/// Manages the text controllers for hours and minutes, the AM/PM period,
/// and handles the logic for updating the time.
class _CustomTimePickerState extends State<CustomTimePicker> {
  late TextEditingController _hourController;
  late TextEditingController _minuteController;

  /// The currently selected period, either 'AM' or 'PM'.
  late String _period;

  @override
  void initState() {
    super.initState();

    TimeOfDay initialTime = widget.initialTime ?? TimeOfDay.now();
    int hour12 = initialTime.hourOfPeriod == 0 ? 12 : initialTime.hourOfPeriod;

    _hourController = TextEditingController(
      text: hour12.toString().padLeft(2, '0'),
    );
    _minuteController = TextEditingController(
      text: initialTime.minute.toString().padLeft(2, '0'),
    );
    _period = initialTime.period == DayPeriod.am ? 'AM' : 'PM';

    // Add listeners to notify parent of changes
    _hourController.addListener(_onTimeChanged);
    _minuteController.addListener(_onTimeChanged);
  }

  /// Parses the current values from the text controllers and the period selector,
  /// converts them to a [TimeOfDay] object, and notifies the parent widget
  /// via the [onTimeChanged] callback.
  void _onTimeChanged() {
    if (_hourController.text.isNotEmpty && _minuteController.text.isNotEmpty) {
      int hour = int.tryParse(_hourController.text) ?? 12;
      int minute = int.tryParse(_minuteController.text) ?? 0;

      // Convert 12-hour format to 24-hour format
      if (_period == 'AM' && hour == 12) {
        hour = 0;
      } else if (_period == 'PM' && hour != 12) {
        hour += 12;
      }

      TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
      widget.onTimeChanged?.call(time);
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Conditionally wraps the picker in a styled container.
    return widget.enableParent
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppPalette.background(context),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              border: Border.all(
                color: widget.borderColor ?? Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: _buildTimePicker(),
          )
        : _buildTimePicker();
  }

  /// Builds a single text input field for either hours or minutes.
  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required int maxValue,
    required int minValue,
  }) {
    Widget textField = TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: label == 'HH'
          ? TextInputAction.next
          : TextInputAction.done,
      style:
          widget.textStyle ??
          const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        _TimeInputFormatter(maxValue: maxValue, minValue: minValue),
      ],
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          int? intValue = int.tryParse(value);
          if (intValue != null) {
            if (intValue < minValue) {
              controller.text = minValue.toString().padLeft(2, '0');
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            } else if (intValue > maxValue) {
              controller.text = maxValue.toString().padLeft(2, '0');
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          }
        }
      },
    );

    return widget.expandInput
        ? textField
        : SizedBox(width: 60, child: textField);
  }

  /// Builds the vertical AM/PM period selector.
  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPeriodButton('AM'),
          Container(height: 1, color: Colors.grey.shade300),
          _buildPeriodButton('PM'),
        ],
      ),
    );
  }

  /// Builds a single button ('AM' or 'PM') for the period selector.
  Widget _buildPeriodButton(String period) {
    bool isSelected = _period == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _period = period;
        });
        _onTimeChanged();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Assembles the complete time picker UI with hour, minute, and period controls.
  Widget _buildTimePicker() {
    return Row(
      mainAxisSize: widget.expandInput ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Hour field
        widget.expandInput
            ? Expanded(
                child: _buildTimeField(
                  controller: _hourController,
                  label: 'HH',
                  maxValue: 12,
                  minValue: 1,
                ),
              )
            : _buildTimeField(
                controller: _hourController,
                label: 'HH',
                maxValue: 12,
                minValue: 1,
              ),

        // Separator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            ':',
            style:
                widget.textStyle ??
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // Minute field
        widget.expandInput
            ? Expanded(
                child: _buildTimeField(
                  controller: _minuteController,
                  label: 'MM',
                  maxValue: 59,
                  minValue: 0,
                ),
              )
            : _buildTimeField(
                controller: _minuteController,
                label: 'MM',
                maxValue: 59,
                minValue: 0,
              ),

        const SizedBox(width: 16),

        // AM/PM selector
        _buildPeriodSelector(),
      ],
    );
  }
}

/// A [TextInputFormatter] that validates time input for hours (1-12) or
/// minutes (0-59).
/// It prevents users from entering values outside the specified [minValue] and [maxValue].
class _TimeInputFormatter extends TextInputFormatter {
  final int maxValue;
  final int minValue;

  _TimeInputFormatter({required this.maxValue, required this.minValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    // Allow typing if within bounds
    if (value <= maxValue && value >= minValue) {
      return newValue;
    }

    // If single digit and could be part of valid number, allow it
    if (newValue.text.length == 1 && value <= maxValue ~/ 10) {
      return newValue;
    }

    return oldValue;
  }
}
