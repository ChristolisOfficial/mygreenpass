import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mycovidpass/reorder_page.dart';
import 'package:mycovidpass/scan_qr_code_page.dart';
import 'package:mycovidpass/utils/blue_curve_white_background_painter.dart';
import 'package:mycovidpass/utils/call_to_action_button.dart';
import 'package:mycovidpass/utils/covid_pass.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:mycovidpass/utils/storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mycovidpass/utils/white_background_painter.dart';

import 'about_page.dart';
import 'main.dart';
import 'utils/constants.dart';
import 'utils/navigation_bar_color.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:card_swiper/card_swiper.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';


final heightModifier = StateProvider((ref) => 0.7);

final certificates = StateProvider((ref) => Storage.certificates!);

// class CurrentIndexNotifier extends ChangeNotifier {
//   int _currentIndex = 0;
//   int get index => _currentIndex;
//
//   void setCurrentIndex(int index) {
//     _currentIndex = index;
//     notifyListeners();
//   }
// }

// final currentIndex = ChangeNotifierProvider((ref) => CurrentIndexNotifier());

int currentIndex = 0;

final currentIndexProvider = StateProvider<int>((ref) => currentIndex);

class CertificatesPage extends ConsumerStatefulWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  @override
  CertificatesPageState createState() => CertificatesPageState();
}

class CertificatesPageState extends ConsumerState<CertificatesPage> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('blue');

    var height = 0.7;

    var topOffset = MediaQuery.of(context).padding.top;

    var paddingBottom = MediaQuery.of(context).padding.bottom;
    var insetsBottom = MediaQuery.of(context).viewInsets.bottom;

    if (shouldSetBottomOffset) {
      shouldSetBottomOffset = false;
      if (paddingBottom > insetsBottom)
        bottomOffset = paddingBottom;
      else
        bottomOffset = insetsBottom;
    }

    var codes = ref.watch(certificates);
    // var activeIndex = ref.watch(currentIndexProvider);

    PageController pageController = PageController(
        viewportFraction: 0.88,
        keepPage: true,
        initialPage: 0
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: BlueCurveWhiteBackgroundPainter(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          (topOffset + bottomOffset),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.red)
                      // ),
                      child: PageView.builder(
                        controller: pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CovidPass(code: codes[index]),
                          );
                        },
                        itemCount: codes.length,
                      ),
                      // child: CarouselSlider.builder(
                      //   options: CarouselOptions(
                      //     enlargeCenterPage: true,
                      //     enableInfiniteScroll: false,
                      //     viewportFraction: 0.8,
                      //     height: MediaQuery.of(context).size.height,
                      //     enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      //     onPageChanged: (index, reason) {
                      //       setState(() {
                      //         _activeIndex = index;
                      //       });
                      //     },
                      //   ),
                      //   itemCount: codes.length,
                      //   itemBuilder: (BuildContext context, int itemIndex,
                      //           int pageViewIndex) {
                      //     // SchedulerBinding.instance?.addPostFrameCallback((_) {
                      //     //   setState(() {
                      //     //     _activeIndex = pageViewIndex;
                      //     //   });
                      //     // });
                      //       return CovidPass(code: codes[itemIndex]);},
                      // ),
                      // child: Swiper(
                      //   itemBuilder: (BuildContext context, int index){
                      //     return CovidPass(code: codes[index]);
                      //   },
                      //   itemCount: codes.length,
                      //   index: 0, // Storage.certificates!.length - 1,
                      //   scrollDirection: Axis.horizontal,
                      //   loop: false,
                      //   pagination: SwiperPagination(
                      //     margin: EdgeInsets.only(bottom: 80),
                      //     builder: DotSwiperPaginationBuilder(
                      //       size: 5,
                      //       color: Color.fromRGBO(255, 255, 255, 0.5),
                      //       activeSize: 10,
                      //       activeColor: COLOR_YELLOW,
                      //       space: 5
                      //     )
                      //   ),
                      //   // control: SwiperControl(),
                      //   viewportFraction: 0.83,
                      //   scale: 0.9,
                      //   // itemHeight: MediaQuery.of(context).size.height * 0.7,
                      //   // itemWidth: MediaQuery.of(context).size.width * 0.85,
                      //   // layout: SwiperLayout.CUSTOM,
                      //   // customLayoutOption: CustomLayoutOption(
                      //   //     startIndex: 0,
                      //   //     stateCount: 5
                      //   // )
                      //   //     .addOpacity(
                      //   //     [0.00, 0.65, 1.00, 1.0, 1.0]
                      //   // )
                      //   //     .addScale(
                      //   //     [0.75, 0.85, 0.93, 1.0, 1.0],
                      //   //     Alignment.center
                      //   // )
                      //   //     .addTranslate([
                      //   //   Offset(0.0, 145.0),
                      //   //   Offset(0.0, 85.0),
                      //   //   Offset(0.0, 40.0),
                      //   //   Offset(0.0, 0.0),
                      //   //   Offset(370.0, 0.0),
                      //   // ]),
                      // ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    (topOffset + bottomOffset),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 18, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/app_icon.svg', height: 45),
                          // Image(
                          //   image: AssetImage('assets/app_icon_checkmark.png'),
                          //   height: 45, // previously 60
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              'myCovidPass',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25), // previously 35
                              textScaleFactor: 1.0,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 56, // 45
                            width: 56, // 45
                            child: FittedBox(
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage(),
                                  ));
                                },
                                heroTag: 'info',
                                child:
                                    Icon(Icons.info_outline_rounded, size: 25),
                                backgroundColor: Colors.transparent,
                                foregroundColor: COLOR_BLACK,
                                // splashColor: Color.fromRGBO(0, 0, 0, 0),
                                elevation: 0,
                                highlightElevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.red)
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: codes.length > 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                height: 56, // 65
                                width: 56, // 65
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            ReorderPage()
                                      ));
                                    },
                                    heroTag: 'reorder',
                                    child: Icon(Icons.reorder, size: 30),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: COLOR_YELLOW,
                                    // splashColor: Color.fromRGBO(0, 0, 0, 0),
                                    elevation: 0,
                                    highlightElevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              // height: MediaQuery.of(context).size.width, // 65
                              // width: MediaQuery.of(context).size.width, // 65
                              child: FittedBox(
                                child: CallToActionButton(
                                  extended: false,
                                  icon: Icon(
                                    Icons.add_rounded,
                                    // size: 30,
                                  ),
                                  heroTag: 'add_certificate',
                                  label: 'Add',
                                  disabled: false,
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ScanQrCodePage()));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: codes.length > 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      (topOffset + bottomOffset),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height - (topOffset + bottomOffset)) * 0.11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                              controller: pageController,
                              count: codes.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: COLOR_YELLOW,
                                dotColor: COLOR_GLASS_WHITE,
                                dotHeight: 8,
                                dotWidth: 8,
                                expansionFactor: 4,
                              ),
                              onDotClicked: (index) {
                                // pageController.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                              }
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}