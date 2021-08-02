import 'package:bidding_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BidTile extends StatelessWidget {
  final String bid;
  final bool byMe;
  final DateTime time;

  const BidTile(
      {required this.bid, required this.byMe, required this.time});
  @override
  Widget build(BuildContext context) {
    final bg = byMe ? Colors.grey[200] : kAccentColor;
    final dynamic radius = BorderRadius.only(
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomRight:
          byMe ? const Radius.circular(0) : const Radius.circular(8),
      bottomLeft:
          byMe ? const Radius.circular(8) : const Radius.circular(0),
    );
    const dynamic margin = EdgeInsets.only(bottom: 1.5);
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin:
          EdgeInsets.only(left: byMe ? 80 : 0, right: byMe ? 0 : 80),
      alignment: byMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: margin as EdgeInsetsGeometry,
        constraints: const BoxConstraints(minWidth: 80),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        decoration: BoxDecoration(
          borderRadius: radius as BorderRadiusGeometry,
          color: bg,
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                bid,
                textAlign: byMe ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: byMe ? Colors.black : Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Row(
                children: [
                  Text(
                    DateFormat.jm().format(time).toString(),
                    style: TextStyle(
                        fontSize: 9.0,
                        color: byMe ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}