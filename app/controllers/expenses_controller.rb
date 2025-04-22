class ExpensesController < ApplicationController
  before_action :set_trip
  before_action :set_potential_payers, only: [:new, :edit, :create, :update]

  def new
    # create a new expense associated with this trip
    @expense = @trip.expenses.build
    # Pre-select current user as payer for new expenses
    @expense.payer = current_user
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
    if @expense.update(expense_params)
      redirect_to trip_path(@trip), notice: "Expense updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id])
    @expense.destroy
    redirect_to trip_path(@trip), notice: "Expense deleted"
  end


  def create
    # build an expense with form data, including payer_id from params
    @expense = @trip.expenses.build(expense_params)
    # @expense.payer = current_user # Removed: payer_id now comes from form params

    if @expense.save
      redirect_to trip_path(@trip), notice: "Expense added!"
    else
      render :new
    end
  end

  private

  def set_trip
    # Find the trip, including participants for auth check
    @trip = Trip.includes(:participants).find(params[:trip_id])
    # Check if the current user is the creator OR a participant
    unless @trip.user_id == current_user.id || @trip.participants.exists?(email: current_user.email)
      raise ActiveRecord::RecordNotFound, "Couldn't find Trip with 'id'=#{params[:trip_id]} for the current user"
    end
  rescue ActiveRecord::RecordNotFound
    # Redirect or render error if trip not found at all or user lacks access
    redirect_to trips_path, alert: "Trip not found or you don't have permission to modify it."
  end

  def set_potential_payers
    participant_emails = @trip.participants.pluck(:email).compact
    @potential_payers = User.where(email: participant_emails)
  end

  def expense_params
    # Allow payer_id to be set from the form
    params.require(:expense).permit(
      :description,
      :amount,
      :date,
      :payer_id, # Allow setting payer_id
      :category,
      participant_ids: []
    )
  end
end
