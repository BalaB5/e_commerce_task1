import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../widgets/network_image_loader.dart';
import '../widgets/success_dialog.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartController cartController = Get.find<CartController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

void _submitOrder() {
  if (_formKey.currentState!.validate()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        onClose: () {
          Navigator.of(context).pop(); // Close dialog
          Get.toNamed('/', preventDuplicates: false); // Navigate home
          cartController.totelPrice.value = 0.0;
          cartController.carts.value = [];
        },
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 1000;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildShippingForm()),
                          const SizedBox(width: 40),
                          Expanded(child: _buildOrderSummary()),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShippingForm(),
                            const SizedBox(height: 30),
                            _buildOrderSummary(),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: _submitOrder,
          child: const Text("Place Order", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildShippingForm() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Shipping Information",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, "Full Name"),
              const SizedBox(height: 16),
              _buildTextField(addressController, "Address", maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(emailController, "Email",
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(phoneController, "Phone Number",
                  keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildTextField(TextEditingController controller, String label,
    {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please enter your $label";
      }
      if (label == "Email" &&
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return "Please enter a valid email address";
      }
      if (label == "Phone Number" &&
          !RegExp(r'^\d{10,15}$').hasMatch(value)) {
        return "Please enter a valid phone number";
      }
      if (label == "Address" && value.trim().length < 25) {
        return "Address must be at least 25 characters";
      }
      return null;
    },
  );
}


  Widget _buildOrderSummary() {
    return Obx(() {
      if (cartController.carts.isEmpty) {
        return const Center(
          child: Text(
            "Your cart is empty.",
            style: TextStyle(fontSize: 18),
          ),
        );
      }
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: cartController.carts.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final cart = cartController.carts[index];
                  final product = cart.product;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: NetworkImageLoader(product.image!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${cart.quantity} x ₹${product.price!.toStringAsFixed(2)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 32, thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Obx(() => Text(
                        "₹${cartController.totelPrice.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
