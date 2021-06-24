import 'dart:typed_data';

import 'package:gestmob/Helpers/Helpers.dart';

class Tiers {
  Tiers.init(this._clientFour);
  Tiers.empty();

  Tiers(
      this._imageUint8List,
      this._raisonSociale,
      this._qrCode,
      this._id_famille,
      this._statut,
      this._tarification,
      this._adresse,
      this._ville,
      this._telephone,
      this._mobile,
      this._fax,
      this._email,
      this._rc,
      this._nif,
      this._nis,
      this._ai,
      this._solde_depart,
      this._chiffre_affaires,
      this._regler,
      this._bloquer);

  int _id;
  int _clientFour;
  int originClientOrFourn;
  String _raisonSociale;
  double _latitude;
  double _longitude;

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String _qrCode;
  Uint8List _imageUint8List;
  int _id_famille;
  int _statut;
  int _tarification;

  int get tarification => _tarification;

  set tarification(int value) {
    _tarification = value;
  }

  String _adresse;
  String _ville;
  String _telephone;
  String _mobile;
  String _fax;
  String _email;
  String _rc;
  String _nif;
  String _ai;
  String _nis ;
  double _solde_depart;
  double _chiffre_affaires;
  double _regler;
  double _credit;
  bool _bloquer;

  Tiers.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._imageUint8List =
        Helpers.getUint8ListFromByteString(obj["BytesImageString"].toString());
    this._clientFour = obj["Clientfour"];
    this._raisonSociale = obj["RaisonSociale"];
    this._latitude = obj["Latitude"];
    this._longitude = obj["Longitude"];
    this._id_famille = obj["Id_Famille"];
    this._statut = obj["Statut"];
    this._qrCode = obj["QRcode"];
    this._tarification = obj["Tarification"];
    this._adresse = obj["Adresse"];
    this._ville = obj["Ville"];
    this._telephone = obj["Telephone"];
    this._mobile = obj["Mobile"];
    this._fax = obj["Fax"];
    this._email = obj["Email"];
    this._rc = obj["Rc"];
    this._nif = obj["Nif"];
    this._nis = obj["Nis"];
    this._ai = obj["Ai"];
    this._solde_depart = obj["Solde_depart"];
    this._chiffre_affaires = obj["Chiffre_affaires"];
    this._regler = obj["Regler"];
    this._credit = obj["Credit"];
    this._bloquer = (obj["Bloquer"] == 1) ? true : false;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (_imageUint8List != null && _imageUint8List.isNotEmpty) {
      map["BytesImageString"] =
          Helpers.getEncodedByteStringFromUint8List(_imageUint8List);
    }

    map["id"] = this._id;
    map["Clientfour"] = this._clientFour;
    map["RaisonSociale"] = this._raisonSociale;
    map["Latitude"] = this._latitude;
    map["Longitude"] = this._longitude;
    map["Id_Famille"] = this._id_famille;
    map["Statut"] = this._statut;
    map["QRcode"] = this._qrCode;
    map["Tarification"] = this._tarification;
    map["Adresse"] = this._adresse;
    map["Ville"] = this._ville;
    map["Telephone"] = this._telephone;
    map["Mobile"] = this._mobile;
    map["Fax"] = this._fax;
    map["Email"] = this._email;
    map["Rc"] = this._rc;
    map["Nif"] = this._nif;
    map["Nis"] = this._nis;
    map["Ai"] = this._ai;
    map["Solde_depart"] = this._solde_depart;
    map["Chiffre_affaires"] = this._chiffre_affaires;
    map["Regler"] = this._regler;
    map["Credit"] = this._solde_depart + this._chiffre_affaires - this._regler;
    map["Bloquer"] = (this._bloquer) ? 1 : 0;

    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get qrCode => _qrCode;

  set qrCode(String value) {
    _qrCode = value;
  }

  Uint8List get imageUint8List => _imageUint8List;

  set imageUint8List(Uint8List value) {
    _imageUint8List = value;
  }

  int get clientFour => _clientFour;

  bool get bloquer => _bloquer;

  set bloquer(bool value) {
    _bloquer = value;
  }

  double get credit => _credit;

  set credit(double value) {
    _credit = value;
  }

  double get regler => _regler;

  set regler(double value) {
    _regler = value;
  }

  double get chiffre_affaires => _chiffre_affaires;

  set chiffre_affaires(double value) {
    _chiffre_affaires = value;
  }

  double get solde_depart => _solde_depart;

  set solde_depart(double value) {
    _solde_depart = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get fax => _fax;

  set fax(String value) {
    _fax = value;
  }

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get telephone => _telephone;

  set telephone(String value) {
    _telephone = value;
  }

  String get ville => _ville;

  set ville(String value) {
    _ville = value;
  }

  String get adresse => _adresse;

  set adresse(String value) {
    _adresse = value;
  }

  int get statut => _statut;

  set statut(int value) {
    _statut = value;
  }

  int get id_famille => _id_famille;

  set id_famille(int value) {
    _id_famille = value;
  }

  String get raisonSociale => _raisonSociale;

  set raisonSociale(String value) {
    _raisonSociale = value;
  }

  set clientFour(int value) {
    _clientFour = value;
  }

  String get rc => _rc;

  set rc(String value) {
    _rc = value;
  }

  String get nif => _nif;

  set nif(String value) {
    _nif = value;
  }

  String get nis => _nis;

  set nis(String value) {
    _nis = value;
  }

  String get ai => _ai;

  set ai(String value) {
    _ai = value;
  }

  @override
  String toString() {
    return 'Tiers{_id: $_id, _clientFour: $_clientFour, originClientOrFourn: $originClientOrFourn, _raisonSociale: $_raisonSociale, _latitude: $_latitude, _longitude: $_longitude, _qrCode: $_qrCode, _imageUint8List: $_imageUint8List, _id_famille: $_id_famille, _statut: $_statut, _tarification: $_tarification, _adresse: $_adresse, _ville: $_ville, _telephone: $_telephone, _mobile: $_mobile, _fax: $_fax, _email: $_email, _solde_depart: $_solde_depart, _chiffre_affaires: $_chiffre_affaires, _regler: $_regler, _credit: $_credit, _bloquer: $_bloquer}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tiers && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
