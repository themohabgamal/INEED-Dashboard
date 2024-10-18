import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المستخدمين',
          style: GoogleFonts.cairo(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد مستخدمين',
                style: GoogleFonts.cairo(),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return _buildUserCard(user);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(QueryDocumentSnapshot user) {
    String email = user['email'] ?? 'لا يوجد بريد';
    String imageUrl = user['image'] ?? '';
    String name = user['name'] ?? 'لا يوجد اسم';
    String phone = user['phone'] ?? 'لا يوجد رقم';

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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email, style: GoogleFonts.cairo()),
            Text(phone, style: GoogleFonts.cairo()),
          ],
        ),
      ),
    );
  }
}
