import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// article selectionné ds une piece
class ArticleListItemSelected extends StatefulWidget {

  ArticleListItemSelected({
    @required this.article,
    Key key,
    this.onItemSelected,
    this.tarification,
    this.fromListing=false,
  })  : assert(article != null),
        super(key: key);

  final Article article;
  final Function(Object) onItemSelected;
  final int tarification ;
  final bool fromListing ;

  @override
  _ArticleListItemSelectedState createState() => _ArticleListItemSelectedState();
}

class _ArticleListItemSelectedState extends State<ArticleListItemSelected> {
  TextEditingController _quntiteControler = new TextEditingController();
  TextEditingController _priceControler = new TextEditingController();
  String _validateQteError;
  String _validatePriceError;

  @override
  Widget build(BuildContext context) {
    return  SelectableListItem(
        key_id: Key(widget.article.id.toString()),
        isListing: widget.fromListing,
        onDismiss: (direction) {
          if(widget.onItemSelected != null){
            selectThisItem();
          }
        },
        onTap: () async {
          if(widget.fromListing == false){
            if(widget.onItemSelected == null ){
              Navigator.of(context).pushNamed(RoutesKeys.addArticle, arguments: widget.article);
            } else if(widget.article.selectedQuantite >= 0){
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addQtedialogue();
                  }).then((val) {

                setState(() {});
              });
            } else if(widget.onItemSelected != null ){
              selectThisItem();
            }
          }
        },
        itemSelected: widget.article.selectedQuantite > 0,
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.yellow[700],
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: MemoryImage(widget.article.imageUint8List),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.assignment,size: 14, color: Theme.of(context).primaryColorDark,),
            SizedBox(width: 2,),
            Text(widget.article.designation),
          ],
        ),
        subtitle: Row(
          children: [
            Icon(MdiIcons.pound,size: 14, color: Theme.of(context).primaryColorDark,),
            SizedBox(width: 2,),
            Text(widget.article.ref),
          ],
        ),
        trailingChildren: [
          Text(
            "${Helpers.numberFormat((widget.article.selectedQuantite * widget.article.selectedPrice))}",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5),
          Text(
            Helpers.numberFormat(widget.article.selectedQuantite).toString(),
            style: TextStyle(
                fontSize: 15.0),
          )
        ]

    );
  }

  //dialog pour modifier le prix et la quantité
  Widget addQtedialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      Widget dialog = Dialog(
        //this right here
        child: Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
              children: [Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            S.current.modification_titre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
                      child: TextField(
                        controller: _quntiteControler,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText: _validateQteError?? null,
                          prefixIcon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.orange[900],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[900]),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: S.current.quantit,
                          labelStyle: TextStyle(color: Colors.orange[900]),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.orange[900]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsets.only(right: 0, left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  onPressed: () async {
                                    double _qte = double.parse(_quntiteControler.text) - 1;
                                    _quntiteControler.text = _qte.toString();
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.redAccent,
                                  child: Icon(
                                    Icons.remove,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                RawMaterialButton(
                                  onPressed: () async {
                                    double _qte = double.parse(_quntiteControler.text) + 1;
                                    _quntiteControler.text = _qte.toString();
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.greenAccent,
                                  child: Icon(
                                    Icons.add,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                              child: TextField(
                                controller: _priceControler,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorText: _validatePriceError?? null,
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Colors.orange[900],
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.orange[900]),
                                      borderRadius: BorderRadius.circular(20)),
                                  contentPadding: EdgeInsets.only(left: 10),
                                  labelText: S.current.prix,
                                  labelStyle: TextStyle(color: Colors.orange[900]),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 3.3,
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.orange[900]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: ()  {
                                    _quntiteControler.text = "0";
                                    widget.article.selectedQuantite = -1;
                                    widget.onItemSelected(widget.article);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    S.current.annuler,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 10),
                                RaisedButton(
                                  onPressed: ()  {
                                    try {
                                      double _qte = double.parse(_quntiteControler.text);
                                      double _price = double.parse(_priceControler.text);
                                      if(_qte > 0){
                                        _validateQteError = null;
                                      } else{
                                        _validateQteError = S.current.msg_qte_err;
                                      }
                                      if(_price > 0){
                                        _validatePriceError = null;
                                      } else{
                                        _validatePriceError = S.current.msg_prix_err;
                                      }
                                      if(_validateQteError == null && _validatePriceError == null){
                                        widget.article.selectedQuantite = _qte;
                                        widget.article.selectedPrice = _price;
                                        widget.onItemSelected(null);

                                        Navigator.pop(context);
                                      } else{
                                        setState(() {
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        _validateQteError = S.current.msg_num_err;
                                      });
                                      print(e);
                                    }
                                  },
                                  child: Text(
                                    S.current.confirme,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ]),
        ),
      );
      _quntiteControler.text = widget.article.selectedQuantite.toString();
      _priceControler.text = widget.article.selectedPrice.toString();
      return dialog;
    });
  }

  void selectThisItem() {
    widget.article.selectedQuantite = 1 ;
    switch (widget.tarification) {
      case 1 :
        widget.article.selectedPrice = widget.article.prixVente1;
        break;
      case 2 :
        widget.article.selectedPrice = widget.article.prixVente2;
        break ;
      case 3 :
        widget.article.selectedPrice = widget.article.prixVente3;
        break ;
      default :
        if(widget.article.selectedPrice == null){
          widget.article.selectedPrice = widget.article.prixVente1;
        }
        break;
    }

    widget.onItemSelected(widget.article);
  }
}

//****************************************************************************************************************************************************************
//*********************************************************************card generic style******************************************************************************
class SelectableListItem extends StatelessWidget {
  final key_id ;
  final bool isListing ;
  final bool itemSelected;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;
  final  onDismiss;

  const SelectableListItem({Key key ,this.key_id,this.isListing,this.leading, this.title, this.subtitle, this.trailingChildren, this.onTap, this.itemSelected, this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    elevation: 4,
    margin: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 5),
    child: Container(
        child: listTile(context)
    ),
  );

  Widget listTile(context){
    var tileItem = Container(
      child:  ListTile(
        onTap: onTap,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: Container(
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              runSpacing: 10.0,
              crossAxisAlignment:  WrapCrossAlignment.end,
              children: trailingChildren,
            )),
      ),
    );
    if(isListing){
      return tileItem ;
    }
    return Dismissible(
      key: key_id,
      onDismissed:onDismiss,
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_forever , color: Colors.white , size: 30,),
          ],
        ),
      ),
      child: tileItem
    );
  }
}