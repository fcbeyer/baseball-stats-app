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
    #@battings = Batting.all.group(:player_id)
    @battings = (params[:filter] && !params[:filter][:allTime].empty?) ? create_career_battings : find_battings_from_params
    @battings = @battings.sort do |a, b|
      aBA = calculate_batting_average(a)
      bBA = calculate_batting_average(b)
      case
        when aBA.nil? && bBA.nil?
          sort_by_slugging_percentage(calculate_slugging_percentage(a), calculate_slugging_percentage(b))
        when aBA.nil? && !bBA.nil?
          1
        when !aBA.nil? && bBA.nil?
          -1
        when aBA < bBA
          1
        when aBA > bBA
          -1
        else
          sort_by_slugging_percentage(calculate_slugging_percentage(a), calculate_slugging_percentage(b))
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
                        "season" => batting.yearID, "ba" => calculate_batting_average(batting),
                       "sp" => calculate_slugging_percentage(batting)})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    #first we group the data by player_id
    #second we need to loop through each key and for all the values calculate the sums for all the categories needed in our table
    #create a new array of objects that has all the summed up values
    #use this new data structure to pass through all the sorting tricking my code into thinking its just like the seasonal data
    def create_career_battings
      grouped_data = Batting.all.group_by(&:player_id)
      career_data = []
      grouped_data.each do |player_id, array|
        career_data.push(Batting.new(league: array.first.league, teamID: array.first.teamID, player_id: player_id,
                         atBats: array.map(&:atBats).compact.sum, hits: array.map(&:hits).compact.sum,
                         doubles: array.map(&:doubles).compact.sum, triples: array.map(&:triples).compact.sum,
                         homeruns: array.map(&:homeruns).compact.sum))
      end
      return career_data
    end

    def find_battings_from_params
      if (params[:filter])
        teamParam = params[:filter][:team]
        leagueParam = params[:filter][:league]
        seasonParam = params[:filter][:season]
        case
          #they are all empty
          when teamParam.empty? && leagueParam.empty? && seasonParam.empty?
            Batting.all
          #team
          when !teamParam.empty? && leagueParam.empty? && seasonParam.empty?
            Batting.where(teamID: teamParam)
          #league
          when teamParam.empty? && !leagueParam.empty? && seasonParam.empty?
            Batting.where(league: leagueParam)
          #season
          when teamParam.empty? && leagueParam.empty? && !seasonParam.empty?
            Batting.where(yearID: seasonParam.to_i)
          #team and season
          when !teamParam.empty? && leagueParam.empty? && !seasonParam.empty?
            Batting.where(teamID: teamParam).where(yearID: seasonParam.to_i)
          #team and league
          when !teamParam.empty? && !leagueParam.empty? && seasonParam.empty?
            Batting.where(teamID: teamParam).where(league: leagueParam)
          #league and season
          when teamParam.empty? && !leagueParam.empty? && !seasonParam.empty?
            Batting.where(league: leagueParam).where(yearID: seasonParam.to_i)
          #team and league and season
          when !teamParam.empty? && !leagueParam.empty? && !seasonParam.empty?
            Batting.where(teamID: teamParam).where(league: leagueParam).where(yearID: seasonParam.to_i)
        end
      else
        Batting.all
      end
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

    def calculate_batting_average(batting)
      #total hits (singles, double, triples, home runs) ÷ At Bats
      if batting.hits and batting.atBats then
        ba = batting.hits.fdiv(batting.atBats)
        return ba.nan? ? nil : ba.round(3)
      end
    end

    def calculate_slugging_percentage(batting)
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
      params.require(:player).permit(:firstName, :lastName, :playerID, :birthYear, :team, :league, :season, :allTime)
    end
end
