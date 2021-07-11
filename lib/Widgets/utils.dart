import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:google_fonts/google_fonts.dart';

// dropdown menus : marque , prix , famille article , famille tier , tiers  ,
//    && statut tier , tarification tiers , tva article

List<DropdownMenuItem<ArticleMarque>> buildMarqueDropDownMenuItems(
    List listItems) {
  List<DropdownMenuItem<ArticleMarque>> items = List();
  for (ArticleMarque listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.libelle , style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<int>> buildPriceDropDownMenuItems(List listItems) {
  List<DropdownMenuItem<int>> items = List();
  for (int listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.toString(), style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<ArticleFamille>> buildDropFamilleArticle(List listItems) {
  List<DropdownMenuItem<ArticleFamille>> items = List();
  for (ArticleFamille listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.libelle, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<TiersFamille>> buildDropFamilleTier(List listItems) {
  List<DropdownMenuItem<TiersFamille>> items = List();
  for (TiersFamille listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.libelle, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<Tiers>> buildDropClients(List listItems) {
  List<DropdownMenuItem<Tiers>> items = List();
  for (Tiers listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.raisonSociale, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<String>> buildDropStatutTier(List listItems) {
  List<DropdownMenuItem<String>> items = List();
  for (String listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<String>> buildDropTypeTier(List listItems) {
  List<DropdownMenuItem<String>> items = List();
  for (String listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<int>> buildDropTarificationTier(List listItems) {
  List<DropdownMenuItem<int>> items = List();
  for (int listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.toString(), style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<ArticleTva>> buildDropTvaDownMenuItems(List listItems) {
  List<DropdownMenuItem<ArticleTva>> items = List();
  for (ArticleTva listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text( "${S.current.taux_tva}: ${listItem.tva.toString()} %", style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<String>> buildDropStatutDownMenuItems(List listItems) {
  List<DropdownMenuItem<String>> items = List();
  for (String listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<String>> buildDropLanguageDownMenuItems(List listItems) {
  List<DropdownMenuItem<String>> items = List();
  for (String listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<TresorieCategories>> buildDropTresorieCategoriesDownMenuItems(List listItems) {
  List<DropdownMenuItem<TresorieCategories>> items = List();
  for (TresorieCategories listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.libelle, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<CompteTresorie>> buildDropCompteTresorieDownMenuItems(List listItems) {
  List<DropdownMenuItem<CompteTresorie>> items = List();
  for (CompteTresorie listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.nomCompte+" (${listItem.numCompte})", style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}

List<DropdownMenuItem<ChargeTresorie>> buildDropChargeTresorieDownMenuItems(List listItems) {
  List<DropdownMenuItem<ChargeTresorie>> items = List();
  for (ChargeTresorie listItem in listItems) {
    items.add(
      DropdownMenuItem(
        child: Text(listItem.libelle, style: GoogleFonts.lato(),),
        value: listItem,
      ),
    );
  }
  return items;
}