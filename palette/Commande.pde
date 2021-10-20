enum Commande{
  Creer("Creer"),
  Deplacer("Deplacer");
  
  public final String label;

    private Commande(String label) {
        this.label = label;
  }

}
