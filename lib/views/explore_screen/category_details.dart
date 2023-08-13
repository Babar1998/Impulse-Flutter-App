import 'package:get/get.dart';
import 'package:impulse/consts/consts.dart';
import 'package:impulse/models/item.dart';
import 'package:impulse/services/explore_service.dart';
import 'package:impulse/services/item_service.dart';
import 'package:impulse/views/explore_screen/item_details.dart';
import 'package:impulse/views/explore_screen/widgets/subcategories_list.dart';
import 'package:impulse/widget_common/bg_widget.dart';

class CategoryDetails extends StatelessWidget {
  final String title;
  final String id;
  const CategoryDetails({super.key, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    final exploreService = ExploreService();
    final itemService = ItemService();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: title.text
              .fontFamily(semibold)
              .white
              .overflow(TextOverflow.ellipsis)
              .make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: exploreService.getSubCategories(id: id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.active) {
                    return circularIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: "Network Connection Error"
                          .text
                          .size(18)
                          .color(darkFontGrey)
                          .make(),
                    );
                  }
                  if (snapshot.hasData) {
                    final subcat = snapshot.data;
                    return subCategories(subcategories: subcat ?? []);
                  }
                  return circularIndicator();
                },
              ),
              20.heightBox,
              Expanded(
                child: FutureBuilder<List<Item>>(
                  future: itemService.getAllItems(categoryId: id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active) {
                      return circularIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: snapshot.error
                            .toString()
                            .text
                            .size(18)
                            .color(darkFontGrey)
                            .make(),
                      );
                    }
                    if (snapshot.hasData) {
                      final listItems = snapshot.data ?? [];
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: listItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          mainAxisExtent: 250.0,
                        ),
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeInImage(
                              placeholder: const AssetImage(placeholder1),
                              image: NetworkImage(listItems.first.images.first),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            listItems.first.title.text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            5.heightBox,
                            '\$${listItems.first.price}'
                                .text
                                .color(mehroonColor)
                                .fontFamily(bold)
                                .size(16)
                                .make()
                          ],
                        )
                            .box
                            .white
                            .padding(const EdgeInsets.all(12.0))
                            .roundedSM
                            .make()
                            .onTap(
                              () => Get.to(
                                () => ItemDetails(item: listItems[index]),
                              ),
                            ),
                      );
                    }
                    return circularIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center circularIndicator() =>
      const Center(child: CircularProgressIndicator(color: mehroonColor));
}
