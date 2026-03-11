import java.util.ArrayList;

public abstract class Partida{    
    protected ArrayList<Jugador> jugadores;

    public Partida(){
        jugadores = new ArrayList<Jugador>();
    }

    public void addJugador(Jugador j){
        jugadores.add(j);
    }

    public abstract void abandonar();
}

class PartidaCasual extends Partida implements Runnable{
    @Override
    public void run(){
        System.out.println("Se está ejecutando una partida casual de " + jugadores.size() + " jugadores.");

        try {
            Thread.sleep(30000);
        } catch (Exception e){
            System.err.println(e);
        }

        abandonar();

        try {
            Thread.sleep(30000);
        } catch (Exception e){
            System.err.println(e);
        }

        System.out.println("Se ha acabado la partida Casual.");
    }

    public void abandonar(){
        int nAbandona = (20 * jugadores.size())/100;

        for(int i = 0; i < nAbandona; i++){
            jugadores.remove(jugadores.get(0));
        }

        System.out.println("Se han salido " + nAbandona + " jugadores de la partida casual. Ahora quedan " + 
                            jugadores.size() + " jugadores.");
    }
}

class PartidaCompeti extends Partida implements Runnable{
    @Override
    public void run(){
        System.out.println("Se está ejecutando una partida competitiva de " + jugadores.size() + " jugadores.");

        try {
            Thread.sleep(30000);
        } catch (Exception e){
            System.err.println(e);
        }

        abandonar();

        try {
            Thread.sleep(30000);
        } catch (Exception e){
            System.err.println(e);
        }

        System.out.println("Se ha acabado la partida competitiva.");
    }


    public void abandonar(){
        int nAbandona = (10 * jugadores.size())/100;

        for(int i = 0; i < nAbandona; i++){
            jugadores.remove(jugadores.get(0));
        }   

        System.out.println("Se han salido " + nAbandona + " jugadores de la partida competitiva. Ahora quedan " + 
                            jugadores.size() + " jugadores.");
    }
}