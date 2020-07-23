import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/milestones.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/global_progress/global_progress_widget.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final ApiServices _apiServices =
      Injector.appInstance.getDependency<ApiServices>();

  bool _loading = true;
  Badges _badges;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key("stats_scroll"),
      child: Column(
        children: <Widget>[
          GlobalProgressWidget(
            showHeader: false,
          ),
          SizedBox(
            height: 16,
          ),
          _loading ? ProgressBar() : _buildMilestones(context),
        ],
      ),
    );
  }

  Widget _buildMilestones(BuildContext context) {
    return _badges != null
        ? Column(
            children: <Widget>[
              _buildMilestoneExpansionTile(
                  context,
                  FlutterI18n.translate(
                    context,
                    "profile_screen.videos_milestones",
                  ),
                  _badges.videos,
                  SvgPicture.asset(
                    Style.of(context).svgAsset.videoMilestone,
                  ),
                  Style.of(context).colors.premium),
              _buildMilestoneExpansionTile(
                  context,
                  FlutterI18n.translate(
                    context,
                    "profile_screen.questions_milestones",
                  ),
                  _badges.questions,
                  SvgPicture.asset(
                    Style.of(context).svgAsset.questionMilestone,
                  ),
                  Style.of(context).colors.questions),
              _buildMilestoneExpansionTile(
                  context,
                  FlutterI18n.translate(
                    context,
                    "profile_screen.flashcards_milestones",
                  ),
                  _badges.flashcards,
                  SvgPicture.asset(
                    Style.of(context).svgAsset.flashcardMilestone,
                  ),
                  Style.of(context).colors.accent2),
            ],
          )
        : Container();
  }

  Container _buildMilestoneExpansionTile(
    BuildContext context,
    String title,
    List<String> badges,
    SvgPicture svgPicture,
    Color textColor,
  ) {
    return badges.isNotEmpty
        ? Container(
            color: Style.of(context).colors.inputBackground,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                accentColor: Style.of(context).colors.content,
                unselectedWidgetColor: Style.of(context).colors.content,
              ),
              child: CustomExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  title,
                  style: normalResponsiveFont(
                    context,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: <Widget>[
                  Container(
                    height: whenDevice(
                      context,
                      large: 120,
                      tablet: 150,
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: badges.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  svgPicture,
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      badges[index],
                                      style: normalResponsiveFont(
                                        context,
                                      ).copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Future<void> _fetchData() async {
    final result = await _apiServices.getMilestones();
    if (result is SuccessResponse<Milestones>) {
      _badges = result.body.badges;
    }

    setState(() {
      _loading = false;
    });
  }
}
