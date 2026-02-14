import Foundation
import MesadaCore

#if canImport(SwiftUI)
import SwiftUI

public struct MesadaDashboardView: View {
    private let account: ChildAccount

    public init(account: ChildAccount) {
        self.account = account
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Resumo") {
                    HStack {
                        Text("Filho")
                        Spacer()
                        Text(account.childName)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("Saldo")
                        Spacer()
                        Text(account.balance.asCurrencyBRL)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text("Total gasto")
                        Spacer()
                        Text(account.totalSpent.asCurrencyBRL)
                            .foregroundStyle(.red)
                    }
                }

                Section("Histórico") {
                    if account.transactions.isEmpty {
                        Text("Sem transações ainda")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(account.transactions) { transaction in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(transaction.description)
                                    .font(.body)
                                HStack {
                                    Text(transaction.type.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text(transaction.amount.asCurrencyBRL)
                                        .fontWeight(.medium)
                                        .foregroundStyle(color(for: transaction.type))
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Mesada Kids")
        }
    }

    private func color(for type: TransactionType) -> Color {
        switch type {
        case .allowance, .savingsInterest:
            return .green
        case .expense:
            return .red
        }
    }
}

#Preview {
    var demo = ChildAccount(
        childName: "Ana",
        monthlyAllowance: 120,
        monthlyInterestRate: 0.01,
        initialBalance: 50
    )

    demo.creditAllowance(description: "Mesada de fevereiro")
    demo.applySavingsInterest(description: "Rendimento do mês")
    try? demo.registerExpense(amount: 35.50, description: "Cinema")

    return MesadaDashboardView(account: demo)
}
#endif
