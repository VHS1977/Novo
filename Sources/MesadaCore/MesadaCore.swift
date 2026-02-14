import Foundation

public enum TransactionType: String, Codable, Sendable {
    case allowance
    case savingsInterest
    case expense
}

public struct Transaction: Codable, Identifiable, Sendable {
    public let id: UUID
    public let date: Date
    public let type: TransactionType
    public let amount: Decimal
    public let description: String

    public init(
        id: UUID = UUID(),
        date: Date = .now,
        type: TransactionType,
        amount: Decimal,
        description: String
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.amount = amount
        self.description = description
    }
}

public struct ChildAccount: Codable, Sendable {
    public let childName: String
    public let monthlyAllowance: Decimal
    public let monthlyInterestRate: Decimal
    public private(set) var balance: Decimal
    public private(set) var transactions: [Transaction]

    public init(
        childName: String,
        monthlyAllowance: Decimal,
        monthlyInterestRate: Decimal,
        initialBalance: Decimal = 0,
        transactions: [Transaction] = []
    ) {
        self.childName = childName
        self.monthlyAllowance = monthlyAllowance
        self.monthlyInterestRate = monthlyInterestRate
        self.balance = initialBalance
        self.transactions = transactions
    }

    @discardableResult
    public mutating func creditAllowance(
        date: Date = .now,
        description: String = "Mesada mensal"
    ) -> Transaction {
        let tx = Transaction(
            date: date,
            type: .allowance,
            amount: monthlyAllowance,
            description: description
        )
        apply(transaction: tx)
        return tx
    }

    @discardableResult
    public mutating func applySavingsInterest(
        date: Date = .now,
        description: String = "Rendimento da poupança"
    ) -> Transaction {
        let interest = roundCurrency(balance * monthlyInterestRate)
        let tx = Transaction(
            date: date,
            type: .savingsInterest,
            amount: interest,
            description: description
        )
        apply(transaction: tx)
        return tx
    }

    @discardableResult
    public mutating func registerExpense(
        amount: Decimal,
        date: Date = .now,
        description: String
    ) throws -> Transaction {
        guard amount > 0 else {
            throw AccountError.invalidExpenseAmount
        }

        guard amount <= balance else {
            throw AccountError.insufficientFunds(currentBalance: balance, requested: amount)
        }

        let tx = Transaction(
            date: date,
            type: .expense,
            amount: -amount,
            description: description
        )
        apply(transaction: tx)
        return tx
    }

    public var totalSpent: Decimal {
        transactions
            .filter { $0.type == .expense }
            .reduce(into: Decimal.zero) { partialResult, tx in
                partialResult += -tx.amount
            }
    }

    private mutating func apply(transaction: Transaction) {
        balance = roundCurrency(balance + transaction.amount)
        transactions.append(transaction)
    }
}

public enum AccountError: LocalizedError, Equatable {
    case invalidExpenseAmount
    case insufficientFunds(currentBalance: Decimal, requested: Decimal)

    public var errorDescription: String? {
        switch self {
        case .invalidExpenseAmount:
            return "O gasto precisa ser maior que zero."
        case let .insufficientFunds(currentBalance, requested):
            return "Saldo insuficiente. Saldo atual: \(currentBalance), gasto solicitado: \(requested)."
        }
    }
}

public func roundCurrency(_ value: Decimal) -> Decimal {
    var value = value
    var result = Decimal()
    NSDecimalRound(&result, &value, 2, .bankers)
    return result
}

public extension Decimal {
    var asCurrencyBRL: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self as NSDecimalNumber) ?? "R$ 0,00"
    }
}
