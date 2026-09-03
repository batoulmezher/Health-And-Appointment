import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/services/wallet_service.dart';

class WalletController extends GetxController {
  final WalletService _walletService = WalletService();

  var balance = 0.obs;
  var isLoading = false.obs;
  var rechargeAmount = 200000.obs;
  var isRecharging = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _walletService.getBalance();
      isLoading.value = false;
      if (result != null) {
        balance.value = result;
      } else {
        errorMessage.value = 'failed_to_fetch_balance'.tr;
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'unexpected_error'.tr;
    }
  }

  Future<void> recharge() async {
    if (rechargeAmount.value <= 0) {
      Get.snackbar(
        'alert'.tr,
        'enter_valid_amount'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }
    isRecharging.value = true;
    errorMessage.value = '';
    try {
      final newBalance = await _walletService.rechargeWallet(rechargeAmount.value);
      isRecharging.value = false;
      if (newBalance != null) {
        balance.value = newBalance;
        Get.snackbar(
          'success'.tr,
          'recharge_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
      } else {
        errorMessage.value = 'recharge_failed'.tr;
        Get.snackbar(
          'error'.tr,
          'recharge_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      isRecharging.value = false;
      errorMessage.value = 'unexpected_error'.tr;
      Get.snackbar('error'.tr, 'unexpected_error'.tr);
    }
  }

  void updateRechargeAmount(int amount) {
    rechargeAmount.value = amount;
  }
}