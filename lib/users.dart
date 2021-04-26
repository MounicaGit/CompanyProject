import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  final Map arguments;
  final Function onDismiss;
  Users(this.arguments, {this.onDismiss});
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List arr;
  int userCnt;

  @override
  void initState() {
    _sortData();
    setState(() {
      userCnt = widget.arguments['data'].values.toList()[0].length;
    });
    super.initState();
  }

  _sortData() {
    arr = widget.arguments['data'].values.toList()[0] as List;
    arr.sort((a, b) => a.firstName.compareTo(b.firstName));
  }

  _buildListWidget() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.2,
        child: ListView.builder(
          // shrinkWrap: true,
          itemCount: arr.length,
          itemBuilder: (context, index) {
            return _buildUserRow(index);
          },
        ));
  }

  _buildUserRow(int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          widget.arguments['onDismiss'](index, arr[index]);
          arr.removeAt(index);
          setState(() {
            userCnt -= 1;
          });
        },
        child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              (index > 0)
                  ? arr[index - 1].firstName[0] != arr[index].firstName[0]
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orangeAccent,
                          ),
                          margin: EdgeInsets.only(bottom: 30),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            arr[index].firstName[0],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                      : Container()
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orangeAccent,
                      ),
                      margin: EdgeInsets.only(bottom: 30),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        arr[0].firstName[0],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(right: 15, left: 10),
                        child: CircleAvatar(
                            radius: 25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                arr[index].avatar,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person);
                                },
                              ),
                            ))),
                    Text(
                      arr[index].firstName + " " + arr[index].lastName,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ]))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: userCnt.toString(),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            TextSpan(
                                text: userCnt > 1
                                    ? " participants"
                                    : " participant",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ])),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                widget.arguments['data'].keys
                                    .toString()
                                    .substring(
                                        1,
                                        widget.arguments['data'].keys
                                                .toString()
                                                .length -
                                            1),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )),
                          userCnt > 0
                              ? _buildListWidget()
                              : Container(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          3),
                                  child: Center(child: Text('No user found')),
                                )
                        ])))));
  }
}
