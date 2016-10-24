class UsermailsController < ApplicationController
  before_action :set_usermail, only: [:show, :edit, :update, :destroy]

  # GET /usermails
  # GET /usermails.json
  def index
    @usermails = Usermail.all
  end

  # GET /usermails/1
  # GET /usermails/1.json
  def show
  end

  # GET /usermails/new
  def new
    @usermail = Usermail.new
  end

  # GET /usermails/1/edit
  def edit
  end

  # POST /usermails
  # POST /usermails.json
  def create
    @usermail = Usermail.new(usermail_params)

    respond_to do |format|
      if @usermail.save
        format.html { redirect_to @usermail, notice: 'Usermail was successfully created.' }
        format.json { render :show, status: :created, location: @usermail }
      else
        format.html { render :new }
        format.json { render json: @usermail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usermails/1
  # PATCH/PUT /usermails/1.json
  def update
    respond_to do |format|
      if @usermail.update(usermail_params)
        format.html { redirect_to @usermail, notice: 'Usermail was successfully updated.' }
        format.json { render :show, status: :ok, location: @usermail }
      else
        format.html { render :edit }
        format.json { render json: @usermail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usermails/1
  # DELETE /usermails/1.json
  def destroy
    @usermail.destroy
    respond_to do |format|
      format.html { redirect_to usermails_url, notice: 'Usermail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usermail
      @usermail = Usermail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usermail_params
      params.require(:usermail).permit(:name, :email)
    end
end
