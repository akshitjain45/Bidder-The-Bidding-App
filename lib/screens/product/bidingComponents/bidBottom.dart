import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BidBottom extends StatefulWidget {
  final Product product;
  final ScrollController scrollController;

  const BidBottom(
      {Key? key, required this.product, required this.scrollController})
      : super(key: key);

  @override
  _BidBottomState createState() => _BidBottomState();
}

class _BidBottomState extends State<BidBottom> {
  final textController = TextEditingController();
  bool timer = false;

  Future<void> addBid(AppUser user) async {
    DateTime? time = widget.product.biddingTime;
    final String bid = textController.text;
    textController.clear();

    if (time != null) {
      if (DateTime.now().isAfter(time) &&
          DateTime.now().isBefore(time.add(const Duration(days: 1)))) {
        if (widget.product.minimumBid! < (num.tryParse(bid.trim()) ?? 0)) {
          bool confirm = false;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Confirm"),
                content: Text(
                    "You are going to bid ${bid.trim()} on ${widget.product.title}"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel Bid"),
                  ),
                  TextButton(
                    onPressed: () {
                      confirm = true;
                      Navigator.pop(context);
                    },
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          ).then((value) {
            if (confirm) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Place your Bid!"),
                    content: Text(
                        "Confirm your bid of ${bid.trim()} on ${widget.product.title}"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel Bid"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await OrderDBServices(uid: user.id)
                              .addNewBid(
                                pId: widget.product.id,
                                value: bid,
                              )
                              .onError(
                                (error, stackTrace) => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "Something went wrong, please try again!"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OKAY"),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                              .whenComplete(() => Navigator.pop(context));
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  );
                },
              );
            }
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Place a higher bid!"),
                content: Text(
                    "You need to place a bid higher than ${widget.product.minimumBid}"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OKAY"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Auction for this product is now over"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("OKAY"),
                ),
              ],
            );
          },
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey[300] ?? Colors.grey)
          ],
          color: Colors.white,
        ),
        // height: 60.0,
        child: timer
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 1,
                        onSubmitted: (value) => addBid(context.read<AppUser>()),
                        keyboardType: TextInputType.number,
                        controller: textController,
                        decoration: const InputDecoration(
                            hintText: "Your Bid",
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      iconSize: 25.0,
                      color: Theme.of(context).accentColor,
                      onPressed: () => addBid(context.read<AppUser>()),
                    ),
                  ],
                ),
              )
            : ListTile(
                leading: Text("Auction Starts on"),
                title: Text(DateFormat.yMMMMd('en_US')
                    .format(widget.product.biddingTime!)),
                subtitle:
                    Text(DateFormat.jm().format(widget.product.biddingTime!)),
              ),
      ),
    );
  }
}
