class TripsController < ApplicationController
    before_action :authenticate_user!
    # Add before_action for show, edit, update, destroy
    before_action :set_and_authorize_trip, only: [:show, :edit, :update, :destroy]

    def index
      # Find trips where the current user is a participant
      participant_trip_ids = Participant.where(email: current_user.email).pluck(:trip_id)

      # Find trips created by the user OR trips they are participating in
      @trips = Trip.includes(expenses: :payer) # Eager load for display
                   .where(user: current_user)
                   .or(Trip.where(id: participant_trip_ids))
                   .order(created_at: :desc) # Optional: order by creation date

      # Calculate total spent by the user across all trips they paid in
      @total_spent = current_user.expenses_paid.sum(:amount)
    end

    def show
      # @trip is set by before_action
      # Eager loading moved to before_action
      @participants_by_email = @trip.participants.index_by(&:email)
      @settlements = DebtCalculator.new(@trip).calculate
      @category_totals = @trip.expenses.group(:category).sum(:amount)

      # Calculate total paid per participant (using participant name as key)
      @participant_totals = Hash.new(0)
      @trip.expenses.each do |expense|
        if expense.payer && @participants_by_email[expense.payer.email]
          payer_name = @participants_by_email[expense.payer.email].name
          @participant_totals[payer_name] += expense.amount
        end
      end
    end

    def destroy
      # @trip is set by before_action
      @trip.destroy
      redirect_to trips_path, notice: "Trip deleted successfully."
    end

    def edit
      # @trip is set by before_action
    end

    def update
      # @trip is set by before_action
      if @trip.update(trip_params)
        redirect_to trip_path(@trip), notice: "Trip updated!"
      else
        render :edit
      end
    end

    def new
      @trip = current_user.trips.build
      3.times { @trip.participants.build } # Pre-fill 3 participant forms
    end

    def create
      @trip = current_user.trips.build(trip_params)
      if @trip.save
        redirect_to trips_path, notice: "Trip created successfully!"
      else
        render :new
      end
    end

    private

    def set_and_authorize_trip
      # Find the trip universally first, including necessary associations for show/auth
      @trip = Trip.includes(:participants, expenses: [:payer, :participants])
                  .find(params[:id])
      # Check if the user created the trip OR is a participant
      unless @trip.user_id == current_user.id || @trip.participants.exists?(email: current_user.email)
        # Raise not found if user doesn't have access
        raise ActiveRecord::RecordNotFound, "Couldn't find Trip with 'id'=#{params[:id]} for the current user"
      end
    rescue ActiveRecord::RecordNotFound
      # Redirect or render error if trip not found at all or user lacks access
      redirect_to trips_path, alert: "Trip not found or you don't have permission to view it."
    end

    def trip_params
      params.require(:trip).permit(
        :name, :start_date, :end_date,
        participants_attributes: [ :id, :name, :email, :_destroy ]
      )
    end
end
