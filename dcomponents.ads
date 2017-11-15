generic
package dcomponents is

  -----------------------------------------------------------------------------
  -- EXCEPTIONS
  -----------------------------------------------------------------------------

  value_not_possible : exception;

  -----------------------------------------------------------------------------
  --                    CONSTANTS OF NUMBER OF PIECES                        --
  -----------------------------------------------------------------------------

  NUM_CORPORAL : constant integer := 6;
  NUM_SERGEANT : constant integer := 4;
  NUM_LIEUTENANT : constant integer := 3;
  NUM_MAJOR : constant integer := 2;
  NUM_GENERAL : constant integer := 1;
  NUM_PIECES_PER_TEAM : constant integer := NUM_GENERAL+NUM_MAJOR+NUM_LIEUTENANT+
                                                    NUM_SERGEANT+NUM_CORPORAL;
  TOTAL_PIECES : constant integer := (NUM_GENERAL+NUM_MAJOR+NUM_LIEUTENANT+
                                                    NUM_SERGEANT+NUM_CORPORAL)*2;


  -----------------------------------------------------------------------------
  --                    TYPES RELATED TO PIECES                              --
  -----------------------------------------------------------------------------

  -- Id for pieces, id 0 reserved to null piece
  subtype pieces_id is integer range 0..TOTAL_PIECES;

  -- Military ranks sorted in an increasing way
  -- corporal, sergeant, lieutenant, major, general
  type piece_type is (c, s, l, m, g);

  type color_type is (black, white);
  type territory_type is (black, white, trench);

  -----------------------------------------------------------------------------
  --                    TYPES RELATED TO BOARD                               --
  -----------------------------------------------------------------------------

  -- Indexes for a typical chess board
  subtype x_index is character range 'a'..'h';
  subtype y_index is integer range 1..8;

  type components is limited private;

  -----------------------------------------------------------------------------
  --             PROCEDURES AND FUNCTIONS FOR COMPONENTS                     --
  -----------------------------------------------------------------------------

  -- Prepare the structure to empty
  procedure empty (c : out components);

  -- Consult a box from the board and return the id contained on it
  function get_id_from_board (c : in components; x : in x_index; y : in y_index)
                                                              return pieces_id;

  -- Put an id on board
  procedure put_piece (c : out components; id : in pieces_id; x : in x_index;
                                                                y : in y_index);

  -- Get the color based on the id of the piece
  function get_color (c : in components; id : in pieces_id) return color_type;

  -- Return the type of the territory based on an box
  function get_territory (c : in components; x : in x_index; y : in y_index)
                                                          return territory_type;

  -- Remove a piece from a box
  procedure remove_piece (c : out components; x : in x_index; y : in y_index);

  -- Print the board
  procedure print_board (c : in components);

private
    -----------------------------------------------------------------------------
  --              PIECE RECORD AND TYPE FOR ARRAY OF PIECES                  --
  -----------------------------------------------------------------------------

  type piece is
    record
    rank : piece_type;
  end record;

  -- Index for array
  subtype index_of_pieces is pieces_id range 1..pieces_id'last;

  -- Array of pieces
  type array_of_pieces is array (index_of_pieces) of piece;

  -----------------------------------------------------------------------------
  --              TYPES RELATED TO BOARD AND BOARD RECORD                    --
  -----------------------------------------------------------------------------

  type chess_board_type is array (x_index, y_index) of pieces_id;

  -----------------------------------------------------------------------------
  --                       PRINCIPAL STRUCTURE                               --
  -----------------------------------------------------------------------------

  type components is
  record
    pieces : array_of_pieces;
    board : chess_board_type;
  end record;

end dcomponents;
