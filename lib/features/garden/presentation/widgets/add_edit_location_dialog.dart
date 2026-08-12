import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';

class AddEditLocationDialog extends StatefulWidget {
  final Location? location; // null = thêm mới
  final Function(String name, String? address, double latitude, double longitude, String? note) onSave;

  const AddEditLocationDialog({super.key, this.location, required this.onSave});

  @override
  State<AddEditLocationDialog> createState() => _AddEditLocationDialogState();
}

class _AddEditLocationDialogState extends State<AddEditLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.location?.name ?? '');
    _addressCtrl = TextEditingController(text: widget.location?.address ?? '');
    _latCtrl = TextEditingController(text: widget.location != null ? widget.location!.latitude.toString() : '');
    _lngCtrl = TextEditingController(text: widget.location != null ? widget.location!.longitude.toString() : '');
    _noteCtrl = TextEditingController(text: widget.location?.note ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final lat = double.tryParse(_latCtrl.text) ?? 0.0;
      final lng = double.tryParse(_lngCtrl.text) ?? 0.0;
      widget.onSave(_nameCtrl.text.trim(), _addressCtrl.text.trim(), lat, lng, _noteCtrl.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.location == null ? 'Thêm vị trí' : 'Sửa vị trí'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên vị trí *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latCtrl,
                      decoration: const InputDecoration(labelText: 'Vĩ độ'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lngCtrl,
                      decoration: const InputDecoration(labelText: 'Kinh độ'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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