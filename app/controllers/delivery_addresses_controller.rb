class DeliveryAddressesController < ApplicationController
	
	before_action :set_delivery_address, only: [:update, :edit, :destroy, :show]

  after_filter :verify_authorized

  def show
    authorize @del
    render :edit
  end

  def new
    @del = DeliveryAddress.new
    authorize @del
  end

  def edit
  	@del
    authorize @del
  end

  def update
  	authorize @del
    respond_to do |format|
      if @del.update_attributes(delivery_params)
        format.html { redirect_to edit_user_path(current_user), notice: "Delivery Address Updated" }
      else
        flash.now[:error] = AlertsHelper.getErrorAlertMessages(@del)
        format.html { render :edit }
        format.json { render json: @del.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @del = DeliveryAddress.new(delivery_params)
    authorize @del
    if @del.save
      flash[:notice] = "Delivery Address Created"
      redirect_to user_path(current_user)
    else
      render :new
      flash.now[:error] = AlertsHelper.getErrorAlertMessages(@del)
    end 
  end

  def destroy
  	authorize @del
    @del.destroy
    flash[:success] = "Delivery Address Deleted"
    redirect_to edit_user_path(current_user)
  end

 	private

 		# Before Filters

 		def set_delivery_address
 			@del = DeliveryAddress.find(params[:id])
 		end

 		def delivery_params
 			params.require(:delivery_address).permit(:order_id, :user_id, :first_name, :last_name, :street_address_1, :street_address_2, :city, :country, :postcode, :phone)
 		end
end
