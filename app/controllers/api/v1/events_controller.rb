class Api::V1::EventsController < ApplicationController
  def index
    events = Event.all 
    render json: events
  end

  def show
    event = Event.find(params[:id])
    render json: event
  end

  def create
    event = Event.new(event_params)
    if event.valid?
      event.save
      render json: event
    else
      render json: { error: '500'}
    end
  end

  def update
    event = Event.find(params[:id])
    if event.update(event_params)
      render json: event
    else
      render json: { error: '500' }
    end
  end

  def destroy
    Event.delete(params[:id])
  end

  def find_times
    events = Event.where(date: params[:date])
    weekday_times = [ '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM']
    weekend_times = weekday_times + ['9:00 PM', '10:00 PM', '11:00 PM', '12:00 AM']
    times = []
    available_times = []

    events_date = Date.parse(params[:date])

    if events_date.wday == 5 || events_date.wday == 6
      times = weekend_times 
    else
      times = weekday_times
    end
    
    times.each do |time|
      events_per_hour = events.filter { |event| event.time == time }
      available_times.push(time) if events_per_hour.size < 7
    end

    render json: available_times
  end

  private
  def event_params
    params.require(:event).permit(:date, :time, :first_name, :last_name, :email_address, :phone_number, :guest_count, :message, :administrator_id)
  end

end
