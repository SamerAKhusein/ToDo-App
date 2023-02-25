import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  validator: validate,
  onTap : onTap,
  onFieldSubmitted: (s){
    onSubmit!(s);
  },
  onChanged: (s){
    onChange!(s);
  },
  obscureText: isPassword! ,
  decoration: InputDecoration(
  labelText: label,
  enabled: isClickable,
  prefixIcon: Icon(
    prefix,
  ),
  suffixIcon: Icon(
    suffix,
  ),

  /*suffix != null ?
  IconButton(
    onPressed:suffixPressed,
      icon: Icon(suffix),
  ) : null,*/
  border: OutlineInputBorder(),

),
);

Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children:

      [

        CircleAvatar(

          radius: 40.0,

          child: Text(

              '${model['time']}'

          ),



        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children:

            [

              Text(

                '${model['title']}',

                style: TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 18.0



                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(



                  color: Colors.grey,



                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: ()

            {

              AppCubit.get(context).updateData(status: 'done', id: model['id']);



            },

            icon: Icon(

              Icons.check_box,

              color: Colors.green,

            ),

        ),

        IconButton(

          onPressed: ()

          {

            AppCubit.get(context).updateData(status: 'archived', id: model['id']);



          },

          icon: Icon(

            Icons.archive,

            color: Colors.black45,

          ),

        ),



      ],

    ),

  ),
  onDismissed: ((direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);

  }),
);