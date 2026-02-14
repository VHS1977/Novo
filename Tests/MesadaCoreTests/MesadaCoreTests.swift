import Testing
@testable import MesadaCore

struct MesadaCoreTests {
    @Test
    func fluxoMesadaERendimentoEAtualizacaoDeSaldo() {
        var account = ChildAccount(
            childName: "Pedro",
            monthlyAllowance: 100,
            monthlyInterestRate: 0.01,
            initialBalance: 200
        )

        account.creditAllowance()
        account.applySavingsInterest()

        #expect(account.balance == 303)
        #expect(account.transactions.count == 2)
    }

    @Test
    func registraGastoComSucesso() throws {
        var account = ChildAccount(
            childName: "Laura",
            monthlyAllowance: 90,
            monthlyInterestRate: 0.01,
            initialBalance: 80
        )

        try account.registerExpense(amount: 25, description: "Sorvete")

        #expect(account.balance == 55)
        #expect(account.totalSpent == 25)
        #expect(account.transactions.last?.type == .expense)
    }

    @Test
    func falhaQuandoSaldoInsuficiente() {
        var account = ChildAccount(
            childName: "Lucas",
            monthlyAllowance: 80,
            monthlyInterestRate: 0.01,
            initialBalance: 20
        )

        #expect(throws: AccountError.self) {
            try account.registerExpense(amount: 35, description: "Jogo")
        }
    }

    @Test
    func falhaQuandoGastoEhZeroOuNegativo() {
        var account = ChildAccount(
            childName: "Bia",
            monthlyAllowance: 100,
            monthlyInterestRate: 0.01,
            initialBalance: 40
        )

        #expect(throws: AccountError.self) {
            try account.registerExpense(amount: 0, description: "Entrada inválida")
        }

        #expect(throws: AccountError.self) {
            try account.registerExpense(amount: -3, description: "Entrada inválida")
        }
    }

    @Test
    func rendimentoEhArredondadoParaDuasCasas() {
        var account = ChildAccount(
            childName: "Nina",
            monthlyAllowance: 0,
            monthlyInterestRate: 0.015,
            initialBalance: 333.33
        )

        let transaction = account.applySavingsInterest()

        #expect(transaction.amount == 5)
        #expect(account.balance == 338.33)
    }
}
