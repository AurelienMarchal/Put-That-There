/*
 * Enumération de a Machine à Etats (Finite State Machine)
 *
 *
 */
 
public enum FSM {
  INITIAL(new String[][] {{"icons/voice.png", "icons/creer.png"}, {"icons/voice.png", "icons/deplacer.png"}}),/* Etat Initial */
  CREER(new String[][] {{"icons/drawing.png", "icons/shapes.png" }}),
  DEPLACER(null),
  D_FORMER(null),
  D_COULEUR(null),
  D_POSITION(null),
  C_FORMER(null),
  C_COULEUR(new String[][] {{"icons/voice.png", "color-wheel/shapes.png" }}),
  C_POSITION(null);
 
  
  public String[][] icons;
  
  
 private FSM(String[][] icons){
   this.icons = icons;
 }

}
