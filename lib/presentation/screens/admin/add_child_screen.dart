
import 'package:creche/presentation/providers/auth_provider.dart';
import 'package:creche/presentation/providers/child_provider.dart';
import 'package:creche/presentation/widgets/common/custom_button.dart';
import 'package:creche/presentation/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
class AddChildScreen extends ConsumerStatefulWidget {
  final String parentId;
  const AddChildScreen({super.key, required this.parentId});

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
      'parentId': widget.parentId,
      'allergies': [],
    };

    try {
      await ref.read(apiServiceProvider).createChild(childData);
      ref.read(childProvider.notifier).loadChildren();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating child: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Child')),
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
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Child',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}