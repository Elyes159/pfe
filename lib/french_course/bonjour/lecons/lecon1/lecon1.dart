import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constant/question.dart';

class ExLeconOne extends StatefulWidget {
  @override
  _ExLeconOneState createState() => _ExLeconOneState();
}

class _ExLeconOneState extends State<ExLeconOne> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  double _progress = 0.0;

  List<dynamic> questions = [
    Question(
      'la femme',
      [
        Option1('the cat', 'assets/chat.png'),
        Option1('the girl', 'assets/fille.png'),
        Option1('the woman', 'assets/mere.png'),
        Option1('one', 'assets/main.png'),
      ],
      [false, false, false, false],
      [false, false, true, false],
    ),
    Question(
      'Question 2',
      [
        Option1('Option 1', 'assets/UserCircle.png'),
        Option1('Option 2', 'assets/UserCircle.png'),
        Option1('Option 3', 'assets/UserCircle.png'),
        Option1('Option 4', 'assets/UserCircle.png'),
      ],
      [false, false, false, false],
      [true, false, false, false],
    ),
    TranslationQuestion(
      originalText: 'Bonjour',
      correctTranslation: 'good Morning',
      userTranslationn: '',
    ),
    Question(
      'Question 2',
      [
        Option1('Option 1', 'assets/UserCircle.png'),
        Option1('Option 2', 'assets/UserCircle.png'),
        Option1('Option 3', 'assets/UserCircle.png'),
        Option1('Option 4', 'assets/UserCircle.png'),
      ],
      [false, false, false, false],
      [true, false, false, false],
    ),
    TranslationQuestion(
      originalText: 'hello',
      correctTranslation: 'salut',
      userTranslationn: '',
    ),
    Question(
      'Question 2',
      [
        Option1('Option 1', 'assets/UserCircle.png'),
        Option1('Option 2', 'assets/UserCircle.png'),
        Option1('Option 3', 'assets/UserCircle.png'),
        Option1('Option 4', 'assets/UserCircle.png'),
      ],
      [false, false, false, false],
      [true, false, false, false],
    ), // Add more questions as needed
  ];
  void _showBottomSheetTranslation(String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

        return Container(
          width: screenWidth, // Utilisez la largeur de l'écran
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Ajoutez le code que vous souhaitez exécuter lorsque le bouton est pressé
                    Navigator.pop(context); // Fermez le BottomSheet
                  },
                  child: Text('Fermer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(bool isCorrect, Question question) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // ...
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isCorrect
                        ? "That's right"
                        : "Ups.. That's not quite right \n",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: isCorrect ? Colors.green : Color(0xFFFF2442),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Answer : ",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: isCorrect ? Colors.green : Color(0xFFFF2442),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Ajoutez le code que vous souhaitez exécuter lorsque le bouton est pressé
                    Navigator.pop(context); // Fermez le BottomSheet
                  },
                  child: Text('Fermer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _nextPageForQuestion() async {
    bool isCorrect = ListEquality().equals(
      (questions[_currentPage] as Question).selectedOptions,
      (questions[_currentPage] as Question).correctOptions,
    );

    if (isCorrect) {
      // Show Bottom Sheet with "Correct" text
      _showBottomSheet(isCorrect, questions[_currentPage]);

      if (_currentPage < questions.length - 1) {
        setState(() {
          _currentPage++;
          _progress = (_currentPage + 1) / questions.length;
          _pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        });
      } else {
        var courseSnapshot = await FirebaseFirestore.instance
            .collection('user_levels')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('courses')
            .where('code', isEqualTo: 'fr')
            .get();

        if (courseSnapshot.docs.isNotEmpty) {
          setState(() {
            // Le document existe avec le code 'fr'
            // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
            // et vérifier la valeur actuelle du champ 'lecon1Bonjour'

            // Mettez à jour le champ 'lecon1Bonjour' car il n'est pas encore vrai
            FirebaseFirestore.instance
                .collection('user_levels')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('courses')
                .doc(courseSnapshot.docs[0].id)
                .update({
              'lecon1Bonjour': true,
            });

            print('Champ lecon1Bonjour ajouté avec succès!');
          });
        } else {
          // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
          print('Le champ lecon1Bonjour est déjà vrai!');
        }
      }
    } else {
      // Show Bottom Sheet with "Incorrect" text
      _showBottomSheet(isCorrect, questions[_currentPage]);
    }

    return isCorrect;
  }

  Future<bool> _nextPageForTranslationQuestion(String userTranslation) async {
    String correctTranslation =
        (questions[_currentPage] as TranslationQuestion).correctTranslation;
    bool isCorrect =
        userTranslation.toLowerCase() == correctTranslation.toLowerCase();

    if (isCorrect) {
      // Show Bottom Sheet with "Correct" text
      _showBottomSheetTranslation("Next question");

      if (_currentPage < questions.length - 1) {
        setState(() {
          _currentPage++;
          _progress = (_currentPage + 1) / questions.length;
          _pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        });
      } else {
        var courseSnapshot = await FirebaseFirestore.instance
            .collection('user_levels')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('courses')
            .where('code', isEqualTo: 'fr')
            .get();

        if (courseSnapshot.docs.isNotEmpty) {
          setState(() {
            // Le document existe avec le code 'fr'
            // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
            // et vérifier la valeur actuelle du champ 'lecon1Bonjour'

            // Mettez à jour le champ 'lecon1Bonjour' car il n'est pas encore vrai
            FirebaseFirestore.instance
                .collection('user_levels')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('courses')
                .doc(courseSnapshot.docs[0].id)
                .update({
              'lecon1Bonjour': true,
            });

            print('Champ lecon1Bonjour ajouté avec succès!');
          });
        } else {
          // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
          print('Le champ lecon1Bonjour est déjà vrai!');
        }
      }
    } else {
      // Show Bottom Sheet with "Incorrect" text
      _showBottomSheetTranslation("resayer");
    }

    return isCorrect;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 55.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // Afficher le Bottom Sheet lorsque le bouton est cliqué
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        // Contenu du Bottom Sheet
                        return Container(
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/dangereux.png",
                                width: 100,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "Quit and you'll lose all XP gained in this lesson",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 25),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Fermer le Bottom Sheet lorsque le bouton est cliqué
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                      0xFF3DB2FF), // Couleur du fond du bouton
                                ),
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      'KEEP GOING',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    // Pas de couleur de fond spécifiée ici
                                    ),
                                onPressed: () {
                                  // Fermer le Bottom Sheet lorsque le bouton est cliqué
                                  Navigator.of(context)
                                      .pushReplacementNamed("home");
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      'QUIT',
                                      style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF3DB2FF),
                      size: 35,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 20,
                  width: 240,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                    value: _progress,
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    // Ne mettez à jour la barre de progression que si la réponse est correcte
                    if (questions[_currentPage] is Question) {
                      _progress = ListEquality().equals(
                        (questions[_currentPage] as Question).selectedOptions,
                        (questions[_currentPage] as Question).correctOptions,
                      )
                          ? (_currentPage + 1) / questions.length
                          : _progress;
                    }
                  });
                },
                physics: NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  if (questions[index] is Question) {
                    return ExercisePage(
                      question: questions[index],
                      onCorrectAnswer: _nextPageForQuestion,
                    );
                  } else if (questions[index] is TranslationQuestion) {
                    TextEditingController translationController =
                        TextEditingController(); // Créez un nouveau contrôleur pour chaque instance de TranslationExercisePage
                    return TranslationExercisePage.create(
                      question: questions[index] as TranslationQuestion,
                      translationController: translationController,
                      onCorrectAnswer: () => _nextPageForTranslationQuestion(
                          translationController.text.trim()),
                    );
                  } else {
                    // Gérer le cas où le type de question n'est ni Question ni TranslationQuestion
                    return Container(); // ou tout autre widget par défaut
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExercisePage extends StatefulWidget {
  final Question question;
  final VoidCallback onCorrectAnswer;

  ExercisePage({
    required this.question,
    required this.onCorrectAnswer,
  });

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("fr-FR");
  }

  Future<void> speak(String text) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select the correct image",
                style: GoogleFonts.poppins(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  speak(widget.question.questionText);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "assets/Volume button.png",
                    width: 100,
                  ),
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "${widget.question.questionText}",
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: widget.question.options.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    widget.question.selectedOptions[index] =
                        !widget.question.selectedOptions[index];
                  });

                  // speak(widget.question.options[index].text);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 200,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: widget.question.selectedOptions[index]
                          ? Color(0xFF3DB2FF)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          widget.question.options[index].imagePath,
                          width: 150,
                          height: 100,
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.question.options[index].text,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: widget.question.selectedOptions[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 50),
            child: ElevatedButton(
              onPressed: () {
                bool isCorrect = ListEquality().equals(
                  widget.question.selectedOptions,
                  widget.question.correctOptions,
                );

                if (isCorrect || !isCorrect) {
                  widget.onCorrectAnswer();
                } else {
                  // Gérez la logique de réponse incorrecte si nécessaire
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Color(0xFF3DB2FF), // Couleur du texte du bouton
                padding: EdgeInsets.all(16), // Espace intérieur du bouton
                minimumSize: Size(MediaQuery.of(context).size.width, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Ajustez cette valeur selon vos besoins
                ), // Largeur du bouton = largeur de l'écran
              ),
              child: Text(
                'CHECK',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TranslationExercisePage extends StatefulWidget {
  final TranslationQuestion question;
  final TextEditingController translationController;
  final VoidCallback onCorrectAnswer;

  TranslationExercisePage({
    required this.question,
    required this.translationController,
    required this.onCorrectAnswer,
  });

  @override
  _TranslationExercisePageState createState() =>
      _TranslationExercisePageState();

  // Ajoutez cette fonction de fabrique
  static TranslationExercisePage create({
    required TranslationQuestion question,
    required TextEditingController translationController,
    required VoidCallback onCorrectAnswer,
  }) {
    return TranslationExercisePage(
      question: question,
      translationController: translationController,
      onCorrectAnswer: onCorrectAnswer,
    );
  }
}

class _TranslationExercisePageState extends State<TranslationExercisePage> {
  // Retirez cette ligne
  // TextEditingController _translationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String correctTranslation = widget.question.correctTranslation;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.question.originalText,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          TextField(
            controller: widget.translationController, // Modifiez cette ligne
            decoration: InputDecoration(
              hintText: 'Traduisez ici...',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String userTranslation = widget.translationController.text
                  .trim(); // Modifiez cette ligne
              bool isCorrect = userTranslation.toLowerCase() ==
                  correctTranslation.toLowerCase();

              // Mettre à jour l'instance de TranslationQuestion avec la userTranslation
              widget.question.userTranslationn = userTranslation;

              if (isCorrect) {
                widget.onCorrectAnswer();
              } else {
                // Gérer la logique pour une réponse incorrecte si nécessaire
              }
            },
            child: Text('Vérifier la traduction'),
          ),
        ],
      ),
    );
  }
}
