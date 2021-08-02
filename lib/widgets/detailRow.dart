import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String? detailName;
  final String? detailContent;
  const DetailRow({Key? key, this.detailContent, this.detailName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '$detailName:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  detailContent!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15),
                ),
              )
            ],
          ),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.2),
                  Color(0xFFF2F7FB).withOpacity(0.2)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
