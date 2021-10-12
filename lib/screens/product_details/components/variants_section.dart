
import 'package:flutter/material.dart';
import 'package:mm_seller_dashboard/models/Product.dart';
import 'package:mm_seller_dashboard/models/Variant.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../product_details_screen.dart';

class VariantsSection extends StatefulWidget {
  final String title;
  final Product product;

  const VariantsSection({
    Key key,
    @required this.title,
    @required this.product,
  }) : super(key: key);

  @override
  _VariantsSectionState createState() => _VariantsSectionState();
}

class _VariantsSectionState extends State<VariantsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Divider(
          height: 8,
          thickness: 1,
          endIndent: 16,
        ),
        createFiltersSection(widget.product)
      ],
    );
  }

  bool checkVariantPresence(String property, String option, String id) {
    if (!(variantsSelected[id] == null)) {
      if (property == 'Color') if (variantsSelected[id].color == option)
        return true;
      else
        return false;
      else if (variantsSelected[id].size == option)
        return true;
      else
        return false;
    } else
      return false;
  }

  Widget createFiltersSection(Product product) {
    List<Widget> filters = [];
    product.filterValues.forEach((key, value) {
      final split = value.split(',');
      if (key == 'Color' || key == 'Size')
        filters.add(Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5, 5, 5),
                child: Text(
                  key,
                  style: categoryBlockHeadingStyle,
                ),
              ),
              Container(
                  height: 40,
                  width: SizeConfig.screenWidth,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: split.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () {
                              if (key == 'Color') {
                                if (variantsSelected[product.id] == null)
                                  variantsSelected[product.id] =
                                      Variant(product.id, color: split[index]);
                                else {
                                  variantsSelected[product.id].color =
                                      split[index];
                                }
                                setState(() {});
                              }
                              if (key == 'Size') {
                                if (variantsSelected[product.id] == null)
                                  variantsSelected[product.id] =
                                      Variant(product.id, size: split[index]);
                                else {
                                  variantsSelected[product.id].size =
                                      split[index];
                                }
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: checkVariantPresence(
                                          key, split[index], product.id)
                                      ? kPrimaryColor
                                      : Colors.grey.withOpacity(0.5),
                                  // border: Border.all(
                                  //     width: 2,
                                  //     color: checkVariantPresence(
                                  //             key, split[index], product.id)
                                  //         ? Colors.black
                                  //         : Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
                                child: Center(
                                  child: Text(
                                    split[index],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: checkVariantPresence(
                                                key, split[index], product.id)
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ));
    });
    return Column(
      children: filters,
    );
  }
}
