import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks/archived_tasks.dart';
import 'package:todoapp/modules/done_tasks/done_tasks.dart';
import 'package:todoapp/modules/new_tasks/new_tasks.dart';
import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }


  void createDataBase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version )
        {
          print('Database Created');
          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value)
          {
            print('Table Created');
          }).catchError((onError){
            print('error${onError.toString()}');

          });

        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('Database Opened');
        }
    ).then((value)
    {
    database = value;
    emit(CreateDataBaseState());
    });
  }

insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async
  {
 await database.transaction((txn)
    async
    {
      txn.rawInsert
        (
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
        ).then((value)
        {
          emit(InsertToDatabaseState());
          print('$value inserted successfully');
          getDataFromDatabase(database);

        }).catchError((onError)
        {
        print('Error When inserted New Record ${onError.toString()}');
        });
    });


  }

  void getDataFromDatabase(database)
  {
    emit(GetDataFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];


      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });


      emit(GetDataFromDatabaseState());

    });
  }

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());

}

  void updateData({
    required String status,
    required int id,
  })async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? Where id = ?',
      ['$status',id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDataFromDatabaseState());
    });
  }

void deleteData({

  required int id,
})async
{
    database.rawUpdate(
      'DELETE FROM tasks Where id = ?',
      [id],
      ).then((value) {
        getDataFromDatabase(database);
        emit(DELETEDataFromDatabaseState());
    });
}


}