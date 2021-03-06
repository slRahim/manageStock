import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/services/cloud_backup_restore.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:google_fonts/google_fonts.dart';

class Selectfromdrive extends StatefulWidget {
  @override
  _SelectfromdriveState createState() => _SelectfromdriveState();
}

class _SelectfromdriveState extends State<Selectfromdrive> {
  GoogleApi googleapi;
  ga.FileList files = new ga.FileList();
  QueryCtr _query = new QueryCtr();

  refreshfileslist() async {
    await googleapi.ListGoogleDriveFiles().then((alist) {
      setState(() {
        files = alist;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    googleapi = GoogleApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await googleapi.GoogleLogout();
                    setState(() {
                      files.files.clear();
                    });
                    refreshfileslist();
                  })
            ],
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  googleapi.GoogleLogout();
                  Navigator.pop(context);
                }),
            title: Text(
              "${S.current.backups}",
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: FutureBuilder(
                                future: refreshfileslist(),
                                builder: (context, snapshot) {
                                  if (files.files == null) {
                                    return Container(
                                        height: 100.0,
                                        width: 100.0,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ));
                                  }
                                  return ListView.builder(
                                      padding: EdgeInsets.all(5),
                                      itemCount: files.files.length,
                                      itemBuilder: (context, i) {
                                        if (files.files[i].name
                                            .startsWith('gestmob_'))
                                          return buildList(files.files[i]);

                                        return null;
                                      });
                                })),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
//          ),
      ),
    );
  }

  Widget buildList(ga.File file) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.yellow[700],
          child: CircleAvatar(
            radius: 20,
            child: Icon(
              Icons.restore,
              color: Colors.white,
              size: 26,
            ),
            backgroundColor: Colors.green,
          ),
        ),
        onTap: () async {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: "${S.current.restore_data}",
              desc: "${S.current.restore_msg}",
              btnCancelText: S.current.non,
              btnCancelOnPress: () {},
              btnOkText: S.current.oui,
              btnOkOnPress: () => restoreData(file))
            ..show();
        },
        title: Text('${file.name.replaceAll('.bkp', '')}',
            style: GoogleFonts.lato(
                textStyle: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ))),
        subtitle: Text(
          ".bkp",
          style: GoogleFonts.lato(
              textStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
          )),
        ),
      ),
    );
  }

  restoreData(ga.File file) async {
    File backup ;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => FutureProgressDialog(
          googleapi.DownloadGoogleDriveFile(file.name, file.id)
              .then((value) async{
            if (value != null) {
              backup = value ;
            } else {
              Helpers.showToast("${S.current.msg_ereure}");
            }
          }).catchError((e)=>{
            Helpers.showToast("${S.current.msg_ereure}")
          }),
          message: Text('${S.current.telechargement}...'),
          progress: CircularProgressIndicator(),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ));

    if(backup != null){
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => FutureProgressDialog(
            _query.restoreBackup(backup).then((value) {
              Navigator.pop(context);
              if (value != null) {
                Navigator.pop(context);
                Helpers.showToast(
                     "${S.current.msg_succes_restoration}");
              } else {
                Helpers.showToast(
                    "${S.current.msg_err_restoration}");
              }
            }).catchError((e)=>{
              Navigator.pop(context),
              Helpers.showToast("${S.current.msg_err_restoration}")
            }),
            message: Text('${S.current.chargement}...'),
            progress: CircularProgressIndicator(),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ));
    }

  }
}
