

import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

class PillRemainderScreen extends StatefulWidget {
  const PillRemainderScreen({Key? key}) : super(key: key);

  @override
  State<PillRemainderScreen> createState() => _PillRemainderScreenState();
}

class _PillRemainderScreenState extends State<PillRemainderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kVerticalMargin),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ResponsiveText(
                "Your Medicines",
                fontSize: 20,
                textColor: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: kVerticalMargin),
            MedicineItem(number: "1", name: "Blood Pressure", dosage: "3 capsules"),
            SizedBox(height: kVerticalMargin / 3),
            MedicineItem(number: "2", name: "Pressure", dosage: "3 capsules"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddMedicineForm();
            },
          );
        },
        child: Icon(Icons.add, color: kDefaultIconLightColor),
      ),
    );
  }
}

class MedicineItem extends StatelessWidget {
  final String number;
  final String name;
  final String dosage;

  const MedicineItem({
    required this.number,
    required this.name,
    required this.dosage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(kHorizontalMargin),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            ResponsiveText(
              number,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              textColor: kDefaultIconLightColor,
            ),
            SizedBox(width: kHorizontalMargin),
            ResponsiveText(
              name,
              textColor: kDefaultIconLightColor,
              fontSize: 16,
            ),
            SizedBox(width: kHorizontalMargin),
            Expanded(
              child: ResponsiveText(
                dosage,
                textColor: kDefaultIconLightColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddMedicineForm extends StatefulWidget {
  @override
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(kHorizontalMargin * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                "Add your medicines",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textColor: kDefaultIconLightColor,
              ),
              SizedBox(height: kVerticalMargin),
              const TextFieldWidget(hintText: "Sinex", labelText: "Medicine Name"),
              SizedBox(height: kVerticalMargin),
              const TextFieldWidget(hintText: "3 Capsules", labelText: "Dosages"),
              SizedBox(height: kVerticalMargin),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kGreenShadowColor),

                ),
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.dialOnly,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                    print("Selected time: $selectedTime");
                    // Here you can handle the selected time
                  }
                },
                child: ResponsiveText(
                  selectedTime == TimeOfDay.now()
                      ? "Choose Time"
                      : selectedTime.format(context),
                  textColor: kDefaultIconLightColor,
                ),
              ),
              SizedBox(height: kVerticalMargin),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kGreenBorderColor)
                    ),
                    onPressed: (){
                      Navigator.pop(context);

                    }, child: ResponsiveText(
                  "Add Remainder",
                  textColor: kDefaultIconLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,

                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final String labelText;

  const TextFieldWidget({
    required this.hintText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: kDefaultIconLightColor),
      cursorColor: kDefaultIconLightColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: kDefaultIconLightColor.withOpacity(0.8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: kDefaultIconLightColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}