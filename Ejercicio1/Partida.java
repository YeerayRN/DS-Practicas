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
        //Supongo que hay que hacer algun sleep o algo
        abandonar();
    }

    public void abandonar(){
        int nAbandona = (20 * jugadores.size())/100;

        for(int i = 0; i < nAbandona; i++){
            jugadores.remove(jugadores.get(0));
        }
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
        //Supongo que hay que hacer algun sleep o algo
        abandonar();
    }


    public void abandonar(){
        int nAbandona = (10 * jugadores.size())/100;

        for(int i = 0; i < nAbandona; i++){
            jugadores.remove(jugadores.get(0));
        }   
    }
}