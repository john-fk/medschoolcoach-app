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
  final bool isEnabled;

  const SearchBar({
    this.searchFunction,
    this.clearFunction,
    this.searchController,
    this.autoFocus = false,
    this.focusNode,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      shadowColor: Colors.black45,
      child: TextFormField(
        enabled: isEnabled,
        style: normalResponsiveFont(context),
        key: const Key("search form"),
        textInputAction: TextInputAction.search,
        onEditingComplete: searchFunction,
        focusNode: focusNode,
        controller: searchController,
        autofocus: autoFocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(
            whenDevice(context, large: 14, tablet: 18),
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
              if(searchController.text.isEmpty)
                Navigator.of(context).pop()
              else
              Future<dynamic>.delayed(
                Duration(
                  milliseconds: 50,
                ),
              ).then((dynamic _) {
                clearFunction();
                searchController.clear();
                focusNode.unfocus();
              }),
            },
          ),
        ),
      ),
    );
  }
}
