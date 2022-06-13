import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tasks_flutter/screens/more_page/view.dart';

class MorePage extends StatefulWidget {
  final task;

  const MorePage(this.task, {Key key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> implements MoreView{
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  void dispose() {
timerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color clr = Colors.grey;
    if (widget.task["color"] != null) {
      clr = Color(widget.task["color"]);
    }

    return Scaffold(
      backgroundColor: clr,
      appBar: AppBar(backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      body: _body(),
    );
  }

  Widget _body(){
    IconData icon;
    final iconObj = widget.task["icon"];
    if (iconObj != null) {
      icon = IconData(iconObj["codePoint"], fontFamily: iconObj["fontFamily"], fontPackage: iconObj["fontPackage"], matchTextDirection: iconObj["matchTextDirection"]);
    }

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon == null ? Container() : Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon, size: 25, color: Colors.white,)),
                Expanded(child: Text(widget.task["name"], style: TextStyle(fontSize: 20, color: Colors.white),))
              ],
            ),
            SizedBox(height: 250,),
            Text(
              "$hoursStr:$minutesStr:$secondsStr",
              style: TextStyle(
                fontSize: 60.0,color: Colors.white
              ),
            ),
        SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
    setState(() {
    hoursStr = ((newTick / (60 * 60)) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
    minutesStr = ((newTick / 60) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
    secondsStr =
    (newTick % 60).floor().toString().padLeft(2, '0');
    }); });
            },
                style: TextButton.styleFrom(primary: Colors.white,
                backgroundColor: Color(0xFFC0392B), padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_outlined),
                    SizedBox(width: 15,),
                    Text("Start", style: TextStyle(fontSize: 18),),
                  ],
                )),
            SizedBox(width: 10,),
            TextButton(
              onPressed: () {
                timerSubscription?.cancel();
                timerStream = null;
                setState(() {
                  hoursStr = '00';
                  minutesStr = '00';
                  secondsStr = '00';
                });
              },
              style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Color(0xFFC0392B), primary: Colors.white
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stop_outlined),
                  SizedBox(width: 15,),
                  Text(
                    'Stop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
          ],
        ),
      ),
    );
  }

}
