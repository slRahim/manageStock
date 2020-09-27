

import 'dart:io';
import 'dart:typed_data';

import 'package:gestmob/Helpers/Helpers.dart';

class ArticleMarque {
  int _id;
  String _libelle;
  File _image;

  Uint8List _imageUint8List;

  Uint8List get imageUint8List => _imageUint8List;

  set imageUint8List(Uint8List value) {
    _imageUint8List = value;
  }

  set id(int value) {
    _id = value;
  }

  int get id=> _id;
  String get libelle=> _libelle;
  File get image=> _image;

  void setLibelle(String lib) {
    this._libelle=lib;
  }
  void setId(int id) {
    this._id=id;
  }
  void setpic(File img) {
    this._image=img;
  }

  ArticleMarque.init();
  ArticleMarque(this._id, this._libelle);

  ArticleMarque.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._libelle = obj["Libelle"];
    this._imageUint8List = Helpers.getUint8ListFromByteString(obj["BytesImageString"].toString());
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    String  _bytesImageString = Helpers.getEncodedByteStringFromFile(this._image);

    map["BytesImageString"] = _bytesImageString;
    map["Libelle"] = _libelle;
    return map;
  }

  @override
  String toString() {
    return _libelle;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleMarque &&
          runtimeType == other.runtimeType &&
          _libelle == other._libelle;

  @override
  int get hashCode => _libelle.hashCode;
}