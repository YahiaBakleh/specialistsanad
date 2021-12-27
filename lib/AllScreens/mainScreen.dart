import 'package:flutter/material.dart';
import 'package:specialistsanad/tapsPages/earningsTabPage.dart';
import 'package:specialistsanad/tapsPages/homeTabPage.dart';
import 'package:specialistsanad/tapsPages/profileTabPage.dart';
import 'package:specialistsanad/tapsPages/ratingTabPage.dart';

class MainScreen extends StatefulWidget {
  static const idScreen = 'mainScreen';
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int selectedIndex = 0 ;

  void onTabSelected(int index){
    setState(() {
      selectedIndex = index ;
      tabController?.index = selectedIndex;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController= TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningsTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Earnings'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Rating'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),

        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14.0),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onTabSelected,
      ),
    );
  }
}
