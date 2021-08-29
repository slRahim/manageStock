import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryListItem extends StatefulWidget {
  final dynamic item;

  CategoryListItem({Key key, this.item,}) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  final QueryCtr _queryCtr = new QueryCtr();
  bool _visible = true;
  TextEditingController _libelleControl = new TextEditingController();
  TextEditingController _numCompteControl = new TextEditingController();
  TextEditingController _soldeInitControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.item is ArticleTva) {
      return Visibility(
        visible: _visible,
        child: Card(
          elevation: 1,
          color: Theme.of(context).selectedRowColor,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).selectedRowColor,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(2),
            child: ListTile(
                title: Text(
                  "${widget.item.tva}%",
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _libelleControl.text = widget.item.tva.toString();
                    });
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      animType: AnimType.BOTTOMSLIDE,
                      title: S.current.supp,
                      body: editDialogue(),
                    )..show();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => dellDialog(context),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )),
          ),
        ),
      );
    }
    if (widget.item is CompteTresorie) {
      return Visibility(
        visible: _visible,
        child: Card(
          elevation: 1,
          color: Theme.of(context).selectedRowColor,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).selectedRowColor,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(2),
            child: ListTile(
                title: Text(
                  "${widget.item.nomCompte} (${widget.item.numCompte})",
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _libelleControl.text = widget.item.nomCompte;
                      _numCompteControl.text = widget.item.numCompte ;
                      _soldeInitControl.text = widget.item.soldeDepart.toString() ;
                    });
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      animType: AnimType.BOTTOMSLIDE,
                      title: S.current.supp,
                      body: editDialogue(),
                    )..show();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                trailing:(widget.item.id != 1)? IconButton(
                  onPressed: () => dellDialog(context),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ) : null
            ),
          ),
        ),
      );
    }
    return Visibility(
      visible: _visible,
      child: Card(
        elevation: 1,
        color: Theme.of(context).selectedRowColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).selectedRowColor,
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(2),
          child: ListTile(
              title: Text(
                widget.item.libelle,
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _libelleControl.text = widget.item.libelle;
                  });
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    animType: AnimType.BOTTOMSLIDE,
                    title: S.current.supp,
                    body: editDialogue(),
                  )..show();
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              trailing: IconButton(
                onPressed: () => dellDialog(context),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )),
        ),
      ),
    );
  }

  Widget editDialogue() {
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${S.current.modification_titre}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _libelleControl,
                        keyboardType: (widget.item is ArticleTva)
                            ? TextInputType.number
                            : TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.text_snippet,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: S.current.designation,
                          labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Visibility(
                        visible: widget.item is CompteTresorie,
                        child: TextFormField(
                          controller: _numCompteControl,
                          keyboardType: TextInputType.text,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return S.current.msg_champ_oblg;
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.confirmation_number_outlined,
                              color: Colors.blue,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding: EdgeInsets.only(left: 10),
                            labelText: S.current.n,
                            labelStyle: GoogleFonts.lato(
                              textStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(height: 10,),
                      Visibility(
                        visible: widget.item is CompteTresorie,
                        child: TextFormField(
                          controller: _soldeInitControl,
                          keyboardType: TextInputType.number,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return S.current.msg_champ_oblg;
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.monetization_on,
                              color: Colors.blue,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding: EdgeInsets.only(left: 10),
                            labelText: S.current.solde_depart,
                            labelStyle: GoogleFonts.lato(
                              textStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await updateItem();
                        Navigator.pop(context);
                        setState(() {
                          _libelleControl.text = "";
                          _numCompteControl.text = "" ;
                          _soldeInitControl.text = "";
                        });
                      }
                    },
                    child: Text("${S.current.save_btn}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> updateItem() async {
    var res = 0;

    if (_libelleControl.text.trim() != '') {
      if (widget.item is ArticleFamille) {
        widget.item.libelle = _libelleControl.text.trim();
        res = await _queryCtr.updateItemInDb(
            DbTablesNames.articlesFamilles, widget.item);
      } else if (widget.item is ArticleMarque) {
        widget.item.libelle = _libelleControl.text.trim();
        res = await _queryCtr.updateItemInDb(
            DbTablesNames.articlesMarques, widget.item);
      } else if (widget.item is TiersFamille) {
        widget.item.libelle = _libelleControl.text.trim();
        res = await _queryCtr.updateItemInDb(
            DbTablesNames.tiersFamille, widget.item);
      } else if (widget.item is ChargeTresorie) {
        widget.item.libelle = _libelleControl.text.trim();
        res = await _queryCtr.updateItemInDb(
            DbTablesNames.chargeTresorie, widget.item);
      } else if (widget.item is ArticleTva) {
        widget.item.tva = double.parse(_libelleControl.text.trim());
        res = await _queryCtr.updateItemInDb(
            DbTablesNames.articlesTva, widget.item);

      }else if (widget.item is CompteTresorie){
        widget.item.nomCompte = _libelleControl.text.trim();
        widget.item.numCompte = _numCompteControl.text.trim();
        widget.item.codeCompte = "";
        widget.item.soldeDepart =(_soldeInitControl.text.trim() != '')? double.parse(_soldeInitControl.text.trim()) : 0.0;

        res = await _queryCtr.updateItemInDb(
            DbTablesNames.compteTresorie, widget.item);
      }
    }

    var message = "";
    if (res > 0) {
      setState(() {
        widget.item;
      });
      message = S.current.msg_update_item;
    } else {
      message = S.current.msg_update_err;
    }
    Helpers.showToast(message);
  }

  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp} ... ',
      btnCancelText: S.current.non,
      btnCancelOnPress: () {},
      btnOkText: S.current.oui,
      btnOkOnPress: () async {
        var res = 0;
        if (widget.item is ArticleFamille) {
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.articlesFamilles, widget.item);
        } else if (widget.item is ArticleMarque) {
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.articlesMarques, widget.item);
        } else if (widget.item is TiersFamille) {
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.tiersFamille, widget.item);
        } else if (widget.item is ChargeTresorie) {
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.chargeTresorie, widget.item);
        } else if (widget.item is ArticleTva) {
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.articlesTva, widget.item);
        }else if (widget.item is CompteTresorie){
          res = await _queryCtr.removeItemFromTable(
              DbTablesNames.compteTresorie, widget.item);
        }

        var message = "";
        if (res > 0) {
          message = S.current.msg_supp_ok;
          setState(() {
            _visible = false;
          });
        } else {
          message = S.current.msg_ereure;
        }
        Helpers.showToast(message);
      },
    )..show();
  }
}
