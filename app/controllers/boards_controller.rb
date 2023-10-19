class BoardsController < ApplicationController
  before_action :set_board, only: %i[edit show update destroy]

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.create!(board_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('new-board', partial: 'show', locals: { board: @board })
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @board = Board.new
    render turbo_stream: turbo_stream.replace('error-container', partial: 'error', locals: { error: e.message })
  end

  def edit ; end

  def show
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: @board
      end
    end
  end

  def update
    if @board.update(board_params)
      redirect_to board_path(@board), notice: "Board #{@board.name} successfully updated."
    else
      render :edit, alert: @board.errors.full_messages.join(', ')
    end
  end

  def destroy
    @board.destroy
    redirect_to root_path, notice: 'Board has been deleted'
  end

  private

  def set_board
    @board = Board.find params[:id]
  end

  def board_params
    params.require(:board).permit(:name, :user_email, :height, :width)
  end
end