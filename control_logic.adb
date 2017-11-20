package body control_logic is

  -----------------------------------------------------------------------------
  --                AUXILIAR OPETIONS FOR PUT_CORPORALS                      --
  -----------------------------------------------------------------------------

  -- Put into argument variables the value of the x and y coordinate depending
  -- on the color
  procedure get_corporal_coordinates (color : in color_type; x : out x_index;
  y : out y_index) is
  begin
    case color is
      when white =>
      x := 'e';
      y := 4;
      when black =>
      x := 'b';
      y := 5;
    end case;
  end get_corporal_coordinates;

  -- Put into argument variables the value of first new line's box depending on
  -- the color
  procedure next_line_coordinates (color : in color_type; x : out x_index;
                                                            y : out y_index) is
  begin
    case color is
      when white =>
        x := 'e';
        y := 3;
      when black =>
        x := 'c';
        y := 6;
    end case;
  end next_line_coordinates;

  -- Put into argument variables the value of the first and last piece id in
  -- integer depending on the color
  procedure get_corporal_range (color : in color_type; first : out integer;
  last : out integer) is
  begin
    case color is
      when white =>
      first := FIRST_WHITE_PIECE;
      last := NUM_CORPORAL;
      when black =>
      first := FIRST_BLACK_PIECE;
      last := FIRST_BLACK_PIECE+NUM_CORPORAL-1;
    end case;
  end get_corporal_range;

  -- put the last corporal depending on the color
  procedure put_last_corporal(components_set : out components; color : in color_type;
  id : in integer) is
  begin
    case color is
      when white =>
      put_piece(components_set, pieces_id'pos(id), 'e', 2);
      when black =>
      put_piece(components_set, pieces_id'pos(id), 'd', 7);
    end case;
  end put_last_corporal;

  -- Check if next id must be in the next line
  function must_change_line (id : in integer) return boolean is
    WHITE_JUMP : constant := FIRST_WHITE_PIECE+(NUM_CORPORAL/2)-1;
    BLACK_JUMP : constant := FIRST_BLACK_PIECE+(NUM_CORPORAL/2)-1;
  begin
    return id = WHITE_JUMP or id = BLACK_JUMP;
  end must_change_line;

  -----------------------------------------------------------------------------
  --                AUXILIAR OPETIONS FOR PUT_SERGEANTS                      --
  -----------------------------------------------------------------------------

  -- Put into argument variables the value of the first and last piece id in
  -- integer depending on the color
  procedure get_sergeant_range (color : in color_type; first : out integer;
  last : out integer) is
  begin
    case color is
      when white =>
      first := FIRST_WHITE_PIECE+NUM_CORPORAL;
      last := NUM_CORPORAL+NUM_SERGEANT;
      when black =>
      first := FIRST_BLACK_PIECE+NUM_CORPORAL;
      last := FIRST_BLACK_PIECE+NUM_CORPORAL+NUM_SERGEANT-1;
    end case;
  end get_sergeant_range;

  -- Put into argument variables the value of the x and y coordinate depending
  -- on the color
  procedure get_sergeant_coordinates (color : in color_type; x : out x_index;
                                                            y : out y_index) is
  begin
    case color is
      when white =>
      x := 'e';
      y := 1;
      when black =>
      x := 'a';
      y := 5;
    end case;
  end get_sergeant_coordinates;

  -----------------------------------------------------------------------------
  --                AUXILIAR OPETIONS FOR PUT_LIEUTENANTS                    --
  -----------------------------------------------------------------------------

  -- Put into argument variables the value of the first and last piece id in
  -- integer depending on the color
  procedure get_lieutenants_range (color : in color_type; first : out integer;
  last : out integer) is
  begin
    case color is
      when white =>
      first := FIRST_WHITE_PIECE+NUM_CORPORAL+NUM_SERGEANT;
      last := NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT;
      when black =>
      first := FIRST_BLACK_PIECE+NUM_CORPORAL+NUM_SERGEANT;
      last := FIRST_BLACK_PIECE+NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT-1;
    end case;
  end get_lieutenants_range;

  -- Put into argument variables the value of the x and y coordinate depending
  -- on the color
  procedure get_lieutenants_coordinates (color : in color_type; x : out x_index;
                                                            y : out y_index) is
  begin
    case color is
      when white =>
      x := 'f';
      y := 1;
      when black =>
      x := 'a';
      y := 6;
    end case;
  end get_lieutenants_coordinates;

-----------------------------------------------------------------------------
  --                AUXILIAR OPETIONS FOR PUT_LIEUTENANTS                    --
  -----------------------------------------------------------------------------

  -- Put into argument variables the value of the first and last piece id in
  -- integer depending on the color
  procedure get_majors_range (color : in color_type; first : out integer;
  last : out integer) is
  begin
    case color is
      when white =>
      first := FIRST_WHITE_PIECE+NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT;
      last := NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT+NUM_MAJOR;
      when black =>
      first := FIRST_BLACK_PIECE+NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT;
      last := FIRST_BLACK_PIECE+NUM_CORPORAL+NUM_SERGEANT+NUM_LIEUTENANT+NUM_MAJOR-1;
    end case;
  end get_majors_range;

  -- Put into argument variables the value of the x and y coordinate depending
  -- on the color
  procedure get_majors_coordinates (color : in color_type; x : out x_index;
                                                            y : out y_index) is
  begin
    case color is
      when white =>
      x := 'g';
      y := 1;
      when black =>
      x := 'a';
      y := 7;
    end case;
  end get_majors_coordinates;

  -----------------------------------------------------------------------------
  --           AUXILIAR PROCEDURES TO PUT THE INITIAL SET UP                 --
  -----------------------------------------------------------------------------

  -- Put all the corporals on the board
  procedure put_corporals(components_set : out components; color : in color_type) is
    first_value : integer;
    last_value : integer;
    coordinate_x : x_index;
    coordinate_y : y_index;
  begin
    -- calculate the range and coordinates
    get_corporal_range(color, first_value, last_value);
    get_corporal_coordinates(color, coordinate_x, coordinate_y);

    -- put all pieces except last
    for id_piece in first_value..last_value-1 loop
      put_piece(components_set, pieces_id'pos(id_piece),coordinate_x, coordinate_y);
      if must_change_line(id_piece) then
        next_line_coordinates(color, coordinate_x, coordinate_y);
      else
        -- next coordinate x
        coordinate_x := x_index'succ(coordinate_x);
      end if;
    end loop;

    -- Put last piece
    put_last_corporal(components_set, color, last_value);
  end put_corporals;

  -- Put the sergeants on the board
  procedure put_sergeants (components_set : out components;
                                                      color : in color_type) is
    coordinate_x : x_index;
    coordinate_y : y_index;
    first_value : integer;
    last_value : integer;
  begin
    -- calculate range and coordinates
    get_sergeant_range(color, first_value, last_value);
    get_sergeant_coordinates(color, coordinate_x, coordinate_y);

    -- put all the pieces on the board
    for id_piece in first_value..last_value loop
      put_piece(components_set, pieces_id'pos(id_piece), coordinate_x, coordinate_y);
      if coordinate_y /= y_index'last and then coordinate_x /= x_index'last then
        coordinate_x := x_index'succ(coordinate_x);
        coordinate_y := y_index'succ(coordinate_y);
      end if;
    end loop;
  end put_sergeants;

  -- Put the lieutenants on the board
  procedure put_lieutenants (components_set : out components; color : in color_type) is
    coordinate_x : x_index;
    coordinate_y : y_index;
    first_value : integer;
    last_value : integer;
  begin
    -- calculate range and coordinates
    get_lieutenants_range(color, first_value, last_value);
    get_lieutenants_coordinates(color, coordinate_x, coordinate_y);

    -- put all the pieces on the board
    for id_piece in first_value..last_value loop
      put_piece(components_set, pieces_id'pos(id_piece), coordinate_x, coordinate_y);
    if coordinate_y /= y_index'last and then coordinate_x /= x_index'last then
        coordinate_x := x_index'succ(coordinate_x);
        coordinate_y := y_index'succ(coordinate_y);
      end if;
    end loop;
  end put_lieutenants;

  -- Put the majors on the board
  procedure put_majors (components_set : out components; color : in color_type) is
    coordinate_x : x_index;
    coordinate_y : y_index;
    first_value : integer;
    last_value : integer;
  begin
    -- calculate range and coordinates
    get_majors_range(color, first_value, last_value);
    get_majors_coordinates(color, coordinate_x, coordinate_y);

    -- put all the pieces on the board
    for id_piece in first_value..last_value loop
      put_piece(components_set, pieces_id'pos(id_piece), coordinate_x, coordinate_y);
    if coordinate_y /= y_index'last and then coordinate_x /= x_index'last then
        coordinate_x := x_index'succ(coordinate_x);
        coordinate_y := y_index'succ(coordinate_y);
      end if;
    end loop;
  end put_majors;

  -- Put the general on the board
  procedure put_general (components_set : out components; color : in color_type) is
    id_piece : integer;
  begin
    case color is
      when white =>
        id_piece := FIRST_BLACK_PIECE-1;
        put_piece(components_set, pieces_id'pos(id_piece), 'h', 1);
      when black =>
        id_piece := pieces_id'last;
        put_piece(components_set, pieces_id'pos(id_piece), 'a', 8);
    end case;
  end put_general;

  -----------------------------------------------------------------------------
  --               AUXILIAR OPERATIONS RELATED TO PREPARE_GAME               --
  -----------------------------------------------------------------------------

  -- Start all scores to initial value
  procedure prepare_scores (scores : out scores_array) is
  begin
    for color in color_type loop
        scores(color) := 0;
    end loop;
  end prepare_scores;

  -- Set up the inicial state of black pieces
  procedure put_black_pieces(components_set : out components) is
  begin
    put_corporals(components_set, black);
    put_sergeants(components_set, black);
    put_lieutenants(components_set, black);
    put_majors(components_set, black);
    put_general(components_set, black);
  end put_black_pieces;

  -- Set up the inicial state of white pieces
  procedure put_white_pieces(components_set : out components) is
  begin
    put_corporals(components_set, white);
    put_sergeants(components_set, white);
    put_lieutenants(components_set, white);
    put_majors(components_set, white);
    put_general(components_set, white);
  end put_white_pieces;

  -- Set up the initial state of the board
  procedure prepare_board(components_set : out components) is
  begin
    empty(components_set);
    put_black_pieces(components_set);
    put_white_pieces(components_set);
  end prepare_board;

  -----------------------------------------------------------------------------
  --               AUXILIAR OPERATIONS FOR PRINT_GAME_STATE                  --
  -----------------------------------------------------------------------------

  -- Print the score of both players
  procedure print_scores (scores : in scores_array) is
  begin
    put("Puntuacion jugador blanco :");
    put(scores(white));
    put_line("");
    put("Puntuacion jugador negro : ");
    put(scores(black));
    put_line("");
  end print_scores;

  -- Print the actual turn
  procedure print_turn (turn : in color_type) is
  begin
    case turn is
      when white =>
        put_line("Turno del jugador : Blanco");
      when black =>
        put_line("Turno del jugador : Negro");
      end case;
  end print_turn;

  -----------------------------------------------------------------------------
  --                   AUXILIAR OPERATIONS FOR MOVE_PIECE                    --
  -----------------------------------------------------------------------------

  -- Return the first component of a coordinate
  function get_x_component (coordinate : in string) return x_index is
  begin
    if coordinate'length /= 2 then
      raise INCORRECT_LENGTH;
    end if;
    return coordinate(coordinate'first);
  end get_x_component;

  -- Return the second component of a coordinate
  function get_y_component (coordinate : in string) return y_index is
    aux_string : string (1..1);
  begin
    if coordinate'length /= 2 then
      raise INCORRECT_LENGTH;
    end if;
    aux_string(1) := coordinate(coordinate'first+1);
    return integer'value(aux_string);
  end get_y_component;

  -----------------------------------------------------------------------------
  --             AUXILIAR OPERATIONS FOR MOVEMENT_IS_CORRECT                 --
  -----------------------------------------------------------------------------

  -- Check if the piece is on a trench
  function is_on_trench (game : in trench_game; coordinate : in string)
                                                              return boolean is
    x_coordinate : x_index;
    y_coordinate : y_index;
  begin
    x_coordinate := get_x_component(coordinate);
    y_coordinate := get_y_component(coordinate);

    return get_territory(game.components_set, x_coordinate, y_coordinate) = trench;

  end is_on_trench;

  -- Return a boolean if the piece is on his territory
  function is_in_own_territory (game : in trench_game; coordinate : in string)
                                                              return boolean is
    x_coordinate : x_index;
    y_coordinate : y_index;
    turn : color_type renames game.turn;
    aux_index : integer;
  begin
    x_coordinate := get_x_component(coordinate);
    y_coordinate := get_y_component(coordinate);

    aux_index := color_type'pos(turn);

    return get_territory(game.components_set, x_coordinate, y_coordinate) =
                                                    territory_type'val(aux_index);

  end is_in_own_territory;

  -----------------------------------------------------------------------------
  --                PROCEDURES WHICH CHECK PIECE MOVEMENT                    --
  -----------------------------------------------------------------------------

  -- Return a boolean depending on the owner of the piece defined by two components
  -- of the coordenate
  function is_owner_of_piece (game : in trench_game; x_coordinate : in x_index;
                                      y_coordinate : in y_index) return boolean is
    id : pieces_id;
  begin

    id := get_id_from_board(game.components_set, x_coordinate, y_coordinate);

    return get_color(id) = game.turn;

  exception
    when NOT_COLOR =>
      put_line("No hay ninguna pieza en la casilla.");
      raise CANT_CHECK_OWNER;
    when CONSTRAINT_ERROR =>
      put_line("Coordenada no válida.");
      raise CANT_CHECK_OWNER;
    when INCORRECT_LENGTH =>
      put_line("Coordenada no válida, longitud de coordenada no válida.");
      raise CANT_CHECK_OWNER;
  end is_owner_of_piece;


  -- Check the movement to the upper boxes
  procedure check_up (game : in trench_game; move : in integer; origin : in string;
                                                          destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    diference : y_index;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    diference := y_origin - y_destination;

    -- Check if the piece is allowed to arrive todestination
    if diference > move then
      raise UNRECHABLE_BOX;
    end if;

    -- Check if there are pieces blocking the path
    for current_y in y_destination..y_origin-1 loop
        if not box_empty(game.components_set, x_destination, current_y) then
          if current_y = y_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin) =
                                                                    trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, x_origin, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
        -- The current box is empty
    end loop;
  exception
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_up;

  -- Check the movement to the right
  procedure check_right (game : in trench_game; move : in integer; origin : in string;
                                                          destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    diference : integer;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    diference := x_index'pos(x_destination) - x_index'pos(x_origin);

    -- Check if the piece is allowed to arrive todestination
    if diference > move then
      raise UNRECHABLE_BOX;
    end if;

    -- Check if there are pieces blocking the path
    for current_x in character'succ(x_origin)..x_destination loop
        if not box_empty(game.components_set, current_x, y_destination) then
          if current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, y_origin) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
        -- The current box is empty
    end loop;
  exception
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_right;

  -- Check the movement to the left
  procedure check_left (game : in trench_game; move : in integer; origin : in string;
                                                          destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    diference : integer;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    diference := x_index'pos(x_origin) - x_index'pos(x_destination);

    -- Check if the piece is allowed to arrive todestination
    if diference > move then
      raise UNRECHABLE_BOX;
    end if;

    -- Check if there are pieces blocking the path
    for current_x in x_destination..character'pred(x_origin) loop
        if not box_empty(game.components_set, current_x, y_destination) then
          if current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, y_origin) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
        -- The current box is empty
    end loop;
  exception
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_left;

  -- Check the movement to lower boxes
  procedure check_down (game : in trench_game; move : in integer; origin : in string;
                                                          destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    diference : y_index;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    diference := y_destination - y_origin;

    -- Check if the piece is allowed to arrive todestination
    if diference > move then
      raise UNRECHABLE_BOX;
    end if;

    -- Check if there are pieces blocking the path
    for current_y in y_origin+1..y_destination loop
        if not box_empty(game.components_set, x_destination, current_y) then
          if current_y = y_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, x_origin, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
        -- The current box is empty
    end loop;
  exception
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_down;

  -- Check the movement to diagonal down and left
  procedure check_down_left (game : in trench_game; move : in integer;
                                  origin : in string; destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    x_diference : integer;
    y_diference : y_index;
    current_y : y_index;
    in_diagonal : boolean := false;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    y_diference := y_destination - y_origin;
    x_diference := x_index'pos(x_origin) - x_index'pos(x_destination);

    -- Check if the piece is allowed to arrive todestination
    if y_diference > move or x_diference > move then
      raise UNRECHABLE_BOX;
    end if;

    current_y := y_origin;

    -- Check if there are pieces blocking the path
    for current_x in reverse x_destination..character'pred(x_origin) loop

      if current_y /= y_index'last then
        current_y := current_y + 1;

        -- check if destination coordinate is on diagonal
        if current_y = y_destination and then current_x = x_destination then
          in_diagonal := true;
        end if;

        if not box_empty(game.components_set, current_x, current_y) then
          if current_y = y_destination and current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece

                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
      end if;
    end loop;

    if not in_diagonal then
      raise UNRECHABLE_BOX;
    end if;

  exception
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_down_left;

  -- Check the movement to diagonal up and right
  procedure check_up_right (game : in trench_game; move : in integer;
                                  origin : in string; destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    x_diference : integer;
    y_diference : y_index;
    current_y : y_index;
    in_diagonal : boolean := false;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    y_diference := y_origin - y_destination;
    x_diference := x_index'pos(x_destination) - x_index'pos(x_origin);

    -- Check if the piece is allowed to arrive todestination
    if y_diference > move or x_diference > move then
      raise UNRECHABLE_BOX;
    end if;

    current_y := y_origin;
    -- Check if there are pieces blocking the path
    for current_x in character'succ(x_origin)..x_destination loop
      if current_y /= y_index'first then
        current_y := current_y-1;

        if current_y = y_destination and then current_x = x_destination then
          in_diagonal := true;
        end if;

        if not box_empty(game.components_set, current_x, current_y) then
          if current_y = y_destination and current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
      end if;
        -- The current box is empty
    end loop;

    if not in_diagonal then
      raise UNRECHABLE_BOX;
    end if;

  exception
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_up_right;

    -- Check the movement to diagonal down and right
  procedure check_down_right (game : in trench_game; move : in integer;
                                  origin : in string; destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    x_diference : integer;
    y_diference : y_index;
    current_y : y_index;
    in_diagonal : boolean := false;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    y_diference := y_destination - y_origin;
    x_diference := x_index'pos(x_destination) - x_index'pos(x_origin);

    -- Check if the piece is allowed to arrive todestination
    if y_diference > move or x_diference > move then
      raise UNRECHABLE_BOX;
    end if;

    current_y := y_origin;
    -- Check if there are pieces blocking the path
    for current_x in character'succ(x_origin)..x_destination loop
      if current_y /= y_index'last then
        current_y := current_y+1;
        -- check if the coordinate given is on the diagonal
        if current_y = y_destination and then current_x = x_destination then
          in_diagonal := true;
        end if;

        if not box_empty(game.components_set, current_x, current_y) then
          if current_y = y_destination and then current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
      end if;
        -- The current box is empty
    end loop;

    if not in_diagonal then
      raise UNRECHABLE_BOX;
    end if;

  exception
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
  end check_down_right;

  -- Check the movement to diagonal up and left
  procedure check_up_left (game : in trench_game; move : in integer;
                                  origin : in string; destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    x_diference : integer;
    y_diference : y_index;
    current_y : y_index;
    in_diagonal : boolean := false;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    y_diference := y_origin - y_destination;
    x_diference := x_index'pos(x_origin) - x_index'pos(x_destination);

    -- Check if the piece is allowed to arrive todestination
    if y_diference > move or x_diference > move then
      raise UNRECHABLE_BOX;
    end if;

    current_y := y_origin;
    -- Check if there are pieces blocking the path
    for current_x in reverse x_destination..character'pred(x_origin) loop
      if current_y /= y_index'first then
        current_y := current_y-1;

        if current_y = y_destination and then current_x = x_destination then
          in_diagonal := true;
        end if;

        if not box_empty(game.components_set, current_x, current_y) then
          if current_y = y_destination and then current_x = x_destination then
            if is_owner_of_piece(game, destination) then
              -- if the box is full, it's last box and current player is the owner
              -- of the destination piece
              raise CANT_KILL;
            end if;
            -- if the box is full, it's last box and current player is note the
            -- owner of the destination piece
            -- Correct move
          else
            if not (get_territory(game.components_set, x_origin, y_origin)
                                                                    = trench) then
              -- if the current box is occupied, is not last box and the player's
              -- piece is not in a trench
              raise PATH_BLOCKED;
            else
              if is_owner_of_piece(game, current_x, current_y) then
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by another player's
                -- piece
                raise PATH_BLOCKED;
              end if;
                -- if the current box is occupied is not last box, the player's
                -- piece is in a trench and this box is ocupied by a piece of
                -- other player
            end if;
          end if;
        end if;
        -- The current box is empty
      end if;
    end loop;

    if not in_diagonal then
      raise UNRECHABLE_BOX;
    end if;

  exception
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when CANT_KILL =>
      put_line("No puede matar una de sus piezas");
      raise CANT_KILL;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
  end check_up_left;

  -----------------------------------------------------------------------------
  --           TYPE DIRECTION AND PROCEDURE TO CALCULATE DIRECTION           --
  -----------------------------------------------------------------------------

  type direction_type is (up, down, right, left, diagonal_U_R, diagonal_U_L,
                                                    diagonal_D_R, diagonal_D_L);

  -- Return a direction_type depending on the destination and the origin
  function calculate_direction (origin : in string; destination : in string)
                                                        return direction_type is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    x_diference, y_diference : integer;
  begin
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);

    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    y_diference := y_origin - y_destination;
    x_diference := x_index'pos(x_origin) - x_index'pos(x_destination);

    if x_diference = 0 and then y_diference > 0 then return up; end if;
    if x_diference = 0 and then y_diference < 0 then return down; end if;
    if x_diference > 0 and then y_diference = 0 then return left; end if;
    if x_diference < 0 and then y_diference = 0 then return right; end if;
    if x_diference > 0 and then y_diference > 0 then return diagonal_U_L; end if;
    if x_diference > 0 and then y_diference < 0 then return diagonal_D_L; end if;
    if x_diference < 0 and then y_diference > 0 then return diagonal_U_R; end if;
    if x_diference < 0 and then y_diference < 0 then return diagonal_D_R; end if;
    if x_diference = 0 and then y_diference = 0 then raise NO_DIRECTION; return up; end if;

    return up;

  exception
    when NO_DIRECTION =>
      put_line("Ha seleccionado la misma casilla de origen que de destino.");
      raise NO_DIRECTION;
  end calculate_direction;

  -----------------------------------------------------------------------------
  --                           CHECKING PIECES                               --
  -----------------------------------------------------------------------------

  -- Check the posible movements for the corporal
  procedure check_corporal_move (game : in trench_game; origin : in string;
                                                        destination : in string) is
    direction : direction_type;
  begin
    direction := calculate_direction(origin, destination);
    case direction is
      when up =>
        check_up(game, MOVE_CORPORAL, origin, destination);
      when down =>
        check_down(game, MOVE_CORPORAL, origin, destination);
      when right =>
        check_right(game, MOVE_CORPORAL, origin, destination);
      when left =>
        check_left(game, MOVE_CORPORAL, origin, destination);
      when others =>
        raise UNRECHABLE_BOX;
    end case;

  exception
    when NO_DIRECTION =>
      raise UNRECHABLE_BOX;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when CANT_KILL =>
     raise CANT_KILL;
  end check_corporal_move;

  --check the posible movements for the corporal
  procedure check_sergeant_move (game : in trench_game; origin : in string;
                                                        destination : in string) is
    direction : direction_type;
  begin
    direction := calculate_direction(origin, destination);
    case direction is
      when up =>
        check_up(game, MOVE_SERGEANT, origin, destination);
      when down =>
        check_down(game, MOVE_SERGEANT, origin, destination);
      when right =>
        check_right(game, MOVE_SERGEANT, origin, destination);
      when left =>
        check_left(game, MOVE_SERGEANT, origin, destination);
      when diagonal_D_L =>
        if game.turn = white then
          check_down_left(game, MOVE_SERGEANT, origin, destination);
        else
          raise UNRECHABLE_BOX;
        end if;
      when diagonal_U_R =>
        if game.turn = black then
          check_up_right(game, MOVE_SERGEANT, origin, destination);
        else
          raise UNRECHABLE_BOX;
        end if;
      when others =>
        raise UNRECHABLE_BOX;
    end case;

  exception
    when NO_DIRECTION =>
      raise UNRECHABLE_BOX;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when CANT_KILL =>
     raise CANT_KILL;
  end check_sergeant_move;

  -- Check the posible movements for lieutenant
  procedure check_lieutenant_move (game : in trench_game; origin : in string;
                                                        destination : in string) is
    direction : direction_type;
  begin
    direction := calculate_direction(origin, destination);
    case direction is
      when up =>
        check_up(game, MOVE_LIEUTENANT, origin, destination);
      when down =>
        check_down(game, MOVE_LIEUTENANT, origin, destination);
      when right =>
        check_right(game, MOVE_LIEUTENANT, origin, destination);
      when left =>
        check_left(game, MOVE_LIEUTENANT, origin, destination);
      when diagonal_D_L =>
        check_down_left(game, MOVE_LIEUTENANT, origin, destination);
      when diagonal_U_R =>
        check_up_right(game, MOVE_LIEUTENANT, origin, destination);
      when others =>
        raise UNRECHABLE_BOX;
    end case;

  exception
    when NO_DIRECTION =>
      raise UNRECHABLE_BOX;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when CANT_KILL =>
     raise CANT_KILL;
  end check_lieutenant_move;

  -- Check the posible movements for major
  procedure check_major_move (game : in trench_game; origin : in string;
                                                        destination : in string) is
      direction : direction_type;
  begin
    direction := calculate_direction(origin, destination);
    case direction is
      when up =>
        check_up(game, MOVE_MAJOR, origin, destination);
      when down =>
        check_down(game, MOVE_MAJOR, origin, destination);
      when right =>
        check_right(game, MOVE_MAJOR, origin, destination);
      when left =>
        check_left(game, MOVE_MAJOR, origin, destination);
      when diagonal_D_L =>
        if game.turn = white then
          check_down_left(game, MOVE_MAJOR, origin, destination);
        else
          raise UNRECHABLE_BOX;
        end if;
      when diagonal_U_R =>
        if game.turn = black then
          check_up_right(game, MOVE_MAJOR, origin, destination);
        else
          raise UNRECHABLE_BOX;
        end if;
      when diagonal_D_R =>
        check_down_right(game, MOVE_MAJOR, origin, destination);
      when diagonal_U_L =>
        check_up_left(game, MOVE_MAJOR, origin, destination);
      when others =>
        raise UNRECHABLE_BOX;
    end case;

  exception
    when NO_DIRECTION =>
      raise UNRECHABLE_BOX;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when CANT_KILL =>
     raise CANT_KILL;
  end check_major_move;

  -- Check the posiblem movements for general
  procedure check_general_move (game : in trench_game; origin : in string;
                                                        destination : in string) is
    direction : direction_type;
  begin
    direction := calculate_direction(origin, destination);
    case direction is
      when up =>
        check_up(game, MOVE_GENERAL, origin, destination);
      when down =>
        check_down(game, MOVE_GENERAL, origin, destination);
      when right =>
        check_right(game, MOVE_GENERAL, origin, destination);
      when left =>
        check_left(game, MOVE_GENERAL, origin, destination);
      when diagonal_D_L =>
        check_down_left(game, MOVE_GENERAL, origin, destination);
      when diagonal_U_R =>
        check_up_right(game, MOVE_GENERAL, origin, destination);
      when diagonal_D_R =>
        check_down_right(game, MOVE_GENERAL, origin, destination);
      when diagonal_U_L =>
        check_up_left(game, MOVE_GENERAL, origin, destination);
      when others =>
        raise UNRECHABLE_BOX;
    end case;

  exception
    when NO_DIRECTION =>
      raise UNRECHABLE_BOX;
    when UNRECHABLE_BOX =>
      raise UNRECHABLE_BOX;
    when PATH_BLOCKED =>
      raise PATH_BLOCKED;
    when CANT_KILL =>
     raise CANT_KILL;
  end check_general_move;

  -----------------------------------------------------------------------------
  --                AUXILIAR OPERATIONS TO PUNTUATE_AND_CLEAN                --
  -----------------------------------------------------------------------------

  -- Return an integer which representate the value of the piece
  function rank_value (rank : in character) return integer is
  begin
    case rank is
      when 'c' =>
        return VALUE_CORPORAL;
      when 's' =>
        return VALUE_SERGEANT;
      when 'l' =>
        return VALUE_MAJOR;
      when 'm' =>
        return VALUE_MAJOR;
      when 'g' =>
        return VALUE_GENERAL;
      when others =>
        return 0;
      end case;
    end rank_value;

  -- All functions whit the name "direction"_simul do the same, simulate the move
  -- of the piece on the board remove pieces in the path and save into score
  -- parameter the value of removed pieces.

  procedure up_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    -- Simulate the move
    for current_y in y_destination..y_origin-1 loop
      id_piece := get_id_from_board(game.components_set, x_origin, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set, x_origin, current_y);
      end if;
    end loop;
  end up_simul;

  procedure down_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    -- Simulate the move
    for current_y in y_origin+1..y_destination loop
      id_piece := get_id_from_board(game.components_set, x_origin, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set, x_origin, current_y);
      end if;
    end loop;
  end down_simul;

  procedure right_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    -- Simulate the move
    for current_x in character'succ(x_origin)..x_destination loop
      id_piece := get_id_from_board(game.components_set, current_x, y_origin);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, y_origin);
      end if;
    end loop;
  end right_simul;

  procedure left_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    -- Simulate the move
    for current_x in x_destination..character'pred(x_origin) loop
      id_piece := get_id_from_board(game.components_set, current_x, y_origin);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, y_origin);
      end if;
    end loop;
  end left_simul;

  procedure up_left_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
    current_y : y_index;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    current_y := y_destination;
    -- Simulate the move
    for current_x in x_destination..character'pred(x_origin) loop
      id_piece := get_id_from_board(game.components_set, current_x, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, current_y);
      end if;
      current_y := current_y + 1;
    end loop;
  end up_left_simul;

  procedure up_right_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
    current_y : y_index;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    current_y := y_origin;
    -- Simulate the move
    for current_x in character'succ(x_origin)..x_destination loop
      current_y := current_y - 1;
      id_piece := get_id_from_board(game.components_set, current_x, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, current_y);
      end if;
    end loop;
  end up_right_simul;

  procedure down_right_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
    current_y : y_index;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    current_y := y_origin;
    -- Simulate the move
    for current_x in character'succ(x_origin)..x_destination loop
      current_y := current_y + 1;
      id_piece := get_id_from_board(game.components_set, current_x, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, current_y);
      end if;
    end loop;
  end down_right_simul;

  procedure down_left_simul (game : in out trench_game; origin, destination : in string;
                                                            score : out integer) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    rank : character;
    id_piece : pieces_id;
    current_y : y_index;
  begin
    score := 0;
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    current_y := y_destination;
    -- Simulate the move
    for current_x in x_destination..character'pred(x_origin) loop
      id_piece := get_id_from_board(game.components_set, current_x, current_y);
      if id_piece /= 0 then
        rank := calculate_rank(id_piece);
        rank := to_lower(rank);
        score := score + rank_value(rank);
        remove_piece(game.components_set,current_x, current_y);
      end if;
      current_y := current_y - 1;
    end loop;
  end down_left_simul;

  -- Return the number of moves that can do the piece in the coordenate
  function get_num_moves (game : in trench_game; coordinate : in string) return integer is

    x_coordinate : x_index;
    y_coordinate : y_index;
    id : pieces_id;
    rank : character;
  begin
    x_coordinate := get_x_component(coordinate);
    y_coordinate := get_y_component(coordinate);

    id := get_id_from_board(game.components_set, x_coordinate, y_coordinate);
    rank := calculate_rank(id);
    rank := to_lower(rank);

    case rank is
      when 'c' =>
        return MOVE_CORPORAL;
      when 's' =>
        return MOVE_SERGEANT;
      when 'l' =>
        return MOVE_LIEUTENANT;
      when 'm' =>
        return MOVE_MAJOR;
      when 'g' =>
        return MOVE_SERGEANT;
      when others =>
        return 0;
    end case;
  end get_num_moves;

  -- simulate the movement of origin piece to destinationbox and remove all pieces
  -- in his path, adding the value of the pieces deleted into score parameter
  procedure get_puntuation(game : in out trench_game; origin : in string;
                                destination : in string; score : out integer) is
    piece_num_moves : integer;
    direction : direction_type;
  begin
    -- Get the number of moves for the origin piece
    piece_num_moves := get_num_moves(game, origin);

    direction := calculate_direction(origin, destination);

    case direction is
      when up =>
        up_simul(game, origin, destination, score);
      when down =>
        down_simul(game, origin, destination, score);
      when left =>
        left_simul(game, origin, destination, score);
      when right =>
        right_simul(game, origin, destination, score);
      when diagonal_U_L =>
        up_left_simul(game, origin, destination, score);
      when diagonal_U_R =>
        up_right_simul(game, origin, destination, score);
      when diagonal_D_R =>
        down_right_simul(game, origin, destination, score);
      when diagonal_D_L =>
        down_left_simul(game, origin, destination, score);
    end case;

  end get_puntuation;

  -----------------------------------------------------------------------------
  --                    PUBLIC PROCEDURES AND FUNCTIONS                      --
  -----------------------------------------------------------------------------

  -- Prepare the board, the scores and the initial turn in order to start the
  -- game
  procedure prepare_game (game : out trench_game) is
  begin
    prepare_board(game.components_set);
    prepare_scores(game.scores);
    game.turn := white;
  end prepare_game;

  -- Print the actual state of the board, the turn and the score
  procedure print_game_state (game : in trench_game) is
  begin
    print_scores(game.scores);
    print_turn(game.turn);
    print_board(game.components_set);
  end print_game_state;

  -- Move a piece from an origin box to a destination box, correct movement and
  -- correct piece coordenates are not checked here
  procedure move_piece (game : in out trench_game; origin : in string;
                                                    destination : in string) is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    id : pieces_id;
  begin
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);

    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    id := get_id_from_board(game.components_set, x_origin, y_origin);
    put_piece(game.components_set, id, x_destination, y_destination);
    remove_piece(game.components_set, x_origin, y_origin);
  exception
    when CONSTRAINT_ERROR =>
      put_line("Coordenadas no válidas");
      raise PIECE_NOT_MOVED;
    when INCORRECT_LENGTH =>
      put_line("Coordenada no válida, longitud de coordenada no válida.");
      raise PIECE_NOT_MOVED;
  end move_piece;

  -- Change the turn
  procedure next_turn (game : in out trench_game) is
  begin
    case game.turn is
      when white =>
        game.turn := black;
      when black =>
        game.turn := white;
    end case;
  end next_turn;

  -- Check if one of both players win the game
  function game_not_finished (game : in trench_game) return boolean is
  begin
    return game.scores(white) < WIN_PUNCTUATION or game.scores(black) < WIN_PUNCTUATION;
  end game_not_finished;

  -- Check if the player is the owner of the piece selected
  function is_owner_of_piece (game : in trench_game; coordinate : in string )
                                                                return boolean is
    x_coordinate : x_index;
    y_coordinate : y_index;
    id : pieces_id;
  begin
    -- get components of the coordinate
    x_coordinate := get_x_component(coordinate);
    y_coordinate := get_y_component(coordinate);

    id := get_id_from_board(game.components_set, x_coordinate, y_coordinate);

    return get_color(id) = game.turn;

  exception
    when NOT_COLOR =>
      put_line("No hay ninguna pieza en la casilla.");
      raise CANT_CHECK_OWNER;
    when CONSTRAINT_ERROR =>
      put_line("Coordenada no válida.");
      raise CANT_CHECK_OWNER;
    when INCORRECT_LENGTH =>
      put_line("Coordenada no válida, longitud de coordenada no válida.");
      raise CANT_CHECK_OWNER;
  end is_owner_of_piece;

    -- Check if is a valid movement
  function movement_is_correct (game : in trench_game; origin : in out string;
                                      destination : in string) return boolean is
    x_origin, x_destination : x_index;
    y_origin, y_destination : y_index;
    id_origin : pieces_id;
    id_destination : pieces_id;
    rank : character;
  begin
    -- get components of the origin and destination
    x_origin := get_x_component(origin);
    y_origin := get_y_component(origin);
    x_destination := get_x_component(destination);
    y_destination := get_y_component(destination);

    id_origin := get_id_from_board(game.components_set, x_origin, y_origin);

    -- Get and convert rank
    rank := calculate_rank(pieces_id'pos(id_origin));
    rank := to_lower(rank);

    -- COMPROBAR PATH_BLOCKED I UNRECHABLE_BOX
    case rank is
      -- Corporal piece
      when 'c' =>
        check_corporal_move(game, origin, destination);
      when 's' =>
        check_sergeant_move(game, origin, destination);
      when 'l' =>
        check_lieutenant_move(game, origin, destination);
      when 'm' =>
        check_major_move(game, origin, destination);
      when 'g' =>
        check_general_move(game, origin, destination);
      when others =>
        null;
    end case;

    id_destination := get_id_from_board(game.components_set, x_destination, y_destination);
    if id_destination /= 0 then
      -- Check if destination is a piece of current player
      if get_color(id_destination) = game.turn then
        raise OBJECTIVE_INVALID;
      end if;

      -- Check if the objective is in a trench and the origin can kill the piece
      if is_on_trench(game, destination) and then is_in_own_territory(game, origin) then
        raise OBJECTIVE_IN_TRENCH;
      end if;
    end if;

    return true;

  exception
    when OBJECTIVE_IN_TRENCH =>
      put_line("Error en el movimiento: el objetivo está en una trinchera, recuerde");
      put_line("que para matar a una pieza que está en una trinchera tiene que hacerlo");
      put_line("desde detrás");
      raise INCORRECT_MOVEMENT;
    when OBJECTIVE_INVALID =>
      put_line("Error en el movimiento: el objectivo le pertenece a usted.");
      raise INCORRECT_MOVEMENT;
    when CONSTRAINT_ERROR =>
      put_line("Coordenadas incorrectas.");
      raise INCORRECT_MOVEMENT;
    when PATH_BLOCKED =>
      put_line("No se puede llegar a la casilla de destino, hay una pieza que");
      put_line("bloquea el camino");
      raise INCORRECT_MOVEMENT;
    when UNRECHABLE_BOX =>
      put_line("No se puede llegar a la casilla de destino, revise los movimientos");
      put_line("validos de la pieza");
      raise INCORRECT_MOVEMENT;
    when CANT_KILL =>
      raise INCORRECT_MOVEMENT;
  end movement_is_correct;

  -- Simulate the movement of the piece, remove the pieces in the path and puntuate
  -- killed pieces
  procedure puntuate_and_clean (game : in out trench_game; origin : in string;
                                                      destination : in string) is
    movement_points : integer := 0;
  begin
    -- simulate movement removing pieces in the path
    get_puntuation(game, origin, destination, movement_points);

    -- add puntuation
    game.scores(game.turn) := game.scores(game.turn) + movement_points;
  end puntuate_and_clean;

end control_logic;
