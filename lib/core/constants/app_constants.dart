// Informações do Programa
const String programName = 'Pós-Graduação em Engenharia Elétrica';
const String programAcronym = 'PPgEE';
const String university = 'Universidade Federal de Campina Grande';
const String ministry = 'Ministério da Educação';
const String address =
    'Rua Aprígio Veloso, 882, - Bairro Universitário, Campina Grande/PB, CEP 58429-900';

// Configurações padrão
const String defaultCoordinator = 'Eisenhawer de Moura Fernandes';
const String defaultSecretary = 'Secretário do PPgEE';

// Status da reunião
const Map<int, String> statusReuniao = {
  0: 'Planejamento',
  1: 'Agendada',
  2: 'Realizada',
  3: 'Cancelada',
};

// Tipos de participante
const Map<int, String> tipoParticipante = {
  0: 'Presidente',
  1: 'Secretário',
  2: 'Membro',
};

// Tipos de reunião
const List<String> tiposReuniao = ['Ordinária', 'Extraordinária'];
