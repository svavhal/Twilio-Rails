class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render text: "Thank you! You will receive an SMS shortly."
       # Instantiate a Twilio client
      client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

      # Create and send an SMS message
      client.account.sms.messages.create(
        from: TWILIO_CONFIG['from'],
        to: @user.phone,
        body: "Thanks for signing up. To verify your account, please reply HELLO to this message."
      )
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:phone)
  end
end
