enum Commande{
  Creer("CREER"),
  Deplacer("DEPLACER");
  
  public final String label;

    private Commande(String label) {
        this.label = label;
  }

}
