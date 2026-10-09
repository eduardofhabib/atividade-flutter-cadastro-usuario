# Verificação da atividade

Verificação realizada em 09/10/2026.

- Flutter 3.47.7 (canal stable) e Dart 3.13.5.
- JDK 17 e Android SDK 36 instalados; licenças aceitas.
- `flutter analyze`: nenhum problema encontrado.
- `flutter test`: seis testes aprovados.
- `flutter build web`: compilação concluída.
- `flutter build apk --debug`: compilação concluída; APK Android gerado.
- Aplicativo executado no Brave em uma janela de teste de 430 × 900 pixels.
- No Brave, confirmado que campos vazios exibem erros individuais e SnackBar vermelho.
- No Brave, confirmado que letras, espaços e pontuação são removidos de CPF e telefone.
- No Brave, confirmado o cadastro com dados válidos e SnackBar verde.
- Nenhum erro de execução JavaScript durante a verificação no navegador.

Os prints usam dados fictícios. O formulário demonstra validação e captura em memória; não cria contas em um serviço externo.
