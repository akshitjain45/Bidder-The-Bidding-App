import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({required this.pId});
  String pId;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedImage = 0;
  Product? product;
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    product = await ProductDBServices().getOneProduct(widget.pId);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ProductDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool isLiked() => (product!.likes).contains(context.watch<AppUser>().id);
  bool isLiked2() => (product!.likes).contains(context.read<AppUser>().id);
  likeUnlike() async {
    if (isLiked2()) {
      await ProductDBServices(uid: context.read<AppUser>().id)
          .removeFromFavorites(productId: widget.pId);
      setState(() {
        product!.likes.remove(context.read<AppUser>().id);
      });
    } else {
      await ProductDBServices(uid: context.read<AppUser>().id)
          .addToFavorites(product: product!);
      setState(() {
        product!.likes.add(context.read<AppUser>().id!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text("Product Detail"),
      ),
      body: product == null
          ? Center(
              child: CircularProgressIndicator(backgroundColor: kPrimaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(238),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Hero(
                            tag: widget.pId,
                            child:
                                Image.network(product!.images[selectedImage]),
                          ),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenWidth(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            product!.images.length,
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
                                child: Image.network(product!.images[index]),
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
                            product!.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20)),
                          child: Text(
                            product?.category ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          ),
                        ),
                        product!.subcategory != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenWidth(20)),
                                child: Text(
                                  product!.subcategory!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            color: isLiked()
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            icon: Icon(
                              isLiked()
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isLiked()
                                  ? Color(0xFFFF4848)
                                  : Color(0xFFDBDEE4),
                            ),
                            onPressed: likeUnlike,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20),
                            right: getProportionateScreenWidth(64),
                          ),
                          child: Text(
                            product!.description,
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
                ],
              ),
            ),
      bottomNavigationBar: product != null
          ? product?.userID != context.watch<AppUser>().id
              ? TopRoundedContainer(
                  color: Color(0xFFF6F7F9),
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DefaultButton(
                          width: SizeConfig.screenWidth / 3,
                          text: "Quick Buy \n ₹${product?.quickSellPrice ?? 0}",
                          press: () {
                            Navigator.pushNamed(context, Routes.checkout,
                                arguments: {
                                  "amount": product?.quickSellPrice,
                                  "product": product
                                });
                          },
                        ),
                        product?.isUpForBidding ?? false
                            ? DefaultButton(
                                width: SizeConfig.screenWidth / 3,
                                text: "Auction",
                                press: () => Navigator.pushNamed(
                                    context, Routes.bidding,
                                    arguments: product))
                            : Container(),
                      ],
                    ),
                  ),
                )
              : Container()
          : Container(),
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
