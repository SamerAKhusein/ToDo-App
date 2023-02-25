
// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener:(context, state) =>
        {
          if(state is InsertToDatabaseState)
          {
             Navigator.pop(context),
          }
        },
        builder: (context, state) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppCubit.get(context).titles[AppCubit.get(context).currentIndex],
              style: const TextStyle(
                fontSize: 25,

              ),
            ),

          ),
          body: ConditionalBuilder(
            condition: state is! GetDataFromDatabaseLoadingState,
            builder: (context) => AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            /* onPressed: () async{
              try{
                var name = await getName();
                print(name);
              }catch(error){
                print('error ${error.toString()}');
              }
            },*/
            /*onPressed: (){
             getName().then((value)
              {
                print(value);
              }).catchError((onError)
              {
                print('error ${onError.toString()}');
              });
            },*/
            onPressed: (){
              if(AppCubit.get(context).isBottomSheetShown)
              {
                if(formKey.currentState!.validate())
                {
                  AppCubit.get(context).insertToDatabase(title: titleController.text, date: dateController.text, time: timeController.text);
                  // insertToDatabase(
                  //   title: titleController.text,
                  //   time: timeController.text,
                  //   date: dateController.text,
                  // ).then((value) {
                  //
                  //   getDataFromDatabase(database).then((value)
                  //   {
                  //     Navigator.pop(context);
                  //     // setState(() {
                  //     //   tasks = value;
                  //     //   isBottomSheetShown = false;
                  //     //   fabIcon = Icons.edit;
                  //     // });
                  //   });
                  //
                  // });
                }
              }else
              {
                scaffoldKey.currentState!.showBottomSheet((context) => Container
                  (
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                        [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,

                            validate: (value)
                            {
                              if(value!.isEmpty){
                                return 'title must be not empty';
                              }
                              return null;

                            },
                            label: 'Task Title',
                            prefix: Icons.title,

                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,

                            onTap: ()
                            {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text = value!.format(context).toString();

                              });
                            },
                            validate: (value)
                            {
                              if(value!.isEmpty){
                                return 'time must be not empty';
                              }
                              return null;

                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,

                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,

                            onTap: ()
                            {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2022-12-18'),
                              ).then((value) {

                                dateController.text = DateFormat.yMMMd().format(value!);

                              });

                            },
                            validate: (value)
                            {
                              if(value!.isEmpty){
                                return 'date must be not empty';
                              }
                              return null;

                            },
                            label: 'Task Date',
                            prefix:  Icons.calendar_today,

                          ),


                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,

                ).closed.then((value) {

                  AppCubit.get(context).changeBottomSheetState(isShow: false, icon: Icons.edit,);
                  // setState(() {
                  //   fabIcon = Icons.edit;
                  // });
                });
                // setState(() {
                //   fabIcon = Icons.add;
                // });
                AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.add,);
              }


            },

            child: Icon(
              AppCubit.get(context).fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index){

              AppCubit.get(context).changeIndex(index);
              // setState(() {
              //   currentIndex =index;
              // });

            },
            items: const [
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.menu,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.check_circle_outline,
                ),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.archive,
                ),
                label: 'Archived',
              ),

            ],
          ),
        ),
      ),
    );
  }


}





