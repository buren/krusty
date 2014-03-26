class CookiesController < ApplicationController
  before_action :set_cookie, only: [:show, :edit, :update, :destroy]

  # GET /cookies
  # GET /cookies.json
  def index
    @cookies = Cookie.all
  end

  # GET /cookies/1
  # GET /cookies/1.json
  def show
  end

  # GET /cookies/new
  def new
    @cookies = Cookie.new
  end

  # GET /cookies/1/edit
  def edit
  end

  # POST /cookies
  # POST /cookies.json
  def create
    @cookies = Cookie.new(cookie_params)

    respond_to do |format|
      if @cookies.save
        format.html { redirect_to @cookies, notice: 'Cookie was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cookies }
      else
        format.html { render action: 'new' }
        format.json { render json: @cookies.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cookies/1
  # PATCH/PUT /cookies/1.json
  def update
    respond_to do |format|
      if @cookies.update(cookie_params)
        format.html { redirect_to @cookies, notice: 'Cookie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cookies.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cookies/1
  # DELETE /cookies/1.json
  def destroy
    @cookies.destroy
    respond_to do |format|
      format.html { redirect_to cookies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cookie
      @cookies = Cookie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cookie_params
      params.require(:cookie).permit(:name)
    end
end
