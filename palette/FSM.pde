/*
 * Enumération de a Machine à Etats (Finite State Machine)
 *
 *
 */
 
public enum FSM {
  INITIAL(new String[][] {{"icons/voice.png", "icons/creer.png"}, {"icons/voice.png", "icons/deplacer.png"}}),/* Etat Initial */
  CREER(new String[][] {{"icons/drawing.png", "icons/shapes.png" }}),
  DEPLACER(new String[][] {{"icons/drawing.png", "icons/shapes.png" }, {"icons/click.png", "icons/shapes.png"}}),
  D_FORME(new String[][] {{"icons/voice.png", "icons/color-wheel.png" }}),
  D_COULEUR(new String[][] {{"icons/click.png", "icons/location.png" }, {"icons/voice.png", "icons/color-wheel.png" }}),
  D_POSITION(null),
  C_FORME(new String[][] {{"icons/voice.png", "icons/color-wheel.png" }}),
  C_COULEUR(new String[][] {{"icons/click.png", "icons/location.png" }, {"icons/voice.png", "icons/color-wheel.png" }}),
  C_POSITION(null);
 
  
  public String[][] icons;
  
  
 private FSM(String[][] icons){
   this.icons = icons;
 }

}
