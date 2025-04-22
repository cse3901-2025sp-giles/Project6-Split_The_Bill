# app/services/debt_calculator.rb

class DebtCalculator
  def initialize(trip)
    @trip = trip
    # Fetch participants and index by email for quick lookup
    @participants_by_email = trip.participants.index_by(&:email)
    # Use participant names as keys for balances
    @balances = Hash.new(0)
    @trip.participants.each { |p| @balances[p.name] = 0 } # Initialize balances for all participants
  end

  def calculate
    # Eager load payer and participants for efficiency
    @trip.expenses.includes(:payer, :participants).each do |expense|
      payer_user = expense.payer
      amount = expense.amount
      shared_with = expense.participants

      # Skip calculation if payer isn't found (e.g., old data before migration)
      next unless payer_user

      # Find the participant record corresponding to the payer user via email
      payer_participant = @participants_by_email[payer_user.email]

      # Skip if the payer user isn't a participant in this trip (edge case?)
      next unless payer_participant

      payer_name = payer_participant.name

      # Ensure shared_with is not empty to avoid division by zero
      next if shared_with.empty?

      share = amount / shared_with.count

      shared_with.each do |participant|
        @balances[participant.name] -= share
      end

      @balances[payer_name] += amount
    end

    settle(@balances)
  end

  private

  def settle(balances)
    # Keep only participants with non-zero balances for settlement
    active_balances = balances.reject { |_, amt| amt.round(2).zero? }

    debtors = active_balances.select { |_, amt| amt < 0 }.sort_by { |_n, a| a }
    creditors = active_balances.select { |_, amt| amt > 0 }.sort_by { |_n, a| -a }

    transactions = []

    while debtors.any? && creditors.any?
      debtor_name, debt = debtors.first
      creditor_name, credit = creditors.first

      transfer_amount = [ credit, -debt ].min.round(2)

      # Avoid creating zero-amount transactions
      next if transfer_amount.zero?

      transactions << "#{debtor_name} pays #{creditor_name} $#{transfer_amount}"

      # Update balances directly in the hash used for iteration
      active_balances[debtor_name] += transfer_amount
      active_balances[creditor_name] -= transfer_amount

      # Remove settled participants
      debtors.shift if active_balances[debtor_name].round(2) >= 0
      creditors.shift if active_balances[creditor_name].round(2) <= 0
    end

    transactions
  end
end
