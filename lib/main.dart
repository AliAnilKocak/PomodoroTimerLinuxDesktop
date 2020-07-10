import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:window_size/window_size.dart' as window_size;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'countdown_timer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.getWindowInfo().then((window) {
    if (window.screen != null) {
      final screenFrame = window.screen.visibleFrame;
      final width = math.max((screenFrame.width / 4).roundToDouble(), 800.0);
      final height = math.max((screenFrame.height / 12).roundToDouble(), 600.0);
      final left = ((screenFrame.width - width) / 4).roundToDouble();
      final top = ((screenFrame.height - height) / 12).roundToDouble();
      final frame = Rect.fromLTWH((screenFrame.height) / 1.8,
          (screenFrame.width) / 6, width, (screenFrame.height - height) / 2.0);
      window_size.setWindowFrame(frame);
      window_size.setWindowTitle(
          'Pomodoro Timer @Flutter ${Platform.operatingSystem}');
    }
  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool init = true;
  bool workTimeIsPlaying = false;
  bool breakTimeIsPlaying = false;
  String currentBreakTime = "05:00";
  String currentWorkTime = "25:00";
  bool currentUseWork = true;
  bool bayrak = true;

  int workTimeStamp = DateTime
      .now()
      .add(Duration(minutes: 25, seconds: 0))
      .millisecondsSinceEpoch;

  int breakTimeStamp = DateTime
      .now()
      .add(Duration(minutes: 5, seconds: 0))
      .millisecondsSinceEpoch;

  int currentMinuteForWork;
  int currentSecondForWork;
  int currentMinuteForBreak;
  int currentSecondForBreak;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCF8465), Color(0xFFAA6A7F)]),
          ),
          padding: const EdgeInsets.only(
              top: 24, bottom: 48, left: 48, right: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.ios_timer,
                    color: Colors.white.withOpacity(0.9),
                    size: 36,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Pomodoro Timer',
                    style: buildTextStyleOpenSans(),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !this.currentUseWork
                      ? Container()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !workTimeIsPlaying
                          ? Text(
                        this.currentWorkTime,
                        style: buildTextStyleTimes(),
                      )
                          : buildWorkCountDown(),
                      SizedBox(
                        height: 12,
                      ),
                      buildWorkActionButton(),
                      SizedBox(
                        height: 12,
                      ),
//                      buildWorkResetButton(),
//                      SizedBox(
//                        height: 16,
//                      ),
                      !workTimeIsPlaying
                          ? Container()
                          : FadeAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: ["Work Time"],
                          textStyle: buildTextStyleTimes()
                              .copyWith(fontSize: 32),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                      )
                    ],
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  this.currentUseWork
                      ? Container()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !breakTimeIsPlaying
                          ? Text(
                        this.currentBreakTime,
                        style: buildTextStyleTimes(),
                      )
                          : buildBreakCountDown(),
                      buildBreakActionButton(),
//                      SizedBox(
//                        height: 24,
//                      ),
//                      buildBreakResetButton(),
                      SizedBox(
                        height: 16,
                      ),
                      !breakTimeIsPlaying
                          ? Container()
                          : FadeAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: ["Break Time"],
                          textStyle: buildTextStyleTimes()
                              .copyWith(fontSize: 32),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  InkWell buildBreakResetButton() {
    return InkWell(
      onTap: () {
        setState(() {
          this.breakTimeStamp = 0;
          this.currentBreakTime = "00:00";
          this.init = true;
          this.currentUseWork = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          Ionicons.ios_refresh,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  InkWell buildWorkResetButton() {
    return InkWell(
      onTap: () {
        setState(() {
          this.currentWorkTime = "25:00";
          this.bayrak = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          Ionicons.ios_refresh,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  InkWell buildBreakActionButton() {
    return InkWell(
      onTap: () {
        setState(() {
          this.breakTimeIsPlaying = !this.breakTimeIsPlaying;
          this.currentUseWork = false;
        });
        int currentBreakTime =
        ((this.breakTimeStamp - DateTime
            .now()
            .millisecondsSinceEpoch) /
            1000)
            .floor();

        if (!this.breakTimeIsPlaying) {
          print("Durduruldu..");
          this.breakTimeStamp =
              ((this.breakTimeStamp - DateTime
                  .now()
                  .millisecondsSinceEpoch) /
                  1000)
                  .floor();
          this.currentMinuteForBreak = (currentBreakTime / 60).floor();
          this.currentSecondForBreak = currentBreakTime % 60;
          this.currentBreakTime =
              "${_getNumberAddZero(currentMinuteForBreak)}" +
                  ":" +
                  "${_getNumberAddZero(currentSecondForBreak)}";
        } else {
          print("Devam ettiriliyor..");
          setState(() {
            this.breakTimeStamp = DateTime
                .now()
                .add(Duration(
                minutes: this.currentMinuteForBreak,
                seconds: this.currentSecondForBreak))
                .millisecondsSinceEpoch;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          !this.breakTimeIsPlaying ? Ionicons.ios_play : Ionicons.ios_pause,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  InkWell buildWorkActionButton() {
    return InkWell(
      onTap: () {
        setState(() {
          this.bayrak = false;

          this.workTimeIsPlaying = !this.workTimeIsPlaying;
          this.breakTimeIsPlaying = false;

          this.currentUseWork = true;
        });

        if (init) {
          setState(() {
            this.init = false;
          });

          this.workTimeStamp = DateTime
              .now()
              .add(Duration(minutes: 25, seconds: 0))
              .millisecondsSinceEpoch;
        }

        if (!this.workTimeIsPlaying) {
          print("Durduruldu..");
          int currentWorkTime =
          ((this.workTimeStamp - DateTime
              .now()
              .millisecondsSinceEpoch) /
              1000)
              .floor();
          this.currentMinuteForWork = (currentWorkTime / 60).floor();
          this.currentSecondForWork = currentWorkTime % 60;
          setState(() {
            this.currentWorkTime =
                "${_getNumberAddZero(currentMinuteForWork)}" +
                    ":" +
                    "${_getNumberAddZero(currentSecondForWork)}";
          });
        } else {
          print("Devam ettiriliyor..");
          setState(() {
            this.workTimeStamp = DateTime
                .now()
                .add(Duration(
                minutes: this.currentMinuteForWork,
                seconds: this.currentSecondForWork))
                .millisecondsSinceEpoch;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          !this.workTimeIsPlaying ? Ionicons.ios_play : Ionicons.ios_pause,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  buildWorkCountDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: CountdownTimer(
        onEnd: () {
          setState(() {
            this.workTimeIsPlaying = false;
            this.breakTimeIsPlaying = true;
            this.breakTimeStamp = DateTime
                .now()
                .add(Duration(minutes: 5, seconds: 0))
                .millisecondsSinceEpoch;

            this.currentUseWork = false;
          });
        },
        endTime: workTimeStamp,
        defaultDays: "==",
        defaultMin: "**",
        defaultSec: "++",
        daysSymbol: "days",
        minSymbol: ":",
        secSymbol: "",
        minTextStyle: buildTextStyleTimes(),
        minSymbolTextStyle: buildTextStyleTimes(),
        secTextStyle: buildTextStyleTimes(),
      ),
    );
  }

  buildBreakCountDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: CountdownTimer(
        onEnd: () {
          setState(() {
            this.breakTimeStamp = 0;
            this.currentBreakTime = "00:00";
            this.init = true;
            this.currentUseWork = true;
          });
        },
        endTime: breakTimeStamp,
        defaultDays: "==",
        defaultMin: "**",
        defaultSec: "++",
        daysSymbol: "days",
        minSymbol: ":",
        secSymbol: "",
        minTextStyle: buildTextStyleTimes(),
        minSymbolTextStyle: buildTextStyleTimes(),
        secTextStyle: buildTextStyleTimes(),
      ),
    );
  }

  TextStyle buildTextStyleOpenSans() {
    return GoogleFonts.openSans(
        fontSize: 36, color: Colors.white.withOpacity(0.85));
  }

  void setWorkTime(int minute) {
    setState(() {
      this.workTimeStamp = DateTime
          .now()
          .add(Duration(days: 0, hours: 0, minutes: minute))
          .millisecondsSinceEpoch;
    });
  }

  void setBreakTime(int minute) {
    setState(() {
      this.breakTimeStamp = DateTime
          .now()
          .add(Duration(days: 0, hours: 0, minutes: minute))
          .millisecondsSinceEpoch;
    });
  }

  TextStyle buildTextStyleTimes() {
    return GoogleFonts.openSans(
        fontSize: 48, color: Colors.white.withOpacity(0.85));
  }

  String _getNumberAddZero(int number) {
    if (number == null) {
      return null;
    }
    if (number < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }
}
