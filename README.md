# StepTimer Package

A customizable timer widget package for Flutter that allows you to create a step timer with various functionalities such as start, pause, resume, reset, and complete actions.

[![Watch the video](https://github.com/Murali-Learner/step_timer/assets/70834715/60473d95-2a09-4f4d-bd66-76ff5ef85da2)](https://github.com/Murali-Learner/step_timer/assets/70834715/60473d95-2a09-4f4d-bd66-76ff5ef85da2)

### Features

- Supports step-based timer functionality.
- Allows for customizable step duration.
- Provides callbacks for timer start, pause, resume, reset, tick, and completion.
- Customizable appearance through `widgetBuilder`.

### Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  step_timer: <latest-version> # Replace with the latest version
```

Run `flutter pub get` to install the package.

## Usage

Import the package:

```dart
import 'package:step_timer/step_timer.dart';
```

Use the `StepTimerIndicator` widget in your Flutter app, providing the necessary parameters:

```dart
StepTimerIndicator get _getStepTimer {
  return StepTimerIndicator(
    key: const Key("timer_page"),
    targetDuration: const Duration(seconds: 60),
    stepCount: 60,
    onInitialization: (controller) {
      // To get and set the TimerController
      setState(() {
        _controller = controller;
      });
    },
    stepChangeDurationInSeconds: 1,
    widgetBuilder: (int currentStep, Duration elapsedTime) {
      return Center(
        child: Text(
          elapsedTime.inSeconds.toString(),
          key: const ValueKey("timerValue"),
        ),
      );
    },
    onPause: (Duration timeValue) {
      print("Onpause triggered ${timeValue.inSeconds}");
      setState(() {
        isPause = true;
      });
    },
    onFinish: () {
      print("Onfinish triggered");
      isRunning = false;
      isPause = false;
      setState(() {});
    },
    onTick: (Duration timeValue) {
      print("Ontick triggered ${timeValue.inSeconds}");
    },
    onReset: () {
      print("Onreset triggered");
      isRunning = false;
      isPause = false;
      setState(() {});
    },
    onResume: (Duration timerValue) {
      print("Onresume triggered ${timerValue.inSeconds}");
      setState(() {
        isPause = false;
      });
    },
    onStart: () {
      print("Onstart triggered");
      setState(() {
        isRunning = true;
        isPause = false;
      });
    },
  );
}
```

## Parameters

- `onInitialization` (required): A callback function that provides the timer controller upon initialization.
- `targetDuration` (default 60 seconds): The total duration of the timer.
- `stepCount` (default 60): The number of steps in the timer.
- `stepWidth` (optional): Width of each step indicator.
- `progressColor` (optional): Color for completed steps.
- `space` (optional): Spacing between the center and step lines.
- `height` (optional): Height of the StepTimerIndicator widget.
- `width` (optional): Width of the StepTimerIndicator widget.
- `initialStep` (optional): Initial step to start from (0 to stepCount-1).
- `inProgressColor` (optional): Color for incomplete steps.
- `indicatorColor` (optional): Color for the triangle indicator at the current step.
- `indicatorGap` (optional): Gap between the step line and the triangle indicator.
- `indicatorSize` (required): Size of the triangle indicator.
- `stepChangeDurationInSeconds` (default 1 second): Duration of each step in seconds.
- `widgetBuilder` (optional): A function that builds the timer widget for each step.
- `onPause` (optional): A callback function that is triggered when the timer is paused.
- `onFinish` (optional): A callback function that is triggered when the timer completes.
- `onTick` (optional): A callback function that is triggered on each tick.
- `onReset` (optional): A callback function that is triggered when the timer is reset.
- `onResume` (optional): A callback function that is triggered when the timer is resumed.
- `onStart` (optional): A callback function that is triggered when the timer starts.
  Here is the provided content formatted in .mdx code format, including the callback function for initialization:

## License

This project is licensed under the [MIT License](LICENSE).

## Issues and Feedback

Please file issues or provide feedback on the [GitHub repository](https://github.com/Murali-Learner/step_timer).
