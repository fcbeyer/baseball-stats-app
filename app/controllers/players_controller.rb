class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def leaderboard
    @players = Player.all
    @battings = Batting.all
    @battings = @battings.sort do |a, b|
      aBA = calculate_season_batting_average(a)
      bBA = calculate_season_batting_average(b)
      case
        when aBA.nil? && bBA.nil?
          sort_by_slugging_percentage(calculate_season_slugging_percentage(a), calculate_season_slugging_percentage(b))
        when aBA.nil? && !bBA.nil?
          1
        when !aBA.nil? && bBA.nil?
          -1
        when aBA < bBA
          1
        when aBA > bBA
          -1
        else
          sort_by_slugging_percentage(calculate_season_slugging_percentage(a), calculate_season_slugging_percentage(b))
      end
    end
    #okay now that everything is sorted, create the data structure we need for our table
    #name, team, league, season, ba, sp
    @leaderData = []
    #create seasonal data
    @battings.each do |batting|
      cur_player = Player.find(batting.player_id)
      @leaderData.push({"firstName" => cur_player.firstName, "lastName" => cur_player.lastName,
                       "team" => batting.teamID, "league" => batting.league,
                        "season" => batting.yearID, "ba" => calculate_season_batting_average(batting),
                       "sp" => calculate_season_slugging_percentage(batting)})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    def sort_by_slugging_percentage(player1, player2)
      case
        when player1.nil? && player2.nil?
          0
        when player1.nil? && !player2.nil?
          1
        when !player1.nil? && player2.nil?
          -1
        when player1 < player2
          1
        when player1 > player2
          -1
        else
          player1 <=> player2
      end
    end

    def calculate_season_batting_average(batting)
      puts "this is batting"
      puts batting.inspect
      #total hits (singles, double, triples, home runs) ÷ At Bats
      if batting.hits and batting.atBats then
        ba = batting.hits.fdiv(batting.atBats)
        return ba.nan? ? nil : ba.round(3)
      end
    end

    def calculate_season_slugging_percentage(batting)
      #Total Bases ÷ At Bats
      #Total Bases = Singles + (2 x Doubles) + (3 x Triples) + (4 x Home Runs)
      if batting.hits and batting.doubles and batting.triples and batting.homeruns and batting.atBats then
        singles = batting.hits - batting.doubles - batting.triples - batting.homeruns
        total_bases = singles + (2 * batting.doubles) + (3 * batting.triples) + (4 * batting.homeruns)
        sg = total_bases.fdiv(batting.atBats)
        return sg.nan? ? nil : sg.round(3)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:firstName, :lastName, :playerID, :birthYear)
    end
end
