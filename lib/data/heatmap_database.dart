
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDatabase {
  List<Map<String, dynamic>> _tasks = [];
  Map<DateTime, int> heatMapDataSet = {};

  Future<void> fetchTasks() async {
    final subCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc('uid')
        .collection('memos');

    final taskDatas = await subCollectionRef.get();

    if (taskDatas != null) {
      _tasks.addAll(taskDatas.docs.map((doc) => doc.data()));
    }
  }



}


//
// Future<Map<DateTime, int>> getDataFromFirestore() async {
//
//
  //
  // // サブコレクションの参照を取得
  // final subCollectionRef = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc('uid')
  //     .collection('memos');

  // // サブコレクションからデータを取得
  // final snapshot = await subCollectionRef.get();
  // print(snapshot);
  //
  // //
  // // データをMap<DateTime, int>に変換
  // final dataMap = snapshot.docs.fold<Map<DateTime, int>>({}, (map, doc) {
  //   final data = doc.data();
  //   final dateString = data['date'] as String; // 日付を表す文字列
  //   final count = data['count'] as bool; // 数値データ
  //   final dateTime = DateTime.parse(dateString); // 日付文字列をDateTimeオブジェクトに変換
  //   map[dateTime] = count ? 1 : 0; // bool型のデータをint型に変換してMapに格納
  //   return map;
  // });
  //
  // return dataMap;
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../datetime/date_time.dart';
//
//
//
// class HabitDatabase {
//   List todaysTaskList = [];
//
//
//   final userTasks = FirebaseFirestore.instance.collection('users')
//       .doc('uid')
//       .collection('memos')
//       .snapshots();
//
//
//   Map<DateTime, int> heatMapDatas = {};
//
// }


//
//
// import 'package:hive_flutter/hive_flutter.dart';
//
// import '../datetime/date_time.dart';
//
// // reference our box
// final _myBox = Hive.box("Habit_Database");
//
// class HabitDatabase {
//   List todaysHabitList = [];
//   Map<DateTime, int> heatMapDataSet = {};
//
//   // create initial default data
//   void createDefaultData() {
//     todaysHabitList = [
//       ["Run", false],
//       ["Read", false],
//     ];
//
//     _myBox.put("START_DATE", todaysDateFormatted());
//   }
//
//   // load data if it already exists
//   void loadData() {
//     // if it's a new day, get habit list from database
//     if (_myBox.get(todaysDateFormatted()) == null) {
//       todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
//       // set all habit completed to false since it's a new day
//       for (int i = 0; i < todaysHabitList.length; i++) {
//         todaysHabitList[i][1] = false;
//       }
//     }
//     // if it's not a new day, load todays list
//     else {
//       todaysHabitList = _myBox.get(todaysDateFormatted());
//     }
//   }
//
//   // update database
//   void updateDatabase() {
//     // update todays entry
//     _myBox.put(todaysDateFormatted(), todaysHabitList);
//
//     // update universal habit list in case it changed (new habit, edit habit, delete habit)
//     _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
//
//     // calculate habit complete percentages for each day
//     calculateHabitPercentages();
//
//     // load heat map
//     loadHeatMap();
//   }
//
//   void calculateHabitPercentages() {
//     int countCompleted = 0;
//     for (int i = 0; i < todaysHabitList.length; i++) {
//       if (todaysHabitList[i][1] == true) {
//         countCompleted++;
//       }
//     }
//
//     String percent = todaysHabitList.isEmpty
//         ? '0.0'
//         : (countCompleted / todaysHabitList.length).toStringAsFixed(1);
//
//     // key: "PERCENTAGE_SUMMARY_yyyymmdd"
//     // value: string of 1dp number between 0.0-1.0 inclusive
//     _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
//   }
//
//   void loadHeatMap() {
//     DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
//
//     // count the number of days to load
//     int daysInBetween = DateTime.now().difference(startDate).inDays;
//
//     // go from start date to today and add each percentage to the dataset
//     // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
//     for (int i = 0; i < daysInBetween + 1; i++) {
//       String yyyymmdd = convertDateTimeToString(
//         startDate.add(Duration(days: i)),
//       );
//
//       double strengthAsPercent = double.parse(
//         _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
//       );
//
//       // split the datetime up like below so it doesn't worry about hours/mins/secs etc.
//
//       // year
//       int year = startDate.add(Duration(days: i)).year;
//
//       // month
//       int month = startDate.add(Duration(days: i)).month;
//
//       // day
//       int day = startDate.add(Duration(days: i)).day;
//
//       final percentForEachDay = <DateTime, int>{
//         DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
//       };
//
//       heatMapDataSet.addEntries(percentForEachDay.entries);
//       print(heatMapDataSet);
//     }
//   }
// }