import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/pages/user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final InputBorder border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
    borderSide: BorderSide(
      color: Colors.blue,
      width: 1.5,
    ),
  );
  bool _hidePass = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _checkPasswordController = TextEditingController();

  final List<String> _countries = ['Russia', 'Ukraine', 'German', 'USA', 'Canada'];
  String? _selectedCountry;

  User? user;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passwordController.dispose();
    _checkPasswordController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Register Form',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              validator: _validateName,
              controller: _nameController,
              //сохранение текста в edit поле
              onSaved: (value) => user?.name = value!,
              decoration: InputDecoration(
                labelText: 'Full name *',
                helperText: 'Input your name',
                hintText: 'Надеюсь ты не просто Вася',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _nameController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outlined,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: border,
                focusedBorder: border,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              validator: (value) => _validatePhoneNumber(value),
              onSaved: (value) {
                user?.phone = value!;
                print(user?.phone);
              },
              controller: _phoneController,
              //сохранение текста в edit поле
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                helperText: 'Phone format (XXX)XX-XX-XX',
                prefixIcon: Icon(Icons.call),
                hintText: 'номер чтобы не кидать бомжа',
                suffixIcon: GestureDetector(
                  onLongPress: () {
                    _phoneController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outlined,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: border,
                focusedBorder: border,
              ),
              keyboardType: TextInputType.phone,
              //для цифр
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly
                FilteringTextInputFormatter(RegExp(r'[()\d -]{1,15}$'), allow: true)
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              // validator: _validateEmail,
              onSaved: (value) {
                if (user != null && value != null) {
                  user?.email = value;
                  print(user?.email);
                }
              },
              controller: _emailController,
              //сохранение текста в edit поле
              decoration: const InputDecoration(
                labelText: 'Email Address *',
                icon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.map),
                labelText: 'choose the country',
              ),
              items: _countries
                  .map(
                    (country) => DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    ),
                  )
                  .toList(),
              onChanged: (country) {
                print(country);
                setState(() {
                  if (country != null) {
                    _selectedCountry = country;
                    user?.country = country;
                    print(user?.country);
                  } else {
                    return;
                  }
                });
              },
              value: _selectedCountry,
              // validator: (val) => val == null ? 'Please selected a country' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _storyController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100), // отвечает за длину введенного текста
              ],
              decoration: const InputDecoration(
                labelText: 'life Story *',
                hintText: 'tell about yourself',
                helperText: 'Как ты, как жизнь?',
                border: OutlineInputBorder(),
              ),
              // validator: (value) => checkValid(value, 'This field must be entered'),
              maxLines: 3,
              onSaved: (value) => user?.story = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              focusNode: _passFocus,
              validator: _validatePassword,
              controller: _passwordController,
              obscureText: _hidePass,
              // скрытие текста
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'никто не узнает)',
                icon: Icon(Icons.security),
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: _validatePassword,
              controller: _checkPasswordController,
              maxLength: 8,
              obscureText: _hidePass,
              decoration: const InputDecoration(
                labelText: 'Confirm   Password *',
                hintText: 'никто не узнает)',
                icon: Icon(Icons.border_color_outlined),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 30),
              color: Colors.green,
              child: IconButton(
                onPressed: () {
                  _submitForm();
                },
                color: Colors.yellowAccent,
                icon: Text('Registration', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      _showDialog(name: _nameController.text);
      _formKey.currentState?.save();
      print('Name: ${_nameController.text}');
      print('phone: ${_phoneController.text}');
      print('email: ${_emailController.text}');
      print('story: ${_nameController.text}');
    } else {
      _showMessage(message: 'Form is not valid! Please review and correct');
    }
  }

  String? checkValid(String? value, String text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  String? _validateName(String? name) {
    final _nameExp =
        RegExp(r'^[A-Za-z]+$'); //Позволяет вводить только буквы вроде английского алфавита
    if (name == null || name.isEmpty) {
      return 'Name is must be';
    } else if (!_nameExp.hasMatch(name)) {
      return 'Please enter abc character!';
    }
    return null;
  }

  String? _validatePhoneNumber(String? input) {
    final _phoneExp = RegExp(
        r'^\(\d\d\d\)\d\d\-\d\d\-\d\d$'); //Позволяет вводить только определенный формат номера
    if (input == null || input.isEmpty) {
      return 'Name is must be';
    } else if (!_phoneExp.hasMatch(input)) {
      return 'Please enter phone number in this format (XXX)XX-XX-XX!';
    }
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password must be';
    } else if (_passwordController.text.length != 8) {
      return 'please write password of 8 characters';
    } else if (_passwordController.text != _checkPasswordController.text) {
      return 'Password does not match';
    }
    return null;
  }

  void _showMessage({required String message}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showDialog({required String name}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Registration successful',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          content: Text(
            '$name is now a verified register form',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                      user: user,
                    ),
                  ),
                );
              },
              child: const Text(
                'Verified',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}
