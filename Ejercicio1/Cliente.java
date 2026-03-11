public class Cliente{
    public static void main(String[] args){
        int N = 10;
        System.out.println("Jugando con " + N + " jugadores.");

        FactoriaCompetitiva factoriaCompeti = new FactoriaCompetitiva();
        FactoriaCasual factoriaCasual = new FactoriaCasual();

        PartidaCasual partidaCasual = factoriaCasual.crearPartida();
        PartidaCompeti partidaCompeti = factoriaCompeti.crearPartida();


        for(int i = 0; i < N; i++){
            partidaCasual.addJugador(factoriaCasual.crearJugador());
            partidaCompeti.addJugador(factoriaCompeti.crearJugador());
        }

        Thread hiloCasual = new Thread(partidaCasual);
        Thread hiloCompeti = new Thread(partidaCompeti);

        hiloCasual.start();
        hiloCompeti.start();
    }
}
