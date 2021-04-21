import 'dart:math';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PracticeProgressCard extends StatefulWidget {
  final ProgressCardData cardData;

  PracticeProgressCard({
    this.cardData
  });

  @override
  _PracticeProgressCardState createState() =>
      _PracticeProgressCardState();
}

class _PracticeProgressCardState extends State<PracticeProgressCard>
    with SingleTickerProviderStateMixin {
  bool playAnimation = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.45 && !playAnimation) {
          setState(() {
            playAnimation = true;
          });
        }
      },
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.cardData.graphData
                    .map((data) => _practiceListTile(
                        data.color, data.label, "${data.percent}%"))
                    .toList()),
          ),
          Flexible(
              flex: 3,
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: progressViewGraph()),
              ))
        ],
      ),
    );
  }

  Widget _practiceListTile(Color leadingColor, String title, String subtitle) {
    return Table(
      columnWidths: {1: FractionColumnWidth(0.85)},
      // border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          // padding: const EdgeInsets.only(left:15.0,right: 5),
          CircleAvatar(
            backgroundColor: leadingColor == Colors.transparent
                ? Style.of(context).colors.background3
                : leadingColor,
            radius: 5,
          ),
          Text(
            title,
            style: normalResponsiveFont(context, opacity: 0.6),
          )
        ]),
        TableRow(children: [
          Container(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              subtitle,
              style: normalResponsiveFont(context, fontWeight: FontWeight.w600),
            ),
          )
        ])
      ],
    );
  }

  Widget progressViewGraph() {
    return RadianGraph(
      cardData: widget.cardData,
      playAnimation: playAnimation,
    );
  }
}

class RadianGraph extends StatefulWidget {
  final ProgressCardData cardData;
  final bool playAnimation;

  RadianGraph({this.cardData, this.playAnimation = false});

  @override
  _RadianGraphState createState() => _RadianGraphState();
}

class _RadianGraphState extends State<RadianGraph>
    with TickerProviderStateMixin {
  Animation<double> animation;
  List<AnimationController> controllers;
  List<RadianGraphData> _graphData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _graphData = List.generate(widget.cardData.graphData.length, (index) {
      var data = RadianGraphData(
          color: widget.cardData.graphData[index].color,
          //TODO change this to 0 when implementing animation;
          percent: widget.cardData.graphData[index].percent,
          label: widget.cardData.graphData[index].label);
      return data;
    });
    controllers = List.generate(
        _graphData.length,
        (index) => AnimationController(
            duration: Duration(milliseconds: 1500), vsync: this));
    // TODO uncomment when implementing animation
    // if (widget.playAnimation) playAnimation();
  }

  void playAnimation() {
    Future.delayed(Duration(milliseconds: 100), () {
      for (int i = 0; i < _graphData.length; i++) {
        animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controllers[i], curve: Curves.easeInOutQuart))
          ..addListener(() {
            setState(() {
              _graphData[i].percent =
                  animation.value * widget.cardData.graphData[i].percent;
            });
          });
        controllers[i].forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllers.map((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.cardData.graphTitle.replaceFirst(" ", "\n"),
            style: normalResponsiveFont(context, opacity: 0.6),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.cardData.graphSubtitle,
            style: normalResponsiveFont(context, fontWeight: FontWeight.w500),
          )
        ],
      )),
      foregroundPainter: ProgressPainter(
          graphData: _graphData,
          backgroundColor: Style.of(context).colors.background3),
    );
  }
}

class ProgressPainter extends CustomPainter {
  //
  List<RadianGraphData> graphData;
  Color backgroundColor;

  ProgressPainter({@required this.graphData, @required this.backgroundColor});

  Paint getPaint(Color color, {Size size}) {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, getPaint(backgroundColor, size: size));
    double previousAngle = -pi / 2;

    for (var data in graphData) {
      double arcAngle = 2 * pi * (data.percent / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          previousAngle, arcAngle, false, getPaint(data.color, size: size));
      previousAngle = previousAngle + arcAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
}

class ProgressCardData {
  String graphTitle;
  String graphSubtitle;
  List<RadianGraphData> graphData;

  ProgressCardData(
      {
      this.graphData,
      this.graphTitle,
      this.graphSubtitle});
}

class RadianGraphData {
  Color color;
  double percent;
  String label;

  RadianGraphData({this.color, this.percent = 0, this.label});
}
