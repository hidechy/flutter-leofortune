import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'detail_display_screen.dart';

class MonthListScreen extends StatefulWidget {
  final String date;
  MonthListScreen({@required this.date});

  @override
  _MonthListScreenState createState() => _MonthListScreenState();
}

class _MonthListScreenState extends State<MonthListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _uranaiData = [];

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);

    //----------------------------------//
    _prevMonth = new DateTime(
        int.parse(_utility.year), int.parse(_utility.month) - 1, 1);
    _nextMonth = new DateTime(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 1);
    //----------------------------------//

    Map data = Map();

    String url = "http://toyohide.work/BrainLog/api/monthlyuranai";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json
        .encode({"date": '${_utility.year}-${_utility.month}-${_utility.day}'});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      if (response.body != 0) {
        data = jsonDecode(response.body);

        for (var i = 0; i < data['data'].length; i++) {
          _uranaiData.add(data['data'][i]);
        }
      }
    }

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 40, right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${_utility.year}-${_utility.month}'),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          tooltip: '前月',
                          onPressed: () => _goMonthlyListScreen(
                            context: context,
                            date: _prevMonth.toString(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          tooltip: '翌月',
                          onPressed: () => _goMonthlyListScreen(
                            context: context,
                            date: _nextMonth.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0),
              SizedBox(
                height: 10,
              ),
              dispHeaderLine(),
              Expanded(
                child: _uranaiList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Container dispHeaderLine() {
    return Container(
      padding: EdgeInsets.only(right: 50),
      child: Table(
        children: [
          TableRow(children: [
            Text(''),
            Container(
              alignment: Alignment.topRight,
              child: Text('Total'),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('Money'),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('Work'),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('Love'),
            ),
          ]),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _uranaiList() {
    return ListView.builder(
      itemCount: _uranaiData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /// リストアイテム表示
  Widget _listItem({int position}) {
    _utility.makeYMDYData(_uranaiData[position]['date'], 0);

    return Card(
      color: _utility
          .getBgColor('${_utility.year}-${_utility.month}-${_utility.day}'),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 12),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${_utility.day}（${_utility.youbiStr}）',
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '${_uranaiData[position]['point_total']}',
                                ),
                                //////////////////
                                decoration: (int.parse(_uranaiData[position]
                                            ['point_total']) >
                                        70)
                                    ? BoxDecoration(
                                        color: Colors.yellowAccent
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      )
                                    : null,
                                //////////////////
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '${_uranaiData[position]['point_money']}',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.topRight,
                              child: Container(
                                child: Text(
                                  '${_uranaiData[position]['point_work']}',
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '${_uranaiData[position]['point_love']}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 5,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${_uranaiData[position]['title_total']}',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap: () => _goDetailDisplayScreen(
            date: '${_uranaiData[position]['date']}',
          ),
          child: Icon(
            Icons.call_made,
            color: Colors.greenAccent,
            size: 20,
          ),
        ),
      ),
    );
  }

  ///
  _goDetailDisplayScreen({date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(date: date),
      ),
    );
  }

  ///
  _goMonthlyListScreen({BuildContext context, String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthListScreen(date: date),
      ),
    );
  }
}
