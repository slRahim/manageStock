class CountryModel {
  int id;
  String name;
  String emoji;
  String emojiU;
  List<Province> province;

  CountryModel({this.id, this.name, this.emoji, this.emojiU, this.province});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    if (json['state'] != null) {
      province = new List<Province>();
      json['state'].forEach((v) {
        province.add(new Province.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    if (this.province != null) {
      data['state'] = this.province.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Province {
  int id;
  String name;
  int countryId;
  List<City> city;

  Province({this.id, this.name, this.countryId, this.city});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    if (json['city'] != null) {
      city = new List<City>();
      json['city'].forEach((v) {
        city.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    if (this.city != null) {
      data['city'] = this.city.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int id;
  String name;
  int stateId;

  City({this.id, this.name, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}
