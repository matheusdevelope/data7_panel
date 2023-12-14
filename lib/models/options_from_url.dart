class ColumnsOptions {
  final RegExp pattern = RegExp(r"{([^}]+)}", caseSensitive: false);
  late String url;
  List<ColumnsOption> filters = [];

  ColumnsOptions({required this.url}) {
    Map<String, String> params = {};
    Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      params = uri.queryParameters;
    }
    params.forEach((key, value) {
      filters.add(
        ColumnsOption(
          name: key.toLowerCase().trim(),
        ).setFromJsonString(value.toLowerCase()),
      );
    });
  }
}

class ColumnsOption {
  String name;
  double? width;
  bool? hide;
  FilterOptions? filter;
  ColumnsOption({required this.name, this.filter});
  setFromJsonString(String options) {
    filter = FilterOptions(
      key: name,
      stringOptions: options,
    );
    width = getWidth(options);
    hide = getHide(options);

    return this;
  }

  double? getWidth(String url) {
    RegExp regExp = RegExp(
      r'width:(\d+(?:\.\d+)?)',
      caseSensitive: false,
    );
    Match? match = regExp.firstMatch(url);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  bool? getHide(String url) {
    RegExp regExp = RegExp(r'hide:(true|false)', caseSensitive: false);
    Match? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1)!.toLowerCase() == 'true';
    }
    return null;
  }
}

class FilterOptions {
  late String key;
  late List<String> values = [];
  late FilterOperators operator = FilterOperators.equal;
  late String strOptions = '';
  FilterOptions({required this.key, String? stringOptions}) {
    if (stringOptions != null) {
      _setStrOptions(stringOptions);
    }
  }
  bool test(Map<String, dynamic> object) {
    bool passed = true;
    object = convertKeysToLower(object);
    print(object);
    if (object.containsKey(key)) {
      String valueObj = object[key].toString().trim().toLowerCase();
      if (operator == FilterOperators.equal) {
        return equal(valueObj, values);
      }
      if (operator == FilterOperators.notEqual) {
        return !equal(valueObj, values);
      }
      if (operator == FilterOperators.greater) {
        return greater(valueObj, values);
      }
      if (operator == FilterOperators.greaterEqual) {
        return greater(valueObj, values) || equal(valueObj, values);
      }
      if (operator == FilterOperators.less) {
        return less(valueObj, values);
      }
      if (operator == FilterOperators.lessEqual) {
        return less(valueObj, values) || equal(valueObj, values);
      }
      if (operator == FilterOperators.contain) {
        return contain(valueObj, values);
      }
      if (operator == FilterOperators.notContain) {
        return !contain(valueObj, values);
      }
    }

    return passed;
  }

  equal(String testValue, List<String> values) {
    bool passed = false;
    for (var value in values) {
      passed = testValue == value;
      if (passed) return passed;
    }
    return passed;
  }

  greater(String testValue, List<String> values) {
    bool passed = false;
    for (var value in values) {
      passed = testValue.compareTo(value) > 0;
      if (passed) return passed;
    }
    return passed;
  }

  less(String testValue, List<String> values) {
    bool passed = false;
    for (var value in values) {
      passed = testValue.compareTo(value) < 0;
      if (passed) return passed;
    }
    return passed;
  }

  contain(String testValue, List<String> values) {
    bool passed = false;
    for (var value in values) {
      passed = testValue.contains(value);
      if (passed) return passed;
    }
    return passed;
  }

  Map<String, dynamic> convertKeysToLower(Map<String, dynamic> inputMap) {
    Map<String, dynamic> result = {};

    inputMap.forEach((key, value) {
      String lowercaseKey = key.toLowerCase();
      result[lowercaseKey] = value;
    });

    return result;
  }

  _setStrOptions(String stringOptions) {
    final RegExp filterPattern =
        RegExp(r"filter:{([^}]+)}", caseSensitive: false);
    final RegExp valuesTagPattern =
        RegExp(r"values:\[.*?\]", caseSensitive: false);
    final RegExp valuesPattern = RegExp(r"\[.*?\]", caseSensitive: false);
    final RegExp operatorPattern =
        RegExp(r"operator=([\w]+)", caseSensitive: false);
    if (filterPattern.hasMatch(stringOptions)) {
      Match match = filterPattern.firstMatch(stringOptions) as Match;
      strOptions = match.group(1) ?? '';
    }
    if (valuesTagPattern.hasMatch(strOptions)) {
      Match match = valuesTagPattern.firstMatch(strOptions) as Match;
      String tagValue = match.group(0) ?? '';
      if (valuesPattern.hasMatch(tagValue)) {
        Match match = valuesPattern.firstMatch(tagValue) as Match;
        values.addAll(match
                .group(0)
                ?.replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((e) => e.trim())
                .toList() ??
            []);
      }
    }
    if (operatorPattern.hasMatch(strOptions)) {
      Match match = operatorPattern.firstMatch(strOptions) as Match;
      String operatorStr = match.group(0) ?? '';
      operatorStr = operatorStr.replaceAll('operator=', '').trim();

      for (var element in FilterOperators.values) {
        if (element.name.toLowerCase() == operatorStr.toLowerCase()) {
          operator = element;
        }
      }
    }
  }
}

enum FilterOperators {
  equal,
  notEqual,
  greater,
  greaterEqual,
  less,
  lessEqual,
  contain,
  notContain
}
