# Instruções de Setup e Execução

## Pré-requisitos

- Flutter SDK (versão 3.7.0 ou superior)
- Dart SDK (versão 3.7.0 ou superior)
- Git (para clonar o repositório)
- Editor: VS Code, Android Studio ou IntelliJ IDEA

## Instalação

### 1. Clonar o Repositório

```bash
git clone <url-do-repositorio>
cd colegiado
```

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Gerar Código (Hive)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Ou, se você quiser que o build_runner rode em modo watch:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Executar Aplicação

#### Para Android
```bash
flutter run -d android
```

#### Para iOS
```bash
flutter run -d ios
```

#### Para Web (se habilitado)
```bash
flutter run -d chrome
```

#### Para Windows
```bash
flutter run -d windows
```

#### Para macOS
```bash
flutter run -d macos
```

## Estrutura de Inicialização

Quando o aplicativo inicia:

1. **WidgetsFlutterBinding.ensureInitialized()** - Garante que o Flutter está pronto
2. **initHive()** - Inicializa o banco de dados local
   - Registra adapters do Hive
   - Abre boxes para reuniões e atas
3. **initLocale()** - Configura localização para português brasileiro
4. **App Module** - Carrega as rotas e dependências

## Estrutura de Pastas

```
colegiado/
├── lib/
│   ├── main.dart                    # Ponto de entrada
│   ├── app/
│   │   ├── app_module.dart         # Configuração de rotas
│   │   └── app_widget.dart         # Widget raiz
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── database/
│   │   │   └── hive_config.dart
│   │   ├── locale/
│   │   │   └── locale_config.dart
│   │   ├── errors/
│   │   └── utils/
│   ├── modules/
│   │   └── reuniao/
│   │       ├── application/
│   │       │   └── usecases/
│   │       ├── domain/
│   │       │   └── repositories/
│   │       ├── external/
│   │       │   ├── hive/
│   │       │   └── pdf/
│   │       ├── infra/
│   │       │   ├── adapters/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── presentation/
│   │       │   └── pages/
│   │       └── reuniao_module.dart
│   └── shared/
│       ├── theme/
│       └── widgets/
├── test/
├── android/
├── ios/
├── windows/
├── macos/
├── web/
├── linux/
├── pubspec.yaml
└── analysis_options.yaml
```

## Rotas da Aplicação

| Rota | Descrição |
|------|-----------|
| `/` | Home - Listagem de Reuniões |
| `/criar` | Criar Nova Reunião |
| `/detalhes/:id` | Detalhes da Reunião |
| `/criar-pauta/:reuniao_id` | Criar Pauta |
| `/criar-ata/:reuniao_id` | Criar Ata |
| `/convocacao/:reuniao_id` | Visualizar Convocação (PDF) |
| `/ata/:ata_id` | Visualizar Ata (PDF) |

## Configuração de Dados

### Primeiro Uso

Na primeira execução, o aplicativo:
1. Cria um banco de dados local (usando Hive)
2. Registra todos os adapters de modelos
3. Abre boxes para armazenar dados
4. Configura localização para português brasileiro

### Dados Padrão

Alguns valores podem ser configurados no arquivo `lib/core/constants/app_constants.dart`:

```dart
const String programName = 'Pós-Graduação em Engenharia Elétrica';
const String defaultCoordinator = 'Eisenhawer de Moura Fernandes';
const String defaultSecretary = 'Secretário do PPgEE';
```

## Troubleshooting

### Erro: "Could not find the Android SDK"
```bash
flutter config --android-sdk [caminho-do-android-sdk]
```

### Erro: "Doctor summary"
```bash
flutter doctor -v
```

### Erro ao gerar código Hive
```bash
flutter pub run build_runner clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erro de permissões (Linux/macOS)
```bash
chmod +x gradlew
```

## Desenvolvimento

### Adicionar Novo UseCase

1. Crie o arquivo em `lib/modules/reuniao/application/usecases/`
2. Implemente herdando as interfaces de repositório
3. Registre em `reuniao_module.dart`

### Adicionar Nova Página

1. Crie o arquivo em `lib/modules/reuniao/presentation/pages/`
2. Exporte em `reuniao_module.dart`
3. Defina a rota

### Adicionar Novo Modelo

1. Crie o modelo em `lib/modules/reuniao/infra/models/`
2. Crie o adapter em `lib/modules/reuniao/infra/adapters/`
3. Registre o adapter em `lib/core/database/hive_config.dart`

## Build para Produção

### Android
```bash
flutter build apk
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

### Windows
```bash
flutter build windows
```

### macOS
```bash
flutter build macos
```

### Linux
```bash
flutter build linux
```

## Documentação Adicional

- [Documentação do Sistema](SISTEMA_README.md)
- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Modular](https://modular.flutterando.com.br/)
- [Hive Database](https://docs.hivedb.dev/)

## Suporte

Para dúvidas ou problemas, entre em contato com a coordenação do PPgEE.
