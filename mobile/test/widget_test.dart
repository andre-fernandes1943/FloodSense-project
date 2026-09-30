// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:relatorio_ocorrencia/main.dart';

void main() {
  testWidgets('exibe somente o formulário de ocorrência', (tester) async {
    await tester.pumpWidget(const OccurrenceApp());

    expect(find.text('Registrar ocorrência'), findsOneWidget);
    expect(find.text('Descrição'), findsOneWidget);
    expect(find.text('Localização'), findsOneWidget);
    expect(find.text('Data e hora'), findsOneWidget);
    expect(find.text('Foto da ocorrência'), findsOneWidget);
    expect(find.text('Tirar foto'), findsOneWidget);
    expect(find.text('Usar localização atual'), findsOneWidget);
    expect(find.text('Mapa'), findsNothing);
    expect(find.text('Minhas ocorrências'), findsNothing);
  });

  testWidgets('valida descrição e localização obrigatórias', (tester) async {
    await _openOccurrenceForm(tester);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preparar envio'));
    await tester.pumpAndSettle();

    expect(find.text('Informe a descrição da ocorrência.'), findsOneWidget);
    expect(find.text('Informe a localização da ocorrência.'), findsOneWidget);
    expect(find.text('Tire uma foto para registrar a ocorrência.'), findsOneWidget);
  });

  testWidgets('prepara o payload JSON quando o formulário é válido', (tester) async {
    await _openOccurrenceForm(tester, withPhoto: true);
    await tester.tap(find.text('Tirar foto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Semáforo apagado',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Rua das Flores, 10',
    );
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preparar envio'));
    await tester.pumpAndSettle();

    final payload = tester.widget<SelectableText>(find.byType(SelectableText));
    expect(payload.data, contains('"descricao": "Semáforo apagado"'));
    expect(payload.data, contains('"localizacao": "Rua das Flores, 10"'));
    expect(payload.data, contains('"dataHora":'));
    expect(payload.data, contains('"fotoNome": "foto-ocorrencia"'));
    expect(payload.data, contains('"fotoBase64":'));
  });
}

Future<void> _openOccurrenceForm(
  WidgetTester tester, {
  bool withPhoto = false,
}) async {
  await tester.pumpWidget(OccurrenceApp(
    photoPicker: withPhoto
        ? () async => XFile.fromData(
            Uint8List.fromList(base64Decode(
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/mHUAAAAASUVORK5CYII=',
            )),
            name: 'foto.png',
            mimeType: 'image/png',
          )
        : null,
  ));
}
