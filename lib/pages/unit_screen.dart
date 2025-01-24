// jenis_motor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_bloc.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_events.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_state.dart';
import 'package:rosantibike_mobile/widgets/header_widget.dart';

class UnitScreen extends StatelessWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JenisMotorBloc(
        jenisMotorApi: JenisMotorApi(),
      )..add(FetchJenisMotors()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(title: "Jenis Motor"), // Custom header
                const SizedBox(height: 20),
                // Add other widgets here (e.g. SearchBar, etc.)
                Expanded(
                  child: BlocBuilder<JenisMotorBloc, JenisMotorState>(
                    builder: (context, state) {
                      if (state is JenisMotorLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is JenisMotorError) {
                        print('Error: ${state.message}');
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }

                      if (state is JenisMotorLoaded) {
                        return ListView.builder(
                          itemCount: state.jenisMotors.length,
                          itemBuilder: (context, index) {
                            final jenisMotor = state.jenisMotors[index];
                            return ListTile(
                              title: Text(jenisMotor.stok.judul),
                              subtitle: Text(
                                  '${jenisMotor.stok.merk} - ${jenisMotor.nopol}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // TODO: Implement update functionality
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<JenisMotorBloc>().add(
                                            DeleteJenisMotor(jenisMotor.id),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return const Center(child: Text('No data'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implement create new Jenis Motor
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
