import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/home/sections_widget.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/search_screen_template/search_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class VideosScreen extends StatefulWidget {
  final String source;

  const VideosScreen(this.source);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  RepositoryResult<List<Section>> _sectionsResult;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(AnalyticsConstants.screenVideo,
        widget.source);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchCategories(forceApiRequest: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchScreenTemplate(
      templateData: SearchScreenTemplateData(
        appBarTitle: FlutterI18n.translate(
          context,
          "more_screen.videos",
        ),
        content: _buildContent(context),
        loading: _loading,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildCategoriesSection(context),
        ],
      ),
    );
  }

  Padding _buildCategoriesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: whenDevice(context, large: 25, tablet: 40),
      ),
      child: _loading
          ? Center(
              child: ProgressBar(),
            )
          : SectionsWidget(
              sectionsResult: _sectionsResult,
              sectionTitle: FlutterI18n.translate(
                context,
                "videos_screen.pick_category",
              ),
              source: AnalyticsConstants.screenVideo,
            ),
    );
  }

  Future<void> _fetchCategories({bool forceApiRequest}) async {
    setState(() {
      _loading = true;
    });
    dynamic result = await SuperStateful.of(context)
        .updateSectionsList(forceApiRequest: forceApiRequest);
    setState(() {
      _loading = false;
      _sectionsResult = result;
    });
  }

  Future<void> _refresh() async {
    _fetchCategories(forceApiRequest: true);
    return null;
  }
}
