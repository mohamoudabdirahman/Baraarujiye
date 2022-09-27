// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:baraarujiyeapp/Colors/colors.dart';
import 'package:baraarujiyeapp/Model/Product_Model.dart';
import 'package:baraarujiyeapp/Screens/AddProduct.dart';
import 'package:baraarujiyeapp/Screens/ProductInformation.dart';
import 'package:baraarujiyeapp/Screens/expiredPoducts.dart';
import 'package:baraarujiyeapp/Screens/information.dart';
import 'package:baraarujiyeapp/utils/product_Tile.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  HomePage({this.products, Key? key}) : super(key: key);
  Products? products;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late FlutterLocalNotificationsPlugin fltrnotification;
  var expiringProducts;
  bool isexpired = false;
  var numberofexpired;
  late TabController tabController;
  //bool? istapped = false;
  Box<Products> databox = Hive.box<Products>('Products');
  var modeStatus = Hive.box('modeStatus');
  bool tapped = false;

  //PageController _controller = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    var checkingnull = modeStatus.get('darkmode');
    if (checkingnull == null) {
      setState(() {
        modeStatus.put('darkmode', true);
      });
    }
    var androidinitialize = AndroidInitializationSettings('app_icon');
    var iosinitialize = IOSInitializationSettings();
    var generalInitialization =
        InitializationSettings(android: androidinitialize, iOS: iosinitialize);
    fltrnotification = FlutterLocalNotificationsPlugin();
    fltrnotification.initialize(generalInitialization,
        onSelectNotification: notificationselected);
    tz.initializeTimeZones();
    for (var element in databox.values) {
      if (element.expiringDate!.isAfter(DateTime.now())) {
        numberofexpired = element.productName!.length;
      }
      var date = element.expiringDate!.subtract(const Duration(days: 30));
      var alert = formatDate(date, [d, " ", '', " ", '']);

      var day = formatDate(element.expiringDate!, [d, " ", '', " ", '']);
      print(day);
      int calculatedExpireDate = int.parse(alert) - int.parse(day);
      if (calculatedExpireDate <= 30) {
        print('it is expiring soon');
        _shownotification(
          element.productName!,
          element.description!,
        );
      }
      // if (element.expiringDate!.isBefore(DateTime.now())) {
      //   element.delete();
      // }
    }
  }

  Future _shownotification(String productname, String desc) async {
    var androidDetails = const AndroidNotificationDetails(
        'channelId2', 'ChannelDescription',
        importance: Importance.max, priority: Priority.high);
    var iosDetails = const IOSNotificationDetails();
    var generalDetals =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // await fltrnotification.show(
    //     0, 'Pasta', 'Pasta is expiring today', generalDetals);
    //var scheduledTime = DateTime.now().add(const Duration(seconds: 5));
    fltrnotification.periodicallyShow(
        1, productname, desc, RepeatInterval.daily, generalDetals);
    // zonedSchedule(1, productname, desc,
    //     dailynotification(const Time(10, 45)), generalDetals,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.time,
    //     androidAllowWhileIdle: true);
  }

  dailynotification(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final schedule = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return schedule;
    // return schedule.isBefore(now)
    //     ? schedule.add(const Duration(days: 1))
    //     : schedule;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().mainAppColor,
      appBar: AppBar(
        bottom: TabBar(
            controller: tabController,
            indicatorColor: AppColors().secondaryAppColor,
            labelColor: AppColors().fourthAppColor,
            unselectedLabelColor: AppColors().thirdAppColor,
            tabs: [
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Expired',
              ),
              Tab(
                text: 'Soon',
              )
            ]),
        backgroundColor: AppColors().mainAppColor,
        title: Text('BARAARUJIYE',
            style: GoogleFonts.montserrat(
                color: AppColors().thirdAppColor,
                letterSpacing: 3,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0.0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tabController.index == 1 || tabController.index == 2
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProductScren()));
                    },
                    backgroundColor: AppColors().secondaryAppColor,
                    child: Icon(
                      Icons.add,
                      color: AppColors().thirdAppColor,
                    ),
                  ),
          ],
        ),
      ),
      body: ValueListenableBuilder<Box<Products>>(
        valueListenable: Hive.box<Products>('Products').listenable(),
        builder: (context, box, _) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Today's Date",
                                style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    color: AppColors().thirdAppColor,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              formatDate(
                                  DateTime.now(), [d, ", ", M, " ", yyyy]),
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: AppColors().thirdAppColor),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              if (modeStatus.get('darkmode') == false) {
                                setState(() {
                                  modeStatus.put('darkmode', true);
                                });
                              } else if (modeStatus.get('darkmode') == true) {
                                setState(() {
                                  modeStatus.put('darkmode', false);
                                });
                              }
                            },
                            icon: Icon(
                              modeStatus.get('darkmode') == true
                                  ? Icons.light_sharp
                                  : Icons.dark_mode_sharp,
                              color: AppColors().thirdAppColor,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: TabBarView(controller: tabController, children: [
                      ListView.builder(
                          itemCount: box.values.length,
                          itemBuilder: ((context, index) {
                            Products currentProduct = box.getAt(index)!;
                            if (currentProduct.expiringDate!
                                .isAfter(DateTime.now())) {
                              return GestureDetector(
                                  onTap: () {
                                    print(currentProduct.productName);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductInfomation(
                                                  products: currentProduct,
                                                  index: index,
                                                  onclose: () {},
                                                )));
                                  },
                                  child: ProductTile(currentProduct, index));
                            } else if (numberofexpired == null &&
                                currentProduct.expired == true) {
                              return Center(
                                child: Text(
                                  'No recorded products yet!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors().fourthAppColor),
                                ),
                              );
                            }
                            return Container();
                          })),
                      ExpiredProducts(),
                      ProductInfo(notified: false,)
                    ]))
                  ]),
            ),
          );
        },
      ),
    );
  }

  void notificationselected(String? payload) async {
    //var expiringProducts = databox.values;
    showDialog(
        context: context,
        builder: (context) {
          return ProductInfo(notified: true,);
        });
  }
}
