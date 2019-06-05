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

  def edit 
    @user = current_user
    @address = @user.addresses.first
  end 

  def update
    @address = Address.find(params[:id])
    @user = @address.user
    @address.update(address_params)
    if @address.save
      flash[:success] = "YoU UpdAtEd iT "
      redirect_to profile_path(@user)
    else
      flash.now[:danger] = @user.errors.full_messages
      render :edit
    end 
  end

  def destroy
    address = Address.find(params[:id])
    if address.check_orders == false
      address.orders.clear
      address.destroy
      redirect_to profile_path
    else
      flash[:danger] = "Address tied to packaged/shipped order"
      redirect_to profile_path
    end
  end 
  private 

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end 
end 