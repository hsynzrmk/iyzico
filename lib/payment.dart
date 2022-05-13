import 'package:flutter/material.dart';
import 'package:iyzi/payment_successful_page.dart';
import 'package:iyzico/iyzico.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'globals.dart' as globals;

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool registerCard = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String _status = '';
  String _err = '';

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  makePayment() async {
    const iyziConfig = IyziConfig(
        'sandbox-RidvidZ6kqBLaiANr8wZk4esFRsCOQ0Y',
        'sandbox-rjcYS1bI0rJDzl8NxvKZLt6UqzL7JgZR',
        'https://sandbox-api.iyzipay.com');

    //Create an iyzico object
    final iyzico = Iyzico.fromConfig(configuration: iyziConfig);

    // //requesting bin number
    // final binResult =
    //     await iyzico.retrieveBinNumberRequest(binNumber: '542119');
    // print(binResult);

    // //requesting Installment Info

    // final installmentResult =
    //     await iyzico.retrieveInstallmentInfoRequest(price: 10);
    // print(installmentResult);

    // final installmentResult2 = await iyzico.retrieveInstallmentInfoRequest(
    //     price: 10, binNumber: '542119');
    // print(installmentResult2);

    //Create Payment Request

    // ignore: omit_local_variable_types
    //final double price = 1;
    // ignore: omit_local_variable_types
    //final double paidPrice = 1.1;

    final paymentCard = PaymentCard(
      cardHolderName: 'John Doe',
      //cardNumber: '4127111111111113',
      cardNumber: '4475050000000003',
      expireYear: '2030',
      expireMonth: '12',
      cvc: '123',
    );

    final shippingAddress = Address(
        address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
        contactName: 'Jane Doe',
        zipCode: '34742',
        city: 'Istanbul',
        country: 'Turkey');
    final billingAddress = shippingAddress;

    final buyer = Buyer(
        id: 'BY789',
        name: 'Huseyin',
        surname: 'Ezirmik',
        identityNumber: '74300864791',
        email: 'email@email.com',
        registrationAddress:
            'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
        city: 'Istanbul',
        country: 'Turkey',
        ip: '85.34.78.112');

    final basketItems = <BasketItem>[
      BasketItem(
          id: 'BI101',
          price: globals.addbpara.toString(),
          name: 'BPara',
          category1: 'Currency',
          itemType: BasketItemType.VIRTUAL),
    ];

    final paymentResult = await iyzico.CreatePaymentRequest(
        price: globals.addbpara,
        paidPrice: globals.addbpara,
        paymentCard: paymentCard,
        buyer: buyer,
        shippingAddress: shippingAddress,
        billingAddress: billingAddress,
        basketItems: basketItems);

    print(paymentResult);
    _status = paymentResult.status;
    //_err = paymentResult.errorMessage!;

    // Initialize 3DS PAYMENT REQUEST

    // final initializeThreeds = await iyzico.initializeThreedsPaymentRequest(
    //   price: price,
    //   paidPrice: paidPrice,
    //   paymentCard: paymentCard,
    //   buyer: buyer,
    //   shippingAddress: shippingAddress,
    //   billingAddress: billingAddress,
    //   currency: Currency.TRY,
    //   basketItems: basketItems,
    //   callbackUrl: 'www.marufmarket.com',
    // );
    // print(initializeThreeds);

    // // Create 3DS payment requesr
    // final createThreedsRequest = await iyzico.createThreedsPaymentRequest(
    //     paymentConversationId: '123456789');
    // print(createThreedsRequest);

    // // Init Checkout Form

    // final initChecoutForm = await iyzico.initializeCheoutForm(
    //     price: price,
    //     paidPrice: paidPrice,
    //     paymentCard: paymentCard,
    //     buyer: buyer,
    //     shippingAddress: shippingAddress,
    //     billingAddress: billingAddress,
    //     basketItems: basketItems,
    //     callbackUrl: 'www.test.com',
    //     enabledInstallments: []);
    // print(initChecoutForm);

    // final retrieveCheckoutForm =
    //     await iyzico.retrieveCheckoutForm(token: 'token');
    // print(retrieveCheckoutForm);
  }

  Future<void> _showMyDialog(String title, String content) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
          );
        }).then((value) => {
          setState(() {
            _isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Iyzipay Entegre'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                height: 155,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        textColor: Colors.black,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Kart Numarası',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'SKT',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Kart Sahibi',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: const Color(0xff1b447b),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Ödeme Yap',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () {
                          makePayment();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const PaymentSuccessfulPage()));
                          // if (_status == "success") {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (BuildContext context) =>
                          //               const PaymentSuccessfulPage()));
                          // } else {
                          //   _showMyDialog('Ödeme Başarısız', _err.toString());
                          // }

                          // if (formKey.currentState!.validate()) {
                          //   print('valid!');
                          // } else {
                          //   print('invalid!');
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
