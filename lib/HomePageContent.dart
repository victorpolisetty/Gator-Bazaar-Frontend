import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/Categories/categories.dart';
import 'Categories1.dart';
import 'Widgets/appbar.dart';
import 'new/screens/home/components/categories.dart';
import 'new/screens/home/components/discount_banner1.dart';
import 'new/screens/home/components/home_header.dart';
import 'new/screens/home/components/popular_product.dart';
import 'new/size_config.dart';
import 'pages/recentItems.dart';
import 'Widgets/sectionTitleHeader.dart';

class HomePageBody extends StatefulWidget {
  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 0.2.h),
            sliver: SliverToBoxAdapter(child: HomeHeader()),
          ),
          SliverToBoxAdapter(child: DiscountBanner()),
          SliverToBoxAdapter(child: Categories()),
          SliverToBoxAdapter(child: Categories1()),
          SliverToBoxAdapter(child: SectionTitle(title: "Featured Products"),),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            sliver: PopularProducts(),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 30.sp)),
        ],
      ),
    );
  }
}
