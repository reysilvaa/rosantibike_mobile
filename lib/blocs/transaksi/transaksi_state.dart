import 'package:equatable/equatable.dart';
import 'package:rosantibike_mobile/model/transaksi.dart';

abstract class TransaksiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransaksiInitial extends TransaksiState {}

class TransaksiLoading extends TransaksiState {}

class TransaksiLoaded extends TransaksiState {
  final List<Transaksi> transaksis;

  TransaksiLoaded(this.transaksis);

  @override
  List<Object?> get props => [transaksis];
}

class TransaksiError extends TransaksiState {
  final String message;

  TransaksiError(this.message);

  @override
  List<Object?> get props => [message];
}