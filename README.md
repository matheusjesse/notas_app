# 📝 Notas App

Um aplicativo Flutter para gerenciamento de notas com banco de dados SQLite.

## ✨ Funcionalidades

- Criar, editar e excluir notas
- Armazenamento local com SQLite
- Interface limpa e intuitiva
- Suporte para Markdown nas notas

## 🛠️ Tecnologias

- **Flutter**: Framework de desenvolvimento
- **SQLite**: Banco de dados local
- **sqflite**: Plugin para SQLite no Flutter
- **flutter_markdown**: Renderização de Markdown

## 🚀 Como iniciar o projeto

### Pré-requisitos

- Flutter SDK instalado ([guia de instalação](https://docs.flutter.dev/get-started/install))
- Git instalado
- Editor de código (VS Code, Android Studio, etc.)

### Passo a passo

1. **Clone o repositório**
   ```bash
   git clone https://github.com/matheusjesse/notas_app.git
   cd notas_app
   ```

2. **Verifique se o Flutter está instalado**
   ```bash
   flutter --version
   ```

3. **Instale as dependências**
   ```bash
   flutter pub get
   ```

4. **Verifique dispositivos disponíveis**
   ```bash
   flutter devices
   ```

5. **Execute o aplicativo**
   
   **Para Android (dispositivo físico ou emulador):**
   ```bash
   flutter run
   ```
   
   **Para Web (Chrome):**
   ```bash
   flutter run -d chrome
   ```
   
   **Para Desktop Linux:**
   ```bash
   flutter run -d linux
   ```
   
   **Para iOS (apenas no macOS):**
   ```bash
   flutter run -d ios
   ```

### 🔧 Comandos úteis

- **Limpar build cache:**
  ```bash
  flutter clean
  flutter pub get
  ```

- **Atualizar dependências:**
  ```bash
  flutter pub upgrade
  ```

- **Verificar problemas de configuração:**
  ```bash
  flutter doctor
  ```

- **Executar testes:**
  ```bash
  flutter test
  ```

## 📁 Estrutura do projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── core/                     # Funcionalidades centrais
│   └── database/            # Configuração do banco de dados
└── features/                # Funcionalidades do app
    └── notes/               # Módulo de notas
        ├── data/            # Camada de dados
        ├── domain/          # Camada de domínio
        └── presentation/    # Camada de apresentação
```

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📞 Contato

Matheus Jesse - [@matheusjesse](https://github.com/matheusjesse)

---

Para mais informações sobre Flutter:
- [Documentação oficial do Flutter](https://docs.flutter.dev/)
- [Cookbook Flutter](https://docs.flutter.dev/cookbook)
- [Pub.dev - Pacotes Flutter](https://pub.dev/)
