class BattingsController < ApplicationController
  before_action :set_batting, only: [:show, :edit, :update, :destroy]

  # GET /battings
  # GET /battings.json
  def index
    find_player
    @battings = @current_player.battings
  end

  # GET /battings/1
  # GET /battings/1.json
  def show
    find_player
  end

  # GET /battings/new
  def new
    find_player
    @batting = Batting.new
  end

  # GET /battings/1/edit
  def edit
    find_player
  end

  # POST /battings
  # POST /battings.json
  def create
    find_player
    @batting = Batting.new(batting_params)
    @batting.player_id = @current_player.id
    respond_to do |format|
      if @batting.save
        format.html { redirect_to [@current_player, @batting], notice: 'Batting was successfully created.' }
        format.json { render :show, status: :created, location: @batting }
      else
        format.html { render :new }
        format.json { render json: @batting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /battings/1
  # PATCH/PUT /battings/1.json
  def update
    find_player
    @batting.player_id = @current_player.id
    respond_to do |format|
      if @batting.update(batting_params)
        format.html { redirect_to [@current_player, @batting], notice: 'Batting was successfully updated.' }
        format.json { render :show, status: :ok, location: @batting }
      else
        format.html { render :edit }
        format.json { render json: @batting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /battings/1
  # DELETE /battings/1.json
  def destroy
    find_player
    @batting.destroy
    respond_to do |format|
      format.html { redirect_to player_battings_url(@current_player), notice: 'Batting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batting
      @batting = Batting.find(params[:id])
    end

    def find_player
      @current_player = Player.find(params[:player_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batting_params
      params.require(:batting).permit(:playerID, :yearID, :league, :teamID, :gamesPlayed, :hits, :doubles, :triples, :homeruns, :runsBattedIn, :stolenBases, :caughtStealing)
    end
end
