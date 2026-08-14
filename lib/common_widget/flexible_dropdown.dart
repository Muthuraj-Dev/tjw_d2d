import 'package:flutter/material.dart';

enum DropdownType { static, searchable }

class FlexibleDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayString;
  final void Function(T?)? onChanged;
  final DropdownType dropdownType;
  final String labelText;
  final InputDecoration? staticDropdownDecoration;
  final FormFieldValidator<T>? validator;
  final bool isRequired;
  final double dropdownMaxHeight;
  final TextEditingController? controller;  // Add this line

  const FlexibleDropdown({super.key, 
    required this.items,
    required this.displayString,
    this.onChanged,
    this.dropdownType = DropdownType.static,
    this.labelText = 'Select an item',
    this.staticDropdownDecoration,
    this.isRequired = false,
    this.validator,
    this.dropdownMaxHeight = 200,
    this.controller,  // Add this line
  });

  @override
  _FlexibleDropdownState<T> createState() => _FlexibleDropdownState<T>();
}

class _FlexibleDropdownState<T> extends State<FlexibleDropdown<T>> {
  late List<T> _allItems;
  late List<T> _filteredItems;
  T? _selectedItem;
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _allItems = widget.items;
    _filteredItems = List.from(_allItems);

    // Initialize the controller
    _searchController = widget.controller ?? TextEditingController();

    if (_searchController.text.isNotEmpty) {
      _selectedItem = _allItems.firstWhere(
            (item) => widget.displayString(item) == _searchController.text,
        orElse: () => _allItems[0],
      );
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isDropdownVisible = false;
        });
      }
    });
  }

  void _filterItems(String query) {
    setState(() {
      if (query.length < 3) {
        _filteredItems = [];
      } else {
        _filteredItems = _allItems
            .where((item) => widget.displayString(item).toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dropdownType == DropdownType.static) {
      return DropdownButtonFormField<T>(
        value: _selectedItem,
        items: _allItems.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(widget.displayString(item)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
            if (widget.controller != null) {
              widget.controller!.text = widget.displayString(value as T);
            }
          });
          if (widget.onChanged != null) widget.onChanged!(value);
        },
        decoration: widget.staticDropdownDecoration ??
            InputDecoration(
              labelText: widget.isRequired ? '${widget.labelText} *' : widget.labelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: Icon(Icons.ac_unit), // Custom suffix icon
            ),
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    } else {
      return FormField<T>(
        validator: widget.validator,
        builder: (FormFieldState<T> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (value) {
                  _filterItems(value);
                  setState(() {
                    _isDropdownVisible = true;
                    state.didChange(null);
                  });
                },
                onTap: () {
                  setState(() {
                    _isDropdownVisible = true;
                  });
                },
                decoration: InputDecoration(
                  labelText: widget.isRequired ? '${widget.labelText} *' : widget.labelText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _isDropdownVisible = !_isDropdownVisible;
                      });
                    },
                  ),
                  errorText: state.errorText,
                ),
              ),
              if (_isDropdownVisible)
                Container(
                  constraints: BoxConstraints(maxHeight: widget.dropdownMaxHeight),
                  child: ListView(
                    shrinkWrap: true,
                    children: _filteredItems.map((item) {
                      return ListTile(
                        title: Text(widget.displayString(item)),
                        onTap: () {
                          setState(() {
                            _selectedItem = item;
                            _searchController.text = widget.displayString(item);
                            _isDropdownVisible = false;
                            state.didChange(item);
                          });
                          if (widget.onChanged != null) widget.onChanged!(item);
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _searchController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }
}
