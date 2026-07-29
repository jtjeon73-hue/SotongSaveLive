class MindSection {
  const MindSection({required this.heading, required this.body});

  final String heading;
  final String body;
}

class MindEssay {
  const MindEssay({
    required this.id,
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.inspiration,
    required this.readingTimeMinutes,
    required this.introduction,
    required this.sections,
    required this.rememberSentence,
    required this.reflection,
    required this.relatedIds,
    required this.sourceNote,
    required this.reviewedAt,
  });

  final String id;
  final String slug;
  final String title;
  final String subtitle;
  final String category;
  final String inspiration;
  final int readingTimeMinutes;
  final String introduction;
  final List<MindSection> sections;
  final String rememberSentence;
  final String reflection;
  final List<String> relatedIds;
  final String sourceNote;
  final String reviewedAt;
}
