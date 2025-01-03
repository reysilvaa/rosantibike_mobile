import 'package:equatable/equatable.dart';
import 'package:rosantibike_mobile/model/transaksi.dart';

abstract class TransaksiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTransaksi extends TransaksiEvent {}

class UpdateTransaksi extends TransaksiEvent {
  final List<Transaksi> transaksis;
  

  UpdateTransaksi(this.transaksis);

  @override
  List<Object?> get props => [transaksis];
}
class SearchTransaksi extends TransaksiEvent {
  final String searchQuery;

  SearchTransaksi(this.searchQuery);
}