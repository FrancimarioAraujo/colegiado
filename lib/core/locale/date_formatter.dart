import 'package:intl/intl.dart';

/// Helper para formatação segura de datas
/// Funciona tanto em web quanto em plataformas nativas
class DateFormatter {
  /// Formata uma data no padrão dd/MM/yyyy com locale pt_BR
  /// Se falhar, retorna formato padrão
  static String formatDate(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
    } catch (e) {
      // Fallback: formato manual brasileiro
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  /// Formata data e hora no padrão dd/MM/yyyy HH:mm com locale pt_BR
  static String formatDateTime(DateTime dateTime) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(dateTime);
    } catch (e) {
      // Fallback: formato manual
      final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return '${formatDate(dateTime)} $time';
    }
  }

  /// Formata data por extenso: dd de MMMM de yyyy (ex: 25 de fevereiro de 2026)
  static String formatDateLong(DateTime date) {
    try {
      return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(date);
    } catch (e) {
      // Fallback: apenas retorna formato simples
      final months = [
        'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
        'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
      ];
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    }
  }

  /// Formata apenas hora: HH:mm
  static String formatTime(DateTime dateTime) {
    try {
      return DateFormat('HH:mm', 'pt_BR').format(dateTime);
    } catch (e) {
      // Fallback: formato manual
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
