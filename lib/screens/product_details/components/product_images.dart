import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/screens/product_details/provider_models/ProductImageSwiper.dart';
import 'package:mm_seller_dashboard/screens/search_result/search_screen.dart';
//import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'dynamic_link_controller.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.product,
    @required this.controller,
  }) : super(key: key);

  final Product product;
  final DynamicLinkController controller;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductImageSwiper(),
      child: Consumer<ProductImageSwiper>(
        builder: (context, productImagesSwiper, child) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 520,
                    width: SizeConfig.screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 520,
                            width: SizeConfig.screenWidth,
                            child: GFCarousel(
                              items: widget.product.images.map(
                                (url) {
                                  return Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: CachedNetworkImage(
                                          imageUrl: url,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress)),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                },
                              ).toList(),

                              height: 500,
                              pagination: true,
                              viewportFraction: 1.0,
                              // aspectRatio: 0.5,
                              onPageChanged: (index) {
                                setState(() {
                                  index;
                                });
                              },
                            ),
                          ),

//                           SwipeDetector(
//                             onSwipeLeft: () {
//                               productImagesSwiper.currentImageIndex++;
//                               productImagesSwiper.currentImageIndex %=
//                                   product.images.length;
//                             },
//                             onSwipeRight: () {
//                               productImagesSwiper.currentImageIndex--;
//                               productImagesSwiper.currentImageIndex +=
//                                   product.images.length;
//                               productImagesSwiper.currentImageIndex %=
//                                   product.images.length;
//                             },
//                             child:
// //                PinchZoomImage(
// //                  image:
//                                 Container(
//                               // padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 // borderRadius: BorderRadius.all(
//                                 //   Radius.circular(10),
//                                 // ),
//                               ),
//                               child: ClipRRect(
//                                 // borderRadius: BorderRadius.circular(10),
//                                 child: Image.network(
//                                     product.images[
//                                         productImagesSwiper.currentImageIndex],
//                                     fit: BoxFit.fill),
//                               ),
//                             ),
//                           ),
                        ),
//              ),

                        // Container(
                        //   height: 300,
                        //   width: 100,
                        //   child: ListView.builder(
                        //     itemCount: product.images.length,
                        //     itemBuilder: (context, index) {
                        //       return buildSmallPreview(productImagesSwiper,
                        //           index: index);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Icon(
                                EvaIcons.arrowIosBack,
                                color: kPrimaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            var link = await widget.controller
                                .createDynamicLink(widget.product.id);
                            await widget.controller.share(
                                link.toString(),
                                widget.product.title,
                                widget.product.description);
                          },
                          child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  EvaIcons.share,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: SizeConfig.screenWidth,
              //   height: 15,
              //   child: Row(
              //     children: [
              //       Spacer(),
              //       ...List.generate(
              //         widget.product.images.length,
              //         (index) {
              //           return Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Container(
              //                 height: 5,
              //                 width: 5,
              //                 decoration: BoxDecoration(
              //                     color:
              //                         productImagesSwiper.currentImageIndex ==
              //                                 index
              //                             ? Colors.black
              //                             : Colors.grey,
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5)))),
              //           );
              //         },
              //       ),
              //       Spacer(),
              //     ], //Minor
              //   ),
              // )
            ],
          );
        },
      ),
    );
  }

  Widget buildSmallPreview(ProductImageSwiper productImagesSwiper,
      {@required int index}) {
    return GestureDetector(
      onTap: () {
        productImagesSwiper.currentImageIndex = index;
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(8)),
              // padding: EdgeInsets.all(getProportionateScreenHeight(8)),
              height: getProportionateScreenWidth(58),
              width: getProportionateScreenWidth(58),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: productImagesSwiper.currentImageIndex == index
                        ? kPrimaryColor
                        : Colors.transparent),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                    imageUrl: widget.product.images[index],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                            ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill),
              )),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
