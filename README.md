# MesadaKids

Base de um programa para iOS (Swift) para:

- Controlar mesadas recebidas por cada filho.
- Remunerar o dinheiro poupado com taxa mensal.
- Registrar e acompanhar gastos.

## Funcionalidades implementadas

### Core (`MesadaCore`)

- Modelo de conta por filho (`ChildAccount`).
- Registro de transações de mesada, rendimento e gasto.
- Validação de saldo insuficiente para gastos.
- Validação de valor de gasto inválido (zero/negativo).
- Cálculo de total gasto.
- Formatação em moeda BRL.

### UI (`MesadaUI`)

- `MesadaDashboardView` em SwiftUI (compilada quando `SwiftUI` está disponível) para exibir:
  - resumo (filho, saldo e total gasto)
  - histórico de transações

## Estrutura

- `Sources/MesadaCore`: regras de negócio reutilizáveis em um app iOS (SwiftUI/UIKit).
- `Sources/MesadaUI`: componentes SwiftUI para o app iOS.
- `Sources/MesadaKids`: executável de exemplo que simula uso.
- `Tests/MesadaCoreTests`: testes automatizados das regras principais.

## Como executar funcionalidades (local)

```bash
swift test
swift run
```

## Como testar a UI e funcionalidades no iOS (Xcode)

1. Abra o Xcode e crie um projeto iOS (App, SwiftUI).
2. Em **Package Dependencies**, adicione este repositório local.
3. Importe no app:

```swift
import MesadaCore
import MesadaUI
```

4. Monte um estado de teste e renderize a tela:

```swift
var conta = ChildAccount(
    childName: "Ana",
    monthlyAllowance: 120,
    monthlyInterestRate: 0.01,
    initialBalance: 50
)
conta.creditAllowance(description: "Mesada de fevereiro")
conta.applySavingsInterest(description: "Rendimento do mês")
try? conta.registerExpense(amount: 35.50, description: "Cinema")

MesadaDashboardView(account: conta)
```

5. Rode no simulador (`⌘R`) e valide:
   - saldo exibido
   - total gasto
   - histórico de transações

### Testes automatizados sugeridos no Xcode

- **Unit Tests**: cobrir regras no módulo de app (ou reusar os do package).
- **UI Tests (XCUITest)**:
  - verificar se os textos “Saldo”, “Total gasto” e “Histórico” aparecem.
  - verificar se uma transação de gasto aparece após ação do usuário.

Exemplo de asserção em UI test:

```swift
XCTAssertTrue(app.staticTexts["Saldo"].exists)
XCTAssertTrue(app.staticTexts["Total gasto"].exists)
```

## Próximos passos

- Persistência com SwiftData ou Core Data.
- Cadastro de múltiplos filhos.
- Fluxo de lançamento de gastos por formulário.
- Relatórios mensais por categoria.
