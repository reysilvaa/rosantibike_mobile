import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';

class UnitDetailScreen extends StatelessWidget {
  final JenisMotor motor;

  const UnitDetailScreen({Key? key, required this.motor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(motor.stok.merk),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'motor_image_${motor.id}',
                child: CachedNetworkImage(
                  imageUrl: motor.stok.foto ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.motorcycle,
                    size: 200,
                    color: theme.iconTheme.color,
                  ),
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context, 
              icon: Icons.motorcycle, 
              label: 'Merk', 
              value: motor.stok.merk
            ),
            _buildDetailRow(
              context, 
              icon: Icons.numbers, 
              label: 'Nomor Polisi', 
              value: motor.nopol
            ),
            _buildDetailRow(
              context, 
              icon: Icons.check_circle, 
              label: 'Status', 
              value: motor.status
            ),
            _buildDetailRow(
              context, 
              icon: Icons.image, 
              label: 'Judul Stok', 
              value: motor.stok.judul
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Edit motor logic
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon, 
    required String label, 
    required String value
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}