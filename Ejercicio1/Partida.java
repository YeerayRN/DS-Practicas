import java.util.ArrayList;

public abstract class Partida{    
    protected ArrayList<Jugador> jugadores;

    public void addJugador(Jugador j){
        jugadores.add(j);
    }

    public abstract void abandonar();
}

class PartidaCasual extends Partida implements Runnable{
    private ArrayList<JugadorCasual> jugadores;

    public PartidaCasual(){
        jugadores = new ArrayList<JugadorCasual>();
    }

    @Override
    public void run(){
        System.out.println("Se está ejecutando una partida casual de " + jugadores.size() + " jugadores.");

        try {
            Thread.sleep(1000);
        } catch (Exception e){
            System.err.println(e);
        }

        abandonar();

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
    public ArrayList<JugadorCompeti> jugadores;

    public PartidaCompeti(){
        jugadores = new ArrayList<JugadorCompeti>();
    }


    @Override
    public void run(){
        System.out.println("Se está ejecutando una partida competi de " + jugadores.size() + " jugadores.");

        try {
            Thread.sleep(1000);
        } catch (Exception e){
            System.err.println(e);
        }

        abandonar();
        System.out.println("Se ha acabado la partida competi.");
    }


    public void abandonar(){
        int nAbandona = (10 * jugadores.size())/100;

        for(int i = 0; i < nAbandona; i++){
            jugadores.remove(jugadores.get(0));
        }   

        System.out.println("Se han salido " + nAbandona + " jugadores de la partida competi. Ahora quedan " + 
                            jugadores.size() + " jugadores.");
    }
}