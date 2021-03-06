class ConversationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @conversations = Conversation.all
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      redirect_to conversation_messages_path(@conversation)
    else
      @conversation = Conversation.create!(conversation_params)
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
