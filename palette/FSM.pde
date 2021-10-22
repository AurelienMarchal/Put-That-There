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
  D_COULEURR(null),
  D_POSITIONR(null),
  C_FORMER(null),
  C_COULEURR(null),
  C_POSITIONR(null);
 
  
  public String[][] icons;
  
  
 private FSM(String[][] icons){
   this.icons = icons;
 }
}
