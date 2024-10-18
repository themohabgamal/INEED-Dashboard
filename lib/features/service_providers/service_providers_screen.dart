import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvidersScreen extends StatelessWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مقدمين الخدمات',
          style: GoogleFonts.cairo(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceProviders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد مقدمي خدمات',
                style: GoogleFonts.cairo(),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var provider = snapshot.data!.docs[index];
              return _buildProviderCard(provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildProviderCard(QueryDocumentSnapshot provider) {
    String name = provider['name'] ?? 'لا يوجد اسم';
    String imageUrl = provider['image'] ?? '';
    String email = provider['email'] ?? 'لا يوجد بريد';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage(
                      'assets/images/default_avatar.png') // Placeholder image
                  as ImageProvider,
        ),
        title: Text(
          name,
          style: GoogleFonts.cairo(),
        ),
        subtitle: Text(
          email,
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }
}
