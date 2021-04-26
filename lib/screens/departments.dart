import 'package:Company/bloc/company/company_bloc.dart';
import 'package:Company/bloc/company/company_event.dart';
import 'package:Company/model/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/company/company_state.dart';

class Deparments extends StatefulWidget {
  _DeparmentsState createState() => _DeparmentsState();
}

class _DeparmentsState extends State<Deparments> {
  CompanyBloc _companyBloc;
  List<Map> userData;

  @override
  void initState() {
    _companyBloc = BlocProvider.of<CompanyBloc>(context);
    _companyBloc.add(FetchCompanyData());
    // debugPrint('init=>');
    _companyBloc.listen(_companyListener);
    super.initState();
  }

  Future<void> _companyListener(CompanyState state) async {
    if (state is CompanyDataSuccess) {
      setState(() {
        userData = _constructData(state.company.data);
      });
    }
  }

  List<Map> _constructData(List<User> data) {
    Set<String> teams = Set<String>();
    List<User> tempData = data;
    Map<String, List> finalData = Map<String, List>();
    List<Map> finalArr = [];
    data.forEach((element) {
      teams.add(element.team);
    });

    teams.forEach((team) {
      finalData[team] = List();
      tempData.forEach((element) {
        if (team == element.team && !(finalData[team].contains(element))) {
          finalData[team].add(element);
        }
      });
    });
    finalData.entries.map((entry) {
      finalArr.add({entry.key: entry.value});
    }).toList();
    return finalArr;
  }

  void _onDismiss(int index, User user) {
    debugPrint('_onDismiss=> $index ${user.firstName}');
    setState(() {});
  }

  Container _buildGridView(List data) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 150),
        child: GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    'Users',
                    arguments: {'data': data[index], 'onDismiss': _onDismiss},
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('data'),
                          Text(
                            data[index].keys.toString().substring(
                                1, data[index].keys.toString().length - 1),
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          data[index].values.toList()[0].length > 0
                              ? Padding(
                                  padding: EdgeInsets.only(top: 30, bottom: 30),
                                  child: Row(children: [
                                    ..._buildAvatars(
                                        data[index].values.toList()[0] ??
                                            Container()),
                                  ]))
                              : Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text('No Users Found')),
                          data[index].values.toList()[0].length > 0
                              ? Text(
                                  data[index]
                                          .values
                                          .toList()[0]
                                          .length
                                          .toString() +
                                      ' participants',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              : Container()
                        ],
                      )),
                ));
          },
        ));
  }

  List<Widget> _buildAvatars(data) {
    int cnt = 0;
    return (data as List).length > 0
        ? (data as List).map((element) {
            if ((data as List).length > cnt++ && cnt <= 3)
              return Padding(
                  padding: EdgeInsets.only(
                      left: cnt == 2 ? 10 : 0, right: cnt == 2 ? 10 : 0),
                  child: CircleAvatar(
                      radius: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.network(
                          element.avatar,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person);
                          },
                        ),
                      )));
            else {
              return Container();
            }
          }).toList()
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: BlocBuilder<CompanyBloc, CompanyState>(
                  condition: (previous, current) {
                    return current is CompanyDataSuccess;
                  },
                  builder: (context, state) {
                    if (state is CompanyDataSuccess)
                      return Container(
                          // height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.all(15),
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "My groups\n",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87)),
                                        TextSpan(
                                            text:
                                                '${userData.length} groups created',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey))
                                      ]))),
                                  _buildGridView(userData)
                                ]);
                          }
                              // shrinkWrap: true,
                              // itemCount: userData.length,
                              // itemBuilder: (context, index) {
                              //   return Row(children: [
                              //     // Text(userData[index].keys.toString()),
                              //     _buildGridView(userData[index])
                              //     // Text(userData[index].values.toString()),
                              //   ]);
                              // })
                              ));
                    else if (state is CompanyDataFailed) {
                      return Text('Unable to get response');
                    } else {
                      return Container();
                    }
                  },
                ))));
  }
}
