import 'package:flutter/material.dart';
import 'package:step_timer/step_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final int stepCount = 30;
  double arrowSize = 20;
  StepTimerController? _controller;
  bool isRunning = false;
  bool isPause = false;

  @override
  void dispose() {
    _controller?.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step Timer Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomPaint(
            //   size: Size(
            //       arrowSize * 2, arrowSize), // Adjusted size based on arrowSize
            //   painter: ArrowPainter(arrowSize),
            // ),

            getStepTimer(),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRunning)
                  FloatingActionButton(
                    key: const ValueKey("Reset Button"),
                    onPressed: () {
                      _controller?.resetTimer();
                    },
                    tooltip: 'Reset',
                    child: const Icon(Icons.stop),
                  ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  tooltip: "Play Pause Button",
                  key: const ValueKey("Play Pause Button"),
                  onPressed: () {
                    _controller?.toggleTimer();
                  },
                  child: Icon(
                      (!isPause && isRunning) ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StepTimerIndicator getStepTimer() {
    return StepTimerIndicator(
      key: const Key("timer_page"),
      targetDuration: const Duration(seconds: 30),
      stepCount: stepCount,
      stepWidth: 4,
      progressColor: Colors.orange,
      showStepNumbers: false,
      indicatorColor: Colors.orange,
      inProgressColor: Colors.grey,
      onInitialization: (controller) {
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
            style: const TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
        );
      },
      onPause: (Duration timeValue) {
        debugPrint("OnPause triggered ${timeValue.inSeconds}");
        setState(() {
          isPause = true;
        });
      },
      onFinish: () {
        debugPrint("OnFinish triggered");
        isRunning = false;
        isPause = false;
        setState(() {});
      },
      onTick: (Duration timeValue) {
        debugPrint("OnTick triggered ${timeValue.inSeconds}");
      },
      onReset: () {
        debugPrint("OnReset triggered");
        isRunning = false;
        isPause = false;
        setState(() {});
      },
      onResume: (Duration timerValue) {
        debugPrint("OnResume triggered ${timerValue.inSeconds}");
        setState(() {
          isPause = false;
        });
      },
      onStart: () {
        debugPrint("OnStart triggered");
        setState(() {
          isRunning = true;
          isPause = false;
        });
      },
    );
  }
}
