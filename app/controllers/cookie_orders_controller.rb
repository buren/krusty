class CookieOrdersController < ApplicationController
  before_action :set_cookie_order, only: [:show, :edit, :update, :destroy]

  # GET /cookie_orders
  # GET /cookie_orders.json
  def index
    @cookie_orders = CookieOrder.all
  end

  # GET /cookie_orders/1
  # GET /cookie_orders/1.json
  def show
  end

  # GET /cookie_orders/new
  def new
    @cookie_order = CookieOrder.new
  end

  # GET /cookie_orders/1/edit
  def edit
  end

  # POST /cookie_orders
  # POST /cookie_orders.json
  def create
    @cookie_order = CookieOrder.new(cookie_order_params)

    respond_to do |format|
      if @cookie_order.save
        format.html { redirect_to @cookie_order, notice: 'Cookie order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cookie_order }
      else
        format.html { render action: 'new' }
        format.json { render json: @cookie_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cookie_orders/1
  # PATCH/PUT /cookie_orders/1.json
  def update
    respond_to do |format|
      if @cookie_order.update(cookie_order_params)
        format.html { redirect_to @cookie_order, notice: 'Cookie order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cookie_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cookie_orders/1
  # DELETE /cookie_orders/1.json
  def destroy
    @cookie_order.destroy
    respond_to do |format|
      format.html { redirect_to cookie_orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cookie_order
      @cookie_order = CookieOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cookie_order_params
      params.require(:cookie_order).permit(:cookie_id, :order_id, :amount)
    end
end
