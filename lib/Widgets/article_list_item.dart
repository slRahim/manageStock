import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'CustomWidgets/list_tile_card.dart';

class ArticleListItem extends StatefulWidget {
  ArticleListItem({
    @required this.article,
    Key key,
    this.onItemSelected,
  })  : assert(article != null),
        super(key: key);

  final Article article;
  final Function(Object) onItemSelected;

  @override
  _ArticleListItemState createState() => _ArticleListItemState();
}

class _ArticleListItemState extends State<ArticleListItem> {
  TextEditingController _quntiteControler = new TextEditingController();
  String _validateQteError;

  @override
  Widget build(BuildContext context) {
    return ListTileCard(
      onTap: () async {
        if(widget.article.selectedQuantite >= 0){
          await showDialog(
              context: context,
              builder: (BuildContext context) {
            return addQtedialogue();
          }).then((val) {
            setState(() {});
        });
        } else if(widget.onItemSelected != null){
          widget.article.selectedQuantite = 1;
          widget.onItemSelected(widget.article);
        } else{
          Navigator.of(context).pushNamed(RoutesKeys.addArticle, arguments: widget.article);
        }
      },

      itemSelected: widget.article.selectedQuantite > 0,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: MemoryImage(widget.article.imageUint8List),
      ),
      title: Text(widget.article.designation),
      subtitle: Text("Ref: " + widget.article.ref),
      trailingChildren: widget.article.selectedQuantite > 0? [Text(
        widget.article.selectedQuantite.toString(),
        style: TextStyle(
            color: Colors.black,
            fontSize: 15.0),
      )]: [
        Text(
          widget.article.prixVente1.toString(),
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          widget.article.quantite.toString(),
          style: TextStyle(
              color: widget.article.quantite <= widget.article.quantiteMinimum
                  ? Colors.redAccent
                  : Colors.black,
              fontSize: 15.0),
        )
      ],
    );
  }

  Widget addQtedialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      Widget dialog = Dialog(
        //this right here
        child: Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Change Quantité",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
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
                      labelText: "Quantité",
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                _quntiteControler.text = "0";
                                widget.article.selectedQuantite = -1;
                                widget.onItemSelected(widget.article);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 10),
                            RaisedButton(
                              onPressed: () async {
                                try {
                                  double _qte = double.parse(_quntiteControler.text);
                                  if(_qte > 0){
                                    widget.article.selectedQuantite = _qte;
                                    _validateQteError = null;
                                    Navigator.pop(context);
                                  } else{
                                    setState(() {
                                      _validateQteError = "Qantité can\'t be less then 0";
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    _validateQteError = "Please enter valid number";
                                  });
                                  print(e);
                                }
                              },
                              child: Text(
                                "Confirmé",
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
        ),
      );
      _quntiteControler.text = widget.article.selectedQuantite.toString();
      return dialog;
    });
  }
}
