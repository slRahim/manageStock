

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/models/Article.dart';

class Piece{
  int _id;
  int _mov;
  String _num_piece;
  String raisonSociale;
  String _piece;
  DateTime _date;

  int _tarification;
  int _transformer;
  double _total_ht;
  double _total_tva;
  double _total_ttc;
  double _timbre;
  double _net_a_payer = 0;
  double _regler;
  double _reste;

  Piece.init();
  Piece.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._mov = obj["Mov"];
    this._num_piece = obj["Num_piece"].toString();
    this._piece = obj["Piece"].toString();
    this._date = DateTime.fromMillisecondsSinceEpoch(obj["Date"]);
    this._raisonSociale = obj["RaisonSociale"];
    this._tarification = obj["Tarification"];
    this._transformer = obj["Transformer"];
    this._total_ht = obj["Total_ht"];
    this._total_tva = obj["Total_tva"];
    this._total_ttc = obj["Total_ttc"];
    this._timbre = obj["Timbre"];
    this._net_a_payer = obj["Net_a_payer"];
    this._regler = obj["Regler"];
    this._reste = obj["Reste"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Mov"] = this._mov;
    map["Num_piece"] = this._num_piece;
    map["Piece"] = this._piece;
    map["Date"] = this._date.millisecondsSinceEpoch;
    map["Tier_id"] = this._id;
    map["Tarification"] = this._tarification;
    map["Transformer"] = this._transformer;
    map["Total_ht"] = this._total_ht;
    map["Total_tva"] = this._total_tva;
    map["Total_ttc"] = this._total_ttc;
    map["Timbre"] = this._timbre;
    map["Net_a_payer"] = this._net_a_payer;
    map["Regler"] = this._regler;
    map["Reste"] = this._reste;

    return map;
  }

  Piece(
      this._piece,
      this._num_piece,
      this._mov,
      this._tarification,
      this._date,
      this._id,
      this._transformer,
      this._total_ht,
      this._total_tva,
      this._total_ttc,
      this._timbre,
      this._net_a_payer,
      this._regler,
      this._reste

      );

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get _raisonSociale => raisonSociale;

  set _raisonSociale(String value) {
    raisonSociale = value;
  }

  String get piece => _piece;

  set piece(String value) {
    _piece = value;
  }

  int get mov => _mov;

  set mov(int value) {
    _mov = value;
  }

  String get num_piece => _num_piece;

  set num_piece(String value) {
    _num_piece = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  int get tier_id => id;

  set tier_id(int value) {
    id = value;
  }

  int get tarification => _tarification;

  set tarification(int value) {
    _tarification = value;
  }

  int get transformer => _transformer;

  set transformer(int value) {
    _transformer = value;
  }

  double get total_ht => _total_ht;

  set total_ht(double value) {
    _total_ht = value;
  }

  double get total_tva => _total_tva;

  set total_tva(double value) {
    _total_tva = value;
  }

  double get total_ttc => _total_ttc;

  set total_ttc(double value) {
    _total_ttc = value;
  }

  double get timbre => _timbre;

  set timbre(double value) {
    _timbre = value;
  }

  double get net_a_payer => _net_a_payer;

  set net_a_payer(double value) {
    _net_a_payer = value;
  }

  double get regler => _regler;

  set regler(double value) {
    _regler = value;
  }

  double get reste => _reste;

  set reste(double value) {
    _reste = value;
  }


  @override
  String toString() {
    return 'Piece{_id: $_id, _mov: $_mov, _num_piece: $_num_piece, raisonSociale: $raisonSociale, _piece: $_piece, _date: $_date, id: $id, _tarification: $_tarification, _transformer: $_transformer, _total_ht: $_total_ht, _total_tva: $_total_tva, _total_ttc: $_total_ttc, _timbre: $_timbre, _net_a_payer: $_net_a_payer, _regler: $_regler, _reste: $_reste}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  Piece.fromArticlesList(List<Article> list) {
    list.forEach((item) {
      this._net_a_payer = _net_a_payer + item.selectedQuantite * item.selectedPrice;
    });
  }
}