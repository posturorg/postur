List<Map<String, String>> sortUsersByName(List<Map<String, String>> inputList) {
  List<Map<String, String>> sortedList = List.from(inputList);
  sortedList.sort((a, b) => a['name']!.compareTo(b['name']!));
  return sortedList;
}
