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
    
    bus.bindMsg("^sra5 Text=(.*) Confidence=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Vous avez dit : " + args[0];
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
             println(c.label);
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

  
  
  
  
  
  
  


void draw() {
  
  background(0);
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
