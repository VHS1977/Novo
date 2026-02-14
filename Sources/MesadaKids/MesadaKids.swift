import Foundation
import MesadaCore

@main
struct MesadaKids {
    static func main() {
        var conta = ChildAccount(
            childName: "Ana",
            monthlyAllowance: 120,
            monthlyInterestRate: 0.01,
            initialBalance: 50
        )

        conta.creditAllowance(description: "Mesada de fevereiro")
        conta.applySavingsInterest(description: "Rendimento do mês")

        do {
            try conta.registerExpense(amount: 35.50, description: "Cinema")
        } catch {
            print("Erro ao registrar gasto: \(error.localizedDescription)")
        }

        print("Conta de \(conta.childName)")
        print("Saldo atual: \(conta.balance.asCurrencyBRL)")
        print("Total gasto: \(conta.totalSpent.asCurrencyBRL)")
        print("--- Histórico ---")

        for tx in conta.transactions {
            print("[\(tx.type.rawValue)] \(tx.description): \(tx.amount.asCurrencyBRL)")
        }
    }
}
