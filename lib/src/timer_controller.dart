import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

class StepTimerController {
  StepTimerController({
    this.stepCount = 60,
    this.stepChangeDuration = const Duration(seconds: 60),
    this.onPause,
    this.onResume,
    this.onReset,
    this.onStart,
    this.targetDuration = const Duration(seconds: 60),
    this.onFinish,
    this.onTick,
  }) {
    _currentStep = ValueNotifier<int>(0);
    _isRunning = ValueNotifier<bool>(false);
    _elapsedTime = ValueNotifier<Duration>(const Duration(seconds: 0));
    _isFinished = ValueNotifier<bool>(false);
  }

  final Duration stepChangeDuration;
  final int stepCount;
  Timer? _timer;
  late final ValueNotifier<int> _currentStep;
  late final ValueNotifier<bool> _isRunning;
  late final ValueNotifier<Duration> _elapsedTime;
  late final ValueNotifier<bool> _isFinished;
  final Function(Duration)? onPause;
  final Function(Duration)? onResume;
  final Function()? onReset;
  final Function()? onStart;
  final Function()? onFinish;
  final Function(Duration)? onTick;
  int elapsedSeconds = 0;
  Duration targetDuration;

  ValueNotifier<bool> get isFinished => _isFinished;

  ValueNotifier<int> get currentStep => _currentStep;
  ValueNotifier<Duration> get elapsedTime => _elapsedTime;
  ValueNotifier<bool> get isRunning => _isRunning;

  double get progress => _currentStep.value / stepCount;

  void incrementStep() {
    if (targetDuration.inSeconds == elapsedSeconds) {
      stopTimer();
      _isFinished.value = true;
      if (onFinish != null) {
        onFinish!();
      }
      return;
    }
    _currentStep.value++;
    // print(_currentStep.value);
    if (_currentStep.value >= stepCount) {
      _currentStep.value = 0;
    }
    setElapsedTime();
    if (onTick != null) {
      onTick!(_elapsedTime.value);
    }
  }

  void startTimer() {
    if (_timer != null && _isRunning.value) return;

    _isRunning.value = true;
    if (_isFinished.value) {
      _currentStep.value = 0;
      _isFinished.value = false;
      elapsedSeconds = 0;
      _elapsedTime.value = Duration.zero;
    }
    _timer = Timer.periodic(stepChangeDuration, (timer) {
      // print("Timer is ticking: ${timer.tick}");
      incrementStep();
    });
    // log("Timer started $_timer ${_isRunning.value}");
    if (onStart != null) {
      onStart!();
    }
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isRunning.value = false;
    }
  }

  void resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _isRunning.value = false;
    _currentStep.value = 0;
    _elapsedTime.value = const Duration(seconds: 0);
    elapsedSeconds = 0;
    if (onReset != null) {
      onReset!();
    }
  }

  void toggleTimer() {
    if (_isRunning.value) {
      stopTimer();
      if (onPause != null) {
        onPause!(_elapsedTime.value);
      }
    } else {
      startTimer();
      if (onResume != null) {
        onResume!(_elapsedTime.value);
      }
    }
  }

  void setElapsedTime() {
    elapsedSeconds += stepChangeDuration.inSeconds;
    _elapsedTime.value = Duration(
      seconds: elapsedSeconds,
    );
  }

  Duration durationToSeconds(Duration? duration) {
    if (duration == null) return const Duration(seconds: 0);

    // Convert to seconds
    double seconds = duration.inMilliseconds / 1000.0;

    return Duration(seconds: seconds.floor());
  }

  void dispose() {
    _timer!.cancel();

    _currentStep.dispose();
    _isRunning.dispose();
  }
}
