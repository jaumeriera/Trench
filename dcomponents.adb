
  package body dcomponents is

    ---------------------------------------------------------------------------
    --                FUNCTIONS TO CHECK RANK RANGES                         --
    ---------------------------------------------------------------------------

    -- Check ranges for corporal
    function is_corporal(i : in integer) return boolean is
      previous_range : integer := NUM_PIECES_PER_TEAM;
    begin
      return i <= NUM_CORPORAL or
             (i > NUM_PIECES_PER_TEAM and i <= previous_range + NUM_CORPORAL);
    end is_corporal;

    -- Check ranges for sergeant
    function is_sergeant(i : in integer) return boolean is
      previous_coute : integer := NUM_CORPORAL;
      actual_cuote : integer := NUM_CORPORAL + NUM_SERGEANT;
      second_previus_cuote : integer := NUM_PIECES_PER_TEAM + NUM_CORPORAL;
      second_actual_cuote : integer := NUM_PIECES_PER_TEAM + NUM_CORPORAL + NUM_SERGEANT;
    begin
      return (i > previous_coute and i <=actual_cuote) or
             (i > second_previus_cuote and i <= second_actual_cuote);
    end is_sergeant;

    -- Check ranges for lieutenant
    function is_lieutenant (i : in integer) return boolean is
      previous_coute : integer := NUM_CORPORAL + NUM_SERGEANT;
      actual_cuote : integer := previous_coute + NUM_LIEUTENANT;
      second_previus_cuote : integer := NUM_PIECES_PER_TEAM + previous_coute;
      second_actual_cuote : integer := NUM_PIECES_PER_TEAM + actual_cuote;
    begin
      return (i > previous_coute and i <=actual_cuote) or
             (i > second_previus_cuote and i <= second_actual_cuote);
    end is_lieutenant;

    -- Check ranges for major
    function is_major (i : in integer) return boolean is
      previous_coute : integer := NUM_CORPORAL + NUM_SERGEANT + NUM_LIEUTENANT;
      actual_cuote : integer := previous_coute + NUM_MAJOR;
      second_previus_cuote : integer := NUM_PIECES_PER_TEAM + previous_coute;
      second_actual_cuote : integer := NUM_PIECES_PER_TEAM + actual_cuote;
    begin
      return (i > previous_coute and i <=actual_cuote) or
             (i > second_previus_cuote and i <= second_actual_cuote);
    end is_major;

    ---------------------------------------------------------------------------
    --            AUXILIAR PROCEDURES FOR EMPTY PROCEDURE                    --
    ---------------------------------------------------------------------------

    -- Init the array of pieces
    procedure init_pieces (set : out array_of_pieces) is
      rank : character;
    begin
      for index in index_of_pieces loop
        rank := calculate_rank(index_of_pieces'pos(index));
        set(index) := rank;
      end loop;
    end init_pieces;

    -- Init the board to empty setup
    procedure init_board(board : out chess_board_type) is
    begin
      for x in x_index loop
          for y in y_index loop
              board(x,y) := pieces_id'first;
          end loop;
      end loop;
    end init_board;

    ---------------------------------------------------------------------------
    --                  AUXILIAR PRCEDURES FOR PRINT_BOARD                   --
    ---------------------------------------------------------------------------

    function prepare_string (c : in components; y : in y_index)
                                                      return unbounded_string is
      s : unbounded_string;
      rank : character;
    begin
      s := to_unbounded_string(integer'image(y));
      for x in x_index loop
        if c.board(x,y) = pieces_id'first then
          append(s, " ·");
        else
          --aux := integer'value(c.board(x,y));
          --s := s & integer'image(c.board(x,y));
          --append(s, integer'image(c.board(x,y)));
          rank := calculate_rank(index_of_pieces'pos(c.board(x,y)));
          append(s, " ");
          append(s, rank);
          --append(s, piece_type'image(rank));
        end if;
      end loop;
      return s;
    end prepare_string;

    ---------------------------------------------------------------------------
    --                        AUXILIAR FUNCTIONS                             --
    ---------------------------------------------------------------------------

    function to_number (x : in x_index) return integer is
    begin
      case x is
        when 'a' => return 1;
        when 'b' => return 2;
        when 'c' => return 3;
        when 'd' => return 4;
        when 'e' => return 5;
        when 'f' => return 6;
        when 'g' => return 7;
        when 'h' => return 8;
      end case;
    end to_number;

    ---------------------------------------------------------------------------
    --                PUBLIC PROCEDURES AND FUNCTIONS                        --
    ---------------------------------------------------------------------------

    -- Prepare the structure to empty
    procedure empty (c : out components) is
    begin
      init_pieces(c.pieces);
      init_board(c.board);
    end empty;

    -- Consult a box from the board and return the id contained on it
    function get_id_from_board (c : in components; x : in x_index; y : in y_index)
                                                            return pieces_id is
    begin
      return c.board(x,y);
    end get_id_from_board;

    -- Put an id on board this procedure don't check if the box is occupied, only
    -- puts and id inside a box
    procedure put_piece (c : out components; id : in pieces_id; x : in x_index;
                                                            y : in y_index) is
    begin
      c.board(x,y) := id;
    end put_piece;

    -- Get the color based on the id of the pieces. First NUM_PIECES_PER_TEAM
    -- are white pieces and the rest of pieces are black
    function get_color (id : in pieces_id) return color_type is
    begin
      if id = 0 then
        raise NOT_COLOR;
      end if;
      if pieces_id'pos(id) <= NUM_PIECES_PER_TEAM then
        return white;
      else
        return black;
      end if;
    end get_color;

    -- Return the type of the territory based on an box
    function get_territory (c : in components; x : in x_index; y : in y_index)
                                                        return territory_type is
      aux : integer;
    begin
      aux := y_index'pos(y) - to_number(x);
      if aux > 0 then
        return black;
      elsif aux < 0 then
        return white;
      else
        return trench;
      end if;
    end get_territory;

    -- Remove a piece from a box
    procedure remove_piece (c : out components; x : in x_index; y : in y_index) is
    begin
      c.board(x,y) := pieces_id'first;
    end remove_piece;

    -- Print the board
    procedure print_board (c : in components) is
      board_line : unbounded_string;
      x_help_line : unbounded_string := to_unbounded_string(" ");
    begin
      for y in y_index loop
        board_line := prepare_string(c,y);
        put_line(to_string(board_line));
      end loop;
      -- Create an string wich contains the leters for the board
      append(x_help_line," ");
      for x in x_index loop
          append(x_help_line," ");
          append(x_help_line,x);
      end loop;
      put_line(to_string(x_help_line));
    end print_board;

    -- Calculate the rank
    function calculate_rank (id : in integer) return character is
      c : character;
    begin
      if is_corporal(id) then
        c := 'c';
      elsif is_sergeant(id) then
        c := 's';
      elsif is_lieutenant(id) then
        c := 'l';
      elsif is_major(id) then
        c := 'm';
      else
        c := 'g';
      end if;

      if get_color(id) = black then
        c := to_upper(c);
      end if;

      return c;

    end calculate_rank;

    -- Check if the box is empty
    function box_empty (c : in components; x : in x_index; y : in y_index)
                                                              return boolean is
    begin
      return get_id_from_board(c, x, y) = 0;
    end box_empty;

  end dcomponents;
