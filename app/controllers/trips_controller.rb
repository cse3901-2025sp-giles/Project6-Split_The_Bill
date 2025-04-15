class TripsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @trips = current_user.trips
    end
  
    def show
      @trip = current_user.trips.find(params[:id])
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
        participants_attributes: [:name, :email, :_destroy]
      )
    end
  end
  