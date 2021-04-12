import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class DetailDisplayScreen extends StatefulWidget {
  final String date;
  DetailDisplayScreen({@required this.date});

  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _uranaiData = List();

  double lineHeight = 1.6;

  final PageController pageController = PageController();

  // ページインデックス
  int currentPage = 0;

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
        ////////////////////////////////
        Map data2 = Map();

        String url2 = "http://toyohide.work/BrainLog/api/monthlyuranaidetail";
        Map<String, String> headers2 = {'content-type': 'application/json'};
        String body2 = json.encode(
            {"date": '${_utility.year}-${_utility.month}-${_utility.day}'});
        Response response2 = await post(url2, headers: headers2, body: body2);

        if (response2 != null) {
          if (response2.body != 0) {
            data2 = jsonDecode(response2.body);
          }
        }
        ////////////////////////////////

        data = jsonDecode(response.body);

        for (var i = 0; i < data['data'].length; i++) {
          Map _map = Map();

          _map['date'] = data['data'][i]['date'];

          var dailyRecord = _getDailyRecord(
              date: data['data'][i]['date'], detail: data2['data']);

          _map['total_title'] = dailyRecord['total']['title'];
          _map['total_description'] = dailyRecord['total']['description'];
          _map['total_point'] = dailyRecord['total']['point'];

          _map['love_description'] = dailyRecord['love']['description'];
          _map['love_point'] = dailyRecord['love']['point'];

          _map['money_description'] = dailyRecord['money']['description'];
          _map['money_point'] = dailyRecord['money']['point'];

          _map['work_description'] = dailyRecord['work']['description'];
          _map['work_point'] = dailyRecord['work']['point'];

          _uranaiData.add(_map);
        }
      }
    }

    //
    var ex_date = (widget.date).split('-');
    pageController.jumpToPage(int.parse(ex_date[2]) - 1);

    /////////////////////////////////
    // ページコントローラのページ遷移を監視しページ数を丸める
    pageController.addListener(() {
      int next = pageController.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    /////////////////////////////////

    setState(() {});
  }

  /**
   *
   */
  Map _getDailyRecord({date, detail}) {
    Map _map = Map();

    for (var i = 0; i < detail.length; i++) {
      if (detail[i]['date'] == date) {
        _map = detail[i];
        break;
      }
    }

    return _map;
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          PageView.builder(
            controller: pageController,
            itemCount: _uranaiData.length,
            itemBuilder: (context, index) {
              //--------------------------------------// リセット
              bool active = (index == currentPage);
              if (active == false) {}
              //--------------------------------------//

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: dispUranaiDetail(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Column dispUranaiDetail(int index) {
    _utility.makeYMDYData(_uranaiData[index]['date'], 0);

    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        dispYearMonthLine(),
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        dispHeadLine(index),
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        Container(
          height: size.height * 0.4,
          child: Text(
            '${_uranaiData[index]['total_description']}',
            style: TextStyle(height: lineHeight),
          ),
        ),
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        dispMoneyLine(index),
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        dispWorkLine(index),
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        dispLoveLine(index),
      ],
    );
  }

  /**
   *
   */
  Row dispYearMonthLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 20),
          child: Text('${_utility.year}-${_utility.month}'),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Row dispHeadLine(int index) {
    _utility.makeYMDYData(_uranaiData[index]['date'], 0);

    return Row(
      children: <Widget>[
        Container(
          child: Text(
            "${_utility.day}",
            style: TextStyle(fontSize: 26),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('${_uranaiData[index]['total_title']}'),
          ),
        ),
        Container(
          child: Text(
            '${_uranaiData[index]['total_point']}',
            style: TextStyle(fontSize: 26),
          ),
        ),
      ],
    );
  }

  /**
   *
   */
  Container dispMoneyLine(int index) {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '金運',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${_uranaiData[index]['money_point']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index]['money_description']}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Container dispWorkLine(int index) {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '仕事運',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${_uranaiData[index]['work_point']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index]['work_description']}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Container dispLoveLine(int index) {
    return Container(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '恋愛運',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${_uranaiData[index]['love_point']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index]['love_description']}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }
}
