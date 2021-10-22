public enum Couleur {
  BLEU("BLEU", #0000ff),
  ROUGE("ROUGE", #ff0000),
  VERT("VERT", #00ff00),
  JAUNE("JAUNE", #ffff00),
  VIOLET("VIOLET", #ff00ff),
  NOIR("NOIR", #000000),
  CYAN("CYAN", #00ffff),
  ORANGE("ORANGE", #ff7f00);
  
   public final String label;
   public final int xValue;

    private Couleur(String label, int xValue) {
        this.label = label;
        this.xValue = xValue;
    }
}
