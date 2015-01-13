class EventsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    @invited_events = current_user.invited_events
    @invitations = current_user.invitations

    respond_to do |format|
      format.html
      format.json { render :json => { :invited_events => @invited_events, :invitations => @invitations } }
    end
  end

  def new
    @event = current_user.created_events.new
  end

  def create
    p params
    @event = current_user.created_events.create(event_params)
    render json: @event
    respond_to do |format|
      format.html
      format.json { render :json => { :events => @events, :invitations => @invitations } }
    end
    redirect_to event_path(@event)
  end

  def create_ios
    p params
    @event = current_user.created_events.create(event_params)
    p params[:users]
    p count = params[:users].length-1 if params[:user].length > 0
    params[:users].each do |user|
      @event.invitations.create(user_id: user["id"], status: "pending")
    end
    redirect_to event_path(@event)
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def show
    @event = Event.where(id: params[:id])
    @event_rails = Event.find(params[:id])
    @sent_invitations = @event.first.invitations
    @users = []
    @sent_invitations.each do |invite|
      @users << User.find(invite.user_id)
    end

    respond_to do |format|
      format.html

      format.json { render :json => { :event => @event , :users => @users }  }
    end
  end

  def attending
    @event = Event.find(params[:id])
    @confirmed_invitations = @event.invitations.where(status: "in")
    @friends = []
    @confirmed_invitations.each do |invite|
      @friends << User.find(invite.user_id)
    end
    # @users = @event.attending_users

    respond_to do |format|
      format.html
      format.json { render :json => { :friends => @friends } }
    end
  end
  private

  def event_params
    params.require(:event).permit(:name, :description, :start_time, :end_time, :venue, :location, :notification?, :notify_time)
  end

end
