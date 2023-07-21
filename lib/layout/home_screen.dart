import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_marko/Screens/cart/cart.dart';
import 'package:super_marko/Screens/search/search.dart';
import 'package:super_marko/cubit/cubit.dart';
import 'package:super_marko/cubit/state.dart';
import 'package:super_marko/shared/components/components.dart';
import 'package:super_marko/shared/mode_cubit/cubit.dart';
import 'package:super_marko/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // ProductModel model;
        var cubit = MainCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.add_shopping_cart_sharp),
              title: const Text("E_Commerce"),
              actions: [
                IconButton(
                  icon: const Icon(
                    IconBroken.Search,
                    color: Colors.deepOrangeAccent,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                ),
                IconButton(
                  onPressed: () {
                    ModeCubit.get(context).changeAppMode();
                  },
                  icon: const Icon(Icons.dark_mode_outlined),
                )
              ],
            ),
            body: cubit.pages[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepOrangeAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: const Icon(
                Icons.add_shopping_cart,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              elevation: 50.0,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              activeIndex: cubit.currentIndex,

              icons: const [
                IconBroken.Home,
                IconBroken.Category,
                IconBroken.Heart,
                IconBroken.Setting,
              ],
              activeColor: Colors.deepOrangeAccent,
              splashColor: Colors.red,
              inactiveColor: Colors.black,
              iconSize: 30.0,
              //backgroundColor: Colors.grey[200],
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.smoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
            ),
          ),
        );
      },
    );
  }
}
