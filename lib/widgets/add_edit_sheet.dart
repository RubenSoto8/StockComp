import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component.dart';
import '../database/db_helper.dart';

class AddEditSheet extends StatefulWidget {
  final Component? component;
  final VoidCallback onSave;

  const AddEditSheet({super.key, this.component, required this.onSave});

  @override
  State<AddEditSheet> createState() => _AddEditSheetState();
}

class _AddEditSheetState extends State<AddEditSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedCategory = 'Resistor';

  final List<String> _categories = [
    'Resistor', 'Capacitor', 'IC', 'LED', 'Transistor', 'Module', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.component != null) {
      _nameController.text = widget.component!.name;
      _quantityController.text = widget.component!.quantity.toString();
      _notesController.text = widget.component!.notes ?? '';
      _selectedCategory = widget.component!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) return;

    final component = Component(
      id: widget.component?.id,
      name: _nameController.text,
      category: _selectedCategory,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    if (widget.component == null) {
      await DBHelper.instance.insertComponent(component);
    } else {
      await DBHelper.instance.updateComponent(component);
    }

    widget.onSave();
    Navigator.pop(context);
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Delete Component', style: GoogleFonts.nunito(color: Colors.white)),
        content: Text('Are you sure you want to delete this component?',
            style: GoogleFonts.nunito(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: GoogleFonts.nunito(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper.instance.deleteComponent(widget.component!.id!);
      widget.onSave();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.component == null ? 'Add Component' : 'Edit Component',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: _inputDecoration('Component Name'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            dropdownColor: const Color(0xFF1A1A2E),
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: _inputDecoration('Category'),
            items: _categories.map((cat) => DropdownMenuItem(
              value: cat,
              child: Text(cat, style: GoogleFonts.nunito(color: Colors.white)),
            )).toList(),
            onChanged: (val) => setState(() => _selectedCategory = val!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: _inputDecoration('Quantity'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            style: GoogleFonts.nunito(color: Colors.white),
            decoration: _inputDecoration('Notes (optional)'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4D8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Save', style: GoogleFonts.nunito(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
              )),
            ),
          ),
          if (widget.component != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _delete,
                child: Text('Delete', style: GoogleFonts.nunito(
                  color: Colors.red, fontSize: 16,
                )),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.nunito(color: Colors.white54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00B4D8)),
      ),
      filled: true,
      fillColor: const Color(0xFF0D0D1F),
    );
  }
}