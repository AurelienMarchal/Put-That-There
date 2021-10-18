public enum Couleur {
  BLEU("BLEU"), /* Etat Initial */ 
  ROUGE("ROUGE"),
  VERT("VERT"),
  JAUNE("JAUNE"),
  VIOLET("VIOLET"),
  NOIR("NOIR"),
  ORANGE("ORANGE");
  
  
   public final String label;

    private Couleur(String label) {
        this.label = label;
    }
}
