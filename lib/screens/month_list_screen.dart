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

  List<Map<dynamic, dynamic>> _uranaiData = List();

  /**
   * 初期動作
   */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /**
   * 初期データ作成
   */
  void _makeDefaultDisplayData() async {
    await _utility.makeYMDYData(widget.date, 0);

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

  /**
   *
   */
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

  /**
   *
   */
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
              child: Text('Love'),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('Money'),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text('Work'),
            ),
          ]),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _uranaiList() {
    return ListView.builder(
      itemCount: _uranaiData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
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
          child: Table(
            children: [
              TableRow(children: [
                Text('${_utility.day}（${_utility.youbiStr}）'),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_uranaiData[position]['point_total']}'),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_uranaiData[position]['point_love']}'),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_uranaiData[position]['point_money']}'),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_uranaiData[position]['point_work']}'),
                ),
              ]),
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap: () =>
              _goDetailDisplayScreen(date: '${_uranaiData[position]['date']}'),
          child: Icon(
            Icons.call_made,
            color: Colors.greenAccent,
            size: 20,
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  _goDetailDisplayScreen({date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(date: date),
      ),
    );
  }
}
