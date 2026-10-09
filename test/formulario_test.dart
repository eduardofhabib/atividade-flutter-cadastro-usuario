import 'package:cadastro_usuario/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> abrir(WidgetTester tester) async {
    // Altura suficiente para verificar todos os campos sem rolagem.
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MeuApp());
  }

  Future<void> preencher(WidgetTester tester, List<String> valores) async {
    final campos = find.byType(TextFormField);
    for (var i = 0; i < valores.length; i++) {
      await tester.enterText(campos.at(i), valores[i]);
    }
  }

  Future<void> cadastrar(WidgetTester tester) async {
    await tester.ensureVisible(find.text('CADASTRAR'));
    await tester.tap(find.text('CADASTRAR'));
    await tester.pumpAndSettle();
  }

  testWidgets('Campos vazios exibem erros individuais e SnackBar vermelho', (
    tester,
  ) async {
    await abrir(tester);
    await cadastrar(tester);

    for (final mensagem in [
      'Informe o nome completo.',
      'Informe o e-mail.',
      'Informe o CPF.',
      'Informe o telefone.',
      'Informe a senha.',
      'Informe a confirmação da senha.',
    ]) {
      expect(find.text(mensagem), findsOneWidget);
    }
    expect(find.text('Corrija os campos indicados.'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.red,
    );
  });

  testWidgets('Valida e-mail, senha curta e confirmação diferente', (
    tester,
  ) async {
    await abrir(tester);
    await preencher(tester, [
      'Aluno Teste',
      'aluno@',
      '12345678900',
      '11999990000',
      '12345',
      'outra',
    ]);
    await cadastrar(tester);

    expect(
      find.text('Informe um e-mail válido (ex.: nome@email.com).'),
      findsOneWidget,
    );
    expect(
      find.text('A senha deve ter no mínimo 6 caracteres.'),
      findsOneWidget,
    );
    expect(find.text('As senhas devem ser iguais.'), findsOneWidget);
    expect(find.text('Cadastro realizado com sucesso!'), findsNothing);
  });

  testWidgets('CPF e telefone filtram letras, espaços e pontuação', (
    tester,
  ) async {
    await abrir(tester);
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(2), 'abc123.456.789-00');
    await tester.enterText(campos.at(3), '(11) 99999-0000xyz');
    final entradas = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .toList();
    expect(entradas[2].controller.text, '12345678900');
    expect(entradas[3].controller.text, '11999990000');
  });

  testWidgets('Mostra e oculta a senha e a confirmação', (tester) async {
    await abrir(tester);
    List<EditableText> entradas() =>
        tester.widgetList<EditableText>(find.byType(EditableText)).toList();
    expect(entradas()[4].obscureText, isTrue);
    expect(entradas()[5].obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();
    expect(entradas()[4].obscureText, isFalse);
    expect(entradas()[5].obscureText, isFalse);
    await tester.tap(find.byTooltip('Ocultar senha'));
    await tester.pump();
    expect(entradas()[4].obscureText, isTrue);
    expect(entradas()[5].obscureText, isTrue);
  });

  testWidgets('Dados válidos exibem SnackBar de sucesso', (tester) async {
    await abrir(tester);
    await preencher(tester, [
      'Aluno Teste',
      'aluno@example.com',
      '12345678900',
      '11999990000',
      '123456',
      '123456',
    ]);
    await cadastrar(tester);
    expect(find.text('Cadastro realizado com sucesso!'), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.green,
    );
    expect(find.text('Corrija os campos indicados.'), findsNothing);
  });

  testWidgets('Tela pequena com teclado permite rolar sem overflow', (
    tester,
  ) async {
    await abrir(tester);
    tester.view.physicalSize = const Size(360, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();
    await cadastrar(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Corrija os campos indicados.'), findsOneWidget);
  });
}
