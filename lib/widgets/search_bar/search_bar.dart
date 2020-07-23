import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback searchFunction;
  final VoidCallback clearFunction;
  final TextEditingController searchController;
  final bool autoFocus;
  final FocusNode focusNode;

  const SearchBar({
    this.searchFunction,
    this.clearFunction,
    this.searchController,
    this.autoFocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(5),
      shadowColor: Colors.black,
      child: TextFormField(
        style: normalResponsiveFont(context),
        key: const Key("search form"),
        textInputAction: TextInputAction.search,
        onEditingComplete: searchFunction,
        focusNode: focusNode,
        controller: searchController,
        autofocus: autoFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(
            whenDevice(context, large: 20, tablet: 25),
          ),
          hintText: FlutterI18n.translate(context, "search.search_hint"),
          hintStyle: TextStyle(
            fontSize: whenDevice(context, large: 15, tablet: 25),
          ),
          border: InputBorder.none,
          prefixIcon: IconButton(
            key: const Key("search term"),
            icon: Icon(
              Icons.search,
            ),
            onPressed: searchFunction,
          ),
          alignLabelWithHint: true,
          suffixIcon: IconButton(
            key: const Key("search clear"),
            icon: Icon(Icons.clear),
            onPressed: () => {
              Future<dynamic>.delayed(
                Duration(
                  milliseconds: 50,
                ),
              ).then((dynamic _) {
                searchController.clear();
                focusNode.unfocus();
              }),
              clearFunction,
            },
          ),
        ),
      ),
    );
  }
}
