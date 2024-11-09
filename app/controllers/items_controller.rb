class ItemsController < ApplicationController
  def index
    @item = Item.new
    @items = Item.order(created_at: :desc)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "Item adicionado com sucesso!"
    else
      @items = Item.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:nome)
  end
end
