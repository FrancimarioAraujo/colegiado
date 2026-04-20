import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';

Future<void> initLocale() async {
  try {
    // Primeiro, define o locale padrão
    Intl.defaultLocale = 'pt_BR';
    
    // Depois, tenta inicializar os dados de formatação
    await initializeDateFormatting('pt_BR', null);
    
    print('✓ Locale pt_BR inicializado com sucesso');
  } catch (e) {
    print('⚠️ Aviso ao inicializar locale: $e');
    print('Tentando inicializar com fallback...');
    
    try {
      // Fallback: tenta com US English
      Intl.defaultLocale = 'en_US';
      await initializeDateFormatting('en_US', null);
      print('✓ Fallback para en_US realizado');
    } catch (e2) {
      print('❌ Erro no fallback: $e2');
      print('Continuando com locale padrão...');
    }
  }
}
