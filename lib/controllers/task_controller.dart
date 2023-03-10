import 'package:get/get.dart';
import 'package:todo_in_flutter/db/db_helper.dart';
import 'package:todo_in_flutter/model/taskModel.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <TaskModel>[].obs;

  // this method added data into db
  Future<int> addTask({TaskModel? taskModel}) async {
    return await DBHelper.insert(taskModel);
  }

  //get all the data from table
  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  }

  // delete controller method is required in db class
  void delete(TaskModel task) {
    DBHelper.delete(task);
    // is  call for to refresh the list
    getTasks();
  }

  // Update method ... isCompleted...
  Future<void> markTaskCompleted(int id) async {
    await DBHelper.update(id);
    // is  call for to refresh the list
    getTasks();
  }
}
