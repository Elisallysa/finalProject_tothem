import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/tothem_theme.dart';
import '../../../tothem_icons.dart';

SizedBox buildUpperBox(
    BuildContext context, double screenArea, String imageName) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * screenArea,
      child: Image.asset('assets/images/$imageName'));
}

Container buildLowerBox(
    BuildContext context, Color color, bool wrongCredentials) {
  return Container(
    decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    child: Padding(
      padding: EdgeInsets.all(20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15.h),
          Text('Iniciar sesión', style: TothemTheme.title),
          SizedBox(height: 10.h),
          _reusableTextField(
              labelText: 'Email',
              hintText: 'usuario@mail.com',
              icon: const Icon(Tothem.mail)),
          SizedBox(
            height: 25.h,
          ),
          _reusableTextField(
              labelText: 'Contraseña',
              hintText: 'Introduzca su contraseña',
              icon: const Icon(Tothem.lock)),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Visibility(
              visible: wrongCredentials,
              child: const Text(
                'Usuario o contraseña erróneos.',
                style: TextStyle(fontSize: 12, color: TothemTheme.silver),
              ),
            ),
          ),
          _reusableClickableText(
              alignment: Alignment.bottomRight,
              text: '¿Has olvidado tu contraseña?',
              height: 40.h),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: TothemTheme.accentPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 10.h,
                shadowColor: const Color.fromARGB(255, 128, 36, 105),
                fixedSize: const Size(double.maxFinite, 50),
              ),
              onPressed: () {},
              child: Text('Iniciar sesión', style: TothemTheme.buttonTextW)),
          SizedBox(
            height: 20.h,
          ),
          Row(children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
            Text("o bien...", style: TothemTheme.silverText),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
          ]),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: TothemTheme.lightGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 10.h,
                shadowColor: const Color.fromARGB(255, 128, 36, 105),
                fixedSize: const Size(double.maxFinite, 50),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/icons/google24.png'),
                  Text('Iniciar sesión con Google',
                      style: TothemTheme.buttonTextB),
                ],
              )),
          SizedBox(
            height: 20.h,
          ),
          _reusableClickableText(
              alignment: Alignment.topCenter,
              text: '¿Nuevo usuario? Regístrate',
              height: 30.h),
        ],
      ),
    ),
  );
}

TextField _reusableTextField(
    {required String labelText, required String hintText, required Icon icon}) {
  return TextField(
    obscureText: true,
    decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        labelStyle: TothemTheme.silverText,
        hintText: hintText),
  );
}

Container _reusableClickableText(
    {required Alignment alignment,
    required String text,
    required double height}) {
  return Container(
    height: height,
    alignment: alignment,
    child: GestureDetector(
      onTap: () {},
      child: Text(text, style: TothemTheme.clickableText),
    ),
  );
}
