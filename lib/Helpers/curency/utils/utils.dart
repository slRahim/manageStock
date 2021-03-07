
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/curency/countries.dart';
import 'package:gestmob/Helpers/curency/country.dart';

class CurrencyPickerUtils {
  static Country getCountryByIsoCode(String isoCode) {
    try {
      return countryList.firstWhere(
        (country) => country.isoCode.toLowerCase() == isoCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }

  static String getFlagImageAssetPath(String isoCode) {
    return "assets/flags/${isoCode.toLowerCase()}.png";
  }

  static Widget getDefaultFlagImage(Country country) {
    return Image.asset(
      CurrencyPickerUtils.getFlagImageAssetPath(country.isoCode),
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
    );
  }

  static Country getCountryByCurrencyCode(String currencyCode) {
    try {
      return countryList.firstWhere(
        (country) => country.currencyCode.toLowerCase() == currencyCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception(
          "The initialValue provided is not a supported country code!");
    }
  }
}
