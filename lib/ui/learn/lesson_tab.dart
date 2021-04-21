import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/ui/section/section_screen.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/extensions/color/hex_color.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/search_bar/search_bar.dart';
import 'package:flutter/material.dart';

class LessonTab extends StatefulWidget {
  @override
  _LessonTabState createState() => _LessonTabState();
}

class _LessonTabState extends State<LessonTab> {
  bool isLoading = false;
  List<Section> sections;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchCategories(forceApiRequest: false));
  }

  Widget _loadingContent() {
    return Center(
      child: ProgressBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _loadingContent();
    }

    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              _buildSearchButton(),
              _buildLessonsList()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchCategories({
    bool forceApiRequest,
  }) async {
    setState(() {
      isLoading = true;
    });
    await SuperStateful.of(context).updateSectionsList(
      forceApiRequest: forceApiRequest,
    );
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildLessonsList() {
    sections = SuperStateful.of(context).sectionsList;

    return ListView.separated(
        padding: EdgeInsets.only(top: 16),
        separatorBuilder: (ctx, index) => SizedBox(
              height: 10,
            ),
        shrinkWrap: true,
        itemCount: sections.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          Section section =
              sections.where((element) => element.order == index).first;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  Routes.section,
                  arguments: SectionScreenData(
                      sectionId: section.id,
                      sectionName: section.name,
                      numberOfCourses: section.amountOfVideos,
                      source: AnalyticsConstants.lessonScreen
                  ),
                );
              },
              child: Card(
                color: HexColor.fromHex(section.setting.backgroundColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          section.name,
                          style: bigResponsiveFont(context,
                              fontColor: FontColor.Content2,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${section.amountOfVideos} lessons",
                          style: bigResponsiveFont(context,
                              fontColor: FontColor.Content2,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white.withOpacity(0.35)),
                        child: Text(
                          "${section.percentage}%",
                          style: bigResponsiveFont(context,
                              fontColor: FontColor.Content2,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildSearchButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.search);
      },
      child: Hero(
          tag: "search_bar",
          child: SearchBar(
            isEnabled: false,
          )),
    );
  }
}
