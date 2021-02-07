

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/models/Article.dart';

class Piece{
  int _id;
  int _tier_id;
  int _mov;
  String _num_piece;
  String _raisonSociale;
  String _mobileTier;
  String _piece;
  DateTime _date;

  int _tarification;
  int _transformer;
  int _etat ;
  double _total_ht=0;
  double _total_tva = 0;
  double _net_ht = 0;
  double _total_ttc = 0;
  double _timbre;
  double _net_a_payer = 0;
  double _regler=0;
  double _reste=0;
  double _marge=0 ;
  double _remise =0;

  Piece.init();
  Piece.typePiece(this._piece);
  Piece.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._tier_id = obj["Tier_id"];
    this._mov = obj["Mov"];
    this._num_piece = obj["Num_piece"].toString();
    this._piece = obj["Piece"].toString();
    this._date = DateTime.fromMillisecondsSinceEpoch(obj["Date"]);
    this._raisonSociale = obj["RaisonSociale"];
    this._mobileTier = obj["Mobile"];
    this._tarification = obj["Tarification"];
    this._etat = obj["Etat"];
    this._transformer = obj["Transformer"];
    this._total_ht = obj["Total_ht"];
    this._net_ht = obj["Net_ht"];
    this._total_tva = obj["Total_tva"];
    this._total_ttc = obj["Total_ttc"];
    this._timbre = obj["Timbre"];
    this._net_a_payer = obj["Net_a_payer"];
    this._regler = obj["Regler"];
    this._reste = obj["Reste"];
    this._marge = obj["Marge"];
    this._remise = obj["Remise"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["Mov"] = this._mov;
    map["Num_piece"] = this._num_piece;
    map["Piece"] = this._piece;
    map["Date"] = this._date.millisecondsSinceEpoch;
    map["Tier_id"] = this._tier_id;
    map["Tarification"] = this._tarification;
    map["Transformer"] = this._transformer;
    map["Etat"] = this._etat ;
    map["Total_ht"] = this._total_ht;
    map["Net_ht"] = this._net_ht ;
    map["Total_tva"] = this._total_tva;
    map["Total_ttc"] = this._total_ttc;
    map["Timbre"] = this._timbre;
    map["Net_a_payer"] = this._net_a_payer;
    map["Regler"] = this._regler;
    map["Reste"] = this._reste;
    map["Marge"] = this._marge ;
    map["Remise"] = this._remise ;
    return map;
  }

  Piece(
      this._piece,
      this._num_piece,
      this._mov,
      this._tarification,
      this._date,
      this._id,
      this._tier_id,
      this._transformer,
      this._etat,
      this._total_ht,
      this._net_ht ,
      this._total_tva,
      this._total_ttc,
      this._timbre,
      this._net_a_payer,
      this._regler,
      this._reste,
      this._marge,
      this._remise
      );

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get raisonSociale => _raisonSociale;

  set raisonSociale(String value) {
    _raisonSociale = value;
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

  int get tier_id => _tier_id;

  set tier_id(int value) {
    _tier_id = value;
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

  double get net_ht => _net_ht;

  set net_ht(double value) {
    _net_ht = value;
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

  int get etat => _etat;

  set etat(int value) {
    _etat = value;
  }

  double get marge => _marge;

  set marge(double value) {
    _marge = value;
  }


  double get remise => _remise;

  set remise(double value) {
    _remise = value;
  }


  String get mobileTier => _mobileTier;

  set mobileTier(String value) {
    _mobileTier = value;
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

}