String categoryShortName(String category) {
  if (category.isEmpty) return category;

   String firstWord = category.split(' ').first;

   firstWord = firstWord.split("'").first;

   return firstWord[0].toUpperCase() + firstWord.substring(1);
}
