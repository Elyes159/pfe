// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe_1/french_course/bonjour/lecons/lecon1/lecon1.dart';
import '../../../../constant/question.dart';

class ExLeconthree extends StatefulWidget {
  const ExLeconthree({super.key});

  @override
  _ExLeconthreeState createState() => _ExLeconthreeState();
}

class _ExLeconthreeState extends State<ExLeconthree> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  double _progress = 0.0;

  List<dynamic> questions = [
    Question(
      'the croissant',
      [
        Option1('le croissant', 'assets/croissant.png'),
        Option1('la pizza', 'assets/pizza.png'),
        Option1("l'orange", 'assets/orange.png'),
        Option1("pomme", 'assets/pomme.png'),
      ],
      [false, false, false, false],
      [true, false, false, false],
    ),
    ScrambledWordsQuestion(
      correctSentence: 'a croissant',
      questionText: 'un croissant',
      additionalWords: [
        'are',
        "it's",
        'boy',
        'man'
      ], // Liste des mots supplémentaires
    ),
    Question(
      'the orange',
      [
        Option1("l'orange", 'assets/orange.png'),
        Option1('la pizza', 'assets/pizza.png'),
        Option1("le croissant", 'assets/croissant.png'),
        Option1("pomme", 'assets/pomme.png'),
      ],
      [false, false, false, false],
      [true, false, false, false],
    ),

    SoundQuestion(
      questionText: 'What is the correctly pronounced word?',
      options: [
        Option1('a', 'assets/chat.png'),
        Option1('ante', 'assets/chat.png'),
        Option1('ant', 'assets/chat.png'),
        Option1('anna', 'assets/chat.png'),
      ],
      spokenWord: 'ant', // Remplacez par le mot correctement prononcé
      selectedWord:
          '', // Laissez vide pour le moment, à remplir lors de la sélection par l'utilisateur
    ),
    Question(
      'the sandwich',
      [
        Option1('la cuisine', 'assets/cuisine.png'),
        Option1('thé', 'assets/thé.png'),
        Option1('le sandwich', 'assets/sandwich.png'),
        Option1('Le gâteau', 'assets/gateau.png'),
      ],
      [false, false, false, false],
      [false, false, true, false],
    ),
    ScrambledWordsQuestion(
      correctSentence: 'an orange',
      questionText: 'une orange',
      additionalWords: [
        'are',
        'eating',
        'boy',
        "it"
      ], // Liste des mots supplémentaires
    ),
    Question(
      'the cheese',
      [
        Option1('la cuisine', 'assets/cuisine.png'),
        Option1('le fromage', 'assets/fromage.png'),
        Option1('le sandwich', 'assets/sandwich.png'),
        Option1('Le gâteau', 'assets/gateau.png'),
      ],
      [false, false, false, false],
      [false, true, false, false],
    ),
    Question(
      'the pizza',
      [
        Option1('le croissant', 'assets/croissant.png'),
        Option1('la pizza', 'assets/pizza.png'),
        Option1("l'orange", 'assets/orange.png'),
        Option1("pomme", 'assets/pomme.png'),
      ],
      [false, false, false, false],
      [false, true, false, false],
    ),

    ScrambledWordsQuestion(
      correctSentence: "a croissant and an orange",
      questionText: "un croissant et une orange",
      additionalWords: [
        'pizza',
        'man',
        'horse',
        "it"
      ], // Liste des mots supplémentaires
    ),
    SoundQuestion(
      questionText: 'What is the correctly pronounced word?',
      options: [
        Option1('pissa', 'assets/chat.png'),
        Option1('croissant', 'assets/chat.png'),
        Option1('pizza', 'assets/chat.png'),
        Option1('orange', 'assets/chat.png'),
      ],
      spokenWord: 'pizza', // Remplacez par le mot correctement prononcé
      selectedWord:
          '', // Laissez vide pour le moment, à remplir lors de la sélection par l'utilisateur
    ),

    ScrambledWordsQuestion(
      correctSentence: "It's an orange",
      questionText: "C'est une orange",
      additionalWords: [
        'are',
        'is',
        'horse',
        'man'
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: 'Marie is eating',
      questionText: 'Marie mange',
      additionalWords: [
        'croissant',
        'pizza',
        'it',
        'orange'
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: 'You are eating a pizza',
      questionText: 'Tu mange une pizza',
      additionalWords: [
        'girl',
        "it's",
        'woman',
        'is'
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: "Un chat mange un croissant",
      questionText: "A cat is eating a croissant",
      additionalWords: [
        'homme',
        'et',
        'fille',
        'farçon',
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: "Tu manges une pizza",
      questionText: "You are eating a pizza",
      additionalWords: [
        'homme',
        'femme',
        'orange',
        'suis',
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: "A woman is eating an orange",
      questionText: "Une femme mange une orange",
      additionalWords: [
        'horse',
        "it's",
        'girl',
        'croissant',
      ], // Liste des mots supplémentaires
    ),
    ScrambledWordsQuestion(
      correctSentence: "A girl and a dog",
      questionText: "Une fille et un chien",
      additionalWords: [
        'horse',
        "it's",
        'you',
        'are',
      ], // Liste des mots supplémentaires
    ), // Add more questions as needed
  ];
  void addQuestionsToFirestore() async {
    try {
      // Obtenez une référence à la collection "questions" dans Firestore
      CollectionReference questionsCollection = FirebaseFirestore.instance
          .collection('cours')
          .doc('bonjour')
          .collection('lecons')
          .doc('lecon3')
          .collection('questions');

      // Parcourez chaque question dans la liste et ajoutez-la à Firestore
      for (int i = 0; i < questions.length; i++) {
        var question = questions[i];
        String questionDocumentName = 'question${i + 1}';

        if (question is Question) {
          await questionsCollection.doc(questionDocumentName).set({
            'type': 'Question',
            'questionText': question.questionText,
            'options': question.options
                .map((option) => {
                      'text': option.text,
                      'imagePath': option.imagePath,
                    })
                .toList(),
            'selectedOptions': question.selectedOptions,
            'correctOptions': question.correctOptions,
          });
        } else if (question is SoundQuestion) {
          await questionsCollection.doc(questionDocumentName).set({
            'type': 'SoundQuestion',
            'questionText': question.questionText,
            'options': question.options
                .map((option) => {
                      'text': option.text,
                      'imagePath': option.imagePath,
                    })
                .toList(),
            'spokenWord': question.spokenWord,
            'selectedWord': question.selectedWord,
          });
        } else if (question is ScrambledWordsQuestion) {
          await questionsCollection.doc(questionDocumentName).set({
            'type': 'ScrambledWordsQuestion',
            'questionText': question.questionText,
            'correctSentence': question.correctSentence,
            'selectedWords': question.selectedWords,
            'selectedWordOrder': question.selectedWordOrder,
            'additionalWords': question.additionalWords,
          });
        } else if (question is TranslationQuestion) {
          await questionsCollection.doc(questionDocumentName).set({
            'type': 'TranslationQuestion',
            'originalText': question.originalText,
            'correctTranslation': question.correctTranslation,
            'userTranslationn': question.userTranslationn,
          });
        }
      }

      print('Toutes les questions ont été ajoutées à Firestore avec succès');
    } catch (e) {
      print('Erreur lors de l\'ajout des questions à Firestore : $e');
    }
  }

  void importQuestionsFromFirestore() async {
    try {
      // Obtenez une référence à la collection "admin" dans Firestore
      CollectionReference adminCollection =
          FirebaseFirestore.instance.collection('admin');

      // Récupérez tous les documents de la sous-collection "Question_added"
      QuerySnapshot querySnapshot = await adminCollection
          .doc("T3Ql5faOK93AQp390964")
          .collection("Question_added")
          .where('chapitre_lecon', isEqualTo: 'bonjour/lecon3')
          .get();

      // Parcourez les documents récupérés
      for (var doc in querySnapshot.docs) {
        // Vérifiez si le document contient des données
        if (doc.exists) {
          // Récupérez les données du document Firestore
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Vérifiez le type de question et ajoutez-la à la liste "questions" en conséquence
          if (data.containsKey('spokenWord')) {
            // Si le document est de type SoundQuestion
            SoundQuestion soundQuestion = SoundQuestion(
              questionText: data['questionText'],
              options: (data['options'] as List<dynamic>)
                  .map((option) => Option1(
                        option['text'],
                        option['imagePath'],
                      ))
                  .toList(),
              spokenWord: data['spokenWord'],
              selectedWord: '', // Initialiser selectedWord selon vos besoins
            );
            setState(() {
              questions.add(soundQuestion);
            });
          }
        }
      }
    } catch (e) {
      print("Erreur lors de l'importation des questions depuis Firestore : $e");
    }
  }

  void _showBottomSheetTranslation(
      bool isCorrect, TranslationQuestion question) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: isCorrect ? Color(0xFFF5FFD8) : Color(0xFFFFDDD8),
              borderRadius: BorderRadius.circular(20)),
          height: 230.0,
          width: 350,
          // Adjust the height here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
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
                      isCorrect
                          ? "Amazing!....."
                          : "Answer : \n ${question.correctTranslation}",
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        color: isCorrect ? Colors.green : Color(0xFFFF2442),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () {
                        // Add the code you want to execute when the button is pressed
                        Navigator.pop(context); // Close the BottomSheet
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            isCorrect ? Color(0xFF99CC29) : Colors.red,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              100.0), // Adjust the borderRadius value
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal:
                                120.0), // Adjust padding for height and width
                        minimumSize: const Size(200.0,
                            40.0), // Set minimum size for height and width
                      ),
                      child: isCorrect
                          ? const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                ],
              ),
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
          decoration: BoxDecoration(
              color: isCorrect ? Color(0xFFF5FFD8) : Color(0xFFFFDDD8),
              borderRadius: BorderRadius.circular(20)),
          height: 200.0,
          width: 350,
          // Adjust the height here
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
                    isCorrect ? "Amazing!" : "don't worry",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      color: isCorrect ? Colors.green : Color(0xFFFF2442),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: () {
                      // Add the code you want to execute when the button is pressed
                      Navigator.pop(context); // Close the BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isCorrect ? Color(0xFF99CC29) : Colors.red,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100.0), // Adjust the borderRadius value
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal:
                              120.0), // Adjust padding for height and width
                      minimumSize: const Size(
                          200.0, 40.0), // Set minimum size for height and width
                    ),
                    child: isCorrect
                        ? const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetForSoundQuestion(
      bool isCorrect, SoundQuestion question) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: isCorrect ? Color(0xFFF5FFD8) : Color(0xFFFFDDD8),
              borderRadius: BorderRadius.circular(20)),
          height: 200.0,
          width: 350,
          // Adjust the height here
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
                    isCorrect ? "Amazing!" : "don't worry",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      color: isCorrect ? Colors.green : Color(0xFFFF2442),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: () {
                      // Add the code you want to execute when the button is pressed
                      Navigator.pop(context); // Close the BottomSheet
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isCorrect ? Color(0xFF99CC29) : Colors.red,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100.0), // Adjust the borderRadius value
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal:
                              120.0), // Adjust padding for height and width
                      minimumSize: const Size(
                          200.0, 40.0), // Set minimum size for height and width
                    ),
                    child: isCorrect
                        ? const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetScrambled(
      bool isCorrect, ScrambledWordsQuestion question) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: isCorrect ? Color(0xFFF5FFD8) : Color(0xFFFFDDD8),
              borderRadius: BorderRadius.circular(20)),
          height: 200.0,
          width: 350,
          // Adjust the height here
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
                    isCorrect ? "Amazing!" : "don't worry",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      color: isCorrect ? Colors.green : Color(0xFFFF2442),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Add the code you want to execute when the button is pressed
                    Navigator.pop(context); // Close the BottomSheet
                    if (isCorrect) {
                      _nextPageForScrambledWordsQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isCorrect ? Color(0xFF99CC29) : Colors.red,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          100.0), // Adjust the borderRadius value
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal:
                            120.0), // Adjust padding for height and width
                    minimumSize: const Size(
                        200.0, 40.0), // Set minimum size for height and width
                  ),
                  child: isCorrect
                      ? const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

///////////////////////////////////////////////////
  Future<void> _nextPageForScrambledWordsQuestion() async {
    // Check if the current question is of type ScrambledWordsQuestion
    if (questions[_currentPage] is ScrambledWordsQuestion) {
      ScrambledWordsQuestion currentQuestion =
          questions[_currentPage] as ScrambledWordsQuestion;

      // Vérifiez si les mots sélectionnés sont dans le bon ordre
      bool isCorrectOrder = ListEquality().equals(
        currentQuestion.selectedWords,
        currentQuestion.correctSentence.split(' '),
      );

      if (isCorrectOrder) {
        // Show Bottom Sheet with "Correct" text
        _showBottomSheetScrambled(isCorrectOrder, currentQuestion);

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
          Navigator.of(context).pushReplacementNamed("frenshunities");

          if (courseSnapshot.docs.isNotEmpty) {
            setState(() {
              // Le document existe avec le code 'fr'
              // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
              // et vérifier la valeur actuelle du champ 'lecon3Bonjour'

              // Mettez à jour le champ 'lecon3Bonjour' car il n'est pas encore vrai
              FirebaseFirestore.instance
                  .collection('user_levels')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('courses')
                  .doc(courseSnapshot.docs[0].id)
                  .update({
                'lecon3Bonjour': true,
              });

              print('Champ lecon3Bonjour ajouté avec succès!');
            });
          } else {
            // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
            print('Le champ lecon3Bonjour est déjà vrai!');
          }
        }
      } else {
        // Show Bottom Sheet with "Incorrect" text
        _showBottomSheetScrambled(isCorrectOrder, currentQuestion);
      }
    } else {
      // Handle the case where the current question is not of type ScrambledWordsQuestion
      // You may want to show an error message or take appropriate action.
      print('Current question is not of type ScrambledWordsQuestion');
    }
  }

  Future<bool> _nextPageForSoundQuestion() async {
    if (questions[_currentPage] is SoundQuestion) {
      String spokenWord = (questions[_currentPage] as SoundQuestion).spokenWord;
      String selectedWord =
          (questions[_currentPage] as SoundQuestion).selectedWord;

      bool isCorrect = spokenWord == selectedWord;

      if (isCorrect) {
        // Show Bottom Sheet with "Correct" text
        _showBottomSheetForSoundQuestion(isCorrect, questions[_currentPage]);

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
          Navigator.of(context).pushReplacementNamed("frenshunities");

          if (courseSnapshot.docs.isNotEmpty) {
            setState(() {
              // Le document existe avec le code 'fr'
              // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
              // et vérifier la valeur actuelle du champ 'lecon3Bonjour'

              // Mettez à jour le champ 'lecon3Bonjour' car il n'est pas encore vrai
              FirebaseFirestore.instance
                  .collection('user_levels')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('courses')
                  .doc(courseSnapshot.docs[0].id)
                  .update({
                'lecon3Bonjour': true,
              });

              print('Champ lecon3Bonjour ajouté avec succès!');
            });
          } else {
            // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
            print('Le champ lecon3Bonjour est déjà vrai!');
          }
        }
      } else {
        // Show Bottom Sheet with "Incorrect" text
        _showBottomSheetForSoundQuestion(isCorrect, questions[_currentPage]);
      }

      return isCorrect;
    } else {
      // Gérer le cas où la question n'est pas de type SoundQuestion
      return false;
    }
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
        Navigator.of(context).pushReplacementNamed("frenshunities");

        if (courseSnapshot.docs.isNotEmpty) {
          setState(() {
            // Le document existe avec le code 'fr'
            // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
            // et vérifier la valeur actuelle du champ 'lecon3Bonjour'

            // Mettez à jour le champ 'lecon3Bonjour' car il n'est pas encore vrai
            FirebaseFirestore.instance
                .collection('user_levels')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('courses')
                .doc(courseSnapshot.docs[0].id)
                .update({
              'lecon3Bonjour': true,
            });

            print('Champ lecon3Bonjour ajouté avec succès!');
          });
        } else {
          // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
          print('Le champ lecon3Bonjour est déjà vrai!');
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
      _showBottomSheetTranslation(isCorrect, questions[_currentPage]);

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
        Navigator.of(context).pushReplacementNamed("frenshunities");

        if (courseSnapshot.docs.isNotEmpty) {
          setState(() {
            // Le document existe avec le code 'fr'
            // Vous pouvez accéder aux données du premier document trouvé (courseSnapshot.docs[0])
            // et vérifier la valeur actuelle du champ 'lecon3Bonjour'

            // Mettez à jour le champ 'lecon3Bonjour' car il n'est pas encore vrai
            FirebaseFirestore.instance
                .collection('user_levels')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('courses')
                .doc(courseSnapshot.docs[0].id)
                .update({
              'lecon3Bonjour': true,
            });

            print('Champ lecon3Bonjour ajouté avec succès!');
          });
        } else {
          // La condition est déjà vraie, vous pouvez faire quelque chose ici si nécessaire
          print('Le champ lecon3Bonjour est déjà vrai!');
        }
      }
    } else {
      // Show Bottom Sheet with "Incorrect" text
      _showBottomSheetTranslation(isCorrect, questions[_currentPage]);
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
                  } else if (questions[index] is ScrambledWordsQuestion) {
                    return ScrambledWordsQuestionWidget(
                      question: questions[index] as ScrambledWordsQuestion,
                      onCorrectAnswer: _nextPageForScrambledWordsQuestion,
                    );
                  } else if (questions[index] is SoundQuestion) {
                    return QuestionSound(
                      question: questions[index] as SoundQuestion,
                      onCorrectAnswer: _nextPageForSoundQuestion,
                    );
                  } else {
                    // Gérer le cas où le type de question n'est ni Question, ni TranslationQuestion, ni ScrambledWordsQuestion, ni SoundQuestion
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
