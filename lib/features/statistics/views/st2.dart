
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';
import 'package:yemen_services_dashboard/features/offers/cutom_button.dart';
import 'package:yemen_services_dashboard/features/statistics/controller/st_controller.dart';
import '../../orders/model/proposal.dart';

class WorkerTasks2 extends StatefulWidget {
  String statusType;
  WorkerTasks2({super.key,required this.statusType});

  @override
  State<WorkerTasks2> createState() => _WorkerTasksState();
}


class _WorkerTasksState extends State<WorkerTasks2> {

  StController controller =
  Get.put(StController());


  @override
  void initState() {
    print("st=======${widget.statusType}");
    if(widget.statusType!='x'){
      controller.changeSelectedStatus(widget.statusType);
    }else{
      controller.getWorkerProposal();
      //controller.getWorkerProposal();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      GetBuilder<StController>(
          builder: (_) {
            return Scaffold(
              backgroundColor:backgroundColor,
              //AppColors.backgroundColor,
              appBar: AppBar(
                toolbarHeight: 90,
                elevation: 0.2,
                backgroundColor: appBarColor,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),

              ),
              body:
              (controller.proposalList.isNotEmpty)
                  ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Container(
                      decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color:primary
                        //.withOpacity(0.5)
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          const Text('المهام المقدمة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,fontWeight:FontWeight.bold
                              )),

                          const SizedBox(height: 8),
                          Center(
                            child: Row(
                              children: [
                                const SizedBox(width: 120,),
                                const Padding(
                                  padding: EdgeInsets.only(left:10.0,right: 10),
                                  child: Text(
                                    "اختر الحالة",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,fontWeight:FontWeight.w600
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width*0.57,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color:primary.withOpacity(0.8)
                                        // color: AppColors.DropDownColor,
                                      ),
                                      child: GetBuilder<StController>(builder: (_) {
                                        return DropdownButton<String>(
                                          underline: const SizedBox.shrink(),
                                          value: controller.selectedStatus,
                                          onChanged: (newValue) {
                                            controller.changeSelectedStatus(newValue!);
                                            //  controller.changeCatValue(newValue!);
                                          },
                                          items:
                                          controller.statusList.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width*0.40,
                                                  decoration:BoxDecoration(
                                                    color:Colors.black.withOpacity(0.6),
                                                    borderRadius: BorderRadius.circular(22),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Center(
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),



                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child:GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: controller.proposalList.length,
                          itemBuilder: (context, index) {
                            return
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TasksNewWidget(
                                  task: controller.proposalList[index],
                                ),
                              );
                            //   ProposalWidget(
                            //   task: controller.proposalList[index],
                            // );
                          }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            mainAxisSpacing: 10.0, // Spacing between rows
                            crossAxisSpacing: 10.0, // Spacing between columns
                            childAspectRatio: 1.2, // Aspect ratio of each item
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                color:backgroundColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 0),
                        Container(
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:primary
                            //.withOpacity(0.5)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text('المهام المقدمة',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,fontWeight:FontWeight.bold
                                  )),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  const Padding(
                                    padding: EdgeInsets.only(left:10.0,right: 10),
                                    child: Text(
                                      "اختر الحالة",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,fontWeight:FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Container(
                                      width: MediaQuery.of(context).size.width*0.57,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color:primary.withOpacity(0.8)
                                        // color: AppColors.DropDownColor,
                                      ),
                                      child: GetBuilder<StController>(builder: (_) {
                                        return DropdownButton<String>(
                                          underline: const SizedBox.shrink(),
                                          value: controller.selectedStatus,
                                          onChanged: (newValue) {
                                            controller.changeSelectedStatus(newValue!);
                                            //  controller.changeCatValue(newValue!);
                                          },
                                          items:
                                          controller.statusList.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Container(
                                                height: 44,
                                                width: MediaQuery.of(context).size.width*0.40,
                                                decoration:BoxDecoration(
                                                  color:Colors.black.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(22),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Center(
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      })),
                                ],
                              ),
                              const SizedBox(height: 19),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),


                        const SizedBox(height: 10),
                        Text(
                          'لا مهام قيد التنفيذ الان',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      );


  }
}

// ignore: must_be_immutable
class TasksNewWidget extends StatelessWidget {
  Proposal task;

  TasksNewWidget({super.key,required this.task});

  @override
  Widget build(BuildContext context) {
    print("IMAGE===${task.image}");
    return InkWell(
      child: Container(
        decoration:BoxDecoration(
          border: Border.all(color:primary,
              width: 0.3
          ),
          borderRadius: BorderRadius.circular(23),
          color:cardColor.withOpacity(0.2),
        ),
        child:Column(children: [
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius:BorderRadius.circular(13),
            child: CachedNetworkImage(
              height: 100,
              width: 222,
              imageUrl: task.image,
              fit:BoxFit.fill,
              placeholder: (context, url) =>const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>const Center(
                child: CircularProgressIndicator(),
              )
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "عنوان العمل المطلوب : ${task.title}",
            style: TextStyle(
                color: secondaryTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
            ),
          ),
          const SizedBox(height: 9,),
          Container(
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(12),
              color:greyTextColor.withOpacity(0.4),
            ),
            child:Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const SizedBox(height: 1,),
                  Text('تفاصيل موقع الخدمة ',
                    style:TextStyle(
                        color: secondaryTextColor,fontSize: 18
                    ),
                  ),

                  Text("اسم الموقع : ${task.locationName}",
                    style:TextStyle(
                        color:secondaryTextColor,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(" تفاصيل الموقع  : ${task.locationDes}",
                    style:TextStyle(
                        color:secondaryTextColor,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 5,),

                  InkWell(
                    child: Row(

                      children: [
                        const SizedBox(width: 12,),
                        Icon(Icons.location_on_rounded,
                          color:secondaryTextColor,
                        ),
                        const SizedBox(width: 12,),
                        Text
                          ('عرض الموقع علي الخريطة',
                          style:TextStyle(
                              decoration: TextDecoration.underline,
                              color:primary,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    onTap:(){
                      StController controller
                      =Get.put(StController());

                      controller.openMap(double.parse(task.lat),
                          double.parse(task.lng));
                    },
                  )


                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text('السعر  :   ',
                style:TextStyle(
                    color:secondaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
              Text("${task.price} ",
                style:TextStyle(
                    color:secondaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( ' حالة الطلب :',
                style:TextStyle(
                    fontWeight: FontWeight.w600,
                    color:secondaryTextColor,
                    fontSize: 18
                ),
              ),

              const   SizedBox(width: 9,),
              if (task.status == 'قيد المراجعة'
                  || task.status == 'pending'
              )
                Text('قيد المراجعة',
                  style:TextStyle(
                      color:secondaryTextColor,
                      fontSize: 17,fontWeight: FontWeight.w600
                  ),
                ),


              if (task.status == 'accepted'
              )
                const Text('تمت الموافقة',
                  style:TextStyle(
                      color:Colors.green,
                      fontSize: 22,fontWeight: FontWeight.w600
                  ),
                ),

              if (task.status == 'canceled')
                const Text('ملغي',
                  style:TextStyle(
                      color:Colors.red,
                      fontSize: 22,fontWeight: FontWeight.w600
                  ),
                ),
              //done
              if (task.status == 'done')
                const Text('تم الانتهاء',
                  style:TextStyle(
                      color:Colors.green,
                      fontSize: 22,fontWeight: FontWeight.w600
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),


          CustomButton(text: 'الغاء الطلب', onPressed: (){
            showDeleteDialog(
                context,
                task.id,
                'canceled'
            );

          })



        ],),
      ),
      onTap:(){


        // Get.to(ViewTask1(proposal: task,
        // ));
        //PropsalsNew
        // Get.to(PropsalsNew(
        //   task: task,
        //   proposalIndex: 1,
        // ));
      },
    );
  }
}

void showDeleteDialog(BuildContext context,String id,String status) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تأكيد العملية'),
        content: const Text('هل أنت متأكد أنك الغاء الطلب ؟'),
        actions: <Widget>[
          TextButton(
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
            onPressed: () {
              updateWorkerStatus(status,id);
              Navigator.of(context).pop();
              Get.snackbar('', 'تم  بنجاح',
                  backgroundColor:Colors.green,
                  colorText:Colors.white);
            },
          ),
          TextButton(
            child: const Text('الغاء', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> updateWorkerStatus(String status,String id)
async {
  StController controller
  =Get.put(StController());

  try {
    // Reference the 'buyService' collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('proposals');
    // Query documents where 'worker_email' matches the provided email
    QuerySnapshot querySnapshot =
    await collectionRef
        .where('id', isEqualTo: id)
        .get();
    // Loop through the documents to update each one's status to 'done'
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'status': status});
    }
    controller.getWorkerProposal();
  } catch (e) {
    print("Error updating status: $e");
  }
}

