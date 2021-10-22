/*
 * Palette Graphique - prélude au projet multimodal 3A SRI
 * 4 objets gérés : cercle, rectangle(carré), losange et triangle
 * (c) 05/11/2019
 * Dernière révision : 28/04/2020
 */
 
import java.awt.Point;
import fr.dgac.ivy.*;

// data

Ivy bus;
PFont f;
String message= "";
ArrayList<Forme> formes; // liste de formes stockées


Forme formeToDraw = null;

FSM mae; // Finite Sate Machine
int indice_forme;
PImage sketch_icon;


void setup() {
  size(800,600);
  surface.setResizable(true);
  surface.setTitle("Palette multimodale");
  surface.setLocation(20,20);
  sketch_icon = loadImage("Palette.jpg");
  surface.setIcon(sketch_icon);
  
  formes = new ArrayList();
  noStroke();
  
  mae = FSM.INITIAL;
  indice_forme = -1;
  
  
   try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    
    bus.bindMsg("^OneDollarIvy Template=(.*) Confidence=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        
        Point p = new Point(width/2, height/2);
        
        if(args[0].contains("CERCLE")){
          formeToDraw = new Cercle(p);
        }
        
        if(args[0].contains("TRIANGLE")){
          formeToDraw = new Triangle(p);
        }
        
        if(args[0].contains("LOSANGE")){
          formeToDraw = new Losange(p);
        }
        
        if(args[0].contains("RECTANGLE")){
          formeToDraw = new Rectangle(p);
        }
        
        message = "Vous avez dessiné : " + args[0];
        System.out.println(message);
        mae = FSM.ACTION;
      }        
    });
    
     
    bus.bindMsg("^sra5 Parsed=(.*) Confidence=(.*) NP=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client, String[] args)
      
      {
        Couleur[] couleurs = Couleur.values();
        
        for(Couleur c : couleurs){
          if(args[0].contains(c.label)){
            if(formeToDraw != null){
               formeToDraw.setColor(color(c.xValue, 64));
               
            }
            else{
              if (formes.size() > 0){
                Forme f = formes.get(formes.size() - 1);
                f.setColor(color(c.xValue));
              }
            }
           }
        }
        
        Commande[] commandes = Commande.values();
        
        for(Commande c : commandes){
          if(args[0].contains(c.label)){
             if (c.label.equals("")){
             
             }
           }
        }
        
        message = "Vous avez prononcé les concepts : " + args[0] + " avec un taux de confiance de " + args[1];
        mae = FSM.FORME;
        System.out.println(message);      
        
      }
   });
    
    bus.bindMsg("^sra5 Event=Speech_Rejected", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Malheureusement, je ne vous ai pas compris"; 
      }        
    });
    
    
    bus.sendMsg("Palette says =" + message); 
     
    
  }
  catch (IvyException ie)
  {
  }
}

  
  
 void mousePressed(){
   if(formeToDraw != null){
     formeToDraw.setAlpha(255);
     formes.add(formeToDraw);
     formeToDraw = null;
   }
   
 }
 

void draw() {
  
  background(0);
  affiche();
  
  if(formeToDraw != null){
    formeToDraw.setLocation(new Point(mouseX, mouseY));
    formeToDraw.update();
  }
  
  
  
  
  //println("MAE : " + mae + " indice forme active ; " + indice_forme);
  /*
  
  switch (mae) {
    case INITIAL:  // Etat INITIAL
      background(255);
      break;
      
    case AFFICHER_FORMES:  // 
    case DEPLACER_FORMES_SELECTION: 
    case DEPLACER_FORMES_DESTINATION: 
      affiche();
      break;
      
    default:
      break;
  }
  
  */
}

// fonction d'affichage des formes m
void affiche() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}
