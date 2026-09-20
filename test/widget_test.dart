import 'package:flutter_test/flutter_test.dart';
import 'package:mes_notes/main.dart';

void main() {
  testWidgets('L’écran de connexion s’affiche', (WidgetTester tester) async {
    await tester.pumpWidget(const MesNotesApp());

    expect(find.text('Mes Notes'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Nom d’utilisateur'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });
}
