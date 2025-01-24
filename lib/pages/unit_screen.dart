import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';
import 'package:rosantibike_mobile/widgets/header_widget.dart';
import 'package:rosantibike_mobile/widgets/unit/add_motor_bottom_sheet.dart';
import 'package:rosantibike_mobile/widgets/unit/unit_detail_screen.dart';
import 'package:rosantibike_mobile/widgets/unit/unit_list_card.dart';

import '../blocs/unit/unit_bloc.dart';
import '../blocs/unit/unit_events.dart';
import '../blocs/unit/unit_state.dart';
import '../api/jenis_motor_api.dart';
import '../theme/theme_provider.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  late JenisMotorBloc _jenisMotorBloc;

  @override
  void initState() {
    super.initState();
    _jenisMotorBloc = JenisMotorBloc(jenisMotorApi: JenisMotorApi());
    _jenisMotorBloc.add(FetchJenisMotors());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Adjust system UI
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(title: "Daftar Motor"),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<JenisMotorBloc, JenisMotorState>(
                  bloc: _jenisMotorBloc,
                  listener: (context, state) {
                    if (state is JenisMotorError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is JenisMotorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is JenisMotorError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }

                    if (state is JenisMotorLoaded) {
                      if (state.jenisMotors.isEmpty) {
                        return const Center(child: Text('Belum Ada Motor'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          _jenisMotorBloc.add(FetchJenisMotors());
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.jenisMotors.length,
                          itemBuilder: (context, index) {
                            final motor = state.jenisMotors[index];
                            return UnitListCard(
                              motor: motor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UnitDetailScreen(motor: motor),
                                ),
                              ),
                              onDelete: () =>
                                  _showDeleteConfirmation(context, motor),
                              onEdit: () =>
                                  _showEditMotorBottomSheet(context, motor),
                            );
                          },
                        ),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMotorBottomSheet(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Add Motor Bottom Sheet
  void _showAddMotorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => AddMotorBottomSheet(
        onSave: (newMotor) {
          _jenisMotorBloc
              .add(CreateJenisMotor(newMotor.toJson())); // Convert to Map
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditMotorBottomSheet(BuildContext context, JenisMotor motor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => AddMotorBottomSheet(
        motor: motor, // Pass the existing motor for editing
        onSave: (updatedMotor) {
          _jenisMotorBloc.add(UpdateJenisMotor(
              motor.id, updatedMotor.toJson())); // Convert to Map
          Navigator.pop(context);
        },
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmation(BuildContext context, JenisMotor motor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Hapus Motor', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Apakah Anda yakin ingin menghapus motor "${motor.stok.judul}"?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _jenisMotorBloc.add(DeleteJenisMotor(motor.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
