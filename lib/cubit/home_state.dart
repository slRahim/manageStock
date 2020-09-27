part of 'home_cubit.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState{
  const HomeLoading();
}

class HomeLoaded extends HomeState{
  final Widget widget;
  const HomeLoaded(this.widget);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeLoaded &&
          runtimeType == other.runtimeType &&
          widget == other.widget;

  @override
  int get hashCode => widget.hashCode;
}

class FragmentLoaded extends HomeState{
  final Widget widget;
  const FragmentLoaded(this.widget);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FragmentLoaded &&
              runtimeType == other.runtimeType &&
              widget == other.widget;

  @override
  int get hashCode => widget.hashCode;
}

class HomeError extends HomeState{
  final String message;
  const HomeError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
