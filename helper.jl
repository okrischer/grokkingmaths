using Markdown

# Exercises
keep_working(text=md"The answer is not quite right.") =
  Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

correct(text=md"You got the right answer! Move on to the next exercise.") =
  Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

"🏁"