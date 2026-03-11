public abstract class Jugador {
    protected int id;

    public Jugador(int id){
        this.id = id;
    }
    
    public int getId(){
        return this.id;
    }
}

class JugadorCasual extends Jugador{
    public JugadorCasual(int id){
        super(id);
    }
}

class JugadorCompeti extends Jugador{
    public JugadorCompeti(int id){
        super(id);
    }
}