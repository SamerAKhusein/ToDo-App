import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/constants.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit , AppStates>(
      listener: (context, state) => {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(AppCubit.get(context).newTasks[index],context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 20.0
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],

          ),
        ),
        itemCount: AppCubit.get(context).newTasks.length,
      ),
    );
  }
}
