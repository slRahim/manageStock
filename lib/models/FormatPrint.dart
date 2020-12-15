import 'package:esc_pos_utils/esc_pos_utils.dart';

class FormatPrint {
  int _id ;
  PaperSize _default_format ;
  String _default_display ;
  int _totalHt , _totalTva , _reste , _credit ;


  FormatPrint.init();

  FormatPrint(this._id, this._default_format, this._default_display,
      this._totalHt, this._totalTva, this._reste, this._credit);


  FormatPrint.fromMap(dynamic obj){
    this._id = obj['id'];
    this._default_format = (obj["Default_format"] == "80")?PaperSize.mm80 : PaperSize.mm58 ;
    this._default_display = obj["Default_display"];
    this._totalHt = obj["Total_ht"];
    this._totalTva = obj["Total_tva"];
    this._reste = obj["Reste"];
    this._credit = obj["Credit"];
  }

  Map<String , dynamic> toMap(){
    Map<String , dynamic> obj = new Map<String , dynamic>();
    obj["Default_format"]=(this._default_format == PaperSize.mm80) ? "80" : "58" ;
    obj["Default_display"] =this._default_display ;
    obj["Total_ht"]=this._totalHt ;
    obj["Total_tva"]=this._totalTva;
    obj["Reste"]=this._reste;
    obj["Credit"]=this._credit ;

    return obj ;
  }

  get credit => _credit;

  set credit(value) {
    _credit = value;
  }

  get reste => _reste;

  set reste(value) {
    _reste = value;
  }

  get totalTva => _totalTva;

  set totalTva(value) {
    _totalTva = value;
  }

  int get totalHt => _totalHt;

  set totalHt(int value) {
    _totalHt = value;
  }

  String get default_display => _default_display;

  set default_display(String value) {
    _default_display = value;
  }

  PaperSize get default_format => _default_format;

  set default_format(PaperSize value) {
    _default_format = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  @override
  String toString() {
    return 'FormatPrint{_id: $_id, _default_format: $_default_format, _default_display: $_default_display, _totalHt: $_totalHt, _totalTva: $_totalTva, _reste: $_reste, _credit: $_credit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormatPrint &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}