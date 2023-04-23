import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme/tothem_theme.dart';
import '../../../common/assets/tothem_icons.dart';

SizedBox buildUpperBox(
    BuildContext context, double screenArea, String imageName) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * screenArea,
      child: Image.asset('assets/images/$imageName'));
}

Container buildLowerBox(
    {required BuildContext context,
    required Color color,
    required bool wrongCredentials,
    required String title,
    required void Function(String value)? mailFunction,
    required void Function(String value)? pwdFunction,
    void Function(String value)? rePwdFunction,
    required void Function() buttonFunction,
    required void Function() googleButtonFunction}) {
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
          _reusableForm(
              wrongCredentials: wrongCredentials,
              title: title,
              mailFunction: mailFunction,
              pwdFunction: pwdFunction,
              rePwdFunction: rePwdFunction),
          ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: TothemTheme.accentPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 10.h,
                shadowColor: const Color.fromARGB(255, 128, 36, 105),
                fixedSize: const Size(double.maxFinite, 50),
              ),
              onPressed: buttonFunction,
              child: Text(title, style: TothemTheme.buttonTextW)),
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
              onPressed: googleButtonFunction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/icons/google24.png'),
                  Text(
                      title.contains('Iniciar')
                          ? 'Iniciar sesión con Google'
                          : 'Regístrate con Google',
                      style: TothemTheme.buttonTextB),
                ],
              )),
          SizedBox(
            height: 20.h,
          ),
          _reusableClickableText(
              alignment: Alignment.topCenter,
              text: title.contains('Iniciar')
                  ? '¿Nuevo usuario? Regístrate'
                  : 'Volver al inicio de sesión',
              height: 30.h,
              context: context),
        ],
      ),
    ),
  );
}

Form _reusableForm(
    {required String title,
    required bool wrongCredentials,
    void Function(String value)? mailFunction,
    required void Function(String value)? pwdFunction,
    void Function(String value)? rePwdFunction}) {
  return Form(
    child: Column(
      children: [
        SizedBox(height: 15.h),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(title, style: TothemTheme.title)),
        SizedBox(height: 10.h),
        _reusableTextField(
            labelText: 'Email',
            hintText: 'usuario@mail.com',
            icon: const Icon(Tothem.mail),
            function: (value) => mailFunction!(value)),
        SizedBox(
          height: 20.h,
        ),
        _reusableTextField(
            labelText: 'Contraseña',
            hintText: 'Introduce su contraseña',
            icon: const Icon(Tothem.lock),
            function: (value) => pwdFunction!(value)),
        SizedBox(
          height: 20.h,
        ),
        Visibility(
          visible: title == 'Regístrate',
          child: Column(children: [
            _reusableTextField(
                labelText: 'Confirmar contraseña',
                hintText: 'Repite tu contraseña',
                icon: const Icon(Tothem.lock),
                function: (value) => rePwdFunction!(value)),
            SizedBox(
              height: 20.h,
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          child: Visibility(
            visible: wrongCredentials,
            child: Text(
              title.contains('Iniciar')
                  ? 'Usuario o contraseña erróneos.'
                  : 'Revisa tus credenciales.',
              style: const TextStyle(fontSize: 12, color: TothemTheme.silver),
            ),
          ),
        ),
      ],
    ),
  );
}

TextField _reusableTextField(
    {required String labelText,
    required String hintText,
    required Icon icon,
    required void Function(String value) function}) {
  return TextField(
    onChanged: (value) => function(value),
    obscureText: labelText.contains('ontraseña') ? true : false,
    keyboardType: labelText == 'Email'
        ? TextInputType.emailAddress
        : TextInputType.multiline,
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
    required double height,
    required BuildContext context}) {
  return Container(
    height: height,
    alignment: alignment,
    child: TextButton(
        child: Text(text, style: TothemTheme.clickableText),
        onPressed: () {
          if (text.contains('olvidado')) {
            Navigator.pushReplacementNamed(context, '/forgotPwd');
          } else if (text.contains('inicio')) {
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Navigator.pushReplacementNamed(context, '/signin');
          }
        }),
  );
}
