import 'package:flutter/material.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/garden_type_utils.dart';

class AddEditGardenDialog extends StatefulWidget {
  final Garden? garden; // null = thêm mới
  final Function(String name, GardenType type, double? area, String? note) onSave;

  const AddEditGardenDialog({super.key, this.garden, required this.onSave});

  @override
  State<AddEditGardenDialog> createState() => _AddEditGardenDialogState();
}

class _AddEditGardenDialogState extends State<AddEditGardenDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _noteCtrl;
  GardenType _selectedType = GardenType.fruit;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.garden?.name ?? '');
    _areaCtrl = TextEditingController(text: widget.garden?.area?.toString() ?? '');
    _noteCtrl = TextEditingController(text: widget.garden?.note ?? '');
    _selectedType = widget.garden?.type ?? GardenType.fruit;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _areaCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final area = double.tryParse(_areaCtrl.text);
      widget.onSave(_nameCtrl.text.trim(), _selectedType, area, _noteCtrl.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.garden == null ? 'Thêm vườn' : 'Sửa vườn'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên vườn *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<GardenType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Loại vườn *'),
                items: GardenType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(gardenTypeName(type)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) _selectedType = val;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaCtrl,
                decoration: const InputDecoration(labelText: 'Diện tích (m²)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
}