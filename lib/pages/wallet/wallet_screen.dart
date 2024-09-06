// import 'package:flutter/material.dart' as material;
// import 'package:flutter/widgets.dart';
// // import 'package:flutter_stripe/flutter_stripe.dart';
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class WalletScreen extends material.StatefulWidget {
//   final String userId;
//
//   const WalletScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _WalletScreenState createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends material.State<WalletScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Map<String, dynamic>? paymentIntent;
//   String? _selectedPaymentMethod;
//   int? _diamondAmount;
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController contactNumberController = TextEditingController();
//   final TextEditingController emailAddressController = TextEditingController();
//
//   Future<void> makePayment(amount, diamondAmount) async {
//     final userDetails = {
//       "userId": widget.userId,
//       "amount": amount,
//       "firstName": firstNameController.text,
//       "lastName": lastNameController.text,
//       "phoneNumber": contactNumberController.text,
//       "email": emailAddressController.text,
//       "diamondAmount": diamondAmount,
//     };
//
//     print(userDetails.toString());
//     try {
//       // Create payment intent data
//       paymentIntent = await createPaymentIntent(amount.toString(), 'USD');
//       // initialise the payment sheet setup
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           // Client secret key from payment data
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//           googlePay: const PaymentSheetGooglePay(
//               // Currency and country code is accourding to India
//               testEnv: true,
//               currencyCode: "USD",
//               merchantCountryCode: "US"),
//           // Merchant Name
//           merchantDisplayName: 'Flutterwings',
//           // return URl if you want to add
//           // returnURL: 'flutterstripe://redirect',
//         ),
//       );
//       // Display payment sheet
//       displayPaymentSheet(amount, diamondAmount);
//     } catch (e) {
//       print("exception $e");
//
//       if (e is StripeConfigException) {
//         print("Stripe exception ${e.message}");
//       } else {
//         print("exception $e");
//       }
//     }
//   }
//
//   displayPaymentSheet(amount, diamondAmount) async {
//     try {
//       // "Display payment sheet";
//       await Stripe.instance.presentPaymentSheet();
//       // Show when payment is done
//       // Displaying snackbar for it
//       material.ScaffoldMessenger.of(context).showSnackBar(
//         const material.SnackBar(content: material.Text("Paid successfully")),
//       );
//       paymentIntent = null;
//       Map<String, dynamic> postData = {
//         "userId": widget.userId,
//         "amount": amount,
//         "firstName": firstNameController.text,
//         "lastName": lastNameController.text,
//         "phoneNumber": contactNumberController.text,
//         "email": emailAddressController.text,
//         "diamondAmount": diamondAmount
//       };
//
//       // Send POST request
//       var response = await http.post(
//         Uri.parse('http://45.126.125.172:8080/api/v1/wallet/save'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(postData),
//       );
//
//       if (response.statusCode == 200) {
//         // Navigate to the /wallet route
//         Navigator.pushNamed(context, '/wallet');
//       } else {
//         print('Failed to save data: ${response.statusCode}');
//       }
//     } on StripeException catch (e) {
//       // If any error comes during payment
//       // so payment will be cancelled
//       print('Error: $e');
//
//       material.ScaffoldMessenger.of(context).showSnackBar(
//         const material.SnackBar(content: material.Text(" Payment Cancelled")),
//       );
//     } catch (e) {
//       print("Error in displaying");
//       print('$e');
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': ((int.parse(amount)) * 100).toString(),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//       };
//       var secretKey =
//           "sk_test_51PE7q0CnvMccepGG7noBN7k40TNU2LUCLbBzacYnC9CI8gQSyn7dJfKdhn28fpyDhX6H71LXqTzumNJSIqaQahFv00I4Rc6lPE";
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $secretKey',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       print('Payment Intent Body: ${response.body.toString()}');
//       return jsonDecode(response.body.toString());
//     } catch (err) {
//       print('Error charging user: ${err.toString()}');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDiamondAmount();
//   }
//
//   Future<void> _fetchDiamondAmount() async {
//     final url =
//         Uri.parse('http://45.126.125.172:8080/api/v1/wallet/diamondAmount/1');
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         final diamondAmount = jsonData['diamondAmount'];
//
//         setState(() {
//           _diamondAmount = diamondAmount;
//         });
//       } else {
//         // Handle error response
//         print('Failed to fetch diamond amount: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network error
//       print('Error fetching diamond amount: $e');
//     }
//   }
//
//   @override
//   material.Widget build(material.BuildContext context) {
//     return material.Scaffold(
//       body: material.Container(
//         decoration: material.BoxDecoration(
//           gradient: material.LinearGradient(
//             begin: material.Alignment.topLeft,
//             end: material.Alignment.bottomRight,
//             colors: [
//               material.Colors.blue.shade300,
//               material.Colors.blue.shade800,
//             ],
//           ),
//         ),
//         child: material.Stack(
//           children: [
//             material.Column(
//               children: [
//                 material.Container(
//                   margin: const material.EdgeInsets.only(top: 46, right: 46),
//                   height: 200,
//                   child: material.Stack(
//                     children: [
//                       material.Align(
//                         alignment: material.Alignment.centerRight,
//                         child: material.Container(
//                           width: 150, // Adjust width if necessary
//                           decoration: const material.BoxDecoration(
//                             image: material.DecorationImage(
//                               image: material.AssetImage(
//                                   'assets/images/wallet_img.png'),
//                               opacity: 0.7,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 material.Expanded(
//                   child: material.Container(
//                     color: material.Colors.transparent,
//                   ),
//                 ),
//               ],
//             ),
//             material.Column(
//               children: [
//                 material.AppBar(
//                   backgroundColor: material.Colors.transparent,
//                   elevation: 0,
//                   leading: material.IconButton(
//                     icon: const material.Icon(material.Icons.arrow_back,
//                         color: material.Colors.white),
//                     onPressed: () {
//                       material.Navigator.pop(context);
//                     },
//                   ),
//                   actions: [
//                     material.IconButton(
//                       icon: const material.Icon(material.Icons.menu_rounded,
//                           color: material.Colors.white),
//                       onPressed: () {},
//                     ),
//                   ],
//                   title: const material.Text(
//                     'Wallet',
//                     style: material.TextStyle(
//                       color: material.Colors.white,
//                       fontWeight: material.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 material.Container(
//                   alignment: material.Alignment.topLeft,
//                   margin: const material.EdgeInsets.only(left: 20),
//                   child: _diamondAmount != null
//                       ? _buildBalanceWidget(_diamondAmount!)
//                       : const material
//                           .CircularProgressIndicator(), // Placeholder for loading state
//                 ),
//                 material.Expanded(
//                   child: material.Container(
//                     padding: const material.EdgeInsets.all(16),
//                     decoration: material.BoxDecoration(
//                       gradient: material.LinearGradient(
//                         begin: material.Alignment.topLeft,
//                         end: material.Alignment.bottomRight,
//                         colors: [
//                           material.Colors.blue.shade200,
//                           material.Colors.blue.shade800,
//                         ],
//                       ),
//                       borderRadius: material.BorderRadius.vertical(
//                           top: material.Radius.circular(30)),
//                     ),
//                     child: material.Column(
//                       crossAxisAlignment: material.CrossAxisAlignment.start,
//                       children: [
//                         const material.SizedBox(height: 16),
//                         material.Row(
//                           mainAxisAlignment:
//                               material.MainAxisAlignment.spaceBetween,
//                           children: [
//                             const material.Text(
//                               'Recharge Channel',
//                               style: material.TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: material.FontWeight.bold,
//                                 color: material.Colors.white,
//                               ),
//                             ),
//                             material.Row(
//                               children: const [
//                                 material.Text('Saudi Arabia',
//                                     style: material.TextStyle(
//                                         color: material.Colors.white)),
//                                 material.SizedBox(width: 8),
//                                 material.Icon(material.Icons.arrow_drop_down,
//                                     color: material.Colors.white),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const material.SizedBox(height: 8),
//                         _buildRechargeChannel('Google Pay',
//                             'assets/images/google_pay.png', 'GPay'),
//                         _buildRechargeChannel('VISA/MASTERCARD',
//                             'assets/images/visa_mastercard.png', 'Visa'),
//                         const material.SizedBox(height: 16),
//                         material.Expanded(
//                           child: material.GridView.count(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                             children: [
//                               _buildDiamondPackage(context, 1260, 10),
//                               _buildDiamondPackage(context, 6300, 50),
//                               _buildDiamondPackage(context, 18900, 150),
//                               _buildDiamondPackage(context, 37800, 300),
//                               _buildDiamondPackage(context, 63000, 500),
//                               _buildDiamondPackage(context, 126000, 1000),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   material.Widget _buildBalanceWidget(int diamondAmount) {
//     return material.Container(
//       color: material.Colors.transparent,
//       padding: const material.EdgeInsets.all(16),
//       child: material.Column(
//         crossAxisAlignment: material.CrossAxisAlignment.start,
//         children: [
//           material.Text(
//             'Balance',
//             style: material.TextStyle(
//               fontSize: 32,
//               fontWeight: material.FontWeight.bold,
//               color: material.Colors.white,
//             ),
//           ),
//           material.SizedBox(height: 8),
//           material.Text(
//             diamondAmount.toString(),
//             style: material.TextStyle(
//               fontSize: 32,
//               fontWeight: material.FontWeight.bold,
//               color: material.Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   material.Widget _buildRechargeChannel(
//       String name, String asset, String value) {
//     return material.Container(
//       margin: const material.EdgeInsets.symmetric(vertical: 4),
//       decoration: material.BoxDecoration(
//         color: material.Colors.white,
//         borderRadius: material.BorderRadius.circular(8),
//       ),
//       child: material.RadioListTile<String>(
//         value: value,
//         groupValue: _selectedPaymentMethod,
//         onChanged: (String? newValue) {
//           setState(() {
//             _selectedPaymentMethod = newValue;
//           });
//         },
//         title: material.Text(
//           name,
//           style: material.TextStyle(color: material.Colors.blue),
//         ),
//         secondary: material.Image.asset(asset, width: 40),
//         activeColor: material.Colors.blue,
//         contentPadding: const material.EdgeInsets.symmetric(horizontal: 16),
//       ),
//     );
//   }
//
//   material.Widget _buildDiamondPackage(
//       material.BuildContext context, int diamonds, int price) {
//     return material.GestureDetector(
//       onTap: () {
//         // Show popup to get user details and confirm payment
//         _showPaymentBottomSheet(context, diamonds, price);
//       },
//       child: material.Card(
//         color: material.Colors.white,
//         child: material.Column(
//           mainAxisAlignment: material.MainAxisAlignment.center,
//           crossAxisAlignment: material.CrossAxisAlignment.center,
//           children: [
//             material.Image.asset(
//               'assets/images/diamond.png',
//               width: 50,
//             ),
//             const material.SizedBox(height: 2),
//             material.Text(
//               '$diamonds',
//               style: const material.TextStyle(
//                 fontSize: 18,
//                 fontWeight: material.FontWeight.bold,
//               ),
//             ),
//             const material.SizedBox(height: 2),
//             material.Text(
//               'USD $price',
//               style: const material.TextStyle(
//                 fontSize: 14,
//                 fontWeight: material.FontWeight.w600,
//                 color: material.Colors.blue,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showPaymentBottomSheet(
//       material.BuildContext context, int diamonds, int price) {
//     material.showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: material.Colors.transparent,
//       builder: (material.BuildContext context) {
//         return material.DraggableScrollableSheet(
//           initialChildSize: 0.6,
//           minChildSize: 0.4,
//           maxChildSize: 0.9,
//           builder: (context, scrollController) {
//             return material.Container(
//               decoration: const material.BoxDecoration(
//                 color: material.Colors.white,
//                 borderRadius: material.BorderRadius.vertical(
//                   top: material.Radius.circular(30),
//                 ),
//               ),
//               padding: const material.EdgeInsets.all(16),
//               child: material.SingleChildScrollView(
//                 controller: scrollController,
//                 child: material.Form(
//                   key: _formKey,
//                   child: material.Column(
//                     children: [
//                       const material.Text(
//                         'Confirm Payment',
//                         style: material.TextStyle(
//                             fontSize: 24,
//                             fontWeight: material.FontWeight.bold,
//                             color: material.Colors.blue),
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                         controller: firstNameController,
//                         decoration: material.InputDecoration(
//                           labelText: 'First Name',
//                           border: material.OutlineInputBorder(
//                             borderRadius: material.BorderRadius.circular(20),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your first name';
//                           }
//                           return null;
//                         },
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                         controller: lastNameController,
//                         decoration: material.InputDecoration(
//                           labelText: 'Last Name',
//                           border: material.OutlineInputBorder(
//                             borderRadius: material.BorderRadius.circular(20),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your last name';
//                           }
//                           return null;
//                         },
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                         controller: contactNumberController,
//                         decoration: material.InputDecoration(
//                           labelText: 'Contact Number',
//                           border: material.OutlineInputBorder(
//                             borderRadius: material.BorderRadius.circular(20),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your contact number';
//                           }
//                           return null;
//                         },
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                         controller: emailAddressController,
//                         decoration: material.InputDecoration(
//                           labelText: 'Email Address',
//                           border: material.OutlineInputBorder(
//                             borderRadius: material.BorderRadius.circular(20),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           return null;
//                         },
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                         readOnly: true,
//                         initialValue: '$diamonds Diamonds',
//                         decoration: material.InputDecoration(
//                           labelText: '',
//                           border: material.OutlineInputBorder(
//                             borderRadius: material.BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                       material.SizedBox(height: 8),
//                       material.TextFormField(
//                           readOnly: true,
//                           initialValue: 'USD $price',
//                           decoration: material.InputDecoration(
//                             labelText: '',
//                             border: material.OutlineInputBorder(
//                               borderRadius: material.BorderRadius.circular(20),
//                             ),
//                           )),
//                       material.SizedBox(height: 8),
//                       material.ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             // Form is valid, proceed with payment
//                             if (_selectedPaymentMethod == 'GPay') {
//                               // Navigate to Google Pay page
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) =>
//                               //         GooglePayPage(), // Assume you have a GooglePayPage
//                               //   ),
//                               // );
//                             } else {
//                               makePayment(price, diamonds);
//                             }
//                           } else {
//                             material.ScaffoldMessenger.of(context).showSnackBar(
//                               const material.SnackBar(
//                                   content:
//                                       material.Text("Please fill all fields")),
//                             );
//                           }
//                         },
//                         child: material.Text('Pay Now',
//                             style: material.TextStyle(
//                                 color: material.Colors.blue)),
//                         style: material.ElevatedButton.styleFrom(
//                           padding: material.EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 16),
//                           shape: material.RoundedRectangleBorder(
//                             borderRadius: material.BorderRadius.circular(30),
//                           ),
//                           backgroundColor: material.Colors.blue.shade50,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
