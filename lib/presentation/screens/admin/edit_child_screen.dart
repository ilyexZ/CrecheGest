// lib/presentation/screens/admin/edit_child_screen.dart
import 'package:creche/core/constants/app_colors.dart';
import 'package:creche/data/models/child_model.dart';
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:creche/presentation/providers/child_provider.dart';
import 'package:creche/presentation/widgets/common/custom_button.dart';
import 'package:creche/presentation/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditChildScreen extends ConsumerStatefulWidget {
  final Child child;
  const EditChildScreen({super.key, required this.child});

  @override
  ConsumerState<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends ConsumerState<EditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  DateTime? _selectedBirthDate;
  late TextEditingController _medicalInfoController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.child.firstName);
    _lastNameController = TextEditingController(text: widget.child.lastName);
    _birthDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(widget.child.birthDate),
    );
    _selectedBirthDate = widget.child.birthDate;
    _medicalInfoController = TextEditingController(
      text: widget.child.medicalInfo);
  }

  Future<void> _selectDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: _selectedBirthDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primary,
             // Use your custom primary color
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      _selectedBirthDate = picked;
      _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }
}


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final childData = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'birthDate': _selectedBirthDate?.toIso8601String(),
      'medicalInfo': _medicalInfoController.text.trim(),
      'allergies': widget.child.allergies,
    };

    try {
      await ref.read(apiServiceProvider).dio.put(
        '/children/${widget.child.id}',
        data: childData,
      );
      ref.read(childProvider.notifier).loadChildren();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating child: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Child')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _birthDateController,
                    labelText: 'Birth Date',
                    hintText: 'Select date',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _medicalInfoController,
                labelText: 'Medical Information',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Update Child',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}