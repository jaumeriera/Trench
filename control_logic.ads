with dcomponents; use dcomponents;
with exceptions; use exceptions;
with ada.integer_text_io; use ada.integer_text_io;
with ada.text_io; use ada.text_io;
with ada.strings; use ada.strings;
with ada.characters.handling; use ada.characters.handling;
package control_logic is

  type trench_game is limited private;

  -----------------------------------------------------------------------------
  --          PROCEDURES AND FUNCTIONS FOR THE CONTROL LOGICS                --
  -----------------------------------------------------------------------------

  -- Prepare the first state of the game, put all the pieces, start the score
  -- to 0 and set the white player as initial player
  procedure prepare_game (game : out trench_game);

  -- Move the piece from origin to destintion coordinates, this procedure
  -- does not check the correct movement for the piece
  procedure move_piece (game : in out trench_game; origin : in string;
                                                      destination : in string);

  -- Print the actual state of the board, the scores and current player turn
  procedure print_game_state (game : in trench_game);

  -- Pass the turn to the next player
  procedure next_turn (game : in out trench_game);

  -- Check if some player arrived to WIN_PUNCTUATION
  function game_not_finished (game : in trench_game) return boolean;

  -- Check if the current player is the owner of piece on the coordinate
  function is_owner_of_piece (game : in trench_game; coordinate : in string )
                                                                return boolean;

  -- Check if the movement selected is a valid move for the piece on the origin
  -- coordenate
  function movement_is_correct (game : in trench_game; origin : in out string;
                                        destination : in string) return boolean;

  -- Do the path from origin to destination coordenates, kill the pieces and
  -- add the value to player's score
  procedure puntuate_and_clean (game : in out trench_game; origin : in string;
                                                      destination : in string);

private

  -----------------------------------------------------------------------------
  --                        CONSTANTS OF THE GAME                            --
  -----------------------------------------------------------------------------

  WIN_PUNCTUATION : constant integer := 25;

  MOVE_CORPORAL : constant integer := 1;
  MOVE_SERGEANT : constant integer := 2;
  MOVE_LIEUTENANT : constant integer := 3;
  MOVE_MAJOR : constant integer := 4;
  MOVE_GENERAL : constant integer := 5;

  VALUE_CORPORAL : constant integer := 1;
  VALUE_SERGEANT : constant integer := 2;
  VALUE_LIEUTENANT : constant integer := 3;
  VALUE_MAJOR : constant integer := 4;
  VALUE_GENERAL : constant integer := 5;

  -----------------------------------------------------------------------------
  --              ARRAY OF SCORES AND TRENCH_GAME RECORD                     --
  -----------------------------------------------------------------------------

  type scores_array is array (color_type) of integer;

  type trench_game is
    record
       components_set : components;
       turn : color_type;
       scores : scores_array;
     end record;

end control_logic;
