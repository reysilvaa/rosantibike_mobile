import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';
import 'package:rosantibike_mobile/model/stok.dart';

class AddMotorBottomSheet extends StatefulWidget {
  final Function(JenisMotor) onSave;
  final JenisMotor? motor; // Add motor as an optional parameter

  const AddMotorBottomSheet({
    Key? key,
    required this.onSave,
    this.motor, // This will be used when editing
  }) : super(key: key);

  @override
  _AddMotorBottomSheetState createState() => _AddMotorBottomSheetState();
}

class _AddMotorBottomSheetState extends State<AddMotorBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _nopolController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If motor is passed, pre-fill the fields for editing
    if (widget.motor != null) {
      _merkController.text = widget.motor!.stok.merk;
      _nopolController.text = widget.motor!.nopol;
      _statusController.text = widget.motor!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.motor == null ? 'Tambah Motor Baru' : 'Edit Motor',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _merkController,
              decoration: InputDecoration(
                labelText: 'Merk Motor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Merk motor tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nopolController,
              decoration: InputDecoration(
                labelText: 'Nomor Polisi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Nomor polisi tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _statusController,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Status tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMotor,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMotor() {
    if (_formKey.currentState!.validate()) {
      // Create a new Stok object
      final stok = Stok(
        id: 1, // Temporary placeholder; replace with actual ID from the server
        merk: _merkController.text,
        judul: _merkController.text, // Using merk as a placeholder for judul
        deskripsi1: "Deskripsi singkat", // Replace with actual value
        kategori: "Kategori motor", // Replace with actual value
        hargaPerHari: "100000", // Replace with actual value
        foto: "url_foto", // Replace with actual image URL or path
      );

      // Create a new JenisMotor object
      final newMotor = JenisMotor(
        id: widget.motor?.id ??
            1, // Use existing ID for editing, or 1 for new motor
        idStok: stok.id,
        nopol: _nopolController.text,
        status: _statusController.text,
        stok: stok,
      );

      widget.onSave(newMotor);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _merkController.dispose();
    _nopolController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
