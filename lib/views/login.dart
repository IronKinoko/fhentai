import 'package:fhentai/apis/user.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:flutter/material.dart';

import './gallery.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Global.prefs.setString('domain', Global.ehUri);
  }

  bool _showPassword = false;
  bool _loading = false;
  // form state
  String _username;
  String _password;

  final TextStyle _style = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  final TextStyle _labelStyle = TextStyle(
    letterSpacing: 1.2,
    fontSize: 16,
    height: -1,
    fontWeight: FontWeight.w500,
    color: Colors.grey[400],
  );

  String _validator(value) {
    if (value.isEmpty) {
      return I18n.of(context).Sign_InEmpty;
    }
    return null;
  }

  Future<void> _goGallery(BuildContext context, bool login) async {
    if (!login) {
      await Global.prefs.setString('domain', Global.ehUri);
      await Global.prefs.setBool('isSignin', false);
    } else {
      await Global.prefs.setString('domain', Global.exUri);
      await Global.prefs.setBool('isSignin', true);
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => Gallery()));
  }

  void _save(context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      _formKey.currentState.save();
      // print([_username, _password]);
      try {
        Global.cookieJar.deleteAll();
        String username = await login(_username, _password);
        await Global.prefs.setString('nickName', username);
        await Global.prefs.setString('email', _username);

        await Global.prefs.setString('his_email', _username);
        await Global.prefs.setString('his_password', _password);

        Global.cookieJar.saveFromResponse(
            Uri.parse(Global.exUri),
            Global.cookieJar
                .loadForRequest(Uri.parse(Global.ehUri))
                .map((e) => e..domain = '.exhentai.org')
                .toList());
        await Global.dio.get('${Global.exUri}/uconfig.php');
        await _goGallery(context, true);
      } catch (e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e),
          duration: Duration(seconds: 2),
        ));
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 64),
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(I18n.of(context).Sign_In,
                      textAlign: TextAlign.left, style: _style),
                  Text(I18n.of(context).Sign_InWelcome,
                      textAlign: TextAlign.left, style: _style),
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: Global.prefs.getString('his_email'),
                              keyboardType: TextInputType.text,
                              validator: _validator,
                              onSaved: (newValue) => _username = newValue,
                              decoration: InputDecoration(
                                  labelText: I18n.of(context)
                                      .Sign_InEmail_Address
                                      .toUpperCase(),
                                  labelStyle: _labelStyle),
                            ),
                            SizedBox(height: 36),
                            TextFormField(
                              initialValue:
                                  Global.prefs.getString('his_password'),
                              obscureText: !_showPassword,
                              validator: _validator,
                              onSaved: (newValue) => _password = newValue,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: _showPassword
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                                labelText: I18n.of(context)
                                    .Sign_InPassword
                                    .toUpperCase(),
                                labelStyle: _labelStyle,
                              ),
                            ),
                            SizedBox(height: 36),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(I18n.of(context).Sign_InCookie,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline))
                              ],
                            ),
                            SizedBox(height: 100),
                            ButtonTheme(
                              minWidth: double.infinity,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: <Widget>[
                                  RaisedButton(
                                    child: _loading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white))
                                        : Text(
                                            I18n.of(context).Sign_In,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                    elevation: 16,
                                    color: Color(0xff6a9df8),
                                    onPressed: () => _save(context),
                                  ),
                                  SizedBox(height: 25),
                                  RaisedButton(
                                    child: Text(
                                      I18n.of(context).Sign_InNO_Sign_In,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    elevation: 16,
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      _goGallery(context, false);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
