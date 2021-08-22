import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:sliding_card/sliding_card.dart';

///**********************************************************************************************************************************************************************
//********************************************************************Card******************************************************************************************
class ListTileCard extends StatefulWidget {
  final from;

  final bool itemSelected;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  final SlidingCardController slidingCardController;
  final Function onCardTapped;

  final bool alreadySelected ;

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
      @required this.onCardTapped ,
      this.alreadySelected})
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
        onDoubleTap:(widget.from is Article)? widget.onLongPress : null,
        child: SlidingCard(
          slimeCardBorderRadius: 5,
          cardsGap: SizeConfig.safeBlockVertical,
          controller: widget.slidingCardController,
          slidingCardWidth: SizeConfig.horizontalBloc * 95,
          visibleCardHeight: (Helpers.isDirectionRTL(context))
              ? (widget.from is Tiers || widget.from is Article)
                  ? 110
                  : 105
              : 105,
          hiddenCardHeight: (Helpers.isDirectionRTL(context)) ? 90 : 80,
          showColors: false,
          frontCardWidget: ListFrontCard(
            title: widget.title,
            subtitle: widget.subtitle,
            leading: widget.leading,
            from: widget.from,
            trailingChildren: widget.trailingChildren,
            itemSelected: widget.itemSelected,
            alreadySelected: widget.alreadySelected,
            onShowInfoTapped: () {
              widget.slidingCardController.expandCard();
            },
            onHideInfoTapped: () {
              widget.slidingCardController.collapseCard();
            },
          ),
          backCardWidget: _backCardCondition()
              ? ListBackCard(
                  trailingChildren: widget.trailingChildren,
                  onTap: widget.onTap,
                )
              : null,
        ),
      ),
    );
  }

  bool _backCardCondition() {
    if (widget.from is Piece || widget.from is Tiers) {
      if (widget.from is Piece && widget.from.piece == 'FP') {
        return false;
      }
      return true;
    }

    return false;
  }
}

//**********************************************************************************************************************************************************************
//********************************************************************front card******************************************************************************************
class ListFrontCard extends StatefulWidget {
  final Widget title;

  final Widget subtitle;

  final from;

  final List<Widget> trailingChildren;
  final Widget leading;
  final bool itemSelected;
  final Function onShowInfoTapped;
  final Function onHideInfoTapped;
  final bool alreadySelected ;

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
    this.alreadySelected,
  }) : super(key: key);

  @override
  _ListFrontCardState createState() => _ListFrontCardState();
}

class _ListFrontCardState extends State<ListFrontCard> {
  bool isinfoPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (widget.itemSelected != null && widget.itemSelected)
              ? Colors.blue[200]
              :(widget.alreadySelected != null && widget.alreadySelected == true)? Colors.lightGreen[400] : Theme.of(context).selectedRowColor,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          //en tete de la carte
          _arrowCondition()
              ? Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            (widget.itemSelected != null && widget.itemSelected)
                                ? Colors.blue[200]
                                :(widget.alreadySelected != null && widget.alreadySelected == true)? Colors.lightGreen[400] :Theme.of(context).selectedRowColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
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
                              padding: EdgeInsetsDirectional.only(end: 10),
                              child: isinfoPressed
                                  ? Transform.rotate(
                                      angle: 0,
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 24,
                                      ),
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 24,
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 18,
                ),
          //corp de la carte
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 3, child: widget.leading),
                      SizedBox(
                        width: 1,
                      ),
                      Expanded(
                        flex: 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.title,
                            SizedBox(
                              height: (Helpers.isDirectionRTL(context)) ? 2 : 5,
                            ),
                            widget.trailingChildren[0],
                            SizedBox(
                              height: (Helpers.isDirectionRTL(context)) ? 2 : 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.trailingChildren[1],
                                (widget.from is Article)
                                    ? Container(
                                        padding:
                                            EdgeInsetsDirectional.only(end: 15),
                                        child: widget.trailingChildren[2])
                                    : SizedBox(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _arrowCondition() {
    if (widget.from is Piece || widget.from is Tiers) {
      if (widget.from is Piece && widget.from.piece == 'FP') {
        return false;
      }
      return true;
    }

    return false;
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        padding: (Helpers.isDirectionRTL(context))
            ? EdgeInsetsDirectional.only(start: 15, end: 15, top: 5)
            : EdgeInsetsDirectional.only(start: 15, end: 15, top: 10),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    trailingChildren[2],
                    SizedBox(
                      height: (Helpers.isDirectionRTL(context)) ? 2 : 5,
                    ),
                    trailingChildren[3],
                    SizedBox(
                      height: (Helpers.isDirectionRTL(context)) ? 2 : 5,
                    ),
                    trailingChildren[4],
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
                      color: Colors.white,
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
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
