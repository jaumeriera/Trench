with dcomponents;
with ada.text_io; use ada.text_io;
procedure prueba is
  package trench_game is new dcomponents;
  use trench_game;
  c : components;
begin
  empty(c);
  put_line("Empty hecho");
  put_line("Tablero actual");
  print_board(c);
  put_line("Poniendo una pieza");
  put_piece(c, 2, 'a', 1);
  put_line("Tablero actual");
  print_board(c);
  put_line("Poniendo una pieza");
  put_piece(c, 6, 'd', 6);
  put_line("Tablero actual");
  print_board(c);
  put_line("eliminando una pieza y mostrando tablero");
  remove_piece(c, 'a', 1);
  print_board(c);
  put_line("eliminando una pieza y mostrando tablero");
  remove_piece(c, 'd', 6);
  print_board(c);


end prueba;
