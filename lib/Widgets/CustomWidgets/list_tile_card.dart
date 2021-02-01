import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';

///**********************************************************************************************************************************************************************
//********************************************************************Card******************************************************************************************
class ListTileCard extends StatefulWidget {
  final from;

  final bool itemSelected;
  final Widget leading;
  final String title;
  final String subtitle;
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  final SlidingCardController slidingCardController;
  final Function onCardTapped;

  const ListTileCard(
      {Key key,
      this.from,
      this.leading,
      this.title,
      this.subtitle,
      this.trailingChildren,
      this.onTap,
      this.itemSelected,
      this.onLongPress,
      this.slidingCardController,
      @required this.onCardTapped})
      : super(key: key);

  @override
  _ListTileCardState createState() => _ListTileCardState();
}

class _ListTileCardState extends State<ListTileCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SlidingCard(
            slimeCardElevation: 2,
            cardsGap: SizeConfig.safeBlockVertical,
            controller: widget.slidingCardController,
            slidingCardWidth: SizeConfig.horizontalBloc * 95,
            visibleCardHeight: SizeConfig.safeBlockVertical * 22,
            hiddenCardHeight: SizeConfig.safeBlockVertical * 15,
            showColors: false,
            frontCardWidget: ListFrontCard(
              title: widget.title,
              subtitle: widget.subtitle,
              leading: widget.leading,
              from: widget.from,
              trailingChildren: widget.trailingChildren,
              itemSelected: widget.itemSelected,
              onShowInfoTapped: () {
                widget.slidingCardController.expandCard();
              },
              onHideInfoTapped: () {
                widget.slidingCardController.collapseCard();
              },
            ),
            backCardWidget: (widget.from is Piece ||
                    widget.from is Tiers ||
                    widget.from is Article)
                ? ListBackCard(
                    trailingChildren: widget.trailingChildren,
                    onTap: widget.onTap,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

//**********************************************************************************************************************************************************************
//********************************************************************front card******************************************************************************************
class ListFrontCard extends StatefulWidget {
  final String title;

  final String subtitle;

  final from;

  final List<Widget> trailingChildren;
  final Widget leading;
  final bool itemSelected;
  final Function onShowInfoTapped;
  final Function onHideInfoTapped;

  const ListFrontCard({
    Key key,
    this.title,
    this.subtitle,
    this.from,
    this.leading,
    this.itemSelected,
    this.trailingChildren,
    this.onShowInfoTapped,
    this.onHideInfoTapped,
  }) : super(key: key);

  @override
  _ListFrontCardState createState() => _ListFrontCardState();
}

class _ListFrontCardState extends State<ListFrontCard> {
  bool isinfoPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //en tete de la carte
        Flexible(
          flex: 1,
          child: Container(
            padding: const EdgeInsetsDirectional.only(top: 0, start: 20),
            decoration: BoxDecoration(
                color: (widget.itemSelected != null && widget.itemSelected)
                    ? Colors.green
                    : Colors.purple,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            color: Colors.white),
                      ),
                    ),
                    (widget.from is Piece ||
                            widget.from is Tiers ||
                            widget.from is Article)
                        ? InkWell(
                            onTap: () {
                              if (isinfoPressed == true) {
                                isinfoPressed = false;
                                widget.onHideInfoTapped();
                                setState(() {});
                              } else {
                                isinfoPressed = true;
                                widget.onShowInfoTapped();
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: isinfoPressed
                                  ? Transform.rotate(
                                      angle: 0,
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        size:
                                            SizeConfig.safeBlockHorizontal * 9,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down,
                                      size: SizeConfig.safeBlockHorizontal * 9,
                                      color: Colors.white,
                                    ),
                            ),
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      (widget.from is Article)
                          ? MdiIcons.barcode
                          : Icons.access_time,
                      size: SizeConfig.safeBlockHorizontal * 6,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4.7,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        //corp de la carte
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: ListView(
              padding: EdgeInsetsDirectional.only(start: 20, end: 20),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  width: SizeConfig.safeBlockHorizontal * 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: widget.leading),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.trailingChildren[0],
                            SizedBox(
                              height: 5,
                            ),
                            widget.trailingChildren[1],
                            SizedBox(
                              height: 5,
                            ),
                            widget.trailingChildren[2],
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.trailingChildren[3],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//**********************************************************************************************************************************************************************
//********************************************************************back card******************************************************************************************
class ListBackCard extends StatelessWidget {
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;

  const ListBackCard({
    Key key,
    @required this.trailingChildren,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: ListView(
        padding: EdgeInsetsDirectional.only(start: 20, end: 20, top: 8),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Text(
            '${S.current.details}:',
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
              fontWeight: FontWeight.bold,
              color: Colors.blue[500],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 90,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        trailingChildren[4],
                        SizedBox(
                          height: 5,
                        ),
                        trailingChildren[5],
                        SizedBox(
                          height: 5,
                        ),
                        trailingChildren[6],
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blue[500], shape: BoxShape.circle),
                        child: Center(
                            child: Icon(
                          Icons.remove_red_eye,
                          size: SizeConfig.safeBlockHorizontal * 8,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//**********************************************************************************************************************************************************************
//********************************************************************Size config class******************************************************************************************
class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double horizontalBloc;
  static double verticalBloc;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    horizontalBloc = screenWidth / 100;
    verticalBloc = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
