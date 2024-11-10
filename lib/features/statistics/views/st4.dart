
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_services_dashboard/core/theme/colors.dart';
import 'package:yemen_services_dashboard/features/offers/cutom_button.dart';
import 'package:yemen_services_dashboard/features/statistics/controller/st_controller.dart';

import '../../orders/model/proposal.dart';

class ServicesOrders extends StatefulWidget {

  String statusType;
  ServicesOrders({super.key,required this.statusType});

  @override
  State<ServicesOrders> createState() => _WorkerTasksState();
}

class _WorkerTasksState extends State<ServicesOrders> {

  StController controller =
  Get.put(StController());

  @override
  void initState() {

    print("st=======${widget.statusType}");
    if(widget.statusType=='x'){
      controller.getWorkerBuyServices();
    }else{
      // controller.changeSelectedStatus
      //   (widget.statusType);
      controller.changeSelectedStatusForBuyServices
        (widget.statusType);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StController>(
        builder: (_) {
          if(controller.isBuyServicesLoading==false){
            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
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
                  title: const Column(
                    children: [


                      SizedBox(
                        height: 10,
                      ),

                    ],
                  )),
              body:const Center(child:
              CircularProgressIndicator()
                ,),
            );
          }else{
            return GetBuilder<StController>(
              builder: (co) {
                return Scaffold(
                  backgroundColor:backgroundColor,
                  //AppColors.backgroundColor,
                  appBar: AppBar(
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
                  body: controller.buySerivcesList.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Container(
                          height: 9,
                          color: primary,
                        ),
                        Container(
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color:primary
                            //.withOpacity(0.5)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 1),
                              const Text('طلبات الخدمات',
                                  style: TextStyle(
                                      color:Colors.white,
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
                                            controller.changeSelectedStatusForBuyServices(newValue!);
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
                                                    padding: const EdgeInsets.all(1.0),
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
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: controller.buySerivcesList.length,
                            itemBuilder: (context, index) {
                              return
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TasksNewWidget(
                                    task: controller.buySerivcesList[index],
                                    controller: controller,
                                  ),
                                );

                              //   ProposalWidget(
                              //   task: controller.proposalList[index],
                              // );
                            }, gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          )
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    color:backgroundColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color:primary
                                //.withOpacity(0.5)
                              ),
                              child: Column(
                                children: [
                                  const  SizedBox(height: 12,),
                                  const Text('طلبات الخدمات',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,fontWeight:FontWeight.bold
                                      )),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const SizedBox(width: 10,),
                                      const Padding(
                                        padding: EdgeInsets.only(left:1.0,right: 1),
                                        child: Center(
                                          child: Text(
                                            "اختر الحالة",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,fontWeight:FontWeight.w600
                                            ),
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
                                                controller.changeSelectedStatusForBuyServices
                                                  (newValue!);
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
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),

                            const SizedBox(height: 34),


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
    );
  }
}

class TasksNewWidget extends StatelessWidget {
  StController controller;
  Proposal task;
  TasksNewWidget({super.key,required this.task
    ,required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration:BoxDecoration(
            border:Border.all(color:primary,
                width: 0.4
            ),
            borderRadius: BorderRadius.circular(23),
            color:cardColor.withOpacity(0.2)
          //.withOpacity(0.5)
        ),
        child:Column(children: [

          ClipRRect(
            borderRadius:BorderRadius.circular(13),
            child: Image.network

              (task.image2,
              fit:BoxFit.fill,
              height: 110,
              width: 222,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "عنوان العمل المطلوب : "+ task.title2,
            style: TextStyle(
                color: secondaryTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
            ),
          ),
          const SizedBox(height: 8),


          (task.locationName.length>1)?
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

                  Text("اسم الموقع : "+task.locationName,
                    style:TextStyle(
                        color:secondaryTextColor,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(" تفاصيل الموقع  : "+task.locationDes,
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
                      controller.openMap(double.parse(task.lat),
                          double.parse(task.lng));
                    },
                  )


                ],
              ),
            ),
          ):const SizedBox(),

          const SizedBox(height: 8),
          Text("السعر : "+task.price+" ",
            style:TextStyle(
                color:secondaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
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



          // if (task.status == 'قيد المراجعة')
          //   Container(
          //     padding: const EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Center(
          //         child: Text( 'الغاء الطلب',
          //           style:TextStyle(
          //               color:mainTextColor,
          //               fontSize: 17,fontWeight: FontWeight.w600
          //           ),
          //         )),
          //   ),
        ],),
      ),
      onTap:(){
        //
        // Get.to(ViewTask2
        //   (proposal: task
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

