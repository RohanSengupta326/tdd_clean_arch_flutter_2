import 'package:clean_arch_bloc_2/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

// this entity is not a model that data layer returns and we are saving it
// inside a type model. cause this time data layer returns nothing.

// so this is just an hardcoded data entity which we are gonna use in
// presentation layer to show data based on user new or not.

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  // will show three pages if user is first timer.
  // three getStarted pages.
  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: 'Brand new curriculum',
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );

  const PageContent.second()
      : this(
          image: MediaRes.casualLife,
          title: 'Brand a fun atmosphere',
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );

  const PageContent.third()
      : this(
          image: MediaRes.casualMeditationScience,
          title: 'Easy to join the lesson',
          description:
              'This is the first online education platform designed by the '
              "world's top professors",
        );

  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, title, description];
}
