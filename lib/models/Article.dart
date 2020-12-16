

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Widgets/article_list_item.dart';

class Article{
  File _image;

  set imageUint8List(Uint8List value) {
    _imageUint8List = value;
  }

  Uint8List _imageUint8List;

  Uint8List get imageUint8List => _imageUint8List;

  String _designation, _ref, _description, _codeBar;

  get codeBar => _codeBar;

  set codeBar(value) {
    _codeBar = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  int _id, _idFamille,_idMarque;

  double _colis ,  _prixVente1TTC, _prixVente1, _prixVente2TTC, _prixVente2,
         _prixVente3TTC, _prixVente3,_qteInit, _qte, _qteMin, _qteColis,
         _prixAchat, _pmpInit, _pmp, _tva;

  double _selectedQuantite = -1;
  double _selectedPrice = 0;

  double get selectedPrice => _selectedPrice;

  set selectedPrice(double value) {
    _selectedPrice = value;
  }

  set selectedQuantite(double value) {
    _selectedQuantite = value;
  }

  double get selectedQuantite => _selectedQuantite;
  bool _bloquer;
  bool _stockable;

  bool get stockable => _stockable;

  set stockable(bool value) {
    _stockable = value;
  }

  Article.init();

  String get designation => _designation;
  String get ref => _ref;
  int get id => _id;
  int get idFamille => _idFamille;
  int get idMarque => _idMarque;
  double get colis => _colis;

  double get quantite => _qte;
  double get quantiteMinimum => _qteMin;
  double get quantiteColis => _qteColis;
  double get quantiteInit => _qteInit;

  double get prixAchat => _prixAchat;
  double get pmp => _pmp;
  double get pmpInit => _pmpInit;
  double get tva => _tva;

  double get prixVente1TTC => _prixVente1TTC;
  double get prixVente1 => _prixVente1;
  double get prixVente2TTC => _prixVente2TTC;
  double get prixVente2 => _prixVente2;
  double get prixVente3TTC => _prixVente3TTC;
  double get prixVente3 => _prixVente3;

  File get image => _image;
  bool get bloquer => _bloquer;

  //section for setters
  void setId(int id) {
    this._id=id;
  }

  void setdesignation(String des) {
    this._designation=des;
  }
  void setref(String ref) {
    this._ref=ref;
  }

  void setCodeBar(String codeBar) {
    this._codeBar = codeBar;
  }

  void setDescription(String description) {
    this._description=description;
  }

  void setIdFamille(int id){
    this._idFamille =id;
  }

  void setIdMarque(int id){
    this._idMarque =id;
  }

  void setColis(double colis){
    this._colis=colis;
  }

  void setbloquer(bool bloquer) {
    this._bloquer=bloquer;
  }

  void setStockable(bool stockable) {
    this._stockable=stockable;
  }

  void setImageUint8List(Uint8List imageUnit8List) {
    this._imageUint8List = imageUnit8List;
  }

  void setquantite(double qte) {
    this._qte=qte;
  }
  void setQteInit(double qte) {
    this._qteInit=qte;
  }
  void setQteMin(double qte) {
    this._qteMin=qte;
  }
  void setQteColis(double qte) {
    this._qteColis=qte;
  }
  void setprixVente1TTC(double ttc) {
    this._prixVente1TTC=ttc;
  }
  void setprixVente1(double pv) {
    this._prixVente1=pv;
  }
  void setprixVente2TTC(double ttc) {
    this._prixVente2TTC=ttc;
  }
  void setprixVente2(double pv) {
    this._prixVente2=pv;
  }
  void setprixVente3TTC(double ttc) {
    this._prixVente3TTC=ttc;
  }
  void setprixVente3(double pv) {
    this._prixVente3=pv;
  }
  
  void setprixAchat(double pa) {
    this._prixAchat=pa;
  }
  void setTva(double tva) {
    this._tva=tva;
  }
  void setPmp(double pmp) {
    this._pmp=pmp;
  }
  void setPmpInit(double pmpinit) {
    this._pmpInit=pmpinit;
  }

  void setpic(File img) {
    this._image=img;
    this._imageUint8List= Helpers.getUint8ListFromFile(img);
  }

  // constructor to convert map to object
  Article.fromMap(dynamic obj) {
    this._imageUint8List = Helpers.getUint8ListFromByteString(obj["BytesImageString"]);

    this._id = obj["id"];
    this._designation = obj["Designation"];
    this._ref = obj["Ref"].toString();
    this._idFamille = obj["Id_Famille"];
    this._idMarque = obj["Id_Marque"];
    this._colis = obj["Colis"];
    this._prixVente1TTC = obj["PrixVente1TTC"];
    this._prixVente1 = obj["PrixVente1"];
    this._prixVente2TTC = obj["PrixVente2TTC"];
    this._prixVente2 = obj["PrixVente2"];
    this._prixVente3TTC = obj["PrixVente3TTC"];
    this._prixVente3 = obj["PrixVente3"];
    this._qteInit = obj["Qte_init"];
    this._qte = obj["Qte"];
    this._qteMin = obj["Qte_Min"];
    this._qteColis = obj["Qte_Colis"];
    this._prixAchat = obj["PrixAchat"];
    this._pmpInit = obj["PMP_init"];
    this._pmp = obj["PMP"];
    this._tva = obj["TVA"];
    this._bloquer = obj["Bloquer"] == 1? true : false;
    this._stockable = obj["Stockable"] == 1? true : false;
    this._description = obj["Description"];
  }

  //conver an object to map for persistance
  Article.fromMapJournaux(dynamic obj) {
    this._imageUint8List = Helpers.getUint8ListFromByteString(obj["BytesImageString"]);

    this._id = obj["Article_id"];
    this._designation = obj["Designation"];
    this._ref = obj["Ref"].toString();
    this._selectedQuantite = obj["Qte"];
    this._selectedPrice = obj["Prix_ht"];
    this._tva = obj["Tva"];

  }

  //convert an object to a map for persistance
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if(_imageUint8List != null && _imageUint8List.isNotEmpty){
      map["BytesImageString"] = base64Encode(_imageUint8List);
    } else{
      map["BytesImageString"] = Helpers.getEncodedByteStringFromFile(this._image);
    }
    map["Designation"] = this._designation;
    map["Ref"] = this._ref;
    map["CodeBar"] = this.codeBar;
    map["Id_Famille"] = this._idFamille;
    map["Id_Marque"] = this._idMarque;
    map["Colis"] = this._colis;
    map["PrixVente1TTC"] = this._prixVente1TTC;
    map["PrixVente1"] = this._prixVente1;
    map["PrixVente2TTC"] = this._prixVente2TTC;
    map["PrixVente2"] = this._prixVente2;
    map["PrixVente3TTC"] = this._prixVente3TTC;
    map["PrixVente3"] = this._prixVente3;
    map["Qte_init"] = this._qteInit;
    map["Qte"] = this._qte;
    map["Qte_Min"] = this._qteMin;
    map["Qte_Colis"] = this._qteColis;
    map["PrixAchat"] = this._prixAchat;
    map["PMP_init"] = this._pmpInit;
    map["PMP"] = this._pmp;
    map["TVA"] = this._tva;
    int bloq = this._bloquer? 1 : 0;
    map["Bloquer"] = bloq;

    int stockable = this._stockable? 1 : 0;
    map["Stockable"] = stockable;
    map["Description"] = this._description;

    return map;
  }

  //constructor with all params
  Article(
      this._image, this._designation, this._ref, this._codeBar, this._description,
      this._idFamille, this._idMarque, this._colis, this._prixVente1TTC,
      this._prixVente1, this._prixVente2TTC, this._prixVente2, this._prixVente3TTC,
      this._prixVente3, this._qteInit, this._qte,
      this._qteMin, this._qteColis, this._prixAchat, this._pmpInit,
      this._pmp, this._tva, this._bloquer, this._stockable);

  //return article object in string format
  @override
  String toString() {
    return 'Article{_image: $_image, _imageUint8List: $_imageUint8List, _designation: $_designation, _ref: $_ref, _description: $_description, _codeBar: $_codeBar, _id: $_id, _idFamille: $_idFamille, _idMarque: $_idMarque, _colis: $_colis, _prixVente1TTC: $_prixVente1TTC, _prixVente1: $_prixVente1, _prixVente2TTC: $_prixVente2TTC, _prixVente2: $_prixVente2, _prixVente3TTC: $_prixVente3TTC, _prixVente3: $_prixVente3, _qteInit: $_qteInit, _qte: $_qte, _qteMin: $_qteMin, _qteColis: $_qteColis, _prixAchat: $_prixAchat, _pmpInit: $_pmpInit, _pmp: $_pmp, _tva: $_tva, _bloquer: $_bloquer, _stockable: $_stockable}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}