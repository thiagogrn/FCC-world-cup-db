#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
    # get team winner id
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get team opponent id
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if no team winner id found
    if [[ -z $TEAM_WINNER_ID ]]
    then
        # insert teams winner
        INSERT_TEAM_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        # get new team winner id
        TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # if no team opponent id found
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
        # insert teams winner
        INSERT_TEAM_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        # get new team opponent id
        TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    if [[ $TEAM_WINNER_ID != NULL && $TEAM_OPPONENT_ID != NULL ]]
    then
        # insert game
        INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$TEAM_WINNER_ID,$TEAM_OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    fi
  fi
done