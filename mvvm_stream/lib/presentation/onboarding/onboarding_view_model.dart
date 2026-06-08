import 'dart:async';
import '../../domain/model.dart';
import '../../domain/slider_view_object.dart';
import '../base/baseview_model.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
import 'onboarding.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controllers
  final StreamController _streamController =
      StreamController<SlideViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    // send this slider data to our view
    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = _currentIndex++; // +1
    if (nextIndex >= _list.length) {
      _currentIndex = 0; // infinite loop to go to first item inside the slider
    }
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--; // -1
    if (previousIndex == -1) {
      _currentIndex =
          _list.length - 1; // infinite loop to go to the length of slider list
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  // TODO: implement inputSliderViewObject
  Sink<dynamic> get inputSliderViewObject => _streamController.sink;

  @override
  // TODO: implement outputSliderViewObject
  Stream<SlideViewObject> get outputSliderViewObject =>
      _streamController.stream.map((slideViewObject) => slideViewObject);

  // private functions
  List<SliderObject> _getSliderData() => [
    SliderObject(
      AppStrings.onBoardingTitle1,
      AppStrings.onBoardingSubTitle1,
      ImageAssets.onboardingLogo1,
    ),
    SliderObject(
      AppStrings.onBoardingTitle2,
      AppStrings.onBoardingSubTitle2,
      ImageAssets.onboardingLogo2,
    ),
    SliderObject(
      AppStrings.onBoardingTitle3,
      AppStrings.onBoardingSubTitle3,
      ImageAssets.onboardingLogo3,
    ),
    SliderObject(
      AppStrings.onBoardingTitle4,
      AppStrings.onBoardingSubTitle4,
      ImageAssets.onboardingLogo4,
    ),
  ];

  void _postDataToView() {
    inputSliderViewObject.add(
      SlideViewObject(_list[_currentIndex], _list.length, _currentIndex),
    );
  }
}

// inputs mean the orders that our view model will recieve from our view
mixin OnBoardingViewModelInputs {
  void goNext(); // when user clicks on right arrow or swipe left.
  void goPrevious(); // when user clicks on left arrow or swipe right.
  void onPageChanged(int index);
  Sink get inputSliderViewObject; // this is the way to add data to the stream .. stream input
}

// outputs mean data or results that will be sent from our view model to our view
mixin OnBoardingViewModelOutputs {
  // will be implement it later
  Stream<SlideViewObject> get outputSliderViewObject;
}

