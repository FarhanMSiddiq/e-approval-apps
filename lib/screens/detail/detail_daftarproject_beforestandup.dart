import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imp_approval/data/data.dart';
import 'package:imp_approval/screens/create/create_detail_standup.dart';
import 'package:imp_approval/screens/create/create_standup.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailDaftarProject extends StatefulWidget {
  final Map project;
  const DetailDaftarProject({super.key, required this.project});

  @override
  State<DetailDaftarProject> createState() => _DetailDaftarProjectState();
}

class _DetailDaftarProjectState extends State<DetailDaftarProject>
    with WidgetsBindingObserver {
  SharedPreferences? preferences;
  int? differenceInDays;
  String? displayString;

  void initState() {
    super.initState();
    getUserData().then((_) {
      _dataFuture = getProject();
    });
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DateTime startDate = DateTime.parse(widget.project['start_date']);
    DateTime endDate = DateTime.parse(widget.project['end_date']);
    DateTime currentDate = DateTime.now();
    differenceInDays = endDate.difference(currentDate).inDays;
    displayString = "Tersisa $differenceInDays hari lagi";
  }

  bool isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  String _searchQuery = "";
  List<dynamic>? _filteredProjects;
  Future? _dataFuture;

  Future getProject() async {
    final String urlj = 'https://testing.impstudio.id/approvall/api/project';
    var response = await http.get(Uri.parse(urlj));
    print(response.body);
    return jsonDecode(response.body);
  }

  late Color statusColor;

  @override
  Widget build(BuildContext context) {
    widget.project['status'] == 'Aktif'
        ? statusColor = Color.fromARGB(255, 94, 202, 67)
        : statusColor = Color.fromARGB(255, 202, 67, 67);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.chevronLeft,
                      color: kButton,
                    ),
                    Text(
                      'Kembali',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: kButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.briefcase,
                  color: Color.fromRGBO(67, 129, 202, 1),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DETAIL",
                                style: GoogleFonts.getFont('Montserrat',
                                    color: kTextoo,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Text(widget.project['project'],
                                    style: GoogleFonts.getFont('Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.039,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: kTextUnselectedOpa,
                                            width: 0.5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Status",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselected,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      widget.project['status'].toString(),
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: statusColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: kTextUnselectedOpa,
                                            width: 0.5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Mulai",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselected,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      widget.project['start_date'].toString(),
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: kTextUnselectedOpa,
                                            width: 0.5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Selesai",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: kTextUnselected,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      widget.project['end_date'].toString(),
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.028,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.86,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kTextBlcknw, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            displayString ?? 'Loading...',
                                            style: GoogleFonts.getFont(
                                                'Montserrat',
                                                color: kTextBlcknw,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.028,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.86,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 1))
                                            ],
                                            color: kTextoo,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0))),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.86,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.32,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 1))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: kTextoo,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0),
                                                child: SvgPicture.asset(
                                                    "assets/img/impdetailproject.svg",
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    fit: BoxFit.cover),
                                              ),
                                              transform:
                                                  Matrix4.translationValues(
                                                      20, -20, 0),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Text(
                                                widget.project['partner']
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.getFont(
                                                    'Montserrat',
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              transform:
                                                  Matrix4.translationValues(
                                                      0, -15, 0),
                                            ),
                                            NotificationListener<
                                                OverscrollIndicatorNotification>(
                                              onNotification: (overscroll) {
                                                overscroll.disallowIndicator();
                                                return true;
                                              },
                                              child: SingleChildScrollView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                child: IntrinsicHeight(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 25.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.78,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.15,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Text(
                                                              widget.project[
                                                                  'partner_description'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: GoogleFonts.getFont(
                                                                  'Montserrat',
                                                                  height: 1.5,
                                                                  color:
                                                                      kTextBlcknw,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.028,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          transform: Matrix4
                                                              .translationValues(
                                                                  0, -10, 0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: GestureDetector(
                                onTap: () {
                                  // if (status == null) {

                                  // } else {
                                  setState(() {
                                    final project = {
                                      'projectname': widget.project['project'],
                                      'projectid': widget.project['id'],
                                    };

                                    print(project);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateDetailStandup(
                                          project: project,
                                        ),
                                      ),
                                    );
                                  });
                                  // }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.86,
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: kTextoo,
                                    border:
                                        Border.all(color: kTextoo, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Stand Up",
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.044,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
