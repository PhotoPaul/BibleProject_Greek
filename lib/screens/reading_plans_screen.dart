import 'package:bibleproject_greek/screens/widgets/reading_plan_widget.dart';
import 'package:bibleproject_greek/types/ReadingPlan.dart';
import 'package:flutter/material.dart';

class ReadingPlans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReadingPlansState();
}

class _ReadingPlansState extends State<ReadingPlans> {
  List<ReadingPlan> _readingPlans = [
    new ReadingPlan(
      id: "0",
      title: "Προσμένουμε την Έλευση",
      description:
          'Το BibleProject δημιούργησε το πρόγραμμα «Προσμένουμε την Έλευση» για να εμπνεύσει άτομα, μικρές ομάδες και οικογένειες να γιορτάσουν την Έλευση του Χριστού. Αυτό το πρόγραμμα τεσσάρων εβδομάδων περιλαμβάνει βίντεο, περιλήψεις και ερωτήσεις που βοηθούν όσους συμμετέχουν να αναλογιστούν και να αναζητήσουν το βιβλικό νόημα της ελπίδας, της ειρήνης, της χαράς και της αγάπης. Επιλέξτε αυτό το πρόγραμμα για να δείτε πώς ο Χριστός έφερε στον κόσμο αυτές τις τέσσερις αξίες.',
      thumbnail: "https://s3.amazonaws.com/yvplans/30643/720x405.jpg",
      url:
          'https://www.bible.com/el/reading-plans/30643-bibleproject-prosmenoume-ten-eleuse',
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
          itemCount: _readingPlans.length,
          itemBuilder: (BuildContext context, int index) {
            return ReadingPlanWidget(data: _readingPlans[index]);
          }),
    );
  }
}
