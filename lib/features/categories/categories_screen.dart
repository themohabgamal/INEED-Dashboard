import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart'
    as Path; // Ensure to import this for path manipulation
import 'package:uuid/uuid.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _imageUrl;
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _uploadedFileURL;

  Future<void> imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Immediately set the image URL to display in the dialog
      setState(() {
        _imageUrl = pickedFile.path; // Set the picked image path
      });

      // Read the image as bytes for upload
      Uint8List imageData = await pickedFile.readAsBytes();
      print('picked');
      uploadImage(imageData);
    }
  }

  Future<String> uploadImage(Uint8List xfile) async {
    Reference ref = FirebaseStorage.instance.ref().child('Folder');
    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(
      xfile,
      SettableMetadata(contentType: 'image/png'),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _uploadedFileURL = downloadUrl;
    });
    print(downloadUrl);
    return downloadUrl;
  }

  Future<void> _addCategory() async {
    if (_uploadedFileURL == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اضافة الصورة واسم التصنيف')),
      );
      return;
    }

    // Check the number of existing categories
    final categoryCount =
        await FirebaseFirestore.instance.collection('cat').get();

    if (categoryCount.docs.length >= 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن إضافة أكثر من 12 تصنيف')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Add category to Firestore
      await FirebaseFirestore.instance.collection('cat').add({
        'name': _nameController.text,
        'image': _uploadedFileURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت اضافة التصنيف بنجاح')),
      );
      _nameController.clear();
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

  Future<void> _deleteCategory(String docId, String imageUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      await FirebaseFirestore.instance.collection('cat').doc(docId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم حذف التصنيف بنجاح')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحذف')));
    }
  }

  Future<void> _showAddCategoryDialog() async {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('صورة القسم الجديد',
                            style: GoogleFonts.cairo(fontSize: 18)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 150,
                          width: 200,
                          child: GestureDetector(
                            onTap: () async {
                              await imgFromGallery();
                              setState(
                                  () {}); // Call setState inside dialog to update the UI after image is picked
                            },
                            child: _imageUrl == null
                                ? Container(
                                    width: double.infinity,
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image,
                                        color: Colors.grey[600]),
                                  )
                                : Image.network(
                                    _imageUrl!, // Display selected image
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              labelText: 'اسم القسم',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ))),
                          style: GoogleFonts.cairo(),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () async {
                                  await _addCategory();
                                  Navigator.pop(
                                      context); // Close dialog after adding
                                },
                                child:
                                    Text('اضافة', style: GoogleFonts.cairo()),
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
        title: Text('الأقسام', style: GoogleFonts.cairo()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Button to open add category dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: _showAddCategoryDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('إضافة قسم جديد',
                        style: GoogleFonts.cairo(
                            color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Categories List
            _buildCategoriesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cat').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('لا توجد تصنيفات', style: GoogleFonts.cairo()));
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height *
              0.7, // Adjust height based on your design
          child: GridView.builder(
            // scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 6 / 7,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var category = snapshot.data!.docs[index];
              return _buildCategoryCard(category);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(QueryDocumentSnapshot category) {
    String docId = category.id;
    String name = category['name'];
    String imageUrl = category['image'];

    return Container(
      width: 160, // Adjust width based on your design
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 80,
                height: 120,
                errorWidget: (context, url, error) {
                  log(error.toString());
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: GoogleFonts.cairo(),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteCategory(docId, imageUrl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
