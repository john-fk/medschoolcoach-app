import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion);

typedef bool Filter<T>(T suggestion, String query);

typedef InputEventCallback<T>(T data);

typedef StringCallback(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  final List<T> suggestions;
  final Filter<T> itemFilter;
  final Comparator<T> itemSorter;
  final StringCallback textChanged, textSubmitted;
  final ValueSetter<bool> onFocusChanged;
  final InputEventCallback<T> itemSubmitted;
  final AutoCompleteOverlayItemBuilder<T> itemBuilder;
  final int suggestionsAmount;
  final GlobalKey<AutoCompleteTextFieldState<T>> key;
  final bool submitOnSuggestionTap, clearOnSubmit;
  final List<TextInputFormatter> inputFormatter;
  final int minLength;
  final List<FormFieldValidator<String>> validators;

  final InputDecoration decoration;
  final TextStyle style;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final FocusNode focusNode;

  AutoCompleteTextField({
    @required this.itemSubmitted,
    @required this.key,
    @required this.suggestions,
    @required this.itemBuilder,
    @required this.itemSorter,
    @required this.itemFilter,
    this.inputFormatter,
    this.style,
    this.decoration = const InputDecoration(),
    this.textChanged,
    this.textSubmitted,
    this.onFocusChanged,
    this.keyboardType = TextInputType.text,
    this.suggestionsAmount = 5,
    this.submitOnSuggestionTap = true,
    this.clearOnSubmit = true,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.minLength = 1,
    this.controller,
    this.focusNode,
    this.validators = const [],
  }) : super(key: key);

  void clear() => key.currentState.clear();

  void addSuggestion(T suggestion) =>
      key.currentState.addSuggestion(suggestion);

  void removeSuggestion(T suggestion) =>
      key.currentState.removeSuggestion(suggestion);

  void updateSuggestions(List<T> suggestions) =>
      key.currentState.updateSuggestions(suggestions);

  void triggerSubmitted() => key.currentState.triggerSubmitted();

  void updateDecoration({
    InputDecoration decoration,
    List<TextInputFormatter> inputFormatter,
    TextCapitalization textCapitalization,
    TextStyle style,
    TextInputType keyboardType,
    TextInputAction textInputAction,
  }) =>
      key.currentState.updateDecoration(
        decoration,
        inputFormatter,
        textCapitalization,
        style,
        keyboardType,
        textInputAction,
      );

  TextFormField get textField => key.currentState.textField;

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<T>(
      suggestions,
      textChanged,
      textSubmitted,
      onFocusChanged,
      itemSubmitted,
      itemBuilder,
      itemSorter,
      itemFilter,
      suggestionsAmount,
      submitOnSuggestionTap,
      clearOnSubmit,
      minLength,
      inputFormatter,
      textCapitalization,
      decoration,
      style,
      keyboardType,
      textInputAction,
      controller,
      focusNode,
      validators);
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();

  TextFormField textField;
  List<T> suggestions;
  StringCallback textChanged, textSubmitted;
  ValueSetter<bool> onFocusChanged;
  InputEventCallback<T> itemSubmitted;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  Comparator<T> itemSorter;
  OverlayEntry listSuggestionsEntry;
  List<T> filteredSuggestions;
  Filter<T> itemFilter;
  int suggestionsAmount;
  int minLength;
  bool submitOnSuggestionTap, clearOnSubmit;
  TextEditingController controller;
  FocusNode focusNode;
  List<FormFieldValidator<String>> validators;

  String currentText = "";

  InputDecoration decoration;
  List<TextInputFormatter> inputFormatter;
  TextCapitalization textCapitalization;
  TextStyle style;
  TextInputType keyboardType;
  TextInputAction textInputAction;

  AutoCompleteTextFieldState(
    this.suggestions,
    this.textChanged,
    this.textSubmitted,
    this.onFocusChanged,
    this.itemSubmitted,
    this.itemBuilder,
    this.itemSorter,
    this.itemFilter,
    this.suggestionsAmount,
    // ignore: avoid_positional_boolean_parameters
    this.submitOnSuggestionTap,
    this.clearOnSubmit,
    this.minLength,
    this.inputFormatter,
    this.textCapitalization,
    this.decoration,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.focusNode,
    this.validators,
  ) {
    textField = TextFormField(
      inputFormatters: inputFormatter,
      textCapitalization: textCapitalization,
      decoration: decoration,
      style: style,
      keyboardType: keyboardType,
      focusNode: focusNode ?? FocusNode(),
      controller: controller ?? TextEditingController(),
      textInputAction: textInputAction,
      validator: _validateField,
      onChanged: (text) {
        currentText = text;
        updateOverlay(text);

        if (textChanged != null) {
          textChanged(text);
        }
      },
      onTap: () {
        updateOverlay(currentText);
      },
      onFieldSubmitted: (submittedText) =>
          triggerSubmitted(submittedText: submittedText),
    );

    if (this.controller != null && this.controller.text != null) {
      currentText = this.controller.text;
    }

    focusNode.addListener(() {
      if (onFocusChanged != null) {
        onFocusChanged(focusNode.hasFocus);
      }

      if (!focusNode.hasFocus) {
        filteredSuggestions = [];
        updateOverlay();
      } else if (!(currentText == "" || currentText == null)) {
        updateOverlay(currentText);
      }
    });
  }

  void updateDecoration(
      InputDecoration decoration,
      List<TextInputFormatter> inputFormatter,
      TextCapitalization textCapitalization,
      TextStyle style,
      TextInputType keyboardType,
      TextInputAction textInputAction) {
    if (decoration != null) {
      this.decoration = decoration;
    }

    if (inputFormatter != null) {
      this.inputFormatter = inputFormatter;
    }

    if (textCapitalization != null) {
      this.textCapitalization = textCapitalization;
    }

    if (style != null) {
      this.style = style;
    }

    if (keyboardType != null) {
      this.keyboardType = keyboardType;
    }

    if (textInputAction != null) {
      this.textInputAction = textInputAction;
    }

    setState(() {
      textField = TextFormField(
        inputFormatters: this.inputFormatter,
        textCapitalization: this.textCapitalization,
        decoration: this.decoration,
        style: this.style,
        keyboardType: this.keyboardType,
        focusNode: focusNode ?? FocusNode(),
        controller: controller ?? TextEditingController(),
        textInputAction: this.textInputAction,
        onChanged: (text) {
          currentText = text;
          updateOverlay(text);

          if (textChanged != null) {
            textChanged(text);
          }
        },
        onTap: () {
          updateOverlay(currentText);
        },
        onFieldSubmitted: (submittedText) =>
            triggerSubmitted(submittedText: submittedText),
      );
    });
  }

  void triggerSubmitted({String submittedText}) {
    submittedText == null
        ? textSubmitted(currentText)
        : textSubmitted(submittedText);

    if (clearOnSubmit) {
      clear();
    }
  }

  void clear() {
    textField.controller.clear();
    currentText = "";
    updateOverlay();
  }

  void addSuggestion(T suggestion) {
    suggestions.add(suggestion);
    updateOverlay(currentText);
  }

  void removeSuggestion(T suggestion) {
    suggestions.contains(suggestion)
        ? suggestions.remove(suggestion)
        : throw "List does not contain suggestion and cannot be removed";
    updateOverlay(currentText);
  }

  void updateSuggestions(List<T> suggestions) {
    this.suggestions = suggestions;
    updateOverlay(currentText);
  }

  void updateOverlay([String query]) {
    if (listSuggestionsEntry == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      listSuggestionsEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            width: width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, 45),
              child: SizedBox(
                width: width,
                height: filteredSuggestions.length > 7 ? 200 : null,
                child: Card(
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      children: filteredSuggestions.map(
                        (suggestion) {
                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  child: itemBuilder(context, suggestion),
                                  onTap: () {
                                    setState(
                                      () {
                                        if (submitOnSuggestionTap) {
                                          String text = suggestion.toString();
                                          textField.controller.text = text;
                                          focusNode.unfocus();
                                          itemSubmitted(suggestion);
                                          if (clearOnSubmit) {
                                            clear();
                                          }
                                        } else {
                                          String text = suggestion.toString();
                                          textField.controller.text = text;
                                          textChanged(text);
                                        }
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context).insert(listSuggestionsEntry);
    }

    filteredSuggestions = getSuggestions(
        suggestions, itemSorter, itemFilter, suggestionsAmount, query);

    listSuggestionsEntry.markNeedsBuild();
  }

  List<T> getSuggestions(List<T> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String query) {
    if (null == query || query.length < minLength) {
      return [];
    }

    suggestions = suggestions.where((item) => filter(item, query)).toList();
    suggestions.sort(sorter);
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  @override
  void dispose() {
    if (focusNode == null) {
      focusNode.dispose();
    }
    if (controller == null) {
      textField.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _layerLink, child: textField);
  }

  String _validateField(String value) {
    for (final validator in widget.validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
