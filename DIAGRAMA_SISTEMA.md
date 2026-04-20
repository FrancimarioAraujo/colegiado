# Diagrama do Sistema - Reuniões do Colegiado

## 📊 Arquitetura de Camadas

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  HomePage                                           │   │
│  │  ├─ ListarReunioesUseCase                           │   │
│  │  ├─ RemoverReuniaoUseCase                           │   │
│  │  └─ AtualizarReuniaoUseCase                         │   │
│  ├─ CriarReuniaoPage → SalvarReuniaoUseCase           │   │
│  ├─ DetalhesReuniaoPage → BuscarReuniaoUseCase        │   │
│  ├─ CriarPautaPage → AtualizarReuniaoUseCase          │   │
│  ├─ CriarAtaPage → SalvarAtaUseCase                   │   │
│  ├─ VisualizarConvocacaoPage → PdfGeneratorService   │   │
│  └─ VisualizarAtaPage → PdfGeneratorService           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│               APPLICATION LAYER (Use Cases)                 │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ Reuniao UseCases │  │ Ata UseCases     │                │
│  ├─ Listar          │  ├─ Listar          │                │
│  ├─ Salvar          │  ├─ Salvar          │                │
│  ├─ Atualizar       │  ├─ Atualizar       │                │
│  ├─ Remover         │  ├─ Remover         │                │
│  └─ Buscar          │  └─ BuscarPorNumero │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   DOMAIN LAYER (Interfaces)                 │
│  ┌──────────────────────┐    ┌──────────────────────┐       │
│  │ ReuniaoRepository    │    │ AtaRepository        │       │
│  │ (Abstract)           │    │ (Abstract)           │       │
│  ├─ salvar()            │    ├─ salvar()            │       │
│  ├─ atualizar()         │    ├─ atualizar()         │       │
│  ├─ remover()           │    ├─ remover()           │       │
│  ├─ listar()            │    ├─ listar()            │       │
│  ├─ buscarPorId()       │    ├─ buscarPorId()       │       │
│  └─ limpar()            │    └─ limpar()            │       │
│  └──────────────────────┘    └──────────────────────┘       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│             INFRASTRUCTURE LAYER (Implementation)           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ReuniaoRepositoryImpl    AtaRepositoryImpl           │  │
│  │  ├─ Delegam para:        ├─ Delegam para:           │  │
│  │  │  ReuniaoHiveService   │  AtaHiveService          │  │
│  │  └─ [Models]             └─ [Models]                │  │
│  │     ├─ ReuniaoModel         ├─ AtaModel             │  │
│  │     ├─ PautaModel           └─ PautaModel           │  │
│  │     └─ ParticipanteModel                            │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Adapters (Hive Serialization)                       │  │
│  │  ├─ ReuniaoAdapter (TypeId: 0)                       │  │
│  │  ├─ PautaAdapter (TypeId: 1)                         │  │
│  │  ├─ ParticipanteAdapter (TypeId: 2)                 │  │
│  │  └─ AtaAdapter (TypeId: 3)                           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│               EXTERNAL LAYER (Services)                     │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ HiveService      │  │ PdfGenerator     │                │
│  ├─ init()          │  ├─ gerarConvocacao │                │
│  ├─ salvar()        │  └─ gerarAta()      │                │
│  ├─ atualizar()     │                     │                │
│  ├─ remover()       │  + Printing Service │                │
│  ├─ listar()        │  ├─ share()         │                │
│  └─ buscar()        │  └─ print()         │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   PERSISTENCE LAYER                         │
│              ┌────────────────────────────┐                 │
│              │  Hive Local Database       │                 │
│              ├─ Box: 'reunioes'           │                 │
│              │  └─ [ReuniaoModel...]      │                 │
│              ├─ Box: 'atas'               │                 │
│              │  └─ [AtaModel...]          │                 │
│              └────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Fluxo de Dados - Criar Reunião

```
User Input
    │
    ▼
CriarReuniaoPage (Form)
    │
    ├─ Validação de campos
    │
    ▼
SalvarReuniaoUseCase.call(reuniao)
    │
    ▼
ReuniaoRepository.salvar(reuniao)
    │
    ▼
ReuniaoRepositoryImpl.salvar()
    │
    ▼
ReuniaoHiveService.salvar()
    │
    ▼
Hive.Box('reunioes').add(reuniao)
    │
    ▼
Persistência em SQLite Local
    │
    ▼
SnackBar: "Reunião criada com sucesso"
    │
    ▼
HomePage (refresh)
```

## 📄 Fluxo de Geração de PDF - Convocação

```
VisualizarConvocacaoPage
    │
    ▼
BuscarReuniaoUseCase.call(id)
    │
    ▼
ReuniaoRepository.buscarPorId()
    │
    ▼
ReuniaoHiveService.buscarPorId()
    │
    ▼
PdfGeneratorService.gerarConvocacao(reuniao)
    │
    ├─ Adiciona cabeçalho (Ministério, Universidade, Programa)
    ├─ Adiciona título "CONVOCAÇÃO"
    ├─ Adiciona corpo com data, hora, local
    ├─ Itera sobre pautas
    │   ├─ Número
    │   ├─ Título
    │   ├─ Descrição
    │   └─ Processo SEI (se existir)
    ├─ Adiciona rodapé com data
    ├─ Adiciona espaço para assinatura do coordenador
    │
    ▼
pw.Document (PDF)
    │
    ▼
PdfPreview (Exibição)
    │
    ├─ Visualizar
    ├─ Compartilhar
    └─ Imprimir
```

## 🏗️ Estrutura de Módulos

```
AppModule
    │
    └─ ReuniaoModule
        ├─ Binds (Injeção de Dependência)
        │   ├─ Services
        │   │   ├─ ReuniaoHiveService
        │   │   ├─ AtaHiveService
        │   │   └─ PdfGeneratorService
        │   ├─ Repositories
        │   │   ├─ ReuniaoRepositoryImpl
        │   │   └─ AtaRepositoryImpl
        │   └─ UseCases
        │       ├─ ListarReunioesUseCase
        │       ├─ SalvarReuniaoUseCase
        │       ├─ ... (todos os use cases)
        │
        └─ Routes
            ├─ '/' → HomePage
            ├─ '/criar' → CriarReuniaoPage
            ├─ '/detalhes/:id' → DetalhesReuniaoPage
            ├─ '/criar-pauta/:reuniao_id' → CriarPautaPage
            ├─ '/criar-ata/:reuniao_id' → CriarAtaPage
            ├─ '/convocacao/:reuniao_id' → VisualizarConvocacaoPage
            └─ '/ata/:ata_id' → VisualizarAtaPage
```

## 🔗 Relacionamento entre Modelos

```
┌─────────────────────┐
│  ReuniaoModel       │
├─────────────────────┤
│ • numero            │
│ • tipo              │
│ • data              │
│ • hora              │
│ • local             │
│ • status            │
│ • pautas[]  ──┐    │
│ • participantes[] ┬┘
│ • temAta        │
│ • notas         │
│ • dataInclusao  │
└─────────────────┼──┘
                  │
        ┌─────────┴──────────┐
        │                    │
        ▼                    ▼
┌──────────────────┐  ┌─────────────────────┐
│  PautaModel      │  │ ParticipanteModel   │
├──────────────────┤  ├─────────────────────┤
│ • numero         │  │ • nome              │
│ • titulo         │  │ • titulacao         │
│ • descricao      │  │ • tipo              │
│ • processoSei    │  │ • siape             │
│ • solicitante    │  │ • cpf               │
│ • relator        │  │                     │
│ • decisao        │  │                     │
│ • dataInclusao   │  │                     │
└──────────────────┘  └─────────────────────┘

┌──────────────────────┐
│    AtaModel          │
├──────────────────────┤
│ • reuniaoNumero      │
│ • dataReuniao        │
│ • hora               │
│ • local              │
│ • pautas[]  ◄────────┼─ Cópia de pautas
│ • observacoes        │   da reunião
│ • assinaturasPresentes
│ • assinaturasAusentes
│ • coordenador        │
│ • secretario         │
│ • dataInclusao       │
└──────────────────────┘
```

## 💾 Estrutura do Hive

```
Hive Instance
├─ Box: 'reunioes'
│  ├─ Index 0: ReuniaoModel {
│  │             numero: "1ª",
│  │             tipo: "Ordinária",
│  │             pautas: [PautaModel1, PautaModel2, ...],
│  │             participantes: [ParticipanteModel1, ...]
│  │           }
│  ├─ Index 1: ReuniaoModel { ... }
│  └─ Index N: ReuniaoModel { ... }
│
└─ Box: 'atas'
   ├─ Index 0: AtaModel { ... }
   ├─ Index 1: AtaModel { ... }
   └─ Index N: AtaModel { ... }
```

## 🎯 Fluxo de Estados UI

```
┌─────────────┐
│   Splash    │
└──────┬──────┘
       │ init()
       ▼
┌─────────────────────┐
│   HomePage          │
│  - Listar reuniões  │◄─────┐
└──────┬──────────────┘      │
       │ Click: "+"          │
       ▼                      │
┌─────────────────────────┐  │
│ CriarReuniaoPage        │  │
│ - Form com validação    │  │
│ - Adicionar participantes
└──────┬──────────────────┘  │
       │ Save               │
       ▼                      │
  Salva no Hive              │
       │                     │
       └─────────────────────┘
       │ Click: Reunião
       ▼
┌──────────────────────┐
│ DetalhesReuniaoPage  │
│ - Info completa      │
│ - Pautas             │
└──────┬───────────────┘
       │ Click: "Convocação" ou "Pauta"
       ▼
┌──────────────────────┐
│ Outras Páginas       │
└──────────────────────┘
```

## 🔐 Segurança e Validação

```
Input Validation
    │
    ├─ FormValidator
    │   ├─ Campo obrigatório
    │   ├─ Formato de data
    │   └─ Formato de hora
    │
    ├─ Business Logic
    │   ├─ Status válido
    │   ├─ Datas coerentes
    │   └─ Pautas não vazias (para convocação)
    │
    └─ Storage
        ├─ Try-catch em operações Hive
        ├─ Validação de tipo ao deserializar
        └─ Rollback em caso de erro
```

---

**Diagrama criado para documentação do sistema PPgEE**
