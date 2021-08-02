import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/screens/product/bidingComponents/allBids.dart';
import 'package:bidding_app/screens/product/bidingComponents/bidBottom.dart';
import 'package:bidding_app/screens/product/bidingComponents/bidTimer.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductBids extends StatefulWidget {
  final Product product;
  ProductBids({required this.product});
  @override
  _ProductBidsState createState() => _ProductBidsState();
}

class _ProductBidsState extends State<ProductBids> {
  final ScrollController _scrollController = ScrollController();
  bool timer = false;

  @override
  void initState() {
    DateTime? time = widget.product.biddingTime;
    if (time != null) {
      setState(() {
        timer = DateTime.now().isAfter(time) &&
            DateTime.now().isBefore(time.add(const Duration(days: 1)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.product.title),
        centerTitle: false,
        actions: timer
            ? <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7643).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      textBaseline: TextBaseline.ideographic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        const Icon(FontAwesomeIcons.stopwatch,
                            size: 15, color: kPrimaryColor),
                        const SizedBox(
                          width: 5,
                        ),
                        BidTimer(
                          product: widget.product,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: AllBids(
                productId: widget.product.id ?? "",
                scrollController: _scrollController,
              ),
            ),
          ),
          BidBottom(
            product: widget.product,
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}
