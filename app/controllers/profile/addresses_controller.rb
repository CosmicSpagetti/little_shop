class Profile::AddressesController < ApplicationController 
  before_action :require_reguser

  def new
    @address = Address.new
    @user = User.find(params[:format])
  end
  
  def create 
    @user = User.find(params[:format])
    address = @user.addresses.create(address_params)
    if address.save
     flash[:success] = "YoU diD iT"
     redirect_to profile_path(@user)
    else 
     flash[:danger] = @user.errors.full_messages
     render :new
    end 
  end 

  private 

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end 
end 