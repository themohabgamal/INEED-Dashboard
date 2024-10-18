import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String? _imageUrl;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isImageUploading = false; // New variable to track image upload status
  String? _uploadedFileURL;

  Future<void> imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path; // Set the picked image path
        _isImageUploading = true; // Set uploading status to true
      });

      // Read the image as bytes for upload
      Uint8List imageData = await pickedFile.readAsBytes();
      print('picked');
      await uploadImage(imageData); // Await the image upload
    }
  }

  Future<void> uploadImage(Uint8List xfile) async {
    Reference ref = FirebaseStorage.instance.ref().child('offers');
    String id = const Uuid().v1();
    ref = ref.child(id);

    try {
      UploadTask uploadTask = ref.putData(
        xfile,
        SettableMetadata(contentType: 'image/png'),
      );
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _uploadedFileURL = downloadUrl; // Set the uploaded file URL
        _isImageUploading = false; // Reset upload status
      });
      print(downloadUrl);
    } catch (error) {
      setState(() {
        _isImageUploading = false; // Reset upload status on error
      });
      print('Upload error: $error');
    }
  }

  Future<void> _addOffer() async {
    if (_uploadedFileURL == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجي اضافة صورة و الانتظار حتي يتم رفعها اولا')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Add offer to Firestore
      await FirebaseFirestore.instance.collection('ads').add({
        'image': _uploadedFileURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت اضافة العرض بنجاح')),
      );
      _descriptionController.clear();
      setState(() {
        _imageUrl = null; // Clear the image URL
        _uploadedFileURL = null; // Clear uploaded file URL
      });
    } catch (error) {
      if (error is FirebaseException) {
        print('Firebase Error: ${error.message}');
      } else {
        print('Error: $error');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ ما')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _deleteOffer(String docId, String imageUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      await FirebaseFirestore.instance.collection('ads').doc(docId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم حذف العرض بنجاح')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحذف')));
    }
  }

// Inside _showAddOfferDialog()
  Future<void> _showAddOfferDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Align(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('صورة العرض الجديد',
                            style: GoogleFonts.cairo(fontSize: 18)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 200,
                          child: GestureDetector(
                            onTap: () async {
                              await imgFromGallery();
                              setState(
                                  () {}); // Update UI after image is picked
                            },
                            child: _imageUrl == null
                                ? _isImageUploading
                                    ? const CircularProgressIndicator()
                                    : Container(
                                        width: double.infinity,
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image,
                                            color: Colors.grey[600]),
                                      )
                                : Stack(
                                    children: [
                                      Image.network(
                                        _imageUrl!, // Use File for local image
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      if (_isImageUploading) // Show loading indicator if uploading
                                        Container(
                                          color: Colors.black54,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _uploadedFileURL == null || _isLoading
                              ? null // Disable the button until the image is uploaded
                              : () async {
                                  await _addOffer();
                                  Navigator.pop(
                                      context); // Close dialog after adding
                                },
                          child: Text('اضافة', style: GoogleFonts.cairo()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('العروض', style: GoogleFonts.cairo()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to open add offer dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: _showAddOfferDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('إضافة عرض جديد',
                        style: GoogleFonts.cairo(
                            color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Offers List
            _buildOffersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ads').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('لا توجد عروض', style: GoogleFonts.cairo()));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Flexible(
              // Changed from SizedBox to Flexible
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var offer = snapshot.data!.docs[index];
                  return _buildOfferCard(offer);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfferCard(QueryDocumentSnapshot offer) {
    String docId = offer.id;
    String imageUrl = offer['image'];

    return GestureDetector(
      onTap: () {
        // Add functionality for when the offer is tapped
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Card(
          elevation: 8, // Enhanced shadow effect
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16), bottom: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    height: 180,
                    width: double.infinity,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    _deleteOffer(docId, imageUrl);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
