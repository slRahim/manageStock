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
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/ui/home.dart';
import 'HomeItemsWidgets.dart';
import 'package:gestmob/models/Profile.dart';


class NavDrawer extends  StatelessWidget {
  final MyParams myparams;
  final Profile profile ;
  NavDrawer({Key key, this.myparams, this.profile}) : super(key: key);

  List<Widget> homeItemWidgetList;
  List<HomeItem> homeItemList = [
    homeItemAccueil,
    homeItemTableauDeBord,
    homeItemArticles,
    homeItemClients,
    homeItemDevis,
    homeItemCommandeClient,
    homeItemBonDeLivraison,
    drawerItemRetourClient,
    homeItemFactureDeVente,
    drawerItemAvoirClient,
    homeItemFournisseurs,
    drawerItemBonDeCommande,
    homeItemBonDeReception,
    drawerItemRetourFournisseur,
    homeItemFactureDachat,
    drawerItemAvoirFournisseur,
    homeItemTresorerie,
    homeItemRapports,
    homeItemParametres,
    drawerItemExit
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
      DrawerHeader(
          decoration: BoxDecoration(
            // color: Colors.blue[900],
              gradient: LinearGradient(
                  colors: [Colors.blue[700], Colors.blue[900]],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  stops: [0.0, 0.5],
                  tileMode: TileMode.clamp)
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(
                RoutesKeys.profilePage,
              );
            },
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      child:(profile.imageUint8List == null)? CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue[700],
                        ),
                      ):CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: MemoryImage(profile.imageUint8List),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${profile.raisonSociale}" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 20),),
                            SizedBox(height: 2,),
                            Text(getTranslateVersion() , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ,),),
                            SizedBox(height: 2,),
                            Text("${S.current.until}: ${Helpers.dateToText(Helpers.getDateExpiration(myparams))}" , style: TextStyle(color: Colors.white),),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          ))
    ];

    if(myparams.versionType == "demo" ||
        Helpers.getDateExpiration(myparams).isBefore(DateTime.now()) ){
      homeItemWidgetList.add(getDrawerItemWidget(context, drawerItemPurchase));
      homeItemWidgetList.add(new Divider()) ;
    }


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
    return ListTile(
      dense: true,
      leading: iconsSet(data.id, 20),
      title: Text(
        data.title,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onTap: () => {
        Navigator.of(context).pop(),
        Helpers.handleIdClick(context, data.id),
      },
      trailing: (Helpers.isDirectionRTL(context))
          ? Icon(
        Icons.keyboard_arrow_left,
        color: Colors.white,
      )
          : Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white,
      ),
    );
  }

  String getTranslateVersion(){
    switch(myparams.versionType){
      case "demo" :
        return S.current.demo;
        break ;
      case "premium" :
        return S.current.premium;
        break ;
      case "beta" :
        return S.current.beta;
        break ;
    }
  }
}


