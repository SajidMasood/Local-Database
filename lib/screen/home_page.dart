import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_in_flutter/constant/my_themes.dart';
import 'package:todo_in_flutter/controllers/task_controller.dart';
import 'package:todo_in_flutter/model/taskModel.dart';
import 'package:todo_in_flutter/services/theme_services.dart';

import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import 'add_task_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());
  final _themeServices = Get.find<ThemeServices>();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTasks(),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          _themeServices.switchTheme();
        },
        icon: Icon(Get.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
        color: _themeServices.color,
      ),
      title: const Text("Todo App"),
      actions: const [
        Icon(
          Icons.add_box_sharp,
          size: 20,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              lable: "+ Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          //_selectedDate = date;
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      // controller me model obs hai is wja se yhn Obx lgana hi
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            print(_taskController.taskList.length);
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("tapped");
                          // second param is Model class obj...
                          _showBottomSheet(
                              context, _taskController.taskList[index]);
                        },
                        child: TaskTile(_taskController.taskList[index]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context, TaskModel task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        // isCompleted by default is 0
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        // check for dark mode...
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        // bottom sheet have 4 child so i use column
        child: Column(
          children: [
            // item no 1...
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),

            // spacer take all the empty space
            Spacer(),
            // item no 2 btn if isCompleted or not
            task.isCompleted == 1
                ? Container()
                : _bottomSheetBTN(
                    context: context,
                    lable: 'Task Completed',
                    onTap: () {
                      // calling update method in controller
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            // btn 2 delete
            //SizedBox(height: 20),
            _bottomSheetBTN(
              context: context,
              lable: 'Delete Task',
              onTap: () {
                _taskController.delete(task);
                
                Get.back();
              },
              clr: Colors.red[300]!,
            ),

            // btn 3
            SizedBox(height: 20),
            _bottomSheetBTN(
              context: context,
              lable: 'Close',
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // BOTTOM SHET has 3 btns so we create reuseable btn
  // curly braces show optional param
  _bottomSheetBTN({
    required String lable,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            // yahan per condition k ander condition hai bhai
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            lable,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
