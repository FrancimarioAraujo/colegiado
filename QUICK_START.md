# 🚀 Quick Start Guide - Sistema PPgEE

Comece a usar o sistema em 5 minutos!

## ⚡ Instalação Rápida

```bash
# 1. Navegar para o diretório
cd colegiado

# 2. Instalar dependências
flutter pub get

# 3. Gerar código Hive
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Executar
flutter run
```

## 📱 Primeira Execução

Quando o app iniciar, você verá uma tela vazia. É normal! Vamos criar sua primeira reunião.

## 📝 Criar Sua Primeira Reunião (2 minutos)

### Passo 1: Clique no botão "+"

```
[Reuniões do Colegiado]
                                    [+]
```

### Passo 2: Preencha os campos

```
Número: 1ª
Tipo: Ordinária
Data: [selecione hoje]
Hora: 14:00
Local: Sala Virtual
Status: Agendada
```

### Passo 3: Adicione um participante

1. Clique em "Adicionar Participante"
2. Nome: Prof. João Silva
3. Titulação: Prof.
4. Tipo: Presidente
5. Clique em "Adicionar Participante"

### Passo 4: Salve

Clique no botão "Salvar"

✅ Pronto! Sua reunião foi criada!

## 📋 Adicionar Pautas (1 minuto)

1. Na tela inicial, clique na reunião
2. Clique em "Detalhes"
3. Em "Pautas", clique em "Adicionar"
4. Preencha:
   ```
   Título: Apreciação de Ata
   Descrição: Discussão da ata anterior
   ```
5. Clique em "Adicionar"

✅ Pauta adicionada!

## 📄 Gerar Convocação em PDF (30 segundos)

1. Volte para a listagem
2. Clique nas opções (**≡**) da reunião
3. Clique em "Convocação"
4. Veja o PDF sendo gerado
5. Use as opções para:
   - 👀 Visualizar
   - 📤 Compartilhar
   - 🖨️ Imprimir

## 📊 Após a Reunião - Criar Ata (1 minuto)

1. Altere o status da reunião para "Realizada"
2. Clique nas opções da reunião
3. Clique em "Criar Ata"
4. Preencha:
   ```
   Coordenador: Prof. João Silva
   Secretário: Prof. Maria Santos
   ```
5. Clique em "Criar Ata"

✅ Ata criada!

## 🔍 Visualizar Ata em PDF (30 segundos)

1. Acesse a ata criada
2. Visualize o PDF completo
3. Compartilhe ou imprima

## 🎯 Fluxo Simplificado

```
Iniciar App
    ↓
[+] Criar Reunião
    ↓
Preencher Dados
    ↓
Adicionar Participantes
    ↓
Salvar
    ↓
Adicionar Pautas
    ↓
Gerar Convocação (PDF)
    ↓
[Reunião realizada]
    ↓
Mudar status para "Realizada"
    ↓
Criar Ata
    ↓
Gerar Ata (PDF)
    ↓
✅ Done!
```

## 💡 Dicas Úteis

### Tipos de Reunião
- **Ordinária**: Reunião regular (mensal)
- **Extraordinária**: Reunião especial

### Status da Reunião
- 🟡 **Planejamento**: Ainda em preparação
- 🟢 **Agendada**: Confirmada
- ✅ **Realizada**: Já ocorreu
- ❌ **Cancelada**: Não vai acontecer

### Tipos de Participante
- 👑 **Presidente**: Conduz a reunião
- 📋 **Secretário**: Anota a ata
- 👥 **Membro**: Participa ativamente

### Campos Opcionais na Pauta
- **Processo SEI**: Para pautas administrativas
- **Solicitante**: Quem solicitou
- **Relator**: Quem relata
- **Decisão**: Preenchida na ata

## ⚙️ Configurações

### Alterar Dados da Instituição

Edite `lib/modules/reuniao/external/pdf/pdf_generator_service.dart`:

```dart
static const String universidade = 'Sua Universidade';
static const String programa = 'Seu Programa';
static const String endereco = 'Seu Endereço';
```

### Alterar Coordenador Padrão

Edite `lib/core/constants/app_constants.dart`:

```dart
const String defaultCoordinator = 'Seu Nome';
const String defaultSecretary = 'Nome do Secretário';
```

## 🆘 Problemas Comuns

### "Reunião não foi salva"
- Verifique se preencheu todos os campos obrigatórios
- Clique em "Salvar" novamente

### "PDF não aparece"
- Certifique-se de que há pautas adicionadas
- Tente novamente

### "App não inicia"
```bash
flutter clean
flutter pub get
flutter run
```

### "Dados desapareceram"
- Verifique se o app foi fechado corretamente
- Reinstale: `flutter run -d <device>`

## 📞 Próximos Passos

1. **Personalizar dados** - Configure os dados da sua instituição
2. **Criar rotina** - Use mensal para suas reuniões
3. **Backup** - Faça backup dos dados regularmente
4. **Treinamento** - Treine os secretários em como usar

## 📚 Documentação Completa

Para mais detalhes, consulte:
- `SISTEMA_README.md` - Documentação completa
- `DIAGRAMA_SISTEMA.md` - Arquitetura do sistema
- `SETUP_INSTRUCOES.md` - Troubleshooting detalhado

## ✨ Funcionalidades Premium

O sistema suporta:
- ✅ Múltiplas reuniões
- ✅ Pautas ilimitadas
- ✅ Participantes ilimitados
- ✅ PDFs automáticos
- ✅ Compartilhamento
- ✅ Impressão direta
- ✅ Armazenamento local seguro

## 🎉 Bem-vindo!

Você está pronto para gerenciar suas reuniões de forma profissional!

---

**💡 Dica Final**: Use o sistema para documentar todas as reuniões. Isso criará um histórico valioso para sua coordenação!

**Dúvidas?** Consulte a documentação completa ou entre em contato com a coordenação.
