
class MyParams {

  int _id ;
  int _tarification ;
  bool _tva ;
  bool _timbre ;
  bool _notifications ;
  String _notificationTime ;
  int _notificationDay ;
  int _echeance ;

  MyParams.init();

  MyParams(this._id, this._tarification, this._tva , this._timbre ,
      this._notifications , this._notificationTime , this._notificationDay , this._echeance);

  MyParams.frommMap(dynamic map){
    this._id=map["id"];
    this._tarification=map["Tarification"];
    this._tva=(map["Tva"] == 1)?true:false;
    this._timbre = (map["Timbre"] == 1)?true : false;
    this._notifications=(map["Notifications"] == 1)? true :false;
    this._notificationTime=map["Notification_time"];
    this._notificationDay = map["Notification_day"];
    this._echeance = map["Echeance"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> map= new  Map<String , dynamic>();

    map["tarification"]=this._tarification;
    map["Tva"] = (this._tva)?1:0;
    map["Timbre"]=(this._timbre)?1:0;
    map["Notifications"]=(this._notifications)?1:0;
    map["Notification_time"]=this._notificationTime;
    map["Notification_day"]=this._notificationDay;
    map["Echeance"] = this._echeance ;

    return map ;
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