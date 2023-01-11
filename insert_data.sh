#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#INSERT TEAMS TABLE DATA 
  #GET WINNER TEAM NAME
    #exclude column names row
    if [[ $WINNER != "winner" ]]
      #get team name
      then
      TEAM_NAME1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      #if team name is not found we need to include the new team to the table
      if [[ -z $TEAM_NAME1 ]]
        then
         #insert knew team
        INSERT_TEAM_NAME1=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        #echo call to let us know team was inserted
        if [[ $INSERT_TEAM_NAME1 == "INSERT 0 1" ]]
          then
          echo inserted $WINNER
        fi
      fi
    fi
      

  #GET OPPONENT TEAM NAME
    #exclude column names row
    if [[ $OPPONENT != "opponent" ]]
      then
      #get team name
      TEAM_NAME2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      #if team name is not found we need to include the new team to the table
      if [[ -z $TEAM_NAME2 ]]
        then
        #insert new team
        INSERT_TEAM_NAME2=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        #echo call to let us know team was inserted
        if [[ $INSERT_TEAM_NAME2 == "INSERT 0 1" ]]
          then
          echo inserted $OPPONENT
        fi
      fi
    fi
      

  #INSERT GAMES TABLE DATA
    #we don't want the column names row so exclude it
    if [[ $YEAR != "year" ]]
      then
      #get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #get opponnent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #insert new games row
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
      #echo call to let us know what was added
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
        echo inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
      fi
    fi
      
done
