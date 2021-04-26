import 'dart:async';
import 'package:Company/http_client.dart';
import 'package:Company/model/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'company_state.dart';
import 'company_event.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  @override
  CompanyState get initialState => CompanyInitial();

  @override
  Stream<CompanyState> mapEventToState(
    CompanyEvent event,
  ) async* {
    CompanyDataSuccess dataState = CompanyDataSuccess();
    if (event is FetchCompanyData) {
      HTTPClient client = HTTPClient();
      List resp = await client.makeRequest();
      Company response = Company.fromJson(resp);
      dataState.company = response;
      yield dataState;
    }
  }
}
