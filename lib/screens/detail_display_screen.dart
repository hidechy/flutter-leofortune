import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../models/uranai.dart';

import '../utilities/utility.dart';

class DetailDisplayScreen extends StatefulWidget {
  final String date;

  const DetailDisplayScreen({Key key, this.date}) : super(key: key);

  ///
  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();

  List _uranaiData = [];

  final PageController pageController = PageController();

  int currentPage = 0;

  double lineHeight = 1.6;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //-------------------------------------------//
    String url = "http://toyohide.work/BrainLog/api/getMonthlyUranaiData";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final uranai = uranaiFromJson(response.body);
    _uranaiData = uranai.data;
    //-------------------------------------------//

    //
    var exDate = (widget.date).split('-');
    pageController.jumpToPage(int.parse(exDate[2]) - 1);

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

  ///
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

  ///
  Column dispUranaiDetail(int index) {
    _utility.makeYMDYData(_uranaiData[index].date.toString(), 0);

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
            '${_uranaiData[index].totalDescription}',
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
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        dispSachikoiLine(index),
      ],
    );
  }

  ///
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

  ///
  Row dispHeadLine(int index) {
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
            child: Text('${_uranaiData[index].totalTitle}'),
          ),
        ),
        Container(
          child: Text(
            '${_uranaiData[index].totalPoint}',
            style: TextStyle(fontSize: 26),
          ),
        ),
      ],
    );
  }

  ///
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
                '${_uranaiData[index].moneyPoint}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index].moneyDescription}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }

  ///
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
                '${_uranaiData[index].workPoint}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index].workDescription}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }

  ///
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
                '${_uranaiData[index].lovePoint}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(height: 10),
          Text(
            '${_uranaiData[index].loveDescription}',
            style: TextStyle(height: lineHeight),
          ),
        ],
      ),
    );
  }

  ///
  Widget dispSachikoiLine(int index) {
    _utility.makeYMDYData(_uranaiData[index].date.toString(), 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(
            color: Colors.indigo, height: 20.0, indent: 20.0, endIndent: 20.0),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(3),
          color: Colors.pinkAccent.withOpacity(0.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'さちこい（${_utility.year}-${_utility.month}-${_utility.day}の運勢）',
              ),
              Text('${_uranaiData[index].sachikoiRank}位')
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('金運'),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('${_uranaiData[index].sachikoiMoney}'),
        ),
        Container(
          child: Text('仕事運'),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('${_uranaiData[index].sachikoiWork}'),
        ),
        Container(
          child: Text('対人運'),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('${_uranaiData[index].sachikoiMan}'),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('恋愛運'),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('${_uranaiData[index].sachikoiLove}'),
        ),
      ],
    );
  }
}
