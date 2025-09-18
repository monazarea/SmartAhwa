import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/ahwa_cubit.dart';
import '../models/drink.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';

  late final TextEditingController _notesController;

  final List<String> _specialInstructions = [
    'سكر زيادة',
    'سكر مظبوط',
    'سكر بره',
    'نعناع زيادة',
    'وش',
    'تلقيمة زيادة',
  ];

  final List<Drink> _availableDrinks = [
    Drink( "شاي",  10.0),
    Drink("قهوة تركي",  15.0),
    Drink("كركديه",17.0),
  ];
  Drink? _selectedDrink;

  @override
  void initState() {
    super.initState();
    _selectedDrink = _availableDrinks.first;
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final drinkWithOptions = Drink(
      _selectedDrink!.name,
      _selectedDrink!.price,
      notes: _notesController.text,
    );

    context.read<AhwaCubit>().addOrder(
      customerName: _customerName,
      drink: drinkWithOptions,
    );

    Navigator.of(context).pop();
  }


  void _addInstruction(String instruction) {
    final currentText = _notesController.text;
    if (currentText.isNotEmpty) {
      _notesController.text += ' $instruction';
    } else {
      _notesController.text = instruction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أوردر جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم الزبون'),
                validator: (value) => value == null || value.isEmpty ? 'الاسم مطلوب' : null,
                onSaved: (value) => _customerName = value!,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<Drink>(
                value: _selectedDrink,
                decoration: const InputDecoration(labelText: 'اختار المشروب'),
                items: _availableDrinks.map((drink) {
                  return DropdownMenuItem<Drink>(value: drink, child: Text(drink.name));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedDrink = newValue),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'ملاحظات خاصة'),
              ),
              const SizedBox(height: 15),

              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _specialInstructions.map((instruction) {
                  return ActionChip(
                    label: Text(instruction),
                    onPressed: () => _addInstruction(instruction),
                    backgroundColor: Colors.brown[100],
                    shape: StadiumBorder(side: BorderSide(color: Colors.brown[200]!)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('إضافة الأوردر', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}