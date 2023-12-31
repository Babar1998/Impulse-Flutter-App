import 'package:get/get.dart';
import 'package:impulse/consts/consts.dart';
import 'package:impulse/controllers/slider_controller.dart';
import 'package:impulse/widget_common/dot_indicator.dart';

class CustomSwiper extends StatelessWidget {
  final List<String> sliderList;
  final int sliderNo;
  final int duration;

  const CustomSwiper({
    super.key,
    required this.sliderList,
    required this.sliderNo,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderController());

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        VxSwiper.builder(
          viewportFraction: 1.0,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayInterval: Duration(seconds: duration),
          autoPlay: true,
          height: 140,
          enlargeCenterPage: true,
          onPageChanged: (index) =>
              controller.sliderIndices[sliderNo].value = index,
          itemCount: sliderList.length,
          itemBuilder: (context, index) => Image.asset(
            sliderList[index],
            fit: BoxFit.fill,
          )
              .box
              .rounded
              .clip(Clip.antiAlias)
              .margin(const EdgeInsets.symmetric(horizontal: 4.0))
              .make(),
        ),
        Obx(
          () => DotIndicator(
            currentIndex: controller.sliderIndices[sliderNo].value,
            itemCount: sliderList.length,
            activeColor: mehroonColor,
          ).positioned(
            bottom: 10.0,
          ),
        ),
      ],
    );
  }
}
