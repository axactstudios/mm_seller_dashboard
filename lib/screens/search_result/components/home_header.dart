
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mm_seller_dashboard/components/search_field.dart';


class HomeHeader extends StatelessWidget {
  final Function onSearchSubmitted;
  HomeHeader(
      {Key key,
      @required this.onSearchSubmitted,
})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                EvaIcons.arrowBack,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                onSubmit: onSearchSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
