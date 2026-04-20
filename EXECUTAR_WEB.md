# Executar Sistema em Web 🌐

O projeto foi totalmente adaptado para executar como aplicação web!

## 📋 Pré-requisitos

- Flutter 3.7.0+
- Dart 3.7.0+
- Chrome/Firefox/Edge (navegadores modernos)

## 🚀 Como Executar em Web

### 1. **Opção Rápida** - Abrir em Chrome/Edge
```bash
flutter run -d web
```

### 2. **Modo Debug com Hot Reload**
```bash
flutter run -d chrome
```

### 3. **Modo Release (Produção)**
```bash
flutter run -d web --release
```

### 4. **Build para Produção**
```bash
flutter build web --release
```
Gera arquivos em: `build/web/`

## ✅ O que funciona em Web

| Recurso | Status | Notas |
|---------|--------|-------|
| UI Flutter | ✅ Completo | Toda interface responsiva |
| Roteamento (Modular) | ✅ Completo | Navegação entre páginas |
| Banco de Dados (Hive) | ✅ IndexedDB | Persistência local no navegador |
| Geração PDF | ✅ Completo | Visualização e download de PDFs |
| Impressão | ✅ Completo | Print via navegador |
| Compartilhamento | ✅ Completo | Download + compartilhamento |
| Datas (intl) | ✅ Português BR | Formatação correta |
| Modular DI | ✅ Completo | Injeção de dependências |

## 📊 Armazenamento em Web

- **Tecnologia**: IndexedDB (automático)
- **Limite**: ~50MB por domínio (navegador)
- **Persistência**: Dados permanecem entre sessões
- **Sincronização**: Dados isolados por navegador (sem nuvem)

## 🔍 Testando Funcionalidades

### Listar Reuniões
```
Home → Lista todos os PDFs gerados localmente
```

### Criar Reunião
```
Home → Botão flutuante (+)
→ Preencher formulário
→ Salvar (armazena em IndexedDB)
```

### Gerar Convocação (PDF)
```
Home → Selecionar reunião
→ Ver Convocação
→ Visualizar PDF gerado
→ Fazer download ou imprimir
```

### Gerar Ata
```
Home → Selecionar reunião
→ Criar Ata
→ Preencher participantes
→ Gerar e visualizar PDF
```

## 🌐 Deploy em Produção

### Opção 1: Firebase Hosting
```bash
npm install -g firebase-tools
firebase login
flutter build web --release
firebase init hosting
firebase deploy
```

### Opção 2: GitHub Pages
1. Build do projeto
2. Fazer push para branch `gh-pages`
3. Ativar GitHub Pages no repositório

### Opção 3: Servidor Web (Apache/Nginx)
```bash
flutter build web --release
# Copiar conteúdo de `build/web/` para servidor web
```

## ⚙️ Configurações Importantes

### CORS (Se necessário)
Se integrar com backend externo, configure CORS na seção `<head>` de `web/index.html`

### Base URL
Para rodar em subdiretório, editar `web/index.html`:
```html
<base href="/colegiado/">  <!-- Se estiver em /colegiado/ -->
```

E ao fazer build:
```bash
flutter build web --base-href="/colegiado/"
```

### PWA (Progressive Web App)
Já está configurado em `web/manifest.json`:
- ✅ Ícone de app
- ✅ Tema de cores
- ✅ Modo standalone (fullscreen)

## 🐛 Troubleshooting

### Problema: "Blank White Screen"
**Solução:**
```bash
flutter clean
flutter pub get
flutter run -d web
```

### Problema: "IndexedDB quota exceeded"
**Solução:** Limpar dados do navegador
- DevTools → Application → IndexedDB → Deletar banco

### Problema: PDFs não geram
**Solução:** Verificar console (F12) para erros

### Problema: Dados perdidos ao fechar aba
**Solução:** Dados devem persistir. Se não, verificar:
- Se IndexedDB está habilitado
- Se cookies/storage não estão deletados

## 📱 Responsividade

O app é totalmente responsivo para:
- ✅ Desktop (1920x1080+)
- ✅ Tablet (1024x768)
- ✅ Mobile (320x480+)

## 🔐 Segurança em Web

- Dados armazenados **localmente** no navegador (sem servidor)
- Sem transmissão de dados pela rede
- Sem autenticação necessária (offline-first)

**NOTA**: Para versão com servidor/autenticação, seria necessário implementar backend.

## 📞 Suporte

Para problemas, verificar:
1. Console do navegador (F12)
2. Flutter DevTools: `flutter pub global run devtools`
3. Logs: `flutter logs`
