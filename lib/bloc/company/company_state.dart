import 'package:Company/model/company.dart';

abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyDataSuccess extends CompanyState {
  Company company;
  CompanyDataSuccess({this.company});
}

class CompanyDataFailed extends CompanyState {}
