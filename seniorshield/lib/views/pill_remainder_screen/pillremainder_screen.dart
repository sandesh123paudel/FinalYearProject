import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/services/local_notifications.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../models/medicine.dart';
import '../../services/medicine_helper.dart';

class PillRemainderScreen extends StatefulWidget {
  const PillRemainderScreen({Key? key}) : super(key: key);

  @override
  State<PillRemainderScreen> createState() => _PillRemainderScreenState();
}

class _PillRemainderScreenState extends State<PillRemainderScreen> {

  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    print('initState called');
    _loadMedicines();


  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final medicines = await MedicineStorage.loadMedicineList();
    print('Loaded medicines: $medicines');
    setState(() {
      _medicines = medicines;
    });
  }

  void _deleteMedicine(Medicine medicine) async {
    final bool confirm = await _showDeleteConfirmationDialog();
    if (confirm) {
      await MedicineStorage.deleteMedicine(medicine);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kPrimaryColor,
          title:  ResponsiveText('Confirm',textColor: kDefaultIconLightColor),
          content:  ResponsiveText('Are you sure you want to delete this medicine?',textColor: kDefaultIconLightColor),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) =>kDefaultIconLightColor)
              ),
              onPressed: () => Navigator.of(context).pop(true),

              child:  ResponsiveText('Delete',textColor: kPrimaryColor),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) =>kDefaultIconLightColor)
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child:  ResponsiveText('Cancel',textColor: kPrimaryColor,),
            ),
          ],
        );
      },
    ) ?? false; // In case the dialog is dismissed by tapping outside of it
  }


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
            Expanded(
              child: StreamBuilder<List<Medicine>>(
                stream: MedicineStorage.medicineListStream,
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final medicines = snapshot.data!;
                      return ListView.builder(
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return MedicineItem(
                            number: '${index + 1}.',
                            name: medicine.name,
                            dosage: medicine.dosage,
                            reminderTime: medicine.reminderTime,
                            onDelete: () {
                              _deleteMedicine(medicine);
                            },
                          );
                        },
                      );
                    } else {
                      // Show message when medicine list is empty
                      return Center(
                        child: ResponsiveText(
                          'No medicine Added yet',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          textColor: kPrimaryColor,
                        ),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

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



class AddMedicineForm extends StatefulWidget {
  @override
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  late TimeOfDay selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _dosageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(kHorizontalMargin * 2),
          child: Form(
            key: _formKey,
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
                TextFieldWidget(
                  controller: _medicineNameController,
                  hintText: "Sinex",
                  labelText: "Medicine Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medicine name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: kVerticalMargin),
                TextFieldWidget(
                  controller: _dosageController,
                  hintText: "3 Capsules",
                  labelText: "Dosages",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dosage';
                    }
                    return null;
                  },
                ),
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
                      backgroundColor: MaterialStateProperty.all(kGreenBorderColor),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addMedicine();
                        Navigator.pop(context);
                      }
                    },
                    child: ResponsiveText(
                      "Add Remainder",
                      textColor: kDefaultIconLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _addMedicine() async {
    final Medicine newMed = Medicine(
      name: _medicineNameController.text,
      dosage: _dosageController.text,
      reminderTime: DateFormat('HH:mm').format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      )),
    );

    List<Medicine> currentMeds = await MedicineStorage.loadMedicineList();
    currentMeds.add(newMed);
    await MedicineStorage.saveMedicineList(currentMeds);

    // Schedule the notification
    String reminderTimeString = newMed.reminderTime;
    List<String> timeParts = reminderTimeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Create a DateTime object with the scheduled time
    DateTime scheduledTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
    );

    // Schedule the notification
    NotificationHeleper.scheduledNotification(
      'Medicine Reminder',
      'It\'s time to take your ${newMed.name} (${newMed.dosage})',
      scheduledTime,
    );
  }





}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const TextFieldWidget({
    required this.hintText,
    required this.labelText,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
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

class MedicineItem extends StatelessWidget {
  final String number;
  final String name;
  final String dosage;
  final String reminderTime;
  final VoidCallback onDelete;

  const MedicineItem({
    required this.number,
    required this.name,
    required this.dosage,
    required this.reminderTime,
    required this.onDelete,
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
            SizedBox(width: kHorizontalMargin),
            ResponsiveText(
              reminderTime,
              textColor: kDefaultIconLightColor,
              fontSize: 16,
            ),
            SizedBox(width: kHorizontalMargin),
            IconButton(
              icon: Icon(Icons.delete, color: kDefaultIconLightColor),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
