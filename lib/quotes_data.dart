class QuotesData {
  static final List<String> motivationalQuotes = [
    "Success is the result of preparation, hard work, and learning from failure",
    "Never give up; great people never know surrender",
    "Every great achievement began with a decision to try",
    "The road to success is always under construction",
    "You are stronger than you think",
    "Start where you are, use what you have, do what you can",
    "Success is not final, and failure is not fatal",
    "Self-belief is the first secret to success",
    "Don’t compare yourself to others; compare yourself to who you were yesterday",
    "Challenges are what make life interesting",
    "The future belongs to those who believe in the beauty of their dreams",
    "Ambition is the first step toward success",
    "There is no elevator to success — you have to take the stairs",
    "Today’s dream is tomorrow’s reality",
    "Success requires patience and perseverance",
    "Be the change you wish to see in the world",
    "Knowledge is power, but application is true power",
    "Don’t wait for opportunity — create it yourself",
    "Failure is simply the opportunity to begin again, this time more intelligently",
    "Set your goal and keep it always before your eyes",
  ];

  
  static String getRandomQuote() {
    return motivationalQuotes[DateTime.now().millisecondsSinceEpoch % motivationalQuotes.length];
  }
}