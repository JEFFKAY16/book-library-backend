class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show update destroy ]
  before_action :authenticate_user!
  ALLOWED_DATA = %(start_date, end_date, cost, book_id, user_id).freeze

  # GET /reservations
  def index
    @reservations = Reservation.all

    render json: @reservations, include: [:user, :book]
  end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  # POST /reservations
  def create
    @data = json_payload.select { |item| ALLOWED_DATA.include?(item) }
    @reservation = Reservation.new(@data)

    if @reservation.save
      render json: @reservation, status: :created, location: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1
  def update
    if @reservation.update(reservation_params)
      render json: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :cost)
    end
end
