import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef GardenRecord = Map<String, dynamic>;

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  List<GardenRecord>? _records;
  bool _failed = false;
  bool _busy = false;
  String? _zoneId;
  String _view = 'Khu trồng';

  String get _storageKey =>
      'garden.v1.${FirebaseAuth.instance.currentUser!.uid}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final key = _storageKey;
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      final records = raw == null
          ? <GardenRecord>[]
          : List<GardenRecord>.from(jsonDecode(raw) as List);
      if (mounted) {
        setState(() {
          _records = records;
          _failed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _save(List<GardenRecord> records) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final key = _storageKey;
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString(key, jsonEncode(records))) {
        throw StateError('Garden save failed');
      }
      if (mounted) setState(() => _records = records);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được dữ liệu. Hãy thử lại.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  DateTime get _today => DateUtils.dateOnly(DateTime.now());
  DateTime _date(GardenRecord record) => DateTime.parse(record['date'] as String);
  String _label(GardenRecord record) => record['name'] as String;

  Future<void> _edit({
    required String kind,
    required String title,
    required String nameLabel,
    GardenRecord? existing,
    GardenRecord? zone,
    GardenRecord? crop,
  }) async {
    if (_busy) return;
    final formKey = GlobalKey<FormState>();
    var name = existing?['name'] as String? ?? '';
    var detail = existing?['detail'] as String? ?? '';
    var date = existing == null ? _today : _date(existing);
    final isZone = kind == 'zone';
    final isHarvest = kind == 'harvest';
    final result = await showDialog<GardenRecord>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    maxLength: 100,
                    decoration: InputDecoration(labelText: nameLabel),
                    onChanged: (value) => name = value,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Vui lòng nhập thông tin'
                        : null,
                  ),
                  TextFormField(
                    initialValue: detail,
                    maxLength: isZone || isHarvest ? 20 : 250,
                    keyboardType: isZone || isHarvest
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: isZone
                          ? 'Diện tích (m²)'
                          : isHarvest
                              ? 'Sản lượng (kg)'
                              : 'Ghi chú',
                    ),
                    onChanged: (value) => detail = value,
                    validator: (value) {
                      if (!isZone && !isHarvest) return null;
                      final amount = double.tryParse(
                        (value ?? '').trim().replaceAll(',', '.'),
                      );
                      return amount != null && amount.isFinite && amount > 0
                          ? null
                          : 'Nhập số lớn hơn 0';
                    },
                  ),
                  if (!isZone)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(kind == 'task'
                          ? 'Hạn thực hiện'
                          : isHarvest ? 'Ngày thu hoạch' : 'Ngày gieo trồng'),
                      subtitle: Text(_dateFormat.format(date)),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: isHarvest ? _date(crop!) : DateTime(2000),
                          lastDate: isHarvest ? _today : DateTime(2100),
                        );
                        if (picked != null && context.mounted) {
                          refresh(() => date = picked);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, <String, dynamic>{
                  ...?existing,
                  'id': existing?['id'] ?? const Uuid().v4(),
                  'kind': kind,
                  'zone': zone?['id'] ?? existing?['zone'],
                  'crop': crop?['id'] ?? existing?['crop'],
                  'name': name.trim(),
                  'detail': detail.trim(),
                  'date': date.toIso8601String(),
                });
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    await _save([
      for (final record in _records!)
        if (record['id'] != result['id']) record,
      result,
    ]);
  }

  Future<void> _complete(GardenRecord record) => _save([
        for (final item in _records!)
          if (item['id'] == record['id'])
            {...item, 'completedAt': DateTime.now().toIso8601String()}
          else
            item,
      ]);

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: FilledButton(onPressed: _load, child: const Text('Tải lại dữ liệu vườn')),
      );
    }
    final records = _records;
    if (records == null) return const Center(child: CircularProgressIndicator());

    final zones = records.where((record) => record['kind'] == 'zone').toList();
    final zoneNames = {for (final zone in zones) zone['id']: _label(zone)};
    final cropNames = {
      for (final crop in records.where((record) => record['kind'] == 'crop'))
        crop['id']: _label(crop),
    };
    final scoped = records.where((record) =>
        _zoneId == null || record['zone'] == _zoneId || record['id'] == _zoneId);
    final crops = scoped.where((record) => record['kind'] == 'crop').toList()
      ..sort((a, b) => _date(b).compareTo(_date(a)));
    final tasks = scoped.where((record) => record['kind'] == 'task').toList()
      ..sort((a, b) => _date(a).compareTo(_date(b)));
    final harvests = scoped.where((record) => record['kind'] == 'harvest').toList()
      ..sort((a, b) => _date(b).compareTo(_date(a)));
    final overdue = tasks.where((record) =>
        record['completedAt'] == null && _date(record).isBefore(_today)).length;
    final dueToday = tasks.where((record) =>
        record['completedAt'] == null && DateUtils.isSameDay(_date(record), _today)).length;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng quan vườn', style: theme.textTheme.headlineSmall
                        ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('${crops.where((crop) => crop['completedAt'] == null).length} lứa đang trồng')),
                        ActionChip(
                          label: Text('$dueToday việc hôm nay'),
                          onPressed: () => setState(() => _view = 'Việc chăm sóc'),
                        ),
                        ActionChip(
                          label: Text('$overdue việc quá hạn'),
                          onPressed: () => setState(() => _view = 'Việc chăm sóc'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (zones.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: _zoneId ?? '',
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Lọc theo khu'),
                items: [
                  const DropdownMenuItem(value: '', child: Text('Tất cả khu')),
                  for (final zone in zones)
                    DropdownMenuItem<String>(
                      value: zone['id'] as String,
                      child: Text(_label(zone), overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => setState(() => _zoneId = value == '' ? null : value),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final view in ['Khu trồng', 'Lứa trồng', 'Việc chăm sóc', 'Thu hoạch'])
                  ChoiceChip(
                    label: Text(view),
                    selected: _view == view,
                    onSelected: (_) => setState(() => _view = view),
                  ),
              ],
            ),
            if (_busy) const LinearProgressIndicator(),
            const SizedBox(height: 12),
            if (_view == 'Khu trồng') ...[
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: _busy ? null : () async {
                    await _edit(kind: 'zone', title: 'Thêm khu trồng', nameLabel: 'Tên khu');
                    if (mounted) setState(() => _zoneId = null);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm khu trồng'),
                ),
              ),
              if (zones.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Tạo khu trồng để bắt đầu ghi nhận lứa và lên lịch chăm sóc.'),
                ),
              for (final zone in scoped.where((record) => record['kind'] == 'zone'))
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.yard_outlined),
                    title: Text(_label(zone)),
                    subtitle: Text('${zone['detail']} m²'),
                    trailing: PopupMenuButton<String>(
                      enabled: !_busy,
                      onSelected: (action) {
                        if (action == 'edit') {
                          _edit(kind: 'zone', title: 'Sửa khu trồng', nameLabel: 'Tên khu', existing: zone);
                        } else if (action == 'crop') {
                          _edit(kind: 'crop', title: 'Tạo lứa trồng', nameLabel: 'Tên cây hoặc giống', zone: zone);
                        } else {
                          _edit(kind: 'task', title: 'Lên lịch chăm sóc', nameLabel: 'Tên công việc', zone: zone);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Sửa khu')),
                        PopupMenuItem(value: 'crop', child: Text('Tạo lứa trồng')),
                        PopupMenuItem(value: 'task', child: Text('Lên lịch chăm sóc')),
                      ],
                    ),
                  ),
                ),
            ],
            if (_view == 'Lứa trồng') ...[
              if (crops.isEmpty)
                const Text('Mở menu của một khu trồng để tạo lứa.'),
              for (final crop in crops)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.eco_outlined),
                    title: Text(_label(crop)),
                    subtitle: Text(
                      '${zoneNames[crop['zone']]} · ${_dateFormat.format(_date(crop))}'
                      '\n${crop['completedAt'] == null ? 'Đang trồng' : 'Đã kết thúc'}'
                      '${crop['detail'] == '' ? '' : ' · ${crop['detail']}'}',
                    ),
                    trailing: crop['completedAt'] != null ? null : PopupMenuButton<String>(
                      enabled: !_busy,
                      onSelected: (action) async {
                        if (action == 'task') {
                          final zone = zones.firstWhere((zone) => zone['id'] == crop['zone']);
                          await _edit(kind: 'task', title: 'Lên lịch chăm sóc', nameLabel: 'Tên công việc', zone: zone, crop: crop);
                        } else if (action == 'harvest') {
                          if (_date(crop).isAfter(_today)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lứa này chưa đến ngày gieo trồng.')),
                            );
                            return;
                          }
                          final zone = zones.firstWhere((zone) => zone['id'] == crop['zone']);
                          await _edit(kind: 'harvest', title: 'Ghi nhận thu hoạch', nameLabel: 'Tên đợt thu hoặc ghi chú', zone: zone, crop: crop);
                        } else {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Kết thúc lứa trồng?'),
                              content: const Text('Lịch sử thu hoạch và các việc đã lên lịch vẫn xem được.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
                                FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Kết thúc')),
                              ],
                            ),
                          );
                          if (confirmed == true && mounted) await _complete(crop);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'task', child: Text('Lên lịch chăm sóc')),
                        PopupMenuItem(value: 'harvest', child: Text('Ghi thu hoạch')),
                        PopupMenuItem(value: 'finish', child: Text('Kết thúc lứa')),
                      ],
                    ),
                  ),
                ),
            ],
            if (_view == 'Việc chăm sóc') ...[
              if (tasks.isEmpty)
                const Text('Lên lịch chăm sóc từ menu khu trồng hoặc lứa trồng.'),
              for (final task in tasks)
                Card(
                  child: ListTile(
                    leading: Icon(task['completedAt'] != null
                        ? Icons.check_circle_outline : Icons.event_note_outlined),
                    title: Text(_label(task)),
                    subtitle: Text(
                      '${zoneNames[task['zone']]}'
                      '${task['crop'] == null ? '' : ' · ${cropNames[task['crop']]}'}'
                      '\n${_dateFormat.format(_date(task))} · '
                      '${task['completedAt'] != null ? 'Đã xong' : _date(task).isBefore(_today) ? 'Quá hạn' : 'Chờ thực hiện'}'
                      '${task['detail'] == '' ? '' : ' · ${task['detail']}'}',
                    ),
                    trailing: task['completedAt'] != null ? null : IconButton(
                      tooltip: 'Đánh dấu đã xong',
                      onPressed: _busy ? null : () => _complete(task),
                      icon: const Icon(Icons.done),
                    ),
                  ),
                ),
            ],
            if (_view == 'Thu hoạch') ...[
              if (harvests.isEmpty)
                const Text('Ghi sản lượng thực tế từ menu của lứa đang trồng.'),
              for (final harvest in harvests)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text('${_label(harvest)} · ${harvest['detail']} kg'),
                    subtitle: Text(
                      '${zoneNames[harvest['zone']]} · ${cropNames[harvest['crop']]}'
                      '\n${_dateFormat.format(_date(harvest))}',
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
