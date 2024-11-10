

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/features/categories/cat_controller.dart';
import 'package:yemen_services_dashboard/features/categories/image_widget.dart';

import '../../core/theme/colors.dart';

class AddSubCat extends StatefulWidget {
  const AddSubCat({super.key});

  @override
  State<AddSubCat> createState() => _AddSubCatState();
}

class _AddSubCatState extends State<AddSubCat> {



  CatController controller=Get.put(CatController());
  @override
  void initState() {
    controller.getCats();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        toolbarHeight: 22,
        backgroundColor:primaryColor
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          
        const  SizedBox(height: 12,),

         Column(
                    children: [
                      const SizedBox(height: 24),
                      ImageWidget(txt: 'اضف صورتك الشخصية'),
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
                              padding: EdgeInsets.all(8.0),
                              child:  Text("اضف قسم فرعي ",
                              style:TextStyle(
                                color:Colors.white,
                                fontSize: 21
                              ),
                              ),
                            ),
                          ),
                          onTap:(){
                            controller.addSubCategory(context);
                          },
                        )





        ],),
      ),
    );
  }
}