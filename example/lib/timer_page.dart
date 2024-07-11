import 'package:flutter/material.dart';
import 'package:step_timer/step_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final int stepCount = 60;

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
            getStepTimer(),
            const SizedBox(height: 20),
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
      targetDuration: const Duration(seconds: 60),
      stepCount: stepCount,
      stepWidth: 4,
      indicatorSize: 15,
      progressColor: Colors.orange,
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
        print("OnPause triggered ${timeValue.inSeconds}");
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
}
