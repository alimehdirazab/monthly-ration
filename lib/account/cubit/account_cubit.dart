import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_flutter_app/account/repository/repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.accountRepository) : super(const AccountState());
  final AccountRepository accountRepository;

  

}