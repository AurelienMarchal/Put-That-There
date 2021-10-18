public enum Couleur {
  BLEU("BLEU", color(0, 200, 0)), /* Etat Initial */ 
  ROUGE("ROUGE"),
  VERT("VERT"),
  JAUNE("JAUNE"),
  VIOLET("VIOLET"),
  NOIR("NOIR"),
  ORANGE("ORANGE");
  
  
   public final String label;
   public final color value;

    private Couleur(String label, color value) {
        this.label = label;
        this.value = value;
    }
}
