import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gv_key_app/app/models/CartModel.dart';
import 'package:gv_key_app/app/models/ProductModel.dart';
import 'package:gv_key_app/app/models/UserProfileModel.dart';
import 'package:gv_key_app/app/pages/BottomNavigation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final localStorage = GetStorage();

connection() async {
  final networkResult = await (Connectivity().checkConnectivity());
  return networkResult;
}

class ActionController extends GetxController {
  RxList<Games> steamResponModelCtr = <Games>[].obs;
  RxList<Games> steamResponseModelCarrouselCtr = <Games>[].obs;
  RxList<Games> steamResponseModelSearchCtr = <Games>[].obs;
  RxList<Games> steamResponseModelCategoryCtr = <Games>[].obs;
  RxList<Games> steamResponseModelCartCtr = <Games>[].obs;

  RxList<Cart> steamResponseModelAllCartCtr = <Cart>[].obs;

  RxList<Userprofile> profileResponseModelCtr = <Userprofile>[].obs;

  final TextEditingController searchController = TextEditingController();

  RxBool enableSkeleton = true.obs;

  RxString searchText = "".obs;

  loadDataCategory({required String category}) async {
    try {
      SmartDialog.showLoading();

      final response = await http.get(
        Uri.parse(
            "https://knowing-fit-goose.ngrok-free.app/api/product/search/category=$category"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        steamResponseModelCategoryCtr.assignAll(gamesFromJson(response.body));

        enableSkeleton.value = false;
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  loadDataName({required String name}) async {
    try {
      SmartDialog.showLoading();

      final response = await http.get(
        Uri.parse(
            "https://knowing-fit-goose.ngrok-free.app/api/product/search/game_name=$name"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        steamResponseModelSearchCtr.assignAll(gamesFromJson(response.body));
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  loadDetailGame({required int app_id}) async {
    try {
      SmartDialog.showLoading();

      final response = await http.get(
        Uri.parse(
            "https://knowing-fit-goose.ngrok-free.app/api/product/search/app_id=$app_id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        steamResponModelCtr.assignAll(gamesFromJson(response.body));
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  addCartProduct({required int app_id}) async {
    try {
      Map body = {"email": localStorage.read('userEmail')};

      SmartDialog.showLoading();

      final response = await http.post(
          Uri.parse(
              "https://knowing-fit-goose.ngrok-free.app/api/product/cart/insert/app_id=$app_id"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${localStorage.read('userToken')}',
          },
          body: jsonEncode(body));

      Future.delayed(Duration(seconds: 1), () => SmartDialog.dismiss());

      final responseApi = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SmartDialog.showToast(responseApi['message']);
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);

        SmartDialog.showToast(responseApi['detail']);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  deleteCartProduct({required int cart_id}) async {
    try {
      Map body = {"email": localStorage.read('userEmail')};

      SmartDialog.showLoading();

      final response = await http.delete(
          Uri.parse(
              "https://knowing-fit-goose.ngrok-free.app/api/product/cart/delete/cart_id=$cart_id"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${localStorage.read('userToken')}',
          },
          body: jsonEncode(body));

      Future.delayed(Duration(seconds: 1), () => SmartDialog.dismiss());

      final responseApi = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SmartDialog.showToast(responseApi['message']);
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);

        SmartDialog.showToast(responseApi['detail']);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  loadDataCart() async {
    try {
      Map body = {"email": localStorage.read('userEmail')};

      SmartDialog.showLoading();

      final response = await http.post(
          Uri.parse(
              "https://knowing-fit-goose.ngrok-free.app/api/product/cart"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${localStorage.read('userToken')}',
          },
          body: jsonEncode(body));

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        steamResponseModelAllCartCtr.assignAll(cartFromJson(response.body));
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  loadData() async {
    try {
      SmartDialog.showLoading();

      final response = await http.get(
        Uri.parse("https://knowing-fit-goose.ngrok-free.app/api/product"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${localStorage.read('userToken')}',
        },
      );

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        steamResponModelCtr.assignAll(gamesFromJson(response.body));
        steamResponseModelCarrouselCtr.assignAll(gamesFromJson(response.body));

        enableSkeleton.value = false;
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

// Profile
  loadUserProfile() async {
    try {
      Map body = {"email": localStorage.read('userEmail')};

      SmartDialog.showLoading();

      final response = await http.post(
          Uri.parse(
              "https://knowing-fit-goose.ngrok-free.app/api/menu/get-profile"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${localStorage.read('userToken')}',
          },
          body: jsonEncode(body));

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        profileResponseModelCtr.assignAll(userprofileFromJson(response.body));
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }

  RxString paymentMethod = "".obs;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  buyProduct({required int app_id, required String method}) async {
    try {
      Map body = {
        "email": localStorage.read('userEmail'),
        "product": app_id,
        "method": method,
        "date": dateFormat.format(DateTime.now())
      };

      SmartDialog.showLoading();

      final response = await http.post(
          Uri.parse("https://knowing-fit-goose.ngrok-free.app/api/product/buy"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${localStorage.read('userToken')}',
          },
          body: jsonEncode(body));

      Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());

      if (response.statusCode == 200) {
        final responseApi = jsonDecode(response.body);

        SmartDialog.showToast(responseApi["message"]);

        Get.to(BottomNavbar());
      } else {
        print("status code : " +
            response.statusCode.toString() +
            " gagal " +
            response.body);
        SmartDialog.showToast(response.body);
      }
    } catch (e) {
      print("error : " + e.toString());
    }
  }
}
