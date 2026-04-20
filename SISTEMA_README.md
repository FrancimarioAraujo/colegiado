# Sistema de Gerenciamento de Reuniões do Colegiado

Sistema Flutter para gerenciar reuniões do colegiado do Programa de Pós-Graduação em Engenharia Elétrica (PPgEE) da Universidade Federal de Campina Grande.

## Funcionalidades

### 1. **Gerenciamento de Reuniões**
   - Criar novas reuniões com informações básicas (número, tipo, data, hora, local)
   - Adicionar participantes (presidente, secretário, membros)
   - Atualizar status da reunião (planejamento, agendada, realizada, cancelada)
   - Adicionar notas e observações
   - Listar todas as reuniões cadastradas

### 2. **Gerenciamento de Pautas**
   - Adicionar pautas às reuniões
   - Incluir processo SEI
   - Definir solicitante e relator
   - Documentar decisões tomadas
   - Máximo de pautas ilimitado

### 3. **Geração de Documentos**

   #### Convocação
   - Gera PDF com formato oficial
   - Inclui cabeçalho institucional
   - Lista todas as pautas da reunião
   - Pode ser compartilhada ou impressa

   #### Ata
   - Registra informações da reunião realizada
   - Documenta todas as pautas discutidas
   - Inclui decisões tomadas
   - Campos para assinaturas do coordenador e secretário
   - Exportação em PDF

### 4. **Persistência de Dados**
   - Utiliza Hive para armazenamento local
   - Sem necessidade de internet
   - Dados sincronizados automaticamente

## Estrutura do Projeto

```
lib/
├── main.dart                          # Entrada da aplicação
├── app/
│   ├── app_module.dart               # Configuração de rotas
│   └── app_widget.dart               # Widget principal
├── core/
│   ├── constants/
│   │   └── app_constants.dart        # Constantes da aplicação
│   ├── database/
│   │   └── hive_config.dart          # Configuração do Hive
│   ├── errors/
│   └── utils/
├── modules/
│   └── reuniao/
│       ├── application/
│       │   └── usecases/             # Casos de uso
│       ├── domain/
│       │   └── repositories/         # Interfaces de repositórios
│       ├── external/
│       │   ├── hive/                 # Serviços Hive
│       │   └── pdf/                  # Serviço de geração PDF
│       ├── infra/
│       │   ├── adapters/             # Adapters Hive
│       │   ├── models/               # Modelos de dados
│       │   └── repositories/         # Implementação de repositórios
│       ├── presentation/
│       │   └── pages/                # Telas da aplicação
│       └── reuniao_module.dart       # Módulo reunião
└── shared/
    ├── theme/
    └── widgets/
```

## Arquitetura

O projeto segue a **Clean Architecture** com as seguintes camadas:

1. **Domain** - Lógica de negócio pura (repositórios abstratos, entidades)
2. **Application** - Casos de uso (use cases)
3. **Infrastructure** - Implementação de persistência (Hive, adaptadores)
4. **External** - Serviços externos (PDF, Hive)
5. **Presentation** - Interface com usuário (páginas, widgets)

## Modelos de Dados

### ReuniaoModel
- `numero`: Número da reunião (1ª, 2ª, etc.)
- `tipo`: Tipo de reunião (Ordinária/Extraordinária)
- `data`: Data da reunião
- `hora`: Hora da reunião
- `local`: Local da reunião
- `status`: Status da reunião (Planejamento, Agendada, Realizada, Cancelada)
- `pautas`: Lista de pautas
- `participantes`: Lista de participantes
- `temAta`: Indica se a ata foi criada

### PautaModel
- `numero`: Número da pauta
- `titulo`: Título da pauta
- `descricao`: Descrição detalhada
- `processoSei`: Número do processo SEI (opcional)
- `solicitante`: Nome do solicitante (opcional)
- `relator`: Nome do relator (opcional)
- `decisao`: Decisão tomada (opcional)

### ParticipanteModel
- `nome`: Nome completo
- `titulacao`: Titulação (Prof., Dr., etc.)
- `tipo`: Tipo de participante (Presidente, Secretário, Membro)
- `siape`: Número SIAPE (opcional)
- `cpf`: CPF (opcional)

### AtaModel
- `reuniaoNumero`: Número da reunião
- `dataReuniao`: Data da reunião
- `hora`: Hora da reunião
- `local`: Local da reunião
- `pautas`: Pautas discutidas
- `observacoes`: Observações gerais
- `assinaturasPresentes`: Participantes presentes
- `assinaturasAusentes`: Participantes ausentes
- `coordenador`: Nome do coordenador
- `secretario`: Nome do secretário

## Como Usar

### 1. Criar uma Nova Reunião

1. Clique no botão "+" (FAB) na tela inicial
2. Preencha os campos obrigatórios:
   - Número da reunião
   - Tipo (Ordinária/Extraordinária)
   - Data
   - Hora
   - Local
   - Status
3. Adicione participantes clicando em "Adicionar Participante"
4. Clique em "Salvar"

### 2. Adicionar Pautas

1. Na listagem de reuniões, clique na reunião desejada
2. Clique em "Detalhes"
3. Clique em "Adicionar Pauta"
4. Preencha:
   - Número da pauta (auto-preenchido)
   - Título
   - Descrição
   - Processo SEI (opcional)
   - Solicitante (opcional)
   - Relator (opcional)
5. Clique em "Adicionar"

### 3. Gerar Convocação em PDF

1. Na listagem de reuniões, clique nas opções da reunião
2. Clique em "Convocação"
3. O PDF será exibido
4. Use o menu para compartilhar ou imprimir

### 4. Criar Ata Após Reunião

1. Altere o status da reunião para "Realizada"
2. Na listagem, clique nas opções da reunião
3. Clique em "Criar Ata"
4. Preencha:
   - Nome do Coordenador
   - Nome do Secretário
   - Participantes Presentes (opcional)
   - Participantes Ausentes (opcional)
   - Observações (opcional)
5. Clique em "Criar Ata"

### 5. Visualizar Ata em PDF

1. Após criar a ata, ela será salva
2. Acesse a ata através do menu da reunião
3. O PDF será exibido com todas as informações e decisões

## Dependências

- **flutter_modular**: Gerenciamento de rotas e injeção de dependência
- **hive**: Banco de dados local
- **hive_flutter**: Integração Flutter com Hive
- **pdf**: Geração de documentos PDF
- **printing**: Visualização e compartilhamento de PDFs
- **intl**: Internacionalização e formatação de datas

## Instalação

1. Clone o repositório
2. Execute `flutter pub get`
3. Execute `flutter run` para iniciar o aplicativo

## Configuração Inicial

O arquivo `hive_config.dart` inicializa automaticamente:
- Hive Flutter
- Adapters para os modelos
- Boxes de armazenamento

## Fluxo de Uso Típico

```
1. Criar Reunião
   ↓
2. Adicionar Participantes
   ↓
3. Adicionar Pautas
   ↓
4. Gerar Convocação (PDF)
   ↓
5. Enviar Convocação
   ↓
6. Realizar Reunião
   ↓
7. Alterar Status para Realizada
   ↓
8. Criar Ata
   ↓
9. Gerar Ata (PDF)
   ↓
10. Arquivar/Compartilhar Ata
```

## Personalização

### Dados da Instituição

Edite o arquivo `lib/modules/reuniao/external/pdf/pdf_generator_service.dart`:

```dart
static const String universidade = 'Sua Universidade';
static const String programa = 'Seu Programa';
static const String endereco = 'Seu Endereço';
```

### Coordenador/Secretário Padrão

Edite o arquivo `lib/core/constants/app_constants.dart`:

```dart
const String defaultCoordinator = 'Nome do Coordenador';
const String defaultSecretary = 'Nome do Secretário';
```

## Troubleshooting

### Dados não são salvos
- Verifique se o Hive foi inicializado corretamente
- Verifique permissões de armazenamento

### PDF não gera
- Certifique-se de que a biblioteca `pdf` e `printing` estão instaladas
- Verifique se há pautas adicionadas à reunião

### Erro ao adicionar participante
- Verifique se o nome foi preenchido
- Tente novamente

## Suporte

Para suporte, entre em contato com a coordenação do PPgEE.

## Licença

Este projeto está sob a licença proposta pela UFCG.
