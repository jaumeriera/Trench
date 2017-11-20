with control_logic; use control_logic;
with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.text_io.unbounded_io; use ada.text_io.unbounded_io;
with exceptions; use exceptions;
procedure trench is

  -----------------------------------------------------------------------------
  --                            TEXT PRODEDURES                              --
  -----------------------------------------------------------------------------

  -- Print the test which asks the origin coordinate
  procedure ask_origin_coordinate is
  begin
    put("Coordenada de la pieza que quiere mover: ");
  end ask_origin_coordinate;

  -- Print the test which asks the destination coordinate
  procedure ask_destination_coordinate is
  begin
    put("Coordenada de destino de la pieza: ");
  end ask_destination_coordinate;

  -- Print the interaction menu
  procedure print_menu is
  begin
    put_line("Bienvenido a trench, seleccione una opción: ");
    put_line("    a) Reglas del juego.");
    put_line("    b) Jugar.");
    put_line("    c) Salir.");
    put("Introduce una opción: ");
  end print_menu;

  -----------------------------------------------------------------------------
  --                  AUXILIAR FUNCTIONS AND PROCEDURES                      --
  -----------------------------------------------------------------------------

  -- Get the keyboard buffer and put ir on the string introduced by parameters
  procedure get_coordinate (coordinate : out string) is
    buffer : unbounded_string;
  begin
    buffer := get_line;
    -- Adapt to my string
    for index in coordinate'first..coordinate'last loop
        if index <= length(buffer) then
          coordinate(index) := element(buffer, index);
        else
          coordinate(index) := ' ';
        end if;
    end loop;
  end get_coordinate;

  -- Get the keyboard buffer and put it on the string introduced by parameters
  procedure get_option (option : out character) is
    buffer : unbounded_string;
  begin
    buffer := get_line;

    if length(buffer) = 1 then
      option := element(buffer,1);
    else
      option := ' ';
    end if;
  end get_option;

  -- Check if the movement is correct, move the piece and pass the turn,
  -- this procedure contains most of advertisments due to errors.
  procedure do_actions (game : in out trench_game; origin : in out string;
                                                destination : in out string) is
  begin
    -- check if the player is the owner of the piece
    if not is_owner_of_piece(game, origin) then
      raise INCORRECT_PIECE;
    end if;
    -- check if the piece can reach the destination
    if movement_is_correct(game, origin, destination) then
      puntuate_and_clean(game, origin, destination);
      move_piece(game, origin, destination);
      -- pass the turn
      next_turn(game);
    else
      raise INCORRECT_MOVEMENT;
    end if;
  exception
    when CANT_CHECK_OWNER =>
      put_line("No se ha movido la pieza");
    when INCORRECT_PIECE =>
      put_line("Usted no es el propietario de la pieza seleccionada, no se ha movido la pieza");
    when INCORRECT_MOVEMENT =>
      put_line("No puede hacer ese movimiento, no se ha movido la pieza");
    when PIECE_NOT_MOVED =>
      put_line("No se ha movido la pieza");
  end do_actions;

  -----------------------------------------------------------------------------
  --                       VARIABLES OF THE PROGRAM                          --
  -----------------------------------------------------------------------------

  game : trench_game;
  origin : string (1..2);
  destination : string (1..2);
  option : character;
  salir : boolean := false;
  rules_file : file_type;
  line : unbounded_string;
begin
  prepare_game(game);
  while not salir loop
    print_menu;
    get_option(option);
    case option is
      when 'a' =>
        --  print the rules
        put_line("----------------------------------------------------------");
        open (file => rules_file, mode => in_file, name => "Reglas.txt");
        while not end_of_file(rules_file) loop
          line := get_line(rules_file);
          put_line(line);
        end loop;
        close(rules_file);
        put_line("----------------------------------------------------------");
      when 'b' =>
        -- game flow
        while game_not_finished(game) loop
          put_line("----------------------------------------------------------");
          print_game_state(game);
          ask_origin_coordinate;
          get_coordinate(origin);
          ask_destination_coordinate;
          get_coordinate(destination);
          do_actions(game, origin, destination);
          put_line("----------------------------------------------------------");
        end loop;
      when 'c' =>
        salir := true;
      when others =>
        put_line("Opción no disponible");
        put_line("----------------------------------------------------------");
    end case;
  end loop;
end trench;
