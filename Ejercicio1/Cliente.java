import java.util.Scanner;

public class Cliente{
    public static void main(String[] args){
        Scanner input = new Scanner(System.in);

        System.out.print("Introduzca el número de jugadores: ");

        int n = input.nextInt();

        System.out.println("Jugando con " + n + " jugadores.");

        FactoriaCompetitiva factoriaCompeti = new FactoriaCompetitiva();
        FactoriaCasual factoriaCasual = new FactoriaCasual();

        PartidaCasual partidaCasual = factoriaCasual.crearPartida();
        PartidaCompeti partidaCompeti = factoriaCompeti.crearPartida();


        for(int i = 0; i < n; i++){
            JugadorCasual jugadorCasual = factoriaCasual.crearJugador();
            JugadorCompeti jugadorCompeti = factoriaCompeti.crearJugador();
        
            partidaCasual.addJugador(jugadorCasual);
            partidaCompeti.addJugador(jugadorCompeti);
        }

        Thread hiloCasual = new Thread(partidaCasual);
        Thread hiloCompeti = new Thread(partidaCompeti);

        hiloCasual.start();
        hiloCompeti.start();
        
        input.close();
    }
}
