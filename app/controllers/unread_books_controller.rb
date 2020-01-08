class UnreadBooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: :tops

  def tops; end

  def index
    @q = current_user.unread_books.ransack(params[:q])
    @unread_books = @q.result(distinct: true)
  end

  def reading
    @reading_book = UnreadBook.find(params[:id])
    if @reading_book.not_yet?
      @reading_book.update(status: 1)
      redirect_to unread_books_path, notice: "#{@reading_book.title}を読書中書籍に登録しました"
    else
      redirect_to unread_books_path, notice: 'すでに読書中の書籍です'
    end
  end

  def reading_books
    @progresses = current_user.progresses
    @progress = Progress.new
    @reading_books = current_user.unread_books.where(status: 1)
  end

  def return
    @reading_book = UnreadBook.find(params[:id])
    @reading_book.update(status: 0)
    redirect_to reading_books_unread_books_path, notice: '未読書籍に戻しました'
  end

  def new
    @unread_book = current_user.unread_books.new
  end

  def create
    @unread_book = current_user.unread_books.new(book_params)
    if @unread_book.save
      redirect_to root_path, notice: "#{@unread_book.title}を未読書籍に登録しました"
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @unread_book.update(book_params)
      redirect_to unread_books_path, notice: '未読書籍情報を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @unread_book.destroy
    redirect_to unread_books_path, notice: '書籍情報を削除しました'
  end

  private

  def book_params
    params.require(:unread_book).permit(:title, :author, :status, :reading_expired, :tag_list)
  end

  def set_book
    @unread_book = current_user.unread_books.find(params[:id])
  end
end
