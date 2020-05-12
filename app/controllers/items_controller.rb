class ItemsController < ApplicationController
  

 
  def new
    @item = Item.new
    @item.item_photos.new
    @category_parent_array = ["選択してください"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      @category_parent_array = ["選択してください"]
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
      end
      render :new
    end
  end

  

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  
  private

  def item_params
    params.require(:item).permit(:name, :explain, :status_id, :category_id, :shipping_fee_id, :shipping_area_id, :shipping_day_id, :shipping_way_id, :price,  brands_attributes: [:name],  item_photos_attributes: [:image])
  end
  

  before_action :move_to_index, except: [:index, :show, :buy]
  before_action :set_item, only: [:show, :buy, :pay]
  
  def index
    @items = Item.order('id DESC').limit(4)
  end
  
  def show
  end

  
  
  def pay
    Payjp.api_key = Rails.application.credentials[:PAYJP][:PAYJP_PRIVATE_KEY]
    charge = Payjp::Charge.create(
    amount: @item.price,
    card: params['payjp-token'],
    currency: 'jpy'
    )
  end

  def done
  end

  private
  
  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  def set_item
    @item = Item.find(params[:id])
  end

  

end
