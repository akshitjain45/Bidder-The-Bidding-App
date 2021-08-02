import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final double width, aspectRetio;
  final Product product;
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1,
    required this.product,
  }) : super(key: key);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Product? product;
  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool isLiked() =>
      (product?.likes ?? []).contains(context.watch<AppUser>().id);
  bool isLiked2() =>
      (product?.likes ?? []).contains(context.read<AppUser>().id);
  likeUnlike() async {
    if (isLiked2()) {
      await ProductDBServices(uid: context.read<AppUser>().id)
          .removeFromFavorites(productId: product!.id!);
      setState(() {
        product!.likes.remove(context.read<AppUser>().id);
      });
    } else {
      await ProductDBServices(uid: context.read<AppUser>().id)
          .addToFavorites(product: widget.product);
      setState(() {
        product!.likes.add(context.read<AppUser>().id!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(widget.width),
      height: getProportionateScreenHeight(widget.width),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.productDetails,
          arguments: product!.id!,
        ),
        child: Card(
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product!.id.toString(),
                    child: Image.network(product!.images[0]),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Text(
                  product?.title ?? "",
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${product!.quickSellPrice}",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      IconButton(
                        color: isLiked()
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        icon: Icon(
                          isLiked() ? Icons.favorite : Icons.favorite_outline,
                          color:
                              isLiked() ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
                        ),
                        onPressed: likeUnlike,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
