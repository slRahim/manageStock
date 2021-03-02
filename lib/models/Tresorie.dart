
class Tresorie {
  int _id;

  int _tierId;

  int _pieceId;

  int _mov;

  int _categorie;
  int _compte;

  int _charge;

  String _numTresorie;

  String _tierRS;

  String _modalite;

  String _objet;

  double _montant;

  DateTime _date;

  Tresorie.init();

  Tresorie(
      this._id,
      this._numTresorie,
      this._tierId,
      this._pieceId,
      this._mov,
      this._tierRS,
      this._modalite,
      this._objet,
      this._categorie,
      this._compte,
      this._charge,
      this._montant,
      this._date);

  Tresorie.fromMap(dynamic obj) {
    this._id = obj["id"];
    this._numTresorie = obj["Num_tresorie"];
    this._tierId = obj["Tier_id"];
    this._pieceId = obj["Piece_id"];
    this._mov = obj["Mov"];
    this._tierRS = obj["Tier_rs"];
    this._modalite = obj["Modalite"];
    this._objet = obj["Objet"];
    this._categorie = obj["Categorie_id"];
    this._compte = obj["Compte_id"];
    this._charge = obj["Charge_id"];
    this._montant = obj["Montant"];
    this._date = new DateTime.fromMillisecondsSinceEpoch(obj["Date"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();

    map["Num_tresorie"] = this._numTresorie;
    map["Piece_id"] = this._pieceId;
    map["Tier_id"] = this._tierId;
    map["Tier_rs"] = this._tierRS;
    map["Mov"] = this._mov;
    map["Modalite"] = this._modalite;
    map["Objet"] = this._objet;
    map["Categorie_id"] = this._categorie;
    map["Compte_id"] = this._compte;
    map["Charge_id"] = this._charge;
    map["Montant"] = this._montant;
    map["Date"] = this._date.millisecondsSinceEpoch;

    return map;
  }

  int get charge => _charge;

  set charge(int value) {
    _charge = value;
  }

  int get compte => _compte;

  set compte(int value) {
    _compte = value;
  }

  int get mov => _mov;

  set mov(int value) {
    _mov = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  double get montant => _montant;

  set montant(double value) {
    _montant = value;
  }

  get categorie => _categorie;

  set categorie(value) {
    _categorie = value;
  }

  get objet => _objet;

  set objet(value) {
    _objet = value;
  }

  get modalite => _modalite;

  set modalite(value) {
    _modalite = value;
  }

  String get tierRS => _tierRS;

  set tierRS(String value) {
    _tierRS = value;
  }

  get pieceId => _pieceId;

  set pieceId(value) {
    _pieceId = value;
  }

  String get numTresorie => _numTresorie;

  set numTresorie(String value) {
    _numTresorie = value;
  }

  int get tierId => _tierId;

  set tierId(int value) {
    _tierId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Tresorie{_id: $_id, _tierId: $_tierId, _pieceId: $_pieceId, _numTresorie: $_numTresorie, _tierRS: $_tierRS, _modalite: $_modalite, _objet: $_objet, _categorie: $_categorie, _montant: $_montant, _date: $_date}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tresorie && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
