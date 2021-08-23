import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class NavDrawer extends StatelessWidget {
  final MyParams myparams;
  final Profile profile;
  NavDrawer({Key key, this.myparams, this.profile}) : super(key: key);

  List<Widget> homeItemWidgetList;
  List<HomeItem> homeItemList = [
    homeItemAccueil,
    homeItemTableauDeBord,
    homeItemArticles,
    drawerItemVente,
    drawerItemAchat,
    homeItemClients,
    homeItemFournisseurs,
    homeItemTresorerie,
    drawerItemFamilleMarque,
    homeItemRapports,
    drawerItemBackup,
    drawerItemExit
  ];

  List<HomeItem> venteItemList = [
    homeItemDevis,
    homeItemCommandeClient,
    homeItemBonDeLivraison,
    drawerItemRetourClient,
    homeItemFactureDeVente,
    drawerItemAvoirClient,
  ];

  List<HomeItem> achatItemList = [
    drawerItemBonDeCommande,
    homeItemBonDeReception,
    drawerItemRetourFournisseur,
    homeItemFactureDachat,
    drawerItemAvoirFournisseur,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: getNavDrawerWidgetList(context),
      ),
    ));
  }

  List<Widget> getNavDrawerWidgetList(context) {
    homeItemWidgetList = <Widget>[
      Container(
          height: 180,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        print(homeItemParametres.title);
                        Helpers.handleIdClick(context, homeItemParametres.id ,);
                      },
                      child: Icon(
                        LineIcons.cog,
                        color: Colors.white,
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(
                        RoutesKeys.profilePage,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: (profile.imageUint8List == null)
                              ? CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.blue[700],
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      MemoryImage(profile.imageUint8List),
                                ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${profile.raisonSociale}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  getTranslateVersion(),
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  (myparams.codeAbonnement != 'illimit')
                                      ? "${S.current.until}: ${Helpers.dateToText(Helpers.getDateExpiration(myparams))}"
                                      : S.current.illimite,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12)),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ];

    // if (myparams.versionType == "demo" ||
    //     Helpers.getDateExpiration(myparams).isBefore(DateTime.now())) {
    //   homeItemWidgetList.add(getDrawerItemWidget(context, drawerItemPurchase));
    //   homeItemWidgetList.add(new Divider());
    // }

    homeItemWidgetList.add(getDrawerItemWidget(context, drawerItemPurchase));
    homeItemWidgetList.add(new Divider());

    homeItemList.forEach((data) => {
          homeItemWidgetList.add(getDrawerItemWidget(context, data)),
          homeItemWidgetList.add(
            new Divider(),
          )
        });

    return homeItemWidgetList;
  }

//the drawer item
  Widget getDrawerItemWidget(context, data) {
    if (data.id == drawerItemVente.id || data.id == drawerItemAchat.id) {
      return ExpansionTile(
        leading: iconsSet(data.id, 20),
        title: Text(data.title,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            )),
        trailing: (Helpers.isDirectionRTL(context))
            ? Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              )
            : Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
        children: (data.id == drawerItemVente.id)
            ? [
                for (var e in venteItemList)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20),
                    child: ListTile(
                      leading: iconsSet(e.id, 20),
                      title: Text(e.title,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                      onTap: () {
                        print(e.title);
                        Navigator.of(context).pop();
                        Helpers.handleIdClick(context, e.id , myparams:myparams);
                      },
                    ),
                  )
              ]
            : [
                for (var e in achatItemList)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20),
                    child: ListTile(
                      leading: iconsSet(e.id, 20),
                      title: Text(e.title,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                      onTap: () {
                        print(e.title);
                        Navigator.of(context).pop();
                        Helpers.handleIdClick(context, e.id , myparams:myparams);
                      },
                    ),
                  )
              ],
      );
    } else {
      return Container(
        height: 45,
        // padding: EdgeInsets.only(bottom: 8 ,),
        child: ListTile(
          dense: true,
          leading: iconsSet(data.id, 20),
          title: Text(data.title,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )),
          onTap: () {
            print(data.title);
            Navigator.of(context).pop();
            Helpers.handleIdClick(context, data.id , myparams:myparams);
          },
        ),
      );
    }
  }

  String getTranslateVersion() {
    switch (myparams.versionType) {
      case "demo":
        return S.current.demo;
        break;
      case "premium":
        return S.current.premium;
        break;
    }
  }
}
