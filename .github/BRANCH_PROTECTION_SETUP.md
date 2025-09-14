# Configuração de Branch Protection Rules para GitHub

Este arquivo contém as instruções para configurar as regras de proteção de branch no GitHub.

## 🔒 Como configurar Branch Protection Rules

### 1. Acesse as configurações do repositório
- Vá para o seu repositório no GitHub
- Clique em **Settings** (Configurações)
- No menu lateral, clique em **Branches**

### 2. Configure regras para o branch `main`

Clique em **Add rule** e configure:

#### Branch name pattern:
```
main
```

#### Configurações obrigatórias:
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: `1` (ou mais se preferir)
  - ✅ Dismiss stale reviews when new commits are pushed
  - ✅ Require review from code owners (opcional)

- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - **Status checks required:**
    - `Code Verification & Tests` (nome do job do workflow)

- ✅ **Require conversation resolution before merging**

- ✅ **Require linear history** (opcional, mas recomendado)

- ✅ **Do not allow bypassing the above settings**

### 3. Configure regras para o branch `dev` (opcional)

Repita o processo para o branch `dev` com as mesmas configurações.

## 🎯 O que isso faz:

1. **Impede merge direto**: Todo código deve passar por Pull Request
2. **Exige aprovação**: Pelo menos 1 pessoa deve revisar o código
3. **Testes obrigatórios**: O workflow deve passar (testes + formatação + análise)
4. **Branch atualizado**: O PR deve estar atualizado com a branch de destino
5. **Conversas resolvidas**: Todos os comentários devem ser resolvidos

## 🚀 Fluxo de trabalho resultante:

1. Desenvolvedor cria branch feature: `git checkout -b feature/nova-funcionalidade`
2. Faz commits com código formatado (pre-commit hook garante isso)
3. Abre Pull Request para `main` ou `dev`
4. GitHub Actions roda automaticamente:
   - Verifica formatação
   - Executa análise de código
   - Roda todos os testes
5. Se tudo passar ✅ e tiver aprovação ✅ → merge liberado
6. Se algo falhar ❌ → merge bloqueado até correção

## 📋 Status checks esperados:

O workflow `Code Verification & Tests` deve passar com todos estes steps:
- ✅ Check code formatting
- ✅ Analyze code  
- ✅ Run unit tests
- ✅ Run widget tests

---

**Importante**: Após configurar, teste criando um PR para verificar se as regras estão funcionando!
