// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  Unit _fromValue;
  List<DropdownMenuItem> _unitMenuItems;
  double _inputValue;
  bool _showInputError = false;
  // TODO: Determine whether you need to override anything, such as initState()

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _createMenuItems() {
    setState(() {
      _unitMenuItems = widget.units.map((Unit unit) {
        return DropdownMenuItem(
          value: unit.name,
          child: Container(
              child: Text(
                    unit.name,
                    softWrap: true,
                  )
              ),
        );
      }).toList();
    });
  }

  void _setDefault() {
    setState(() {
      _fromValue = widget.units[0];
    });
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere((Unit unit) {
      return unit.name == unitName;
    }, orElse: null);
  }

  void _updateInput(String input) {
    if (input == null || input.isEmpty) {
    } else {
      try {
        final inputDouble = double.parse(input);
        setState(() {
          _showInputError = false;
        });
      } on Exception catch (e) {
        print('Error:$e');
        setState(() {
          _showInputError = true;
        });
      }
    }
  }

  Widget generateTextField(String label) {
    return TextField(
      decoration: InputDecoration(
          labelText: label,
          errorText: _showInputError ? 'The input should be double' : null,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          )),
      keyboardType: TextInputType.number,
      onChanged: _updateInput,
//      validator: (value){
//        if(value.isEmpty) {
//          return 'Please enter some text';
//        }
//      },
    );
  }

  Widget generateDropdownList(items, onChange, value) {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[50],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          items: _unitMenuItems,
                          onChanged: (value) {
                            setState(() {
                              _fromValue = _getUnit(value);
                            });
                          },
                          value: _fromValue.name,
                          style: Theme.of(context).textTheme.title,
                        ))),
              )
            ],
          )

        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._createMenuItems();
    this._setDefault();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    final inputGroup = Column(
      children: <Widget>[
        generateTextField('Input'),
        generateDropdownList(_unitMenuItems, (value) {
          setState(() {
            _fromValue = _getUnit(value);
          });
        }, _fromValue.name)
      ],
    );

    final outputGroup = Column(
      children: <Widget>[
        generateTextField('Output'),
        generateDropdownList(_unitMenuItems, (value) {
          setState(() {
            _fromValue = _getUnit(value);
          });
        }, _fromValue.name)
      ],
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    // TODO: Create a compare arrows icon.

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    // TODO: Delete the below placeholder code.

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          inputGroup,
          arrows,
          outputGroup,
        ],
      ),
    );
  }
}
