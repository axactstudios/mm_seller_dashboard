import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/components/variants_section.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'expandable_text.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: buildProductRatingWidget(product.rating),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text.rich(
                  TextSpan(
                      text: widget.product.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: "\n${widget.product.variant} ",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ]),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          SizedBox(
            height: getProportionateScreenHeight(34),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: Text.rich(
                    TextSpan(
                      text: "\₹${widget.product.discountPrice} ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                      children: [
                        TextSpan(
                          text: "\₹${widget.product.originalPrice}",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: kTextColor.withOpacity(0.7),
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Container(
                      //   height: getProportionateScreenHeight(60),
                      //   child: SvgPicture.asset(
                      //     "assets/icons/Discount.svg",
                      //     color: Colors.orange[200],
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${widget.product.calculatePercentageDiscount()}% Off",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionateScreenHeight(11),
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.product.soldOut == true
              ? Text(
                  'This product is out of stock',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              : Container(),
          const SizedBox(height: 16),
          ExpandableText(
            maxLines: 2,
            title: "Highlights",
            content: widget.product.highlights,
          ),
          const SizedBox(height: 16),
          VariantsSection(
            title: "Variants",
            product: widget.product,
          ),
          const SizedBox(height: 16),

//            const SizedBox(height: 16),
//            ExpandableText(
//              title: "Description",
//              content: product.description,
//            ),
          // const SizedBox(height: 16),
          // Text.rich(
          //   TextSpan(
          //     text: "Sold by ",
          //     style: TextStyle(
          //       fontSize: 15,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     children: [
          //       TextSpan(
          //         text: "${product.seller}",
          //         style: TextStyle(
          //           decoration: TextDecoration.underline,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildProductRatingWidget(num rating) {
    return Container(
      width: getProportionateScreenWidth(80),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$rating",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(14),
              ),
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.star,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
