import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';

class AddEditPlantDialog extends StatefulWidget {
  final Plant? plant;
  final Function(String name, String? species, DateTime? plantingDate, String? notes) onSave;

  const AddEditPlantDialog({super.key, this.plant, required this.onSave});

  @override
  State<AddEditPlantDialog> createState() => _AddEditPlantDialogState();
}

class _AddEditPlantDialogState extends State<AddEditPlantDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _speciesCtrl;
  late final TextEditingController _notesCtrl;
  DateTime? _plantingDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.plant?.name ?? '');
    _speciesCtrl = TextEditingController(text: widget.plant?.species ?? '');
    _notesCtrl = TextEditingController(text: widget.plant?.notes ?? '');
    _plantingDate = widget.plant?.plantingDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameCtrl.text.trim(),
        _speciesCtrl.text.trim().isNotEmpty ? _speciesCtrl.text.trim() : null,
        _plantingDate,
        _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _plantingDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.plant == null ? 'Thêm cây' : 'Sửa cây'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên cây *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _speciesCtrl,
                decoration: const InputDecoration(labelText: 'Loài'),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Ngày trồng'),
                  child: Text(_plantingDate != null
                      ? '${_plantingDate!.day}/${_plantingDate!.month}/${_plantingDate!.year}'
                      : 'Chọn ngày'),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
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