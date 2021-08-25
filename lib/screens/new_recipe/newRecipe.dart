import 'package:flutter/material.dart';
import 'package:tassie/models/enduser.dart';
import 'package:tassie/utilities/auth.dart';
import 'package:tassie/utilities/database.dart';

class NewRecipe extends StatefulWidget {
  late final EndUser? user;
  NewRecipe({this.user});
  @override
  _NewRecipeState createState() => _NewRecipeState(user: user);
}

class _NewRecipeState extends State<NewRecipe> {
  late final EndUser? user;
  _NewRecipeState({this.user});

  List<Widget> _getRecipe() {
    List<Widget> recipeTextFields = [];
    for (int i = 0; i < stepsList.length; i++) {
      recipeTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: StepTextField(index: i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButtonR(i == stepsList.length - 1, i),
          ],
        ),
      ));
    }
    return recipeTextFields;
  }

  Widget _addRemoveButtonR(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          stepsList.insert(0, null);
        } else
          stepsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getIngredient() {
    List<Widget> ingredientsTextFields = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredientsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: IngredientTextField(index: i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButtonI(i == ingredientsList.length - 1, i),
          ],
        ),
      ));
    }
    return ingredientsTextFields;
  }

  Widget _addRemoveButtonI(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          ingredientsList.insert(0, null);
        } else
          ingredientsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  /// add / remove button

  final AuthUtil _auth = AuthUtil();
  TextEditingController _stepController = TextEditingController();
  TextEditingController _ingredientController = TextEditingController();
  static List<String?> stepsList = [null];
  static List<String?> ingredientsList = [null];
  String recipeName = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _stepController = TextEditingController();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Add New Recipe'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name textfield
              Padding(
                padding: const EdgeInsets.only(right: 32.0),
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      recipeName = val;
                    });
                  },
                  controller: _stepController,
                  decoration: InputDecoration(hintText: 'Enter your name'),
                  validator: (v) {
                    if (v!.trim().isEmpty) return 'Please enter something';
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Add Steps',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              ..._getRecipe(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Add Ingredients',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              ..._getIngredient(),
              SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    await DatabaseUtil(uid: user?.uid)
                        .addNewRecipe(recipeName, ingredientsList, stepsList);
                  }
                },
                child: Text('Submit'),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepTextField extends StatefulWidget {
  late final int? index;

  StepTextField({this.index});
  @override
  _StepTextFieldState createState() => _StepTextFieldState();
}

class _StepTextFieldState extends State<StepTextField> {
  late TextEditingController _stepController;
  @override
  void initState() {
    super.initState();
    _stepController = TextEditingController();
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _stepController.text = _NewRecipeState.stepsList[widget.index!] ?? '';
    });
    return TextFormField(
      controller: _stepController,
      onChanged: (v) => _NewRecipeState.stepsList[widget.index!] = v,
      decoration: InputDecoration(hintText: 'Enter each step'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

class IngredientTextField extends StatefulWidget {
  late final int? index;

  IngredientTextField({this.index});
  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  late TextEditingController _ingredientController;
  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ingredientController.text =
          _NewRecipeState.ingredientsList[widget.index!] ?? '';
    });
    return TextFormField(
      controller: _ingredientController,
      onChanged: (v) => _NewRecipeState.ingredientsList[widget.index!] = v,
      decoration: InputDecoration(hintText: 'Enter each step'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
