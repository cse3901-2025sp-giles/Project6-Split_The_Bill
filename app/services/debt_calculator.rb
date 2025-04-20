# app/services/debt_calculator.rb

class DebtCalculator
  def initialize(trip)
    @trip = trip
    @participants = trip.participants.index_by(&:id)
    @balances = Hash.new(0)
  end

  def calculate
    # Go through each expense
    @trip.expenses.includes(:participants).each do |expense|
      payer = expense.payer_name
      amount = expense.amount
      shared_with = expense.participants

      share = amount / shared_with.count

      shared_with.each do |participant|
        @balances[participant.name] -= share
      end

      @balances[payer] += amount
    end

    settle(@balances)
  end

  private

  def settle(balances)
    debtors = balances.select { |_, amt| amt < 0 }.sort_by { |_n, a| a }
    creditors = balances.select { |_, amt| amt > 0 }.sort_by { |_n, a| -a }

    transactions = []

    until debtors.empty? || creditors.empty?
      debtor_name, debt = debtors.first
      creditor_name, credit = creditors.first

      settled_amount = [ credit, -debt ].min.round(2)

      transactions << "#{debtor_name} pays #{creditor_name} $#{settled_amount}"

      balances[debtor_name] += settled_amount
      balances[creditor_name] -= settled_amount

      debtors.shift if balances[debtor_name] >= 0
      creditors.shift if balances[creditor_name] <= 0
    end

    transactions
  end
end
