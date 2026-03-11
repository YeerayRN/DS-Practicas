public interface FactoriaPartidaYJugador{
    public Partida crearPartida();
    public Jugador crearJugador();

}

class FactoriaCompetitiva implements FactoriaPartidaYJugador{
    private int numJugadores = 0;

    public PartidaCompeti crearPartida(){
        PartidaCompeti partida = new PartidaCompeti();

        return partida;
    }

    public JugadorCompeti crearJugador(){
        JugadorCompeti jugador = new JugadorCompeti(numJugadores);
        numJugadores ++;

        return jugador;
    }
}

class FactoriaCasual implements FactoriaPartidaYJugador{
    private int numJugadores = 0;

    public PartidaCasual crearPartida(){
        PartidaCasual partida = new PartidaCasual();

        return partida;
    }

    public JugadorCasual crearJugador(){
        JugadorCasual jugador = new JugadorCasual(numJugadores);
        numJugadores ++;

        return jugador;
    }
}