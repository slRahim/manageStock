class CountryModel {
  int id;
  String name;
  String iso2;
  String iso3 ;
  String currency;
  String currencySymbol;
  String native;
  String emoji;
  String emojiU;
  Translations translations ;
  List<States> states;

  CountryModel(
      {this.id,
      this.name,
      this.iso2,
      this.iso3,
      this.currency,
      this.currencySymbol,
      this.native,
      this.emoji,
      this.emojiU,
      this.translations,
      this.states});

  CountryModel.init({this.name});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso2 = json["iso2"];
    iso3 = json["iso3"];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    native = json["native"];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    translations = new Translations.fromJson(json["translations"]);
    if (json['states'] != null) {
      states = new List<States>();
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data["iso2"] = this.iso2;
    data["iso3"] = this.iso3;
    data['currency'] = this.currency;
    data['currency_symbol'] = this.currencySymbol;
    data["native"] = this.native;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data["translations"] = this.translations.toJson();
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  var fa;
  var fr;

  Translations();

  Translations.fromJson(Map<String, dynamic> json) {
    fa = json["fa"];
    fr = json["fr"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["fa"] = this.fa;
    data["fr"] = this.fr;
    return data;
  }
}

class States {
  int id;
  String name;
  String stateCode;
  List<City> cities;

  States({this.id, this.name, this.stateCode, this.cities});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateCode = json['state_code'];
    if (json['cities'] != null) {
      cities = new List<City>();
      json['cities'].forEach((v) {
        cities.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_code'] = this.stateCode;
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int id;
  String name;

  City({
    this.id,
    this.name,
  });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
