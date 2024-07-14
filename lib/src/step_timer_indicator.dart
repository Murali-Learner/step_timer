import 'package:flutter/material.dart';
import 'package:step_timer/src/number_painter.dart';
import 'package:step_timer/src/painters/circle_painter.dart';
import 'package:step_timer/src/painters/step_painter.dart';
import 'package:step_timer/src/timer_controller.dart';
import 'package:step_timer/src/utils/constants.dart';

class StepTimerIndicator extends StatefulWidget {
  /// The width of the stroke used to draw the step lines.
  final double stepWidth;

  /// The color used to paint the completed steps.
  final Color progressColor;

  /// The total number of steps in the timer.
  final int stepCount;

  /// The space between the center and the edge of the step lines.
  final double space;

  /// The height of the StepTimerIndicator widget.
  final double height;

  /// The width of the StepTimerIndicator widget.
  final double width;

  /// The initial step to start from (must be between 0 and stepCount-1).
  final int initialStep;

  /// The duration (in seconds) for each step transition.
  final int stepLength;

  /// The color used to paint the incomplete steps.
  final Color inProgressColor;

  /// A callback function that is called after the StepTimerController is initialized.
  final Function(StepTimerController) onInitialization;

  /// The duration (in seconds) for the step change animation.
  final int stepChangeDurationInSeconds;

  /// A function that allows you to customize the widget displayed in the center of the timer based on the current step and elapsed time.
  final Widget Function(int currentStep, Duration elapsedTime)? widgetBuilder;

  /// A callback function that is called when the timer is paused.
  final Function(Duration)? onPause;

  /// A callback function that is called when the timer is resumed.
  final Function(Duration)? onResume;

  /// A callback function that is called when the timer is reset.
  final Function()? onReset;

  /// A callback function that is called when the timer starts.
  final Function()? onStart;

  /// The target duration of the timer.
  final Duration targetDuration;

  /// A callback function that is called when the timer finishes.
  final Function()? onFinish;

  /// A callback function that is called on every timer tick.
  final Function(Duration)? onTick;

  /// The color used to paint the triangle indicator at the current step.
  final Color indicatorColor;

  /// Show Step number above the step.
  final bool showStepNumbers;

  const StepTimerIndicator({
    super.key,
    required this.onInitialization,
    this.stepWidth = 2.0,
    this.progressColor = Colors.blue,
    this.stepCount = 60,
    this.space = 100,
    this.initialStep = 0,
    this.stepLength = 10,
    this.inProgressColor = Colors.grey,
    this.stepChangeDurationInSeconds = 1,
    this.widgetBuilder,
    this.onPause,
    this.onResume,
    this.height = 200.0,
    this.width = 200.0,
    this.onReset,
    this.onStart,
    this.targetDuration = const Duration(seconds: 60),
    this.onFinish,
    this.onTick,
    this.indicatorColor = Colors.green,
    this.showStepNumbers = false,
  })  : assert(stepWidth > 0, 'Stroke width must be greater than zero'),
        assert(stepCount > 0, 'Step count must be greater than zero'),
        assert(space > 0, 'Space must be greater than zero'),
        assert(initialStep >= 0 && initialStep < stepCount,
            'Initial step must be non-negative and less than step count'),
        assert(stepLength > 0, 'Step length must be greater than zero'),
        assert(stepChangeDurationInSeconds != 0,
            'Step change duration must not be zero'),
        assert(height > 0, 'Height must be greater than zero'),
        assert(width > 0, 'Width must be greater than zero'),
        assert(targetDuration > Duration.zero,
            'Target duration must be greater than zero');

  @override
  State<StepTimerIndicator> createState() => _StepTimerIndicatorState();
}

class _StepTimerIndicatorState extends State<StepTimerIndicator> {
  StepTimerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller = StepTimerController(
        stepCount: widget.stepCount,
        stepChangeDuration: Duration(
          seconds: widget.stepChangeDurationInSeconds,
        ),
        onPause: widget.onPause,
        onResume: widget.onResume,
        onReset: widget.onReset,
        onStart: widget.onStart,
        targetDuration: widget.targetDuration,
        onFinish: widget.onFinish,
        onTick: widget.onTick,
      );
      widget.onInitialization(_controller!);
      setState(() {}); // Trigger a rebuild to use the initialized controller
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Container();

    return ValueListenableBuilder<int>(
      valueListenable: _controller!.currentStep,
      builder: (context, currentStep, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              ChildWidget(widget: widget, controller: _controller),
              Center(
                child: Transform.rotate(
                  angle: -Constants.PI / 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(
                      widget.stepCount,
                      (stepIndex) {
                        double stepAngle =
                            stepIndex * 2 * Constants.PI / widget.stepCount;
                        bool isActive = currentStep >= stepIndex;
                        bool showIndicator = currentStep == stepIndex;
                        Offset p1 =
                            Offset.fromDirection(stepAngle, widget.space);
                        Offset p2 = Offset.fromDirection(
                            stepAngle, widget.space - widget.stepLength);

                        // Create TextPainter for the step index

                        return CustomPaint(
                          foregroundPainter: !widget.showStepNumbers
                              ? null
                              : NumberPainter(
                                  p1: p1,
                                  stepIndex: stepIndex,
                                  textPainter: TextPainter()
                                    ..textDirection = TextDirection.ltr
                                    ..text = TextSpan(
                                      text: stepIndex.toString(),
                                      style: TextStyle(
                                        color: isActive
                                            ? widget.progressColor
                                            : widget.inProgressColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                ),
                          painter: StepPainter(
                            p1: p1,
                            p2: p2,
                            stepPaint: Paint()
                              ..color = isActive
                                  ? widget.progressColor
                                  : widget.inProgressColor
                              ..strokeWidth = widget.stepWidth
                              ..style = PaintingStyle.stroke
                              ..strokeCap = StrokeCap.round,
                            isActive: showIndicator,
                          ),
                          child: showIndicator
                              ? CustomPaint(
                                  painter: CirclePainter(
                                    p1: p1,
                                    angle: stepAngle,
                                    indicatorColor: widget.indicatorColor,
                                  ),
                                  // painter: TrianglePainter(
                                  //   p1: p1,
                                  //   p2: p2,
                                  //   indicatorColor: widget.indicatorColor,
                                  // ),
                                )
                              : const IgnorePointer(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: Transform.rotate(
              //     angle: -Constants.PI / 2,
              //     child: Stack(
              //       alignment: Alignment.center,
              //       children: List.generate(
              //         widget.stepCount,
              //         (stepIndex) {
              //           double stepAngle =
              //               stepIndex * 2 * Constants.PI / widget.stepCount;
              //           bool isActive = currentStep >= stepIndex;
              //           bool showIndicator = currentStep == stepIndex;
              //           Offset p1 =
              //               Offset.fromDirection(stepAngle, widget.space);
              //           Offset p2 = Offset.fromDirection(
              //               stepAngle, widget.space - widget.stepLength);
              //           return CustomPaint(
              //             foregroundPainter: NumberPainter(
              //               p1: p1,
              //               stepIndex: stepIndex,
              //               showText: showIndicator,
              //               textPainter: TextPainter()
              //                 ..textDirection = TextDirection.ltr
              //                 ..text = TextSpan(
              //                   text: stepIndex.toString(),
              //                   style: const TextStyle(
              //                     color: Colors.amber,
              //                     fontSize: 15,
              //                   ),
              //                 ),
              //             ),
              //             painter: StepPainter(
              //               p1: p1,
              //               p2: p2,
              //               stepPaint: Paint()
              //                 ..color = isActive
              //                     ? widget.progressColor
              //                     : widget.inProgressColor
              //                 ..strokeWidth = widget.stepWidth
              //                 ..style = PaintingStyle.stroke
              //                 ..strokeCap = StrokeCap.round,
              //               isActive: showIndicator,
              //             ),
              //             child: showIndicator
              //                 ?
              //                 // CustomPaint(
              //                 //     painter: ArrowPainter(
              //                 //         p1: p1,
              //                 //         indicatorColor: widget.indicatorColor,
              //                 //
              //                 //
              //                 //         angle: stepAngle,
              //                 //         p2: p2),
              //                 //   )
              //                 // CustomPaint(
              //                 //     painter: CirclePainter(
              //                 //       p1: p1,
              //                 //       indicatorColor: widget.indicatorColor,
              //                 //       indicatorGap: widget.indicatorGap,
              //                 //       indicatorSize: widget.indicatorSize,
              //                 //       angle: stepAngle,
              //                 //     ),
              //                 //   )
              //                 CustomPaint(
              //                     painter: TrianglePainter(
              //                       p1: p1,
              //                       p2: p2,
              //                       indicatorColor: widget.indicatorColor,
              //
              //                     ),
              //                   )
              //                 // CustomPaint(
              //                 //     painter: ArrowPainter(
              //                 //       p1: p1,
              //                 //       p2: p2,
              //                 //       indicatorColor: widget.indicatorColor,
              //                 //       angle: stepAngle,
              //                 //     ),
              //                 //   )
              //                 : const IgnorePointer(),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({
    super.key,
    required this.widget,
    required StepTimerController? controller,
  }) : _controller = controller;

  final StepTimerIndicator widget;
  final StepTimerController? _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(
        builder: (context) {
          if (widget.widgetBuilder == null) {
            return const IgnorePointer();
          }

          return widget.widgetBuilder!(
            _controller!.currentStep.value,
            _controller!.elapsedTime.value,
          );
        },
      ),
    );
  }
}
