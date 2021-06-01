import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_status.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FlashCardBack extends StatefulWidget {
  final FlashcardModel flashCard;
  final String progress;
  final VoidCallback flip;

  const FlashCardBack({
    Key key,
    @required this.flashCard,
    @required this.progress,
    @required this.flip,
  }) : super(key: key);

  @override
  _FlashCardBackState createState() => _FlashCardBackState();
}

class _FlashCardBackState extends State<FlashCardBack>
    with TickerProviderStateMixin {
  String _anHtml = "";
  String _anHtmlDefinition = "";
  String _anHtmlExample = "";

  @override
  void initState() {
    super.initState();
    _anHtmlDefinition = widget.flashCard.definition;
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sub>", "&#8288<sub>");

    _anHtmlExample = widget.flashCard.example;
    _anHtmlExample = _anHtmlExample.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlExample = _anHtmlExample.replaceAll("<sub>", "&#8288<sub>");

    _anHtml = widget.flashCard.front;
    _anHtml = _anHtml.replaceAll("<sup>", "&#8288<sup>");
    _anHtml = _anHtml.replaceAll("<sub>", "&#8288<sub>");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: widget.flip,
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlashCardStatusWidget(
                status: widget.flashCard.status,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                            child: Html(
                              data: _anHtml,
                              defaultTextStyle:
                                  medstyles.Style.of(context)
                                      .font
                                      .bold
                                      .copyWith(
                                        fontSize: whenDevice(
                                          context,
                                          small: 18.0,
                                          large: 20.0,
                                          tablet: 40.0,
                                        ))
                                ),
                            ),
                        widget.flashCard.definitionImage == null ||
                                widget.flashCard.definitionImage.isEmpty
                            ? Container(
                                margin:
                                    EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                                child: Html(
                                  data: _anHtmlDefinition,
                                  defaultTextStyle:
                                      medstyles.Style.of(context)
                                          .font
                                          .normal
                                          .copyWith(
                                            fontSize: whenDevice(
                                              context,
                                              small: 15.0,
                                              large: 12.0,
                                              tablet: 25.0,
                                            ),
                                          ))
                                )
                            : ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxHeight: height * 0.15),
                                child: Image.network(
                                    widget.flashCard.definitionImage),
                              ),
                        const SizedBox(height: 15),
                        widget.flashCard.exampleImage == null ||
                                widget.flashCard.exampleImage.isEmpty
                            ? Container(
                                margin:
                                    EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                                child: Html(
                                  data: _anHtmlExample,
                                  defaultTextStyle:
                                    medstyles.Style.of(context)
                                          .font
                                          .normal
                                          .copyWith(
                                            fontSize: whenDevice(
                                              context,
                                              small: 15.0,
                                              large: 12.0,
                                              tablet: 25.0,
                                            ),
                                          ),
                                    )
                                )
                            : ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxHeight: height * 0.15),
                                child: Image.network(
                                    widget.flashCard.exampleImage),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
