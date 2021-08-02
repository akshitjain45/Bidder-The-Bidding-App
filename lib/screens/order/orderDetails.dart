import 'package:bidding_app/models/order.dart';
import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({required this.oId});
  String oId;
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text("Order Detail"),
      ),
      body: StrmBldr<Order>(
        stream: OrderDBServices(uid: context.watch<AppUser>().id)
            .getOneOrder(widget.oId)
            .asStream(),
        builder: (context, order) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(238),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Hero(
                          tag: widget.oId,
                          child: Image.network(order!.images[selectedImage]),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          order.images.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImage = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: defaultDuration,
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.all(8),
                              height: getProportionateScreenWidth(48),
                              width: getProportionateScreenWidth(48),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: kPrimaryColor.withOpacity(
                                        selectedImage == index ? 1 : 0)),
                              ),
                              child: Image.network(order.images[index]),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Text(
                          order.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Text(
                          order.category ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                      order.subcategory != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(20)),
                              child: Text(
                                order.subcategory ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20),
                          right: getProportionateScreenWidth(64),
                        ),
                        child: Text(
                          order.description,
                          maxLines: 3,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "See More Detail",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Resell",
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.newProduct,
                              arguments: Product(
                                userID: order.userID,
                                title: order.title,
                                description: order.description,
                                category: order.category,
                                subcategory: order.subcategory,
                                condition: order.condition,
                                quickSellPrice: order.price,
                                isUpForBidding: false,
                                isActive: false,
                                isVerified: false,
                                images: order.images,
                                likes: [],
                                publishedAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ),
                            );
                          },
                          icon: Icon(Icons.local_offer)
                        ),
                      ],
                    ))
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: order != null
      //     ? order?.userID != context.watch<AppUser>().id
      //         ? TopRoundedContainer(
      //             color: Color(0xFFF6F7F9),
      //             child: Padding(
      //               padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   DefaultButton(
      //                     width: SizeConfig.screenWidth / 3,
      //                     text:
      //                         "Quick Buy \n ₹${order?.quickSellPrice ?? 0}",
      //                     press: () async {
      //                       await OrderDBServices(
      //                               uid: context.read<AppUser>().id)
      //                           .makeOrder(
      //                               order: order!,
      //                               price: order!.quickSellPrice);
      //                     },
      //                   ),
      //                   order?.isUpForBidding ?? false
      //                       ? DefaultButton(
      //                           width: SizeConfig.screenWidth / 3,
      //                           text: "Auction",
      //                           press: () => Navigator.pushNamed(
      //                               context, Routes.bidding,
      //                               arguments: order))
      //                       : Container(),
      //                 ],
      //               ),
      //             ),
      //           )
      //         : Container()
      //     : Container(),
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}
