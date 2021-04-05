import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

// represante la page de l'ajout ou representation de l'image (profile , article , tiers )
class ImagePickerWidget extends StatefulWidget {
  final bool editMode;
  final int scallFactor;
  final File imageFile;
  final Function(File imageFile) onImageChange;

  const ImagePickerWidget(
      {Key key, @required this.editMode, this.onImageChange, this.scallFactor, this.imageFile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ImagePickerWidgetState();
  }
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    _imageFile = widget.imageFile;
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset:
                    Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: _imageFile == null
                  ? Center(child: Text(S.current.ajout_image , style: GoogleFonts.lato(textStyle : TextStyle(color : Colors.black)),))
                  : new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: new FileImage(_imageFile),
                      radius: 200.0,
                    ),
            ),
          ),
          widget.editMode
              ? Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: new IconButton(
                          color: Colors.black,
                          icon: new Icon(
                            Icons.photo_camera,
                            size: 30,
                            color: Colors.blue[700],
                          ),
                          onPressed: widget.editMode
                              ? () {
                                  choiceImage(ImageSource.camera, setState);
                                }
                              : null,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: new IconButton(
                          color: Colors.black,
                          icon: new Icon(
                            Icons.photo_library,
                            size: 30,
                            color: Colors.blueGrey,
                          ),
                          onPressed: widget.editMode
                              ? () {
                                  choiceImage(ImageSource.gallery, setState);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: 5,
                ),

          Padding(padding: EdgeInsets.all(10)),
        ]);
  }

  Future choiceImage(ImageSource source, setState) async {
    var pickedImage = await _imagePicker.getImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        widget.onImageChange(_imageFile);
      } else {
        _imageFile = null;
      }
    });
  }
}
