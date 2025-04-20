class ExpensesController < ApplicationController
  before_action :set_trip

  def new
    # create a new expense associated with this trip
    @expense = @trip.expenses.build
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
    # build an expense with form data
    @expense = @trip.expenses.build(expense_params)

    if @expense.save
      redirect_to trip_path(@trip), notice: "Expense added!"
    else
      render :new
    end
  end

  private

  def set_trip
    # find the trip this expense belongs to
    @trip = Trip.find(params[:trip_id])
  end

  def expense_params
    # allow category to be saved with the expense
    params.require(:expense).permit(
      :description,
      :amount,
      :date,
      :payer_name,
      :category,              # ← add this line
      participant_ids: []     # checkboxes for shared participants
    )
  end
end
