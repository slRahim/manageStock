
import 'dart:convert';
import 'dart:typed_data';

import 'package:gestmob/Helpers/Helpers.dart';

class Profile{
  Profile.init(this._id);
  Profile.empty();


  Profile(
      this._imageUint8List,
      this._codepin,
      this._raisonSociale,
      this._statut,
      this._adresse,
      this._addressWeb,
      this._ville,
      this._departement,
      this._pays,
      this._cp,
      this._telephone,
      this._telephone2,
      this._fax,
      this._mobile,
      this._mobile2,
      this._email,
      this._site,
      this._rc,
      this._nif,
      this._ai,
      this._capital,
      this._activite,
      this._nis,
      this._codedouane,
      this._maposition,
      this._codePinEnabled);

  int _id;
  Uint8List _imageUint8List;
  String _codepin;
  String _raisonSociale;
  int _statut;
  String _adresse;
  String _addressWeb;

  String get addressWeb => _addressWeb;

  set addressWeb(String value) {
    _addressWeb = value;
  }

  String _ville;
  String _departement;
  String _pays;
  String _cp;
  String _telephone;
  String _telephone2;
  String _fax;
  String _mobile;
  String _mobile2;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String _email;
  String _site;
  String _rc;
  String _nif;
  String _ai;
  double _capital;
  String _activite;
  String _nis;
  String _codedouane;
  String _maposition;
  bool _codePinEnabled;


  bool get codePinEnabled => _codePinEnabled;

  set codePinEnabled(bool value) {
    _codePinEnabled = value;
  }

  Profile.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._imageUint8List = Helpers.getUint8ListFromByteString(obj["BytesImageString"].toString());
    this._raisonSociale = obj["Raison"];
    this._codepin = obj["CodePin"];
    this._statut = obj["Statut"];
    this._adresse = obj["Adresse"];
    this._addressWeb = obj["AdresseWeb"];
    this._ville = obj["Ville"];
    this._departement = obj["Departement"];
    this._pays = obj["Pays"];
    this._cp = obj["Cp"];
    this._telephone = obj["Telephone"];
    this._telephone2 = obj["Telephone2"];
    this._fax = obj["Fax"];
    this._mobile = obj["Mobile"];
    this._mobile2 = obj["Mobile2"];
    this._email = obj["Mail"];
    this._site = obj["Site"];
    this._rc = obj["Rc"];
    this._nif = obj["Nif"];
    this._ai = obj["Ai"];
    this._capital = obj["Capital"];
    this._activite = obj["Activite"];
    this._nis = obj["Nis"];
    this._codedouane = obj["Codedouane"];
    this._maposition = obj["Maposition"];
    this._codePinEnabled = obj["CodePinEnabled"] == 1? true : false;;

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if(_imageUint8List != null && _imageUint8List.isNotEmpty){
      map["BytesImageString"] = Helpers.getEncodedByteStringFromUint8List(_imageUint8List);
    }

    map["id"] = this._id;
    map["Raison"] = this._raisonSociale;
    map["Statut"] = this._statut;
    map["CodePin"] = this._codepin;
    map["Adresse"] = this._adresse;
    map["Ville"] = this._ville;
    map["Departement"] = this._departement;
    map["Pays"] = this._pays;
    map["Cp"] = this._cp;
    map["Telephone"] = this._telephone;
    map["Telephone2"] = this._telephone2;
    map["Fax"] = this._fax;
    map["Mobile"] = this._mobile;
    map["Mobile2"] = this._mobile2;
    map["Mail"] = this._email;
    map["Site"] = this._site;
    map["Rc"] = this._rc;
    map["Nif"] = this._nif;
    map["Ai"] = this._ai;
    map["Capital"] = this._capital;
    map["Activite"] = this._activite;
    map["Nis"] = this._nis;
    map["Codedouane"] = this._codedouane;
    map["Maposition"] = this._maposition;
    map["CodePinEnabled"] = this._codePinEnabled? 1 : 0;


    return map;
  }

  Uint8List get imageUint8List => _imageUint8List;

  set imageUint8List(Uint8List value) {
    _imageUint8List = value;
  }

  String get codepin => _codepin;

  set codepin(String value) {
    _codepin = value;
  }

  String get raisonSociale => _raisonSociale;

  set raisonSociale(String value) {
    _raisonSociale = value;
  }

  int get statut => _statut;

  set statut(int value) {
    _statut = value;
  }

  String get adresse => _adresse;

  set adresse(String value) {
    _adresse = value;
  }

  String get ville => _ville;

  set ville(String value) {
    _ville = value;
  }

  String get departement => _departement;

  set departement(String value) {
    _departement = value;
  }

  String get pays => _pays;

  set pays(String value) {
    _pays = value;
  }

  String get cp => _cp;

  set cp(String value) {
    _cp = value;
  }

  String get telephone => _telephone;

  set telephone(String value) {
    _telephone = value;
  }

  String get telephone2 => _telephone2;

  set telephone2(String value) {
    _telephone2 = value;
  }

  String get fax => _fax;

  set fax(String value) {
    _fax = value;
  }

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get mobile2 => _mobile2;

  set mobile2(String value) {
    _mobile2 = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get site => _site;

  set site(String value) {
    _site = value;
  }

  String get rc => _rc;

  set rc(String value) {
    _rc = value;
  }

  String get nif => _nif;

  set nif(String value) {
    _nif = value;
  }

  String get ai => _ai;

  set ai(String value) {
    _ai = value;
  }

  double get capital => _capital;

  set capital(double value) {
    _capital = value;
  }

  String get activite => _activite;

  set activite(String value) {
    _activite = value;
  }

  String get nis => _nis;

  set nis(String value) {
    _nis = value;
  }

  String get codedouane => _codedouane;

  set codedouane(String value) {
    _codedouane = value;
  }

  String get maposition => _maposition;

  set maposition(String value) {
    _maposition = value;
  }

}