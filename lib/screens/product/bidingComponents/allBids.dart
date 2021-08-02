import 'package:bidding_app/models/bids.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:bidding_app/widgets/bidTile.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBids extends StatelessWidget {
  final String productId;
  final ScrollController scrollController;
  const AllBids({required this.productId, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StrmBldr<List<Bids>>(
      noDataWidget: const Center(
        child: Text("No bids yet"),
      ),
      stream: OrderDBServices().fetchAllBids(productId),
      builder: (context, value) {
        return Scrollbar(
          child: ListView(
            controller: scrollController,
            reverse: true,
            shrinkWrap: true,
            children: value
                    ?.map(
                      (bid) => BidTile(
                        bid: bid.value,
                        byMe: bid.user == context.watch<AppUser>().id,
                        time: bid.publishedAt,
                      ),
                    )
                    .toList() ??
                [],
          ),
        );
      },
    );
  }
}
