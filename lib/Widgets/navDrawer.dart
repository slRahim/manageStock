import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/ui/home.dart';

import 'HomeItemsWidgets.dart';

// le nav drawer restyle
class NavDrawer extends StatelessWidget {
  var drawerHeaderColor = 0xFF1E90FF;

  List<Widget> homeItemWidgetList;
  List<HomeItem> homeItemList = [
    homeItemAccueil,
    homeItemTableauDeBord,
    homeItemArticles,
    homeItemClients,
    homeItemDevis,
    homeItemCommandeClient,
    homeItemBonDeLivraison,
    homeItemFactureDeVente,
    homeItemFournisseurs,
    homeItemBonDeReception,
    homeItemFactureDachat,
    homeItemTresorerie,
    homeItemRapports,
    homeItemParametres,
    drawerItemHelp,
    drawerItemExit
  ];

  List<Widget> getNavDrawerWidgetList(context) {
    homeItemWidgetList = <Widget>[
      DrawerHeader(
        child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(
                  RoutesKeys.profilePage,
              );
            },
            child: new Container(
              width: 500.0,
              padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,0,0,60),
                    child: Image(image: AssetImage('assets/logos/profile_logo.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,0,0,0),
                    child: Image(image: AssetImage('assets/logos/profile_logo.png')),
                  ),
                ],
              ),
            )
        ),
        decoration: BoxDecoration(color: Colors.blue[200]),
      )
    ];

    homeItemList.forEach((data) => {
          //chartBars list with info
          // add your ChartBar widget to the list with appropiate info
          homeItemWidgetList.add(getDrawerItemWidget(context, data)),

          homeItemWidgetList.add(
            new Divider(),
          )
        });

    return homeItemWidgetList;
  }


//the drawer item
  Widget getDrawerItemWidget(_context, data) {
    return ListTile(
      dense: true,
      leading: iconsSet(data.id, 20),
      title: Text(
        data.title,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onTap: () => {
        print(data.title),
        Navigator.of(_context).pop(),
        Helpers.handleIdClick(_context, data.id),
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Color.fromRGBO(41, 128, 185,1.0),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: getNavDrawerWidgetList(context),
      ),
    ));
  }
}
