import 'package:gestmob/models/Piece.dart';

import 'Article.dart';

class Journaux{
  int _id;
  int _mov;
  DateTime _date;
  int _piece_id;
  int _article_id;
  double _qte;
  double _prix_ht;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  double _tva;

  int get mov => _mov;

  set mov(int value) {
    _mov = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  int get piece_id => _piece_id;

  set piece_id(int value) {
    _piece_id = value;
  }

  int get article_id => _article_id;

  set article_id(int value) {
    _article_id = value;
  }

  double get qte => _qte;

  set qte(double value) {
    _qte = value;
  }

  double get prix_ht => _prix_ht;

  set prix_ht(double value) {
    _prix_ht = value;
  }

  double get tva => _tva;

  set tva(double value) {
    _tva = value;
  }

  Journaux.fromPiece(Piece piece, Article article){
    this._mov = piece.mov;
    this._date = piece.date;
    this._piece_id = piece.id;
    this._article_id = article.id;
    this._qte = article.quantite;
    this._prix_ht = article.prixAchat;
    this._tva = article.tva;
  }

  Journaux(this._mov, this._date, this._piece_id, this._article_id,
      this._qte, this._prix_ht, this._tva);

  Journaux.init();
  Journaux.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._article_id = obj["Article_id"];
    this._piece_id = obj["Piece_id"];
    this._mov = obj["Mov"];
    this._date = DateTime.fromMillisecondsSinceEpoch(obj["Date"]);
    this._qte = obj["Qte"];
    this._prix_ht = obj["Prix_ht"];
    this._tva = obj["Tva"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Mov"] = this._mov;
    map["Article_id"] = this._article_id;
    map["Piece_id"] = this._piece_id;
    map["Date"] = this._date.millisecondsSinceEpoch;
    map["Qte"] = this._qte;
    map["Prix_ht"] = this._prix_ht;
    map["Tva"] = this._tva;

    return map;
  }
}