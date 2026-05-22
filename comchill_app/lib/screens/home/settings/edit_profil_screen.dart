import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:comchill_app/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController(text: "John Doe");
  final _usernameController = TextEditingController(text: "johndoe");
  final _phoneController = TextEditingController(text: "+229 01 00 00 00 00");

  File? _imageFile;
  bool _isLoading = false;


  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceMenu() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: secondaryTextColor),
                title: const Text('Sélectionner depuis la galerie', style: TextStyle(color: primaryTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: secondaryTextColor),
                title: const Text('Prendre une photo en direct', style: TextStyle(color: primaryTextColor)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : \$e"), backgroundColor: errorColor),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !'), backgroundColor: successColor),
        );
        Navigator.maybePop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : \$e"), backgroundColor: errorColor),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: primaryTextColor, size: 22),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Modifier le Profil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: secondaryTextColor.withOpacity(0.2)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showImageSourceMenu,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: secondaryTextColor.withOpacity(0.1),
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null
                                  ? const Text(
                                      'JD',
                                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: secondaryTextColor),
                                    )
                                  : null,
                            ),
                            const Positioned(
                              right: 2,
                              bottom: 2,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: primaryColor,
                                child: Icon(
                                  Icons.edit,
                                  color: thirdColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildInputLabel("Nom complet"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(color: primaryTextColor),
                        decoration: _buildInputDecoration("Votre nom"),
                        validator: (value) => value == null || value.trim().isEmpty ? "Le nom est requis" : null,
                      ),
                      const SizedBox(height: 24),
                      _buildInputLabel("Nom d'utilisateur"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: primaryTextColor),
                        decoration: _buildInputDecoration("Votre pseudo"),
                        validator: (value) => value == null || value.trim().isEmpty ? "Le pseudo est requis" : null,
                      ),
                      const SizedBox(height: 24),
                      _buildInputLabel("Numéro de téléphone"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: primaryTextColor),
                        decoration: _buildInputDecoration("Votre numéro"),
                        validator: (value) => value == null || value.trim().isEmpty ? "Le numéro est requis" : null,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: thirdColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: thirdColor, strokeWidth: 2.5),
                                )
                              : const Text(
                                  'Enregistrer les modifications',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor),
      ),
    );
  }

InputDecoration _buildInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 15),
    filled: true,fillColor: surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: secondaryTextColor.withOpacity(0.3), width: 1.5),),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: primaryColor, width: 1.5),),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: errorColor, width: 1.5),),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: errorColor, width: 2.0),),);
  }
}