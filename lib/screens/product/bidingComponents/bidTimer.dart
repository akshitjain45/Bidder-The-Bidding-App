import 'dart:async';
import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidTimer extends StatefulWidget {
  final Product? product;
  const BidTimer({this.product}) : super();
  @override
  _BidTimerState createState() => _BidTimerState();
}

class _BidTimerState extends State<BidTimer> {
  bool timerWorks = false;
  late Duration timeLeft;
  Timer? timer;
  Future<void> init() async {
    debugPrint("TIMER STARTED${DateTime.now()}");
    final time = widget.product?.biddingTime;
    if (time == null) {
      return;
    } else {
      timeLeft = time.add(const Duration(days: 1)).difference(DateTime.now());
      if (timeLeft.isNegative) {
        timerWorks = false;
      }
      if (!timeLeft.isNegative) {
        timerWorks = true;
        timeLeft = timeLeft.abs();
        timer = Timer.periodic(const Duration(seconds: 1), (t) {
          timeLeft = timeLeft - const Duration(seconds: 1);
          if (timeLeft.isNegative) {
            timerWorks = false;
            try {
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Bidding Ended',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        content: Text(
                            "The bidding period for this product has ended!"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Dismiss"),
                          )
                        ]);
                  },
                );
                setState(() {});
              }
            } catch (e) {
              debugPrint(e.toString());
            }
            t.cancel();
          }
          if (mounted) {
            setState(() {});
          }
        });
        setState(() {});
      }
    }
  }

  String getDurationShort(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitHours = twoDigits(duration.inHours.remainder(60));
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Text(timerWorks ? getDurationShort(timeLeft) : '--:--');
  }
}
