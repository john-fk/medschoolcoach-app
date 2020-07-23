import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';

class SearchScreenTemplateData {
  final String appBarTitle;
  final String appBarSubTitle;
  final String topicId;
  final Widget content;
  final bool loading;

  SearchScreenTemplateData({
    this.appBarTitle,
    this.appBarSubTitle,
    this.topicId,
    this.content,
    this.loading = false,
  });
}

class SearchScreenTemplate extends StatefulWidget {
  final SearchScreenTemplateData templateData;

  const SearchScreenTemplate({
    Key key,
    this.templateData,
  }) : super(key: key);

  @override
  _SearchScreenTemplateState createState() => _SearchScreenTemplateState();
}

class _SearchScreenTemplateState extends State<SearchScreenTemplate> {
  final GlobalKey _heightKey = GlobalKey();
  int _appBarHeight = 0;

  final TextEditingController _searchController = TextEditingController();
  final _searchInputFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => {
        _getSizes(),
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                CustomAppBar(
                  title: widget.templateData.appBarTitle,
                  subTitle: widget.templateData.appBarSubTitle,
                  key: _heightKey,
                ),
                Expanded(
                  child: _getContent(),
                ),
              ],
            ),
            Positioned(
              top: (_appBarHeight -
                      whenDevice(
                        context,
                        large: 20,
                        tablet: 32,
                      ))
                  .toDouble(),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                width: MediaQuery.of(context).size.width - 40,
                child: SearchBar(
                  searchFunction: _search,
                  searchController: _searchController,
                  focusNode: _searchInputFocusNode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search() {
    Navigator.of(context).pushNamed(
      Routes.search,
      arguments: _searchController.text,
    );
  }

  Widget _getContent() {
    if (widget.templateData.loading) {
      return Center(
        child: ProgressBar(),
      );
    }

    return widget.templateData.content;
  }

  void _getSizes() {
    final RenderBox renderBoxRed = _heightKey.currentContext.findRenderObject();
    final titleSize = renderBoxRed.size;
    setState(() {
      _appBarHeight = titleSize.height.round();
    });
  }
}
