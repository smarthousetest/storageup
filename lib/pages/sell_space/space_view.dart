import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:file_picker/file_picker.dart';

class SpaceSellPage extends StatefulWidget {
  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();
  SpaceSellPage();
}

class _SpaceSellPageState extends State<SpaceSellPage> {
  Future<List<String?>?> getFilesPaths() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      List<String?> file_paths = result.paths;
      return file_paths;
    } else {
      return null;
    }
  }

  var index = 0;
  double _currentSliderValue = 32;
  //int _valueForSlider = _currentSliderValue.toInt();
  S translate = getIt<S>();
  Widget build(BuildContext context) {
    return Expanded(
      // Padding(
      //   padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
      //   child:
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Container(
            height: 46,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color.fromARGB(25, 23, 69, 139),
                              blurRadius: 4,
                              offset: Offset(1, 4))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 46,
                  child: Row(
                    children: [
                      Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color.fromARGB(25, 23, 69, 139),
                                      blurRadius: 4,
                                      offset: Offset(1, 4))
                                ]),
                            child: Center(
                              child: SvgPicture.asset(
                                  "assets/file_page/settings.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23.0),
                          child: Image.asset('assets/home_page/man.jpg'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Александр Рождественский",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                            ),
                          ),
                          Text(
                            "votreaa@mail.ru",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).bottomAppBarColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IndexedStack(
          index: index,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromARGB(25, 23, 69, 139),
                          blurRadius: 4,
                          offset: Offset(1, 4))
                    ],
                  ),
                  // Padding(
                  //         padding: const EdgeInsets.only(right: 40),
                  //         child: Container(
                  //           //height: 375,
                  //           child: Image.asset(
                  //             'assets/file_page/man3.png',
                  //             //fit: BoxFit.fitWidth,
                  //           ),
                  //         ),
                  //       ),

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Container(
                            width: 130,
                            child: Text(
                              translate.sell_space,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 20, right: 40),
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Container(
                            child: Text(
                              translate.how_work,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 15),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  translate.rent_space +
                                      "\n" +
                                      translate.make_money,
                                  style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 15),
                          child: Container(
                            child: Text(
                              translate.select_folder +
                                  "\n" +
                                  translate.store_files +
                                  "\n" +
                                  translate.money,
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Container(
                            child: Text(
                              translate.money_two_step,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: Color(0xff868FFF),
                                    shape: BoxShape.circle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  child: Text(
                                    translate.folder,
                                    style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: Color(0xff868FFF),
                                    shape: BoxShape.circle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  child: Text(
                                    translate.size_of_space,
                                    style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 15),
                          child: Container(
                            child: Text(
                              translate.upload_file +
                                  "\n" +
                                  translate.your_balance,
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, top: 20, right: 40),
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Container(
                            child: Text(
                              translate.not_storage,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 20),
                          child: Container(
                            height: 42,
                            width: 200,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  index = 1;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Theme.of(context).splashColor,
                              ),
                              child: Text(
                                translate.add_location,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(child: addSpace(context))
          ],
        ),
      ]),
    );
  }

  Widget addSpace(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromARGB(25, 23, 69, 139),
                  blurRadius: 4,
                  offset: Offset(1, 4))
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Row(children: [
                Container(
                  child: Text(
                    translate.sell_space + " / ",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1?.color,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    translate.add_location,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 20,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 26),
              child: Row(children: [
                Container(
                  child: Text(
                    translate.select_storage,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    child: Image.asset(
                      'assets/file_page/prompt.png',
                    ),
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Container(
                    height: 42,
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).cardColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Color(0xffE4E7ED), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Color(0xffE4E7ED), width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    height: 42,
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () async {
                        List<String?>? list = await getFilesPaths();
                        print(list);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Theme.of(context).splashColor,
                      ),
                      child: Text(
                        translate.overview,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 25),
                child: Container(
                  child: Text(
                    translate.set_size,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 16,
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 10),
                child: Container(
                  child: Text(
                    translate.min_storage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 14,
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Container(
                  child: Text(
                    translate.max_storage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 14,
                    ),
                  ),
                )),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Container(
                    width: 350,
                    height: 20,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).dividerColor,
                        inactiveTrackColor: Theme.of(context).dividerColor,
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 8.0,
                        thumbColor: Theme.of(context).primaryColor,
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                        //thumbShape:
                        //RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        min: 32,
                        max: 180,
                        value: _currentSliderValue,
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Container(
                    height: 42,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _currentSliderValue.toInt().toString() + " ГБ",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 50, right: 40),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 25),
                child: Container(
                  child: Text(
                    translate.yuor_income,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 16,
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Container(
                  child: Text(
                    translate.our_tarff,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1?.color,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 14,
                    ),
                  ),
                )),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 40, top: 30),
                    child: Container(
                      child: Text(
                        translate.earnings,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 16,
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 27, top: 30),
                  child: Container(
                    width: 140,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "6₽/день",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 31),
              child: Container(
                height: 42,
                width: 200,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xffE4E7ED),
                  ),
                  child: Text(
                    translate.save,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );

    //       ),
    //     ]),
    //   ),
    // );
    //     ),
    //   ]),
    // ));
  }
}
