import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مقدمين الخدمات',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(Icons.search, size: 40),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // Update the search query
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ابحث عن مقدم خدمة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
                style: GoogleFonts.cairo(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                // Filter providers based on the search query
                var filteredProviders = snapshot.data!.docs.where((provider) {
                  String name = provider['name'] ?? '';
                  String email = provider['email'] ?? '';
                  return name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredProviders.length,
                  itemBuilder: (context, index) {
                    var provider = filteredProviders[index];
                    return _buildProviderCard(provider);
                  },
                );
              },
            ),
          ),
        ],
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
                  'assets/images/default_avatar.png'), // Placeholder image
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
