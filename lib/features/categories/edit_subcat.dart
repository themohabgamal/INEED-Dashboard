





import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/features/categories/cat_controller.dart';
import 'package:yemen_services_dashboard/features/categories/image_widget.dart';

import '../../core/theme/colors.dart';
import '../model/subCat_model.dart';

class EditSubCat extends StatefulWidget {
  SubCat subCat;

 EditSubCat({super.key,required this.subCat});

  @override
  State<EditSubCat> createState() => _AddSubCatState();
}

class _AddSubCatState extends State<EditSubCat> {



  CatController controller=Get.put(CatController());
  @override
  void initState() {
    controller.getCats();
    controller.subCatNameController.text=widget.subCat.name;
    Future.delayed(const Duration(seconds: 2)).then((value) =>
        controller.passCatValue(widget.subCat.cat));

   // controller.selectedItem=widget.subCat.cat;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          toolbarHeight: 71,
          backgroundColor:primaryColor
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<CatController>(
          builder: (_) {
            return ListView(children: [

              const  SizedBox(height: 12,),
              Column(
                children: [
                  (controller.imageUrl==null)?
                  ClipRRect(
                    borderRadius:BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl:widget.subCat.image,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>  Column(
                        children: [
                          SizedBox(
                              height: 71,
                              child: Image.asset('assets/logoXX.png')),
                          const SizedBox(height: 5,),
                          const Text(
                            maxLines: 7,
                            "هذا يعني ان صورة هذا القسم تعمل ولكنها لا تعمل علي بعض المتصفحات",
                            style:TextStyle(color:Colors.grey,
                                fontSize: 12
                            ),
                          )
                        ],
                      ),
                      //Image.network(subCat.image,
                      height: 124,
                    ),
                  ):const SizedBox(),
                  const SizedBox(height: 24),
                  const Text("اضغط هنا لتغيير صورة القسم  ",style:TextStyle(color:Colors.grey),),
                  ImageWidget(txt: 'اضغط هنا لتغيير صورة القسم  '),
                  const SizedBox(height: 20),
                ],
              ),
              TextField(
                controller: controller.subCatNameController,
                decoration:const InputDecoration(
                    hintText: 'اسم القسم الفرعي'
                ),

              ),
              const SizedBox(height: 30),

              const Row(
                children: [
                  Text(
                    "اختر القسم ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,fontWeight:FontWeight.w600
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Text("القسم الحالي : ${widget.subCat.cat}",style:const TextStyle(color:Colors.black),),
              const SizedBox(height: 5,),
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:Colors.grey[300],
                  ),
                  child: GetBuilder<CatController>(builder: (_) {
                    return DropdownButton<String>(
                      underline: const SizedBox.shrink(),
                      value: controller.selectedItem,
                      onChanged: (newValue) {
                        controller.changeCatValue(newValue!);
                      },
                      items:
                      controller.catListNames.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item,
                              style: const TextStyle(
                                  color: primaryColor),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  })),
              const SizedBox(height: 20),

              InkWell(
                child: const Card(
                  color:Colors.blue,
                  child:Padding(
                    padding: EdgeInsets.all(9.0),
                    child:  Center(
                      child: Text("تعديل  ",
                        style:TextStyle(
                            color:Colors.white,
                            fontSize: 21
                        ),
                      ),
                    ),
                  ),
                ),
                onTap:(){
                  if(controller.imageUrl==null){

                    controller.updateSubCategoryDocument(
                        widget.subCat.name,
                        {
                          "name": controller.subCatNameController.text,
                          "cat": controller.selectedItem,
                          "image": widget.subCat.image
                        }
                    );

                  }else{

                    controller.updateSubCategoryDocument(
                        widget.subCat.name,
                        {
                          "name": controller.subCatNameController.text,
                          "cat": controller.selectedItem,
                          "image": controller.imageUrl
                        }
                    );

                  }

                },
              )





            ],);
          }
        ),
      ),
    );
  }
}