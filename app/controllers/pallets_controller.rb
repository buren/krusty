class PalletsController < ApplicationController
  before_action :set_pallet, only: [:show, :edit, :update, :destroy]
  before_action :search, only: [:index]
  before_action :blocked_cookies, only: [:index]

  # GET /pallets/1
  # GET /pallets/1.json
  def show
    redirect_to pallets_path(pallet_id: @pallet['id'])
  end

  # GET /pallets/new
  def new
    @pallet = Pallet.new
  end

  # GET /pallets/1/edit
  def edit
  end

  # POST /pallets
  # POST /pallets.json
  def create
    @pallet = Pallet.new(pallet_params)

    respond_to do |format|
      if @pallet.save # SQL
        format.html { redirect_to @pallet, notice: 'Pallet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pallet }
      else
        format.html { render action: 'new' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pallets/1
  # PATCH/PUT /pallets/1.json
  def update
    respond_to do |format|
      if @pallet.update(pallet_params) # SQL
        format.html { redirect_to @pallet, notice: 'Pallet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pallets/1
  # DELETE /pallets/1.json
  def destroy
    @pallet.destroy
    respond_to do |format|
      format.html { redirect_to pallets_url }
      format.json { head :no_content }
    end
  end

  def search
    from = params[:from_date]
    from = Date.new(2010) if from.blank?

    to = params[:to_date]
    to = Date.new(2100)   if to.blank?

    only_blocked = params[:blocked].blank? || params[:blocked].to_i.eql?(0) ? false : true
    date_range = (from..to)

    @results = Pallet.search_sql(
      date_range,
      only_blocked,
      params[:cookie_id],
      params[:pallet_id]
    )
  end

  def block
    from = params[:from_date]
    to = params[:to_date]
    from = Date.new(2010) if from.blank?
    to = Date.new(2100)   if to.blank?

    cookie = Cookie.find_by(id: params[:cookie_id]) # SQL
    block = params[:unblock].to_i.eql?(1) ? 0 : 1

    Pallet.block!((from..to), cookie.id, block) unless cookie.blank?

    flash[:notice] = "Updated block status for all pallets containing: #{cookie.name}"
    redirect_to pallets_url
  end

  def blocked_cookies
    @blocked_pallets = Pallet.blocked_pallets
  end

  def produce
    quantity = params[:quantity].to_i
    cookie = Cookie.find_by(id: params[:cookie_id]) # SQL

    if quantity.blank? || cookie.blank?
      notice = ''
      notice += "Quantity cannot be blank" if quantity.blank?
      notice += "Cookie cannot be blank" if cookie.blank?
      flash[:warning] = notice
      redirect_to pallets_url and return
    end

    if Pallet.produce(quantity, cookie.id)
      flash[:success] = "Successfully added #{quantity} pallets of #{cookie.name} to production queue."
    else
      flash[:error] = "Error: Not enough substances, please restock."
    end
    redirect_to pallets_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pallet
      @pallet = Pallet.find(params[:id]) # SQL
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pallet_params
      params.require(:pallet).permit(:is_blocked, :order_id, :cookie_id, :location)
    end
end
