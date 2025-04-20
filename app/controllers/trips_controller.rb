class TripsController < ApplicationController
    before_action :authenticate_user!

    def index
      @trips = current_user.trips
    end

    def show
      @trip = current_user.trips.find(params[:id])
      @settlements = DebtCalculator.new(@trip).calculate
      @category_totals = @trip.expenses.group(:category).sum(:amount)
    end

    def destroy
      @trip = current_user.trips.find(params[:id])
      @trip.destroy
      redirect_to trips_path, notice: "Trip deleted successfully."
    end

    def expense_breakdown
      @trip = current_user.trips.find(params[:id])
      @category_totals = @trip.expenses
                      .where.not(category: [ nil, "" ])
                      .group(:category)
                      .sum(:amount)
    end

    def edit
      @trip = current_user.trips.find(params[:id])
    end

    def update
      @trip = current_user.trips.find(params[:id])
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

    def trip_params
      params.require(:trip).permit(
        :name, :start_date, :end_date,
        participants_attributes: [ :id, :name, :email, :_destroy ]
      )
    end
end
