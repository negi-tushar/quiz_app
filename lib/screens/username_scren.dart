import 'package:flutter/material.dart';
import 'package:quiz_app/common/string.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveUserName() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name!')));
      return;
    }
    await SharedPrefService.saveData(userNameKey, _nameController.text.trim());

    Navigator.of(context).pushReplacementNamed('/home');

    // Call the callback to signal completion
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image at the top
              Center(
                child: Image.asset(
                  'assets/img/onboarding.jpg',
                  // height: 180,
                  // width: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Prompt for user's name
                    const Text(
                      'What should we call you?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Textbox for user's name
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        hintText: 'e.g., Alex, Sarah',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 30),
                    // Button to save the name
                    SizedBox(
                      width: double.infinity, // Make button full width
                      child: ElevatedButton(
                        onPressed: _saveUserName,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: const Color.fromARGB(255, 7, 174, 121),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
