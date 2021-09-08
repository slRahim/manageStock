import 'package:esc_pos_utils/esc_pos_utils.dart';

class MyParams {

  int _id ;
  int _tarification ;
  bool _tva ;
  bool _timbre ;
  bool _autoverssement ;
  int _printDisplay ;
  bool _creditTier ;
  PaperSize _defaultFormatPrint ;
  bool _notifications ;
  String _notificationTime ;
  int _notificationDay ;
  int _echeance ;
  String _pays;
  String _devise ;

  //get from sharedPreferances
  //unused in constructors
  int _currencyDecimalText;

  String _versionType ;
  DateTime _startDate ;
  String _codeAbonnement ;

  MyParams.init();

  MyParams(this._id, this._tarification, this._tva , this._timbre , this._autoverssement, this._printDisplay , this._creditTier,
      this._defaultFormatPrint,this._notifications , this._notificationTime , this._notificationDay , this._echeance
      ,this._pays ,this._devise , this._versionType , this._startDate , this._codeAbonnement);

  MyParams.frommMap(dynamic map){
    this._id=map["id"];
    this._tarification=map["Tarification"];
    this._tva=(map["Tva"] == 1)?true:false;
    this._timbre = (map["Timbre"] == 1)?true : false;
    this._autoverssement = (map["AutoVerssement"] == 1 || map["AutoVerssement"] == null)?true : false;
    this._printDisplay=map["Print_display"];
    this._creditTier = (map["Credit_tier"] == 1)?true : false;
    this._defaultFormatPrint = (map["Default_format_print"] == "80")?PaperSize.mm80 : PaperSize.mm58 ;
    this._notifications=(map["Notifications"] == 1)? true :false;
    this._notificationTime=map["Notification_time"];
    this._notificationDay = map["Notification_day"];
    this._echeance = map["Echeance"];
    this._pays = map["Pays"];
    this._devise = map["Devise"];
    this._versionType = map["Verssion_type"];
    this._startDate = DateTime.fromMillisecondsSinceEpoch(map["Start_date"]);
    this._codeAbonnement = map["Code_abonnement"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map= new  Map<String , dynamic>();

    map["tarification"]=this._tarification;
    map["Tva"] = (this._tva)?1:0;
    map["Timbre"]=(this._timbre)?1:0;
    map["AutoVerssement"]=(this._autoverssement)?1:0;
    map["Print_display"]=this._printDisplay;
    map["Credit_tier"] = (this._creditTier)?1:0 ;
    map["Default_format_print"]=(this._defaultFormatPrint == PaperSize.mm80) ? "80" : "58" ;
    map["Notifications"]=(this._notifications)?1:0;
    map["Notification_time"]=this._notificationTime;
    map["Notification_day"]=this._notificationDay;
    map["Echeance"] = this._echeance ;
    map["Pays"]=this._pays ;
    map["Devise"]=this._devise ;
    map["Verssion_type"]=this._versionType ;
    map["Start_date"]=this._startDate.millisecondsSinceEpoch ;
    map["Code_abonnement"]=this._codeAbonnement ;

    return map ;
  }

  bool get autoverssement => _autoverssement;

  set autoverssement(bool value) {
    _autoverssement = value;
  }

  bool get creditTier => _creditTier;

  set creditTier(bool value) {
    _creditTier = value;
  }

  String get devise => _devise;

  set devise(String value) {
    _devise = value;
  }

  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  String get codeAbonnement => _codeAbonnement;

  set codeAbonnement(String value) {
    _codeAbonnement = value;
  }

  String get versionType => _versionType;

  set versionType(String value) {
    _versionType = value;
  }

  String get pays => _pays;

  set pays(String value) {
    _pays = value;
  }

  PaperSize get defaultFormatPrint => _defaultFormatPrint;

  set defaultFormatPrint(PaperSize value) {
    _defaultFormatPrint = value;
  }

  int get printDisplay => _printDisplay;

  set printDisplay(int value) {
    _printDisplay = value;
  }

  int get echeance => _echeance;

  set echeance(int value) {
    _echeance = value;
  }

  int get notificationDay => _notificationDay;

  set notificationDay(int value) {
    _notificationDay = value;
  }

  String get notificationTime => _notificationTime;

  set notificationTime(String value) {
    _notificationTime = value;
  }

  bool get notifications => _notifications;

  set notifications(bool value) {
    _notifications = value;
  }

  bool get timbre => _timbre;

  set timbre(bool value) {
    _timbre = value;
  }

  bool get tva => _tva;

  set tva(bool value) {
    _tva = value;
  }

  int get tarification => _tarification;

  set tarification(int value) {
    _tarification = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get currencyDecimalText => _currencyDecimalText;

  set currencyDecimalText(int value) {
    _currencyDecimalText = value;
  }

  @override
  String toString() {
    return 'MyParams{_id: $_id, _tarification: $_tarification, _tva: $_tva, _timbre: $_timbre, _notifications: $_notifications, _notificationTime: $_notificationTime, _notificationDay: $_notificationDay}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyParams && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;


}