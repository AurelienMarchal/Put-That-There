/*
 * Palette Graphique - prélude au projet multimodal 3A SRI
 * 4 objets gérés : cercle, rectangle(carré), losange et triangle
 * (c) 05/11/2019
 * Dernière révision : 28/04/2020
 */

import java.awt.Point;
import fr.dgac.ivy.*;
import controlP5.*;

// data

Ivy bus;
PFont f;
String message= "";
ArrayList<Forme> formes; // liste de formes stockées


Forme formeToDraw = null;

FSM mae; // Finite Sate Machine
FSM last_mae;
int indice_forme;
PImage sketch_icon;
IconDisplay iconDisplay;


ControlP5 cp5;

float minConfidence = 0.85;

void setup() {
  size(800,600);
  surface.setResizable(true);
  surface.setTitle("Palette multimodale");
  surface.setLocation(20,20);
  sketch_icon = loadImage("Palette.jpg");
  surface.setIcon(sketch_icon);
  
  iconDisplay = new IconDisplay(new Point(0, 0), true);
  
  formes = new ArrayList();
  noStroke();
  
  mae = FSM.INITIAL;
  last_mae = mae;
  indice_forme = -1;
  
  
  cp5 = new ControlP5(this);
  
  
  // add a vertical slider
  Slider confidenceSlider = cp5.addSlider("minConfidence")
     .setPosition(100,550)
     .setSize(600,20)
     .setRange(0,1)
     .setValue(minConfidence)
     
     /*.setSliderMode(Slider.FLEXIBLE)
     .setNumberOfTickMarks(7)*/
     ;
  
  // reposition the Label for controller 'slider'
  confidenceSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  confidenceSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  confidenceSlider.setColorValueLabel(0);
  confidenceSlider.setColorCaptionLabel(0);
  confidenceSlider.setCaptionLabel("Minimum Confidence");
 
   try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    
    bus.bindMsg("^OneDollarIvy Template=(.*) Confidence=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        
        switch(mae){
          case CREER: 
            Point p = new Point(width/2, height/2);
            boolean found = true;
            if(args[0].contains("CERCLE")){
              formeToDraw = new Cercle(p);
            }
            
            else if(args[0].contains("TRIANGLE")){
              formeToDraw = new Triangle(p);
            }
            
            else if(args[0].contains("LOSANGE")){
              formeToDraw = new Losange(p);
            }
            
            else if(args[0].contains("RECTANGLE")){
              formeToDraw = new Rectangle(p);
            }
            else{
              found = false;
            }
            
            if(found){
              mae = FSM.C_FORME;
            }
            
            message = "Vous avez dessiné : " + args[0];
            System.out.println(message);
            break;
          
          
          default:
            break;
        }
        
        
        
      }        
    });
    
     
    bus.bindMsg("^sra5 Parsed=(.*) Confidence=(.*) NP=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client, String[] args)
      
      {
        
        switch(mae){
          case INITIAL:
            Commande[] commandes = Commande.values();
            
            for(Commande c : commandes){
              if(args[0].contains(c.label)){
               if (c.equals(Commande.Creer)){
                  mae = FSM.CREER;
               }
               if (c.equals(Commande.Deplacer) && formes.size() != 0){
                  mae = FSM.DEPLACER;
               }
              }
            }
            break;
           
          case C_COULEUR:
          case C_FORME:
            Couleur[] couleurs = Couleur.values();
        
            for(Couleur c : couleurs){
              if(args[0].contains(c.label)){
                if(formeToDraw != null){
                   formeToDraw.setColor(color(c.xValue, 64));
                   mae = FSM.C_COULEUR;
                }
                else{
                  if (formes.size() > 0){
                    Forme f = formes.get(formes.size() - 1);
                    f.setColor(color(c.xValue));
                  }
                }
              }
            }
            
            
            break;
          
          default:
            break;
        
        }
        
        
        
        message = "Vous avez prononcé les concepts : " + args[0] + " avec un taux de confiance de " + args[1];
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
    switch(mae){
      case C_COULEUR:
        if(formeToDraw != null){
         formeToDraw.setAlpha(255);
         formes.add(formeToDraw);
         formeToDraw = null;
         }
          
         mae = FSM.INITIAL;
         break;
     
       default:
         break;
   
    }
   
 }
 

void draw() {
  
  background(0);
  affiche();
  iconDisplay.display();
  //println(mae);
  
  if(formeToDraw != null){
    formeToDraw.setLocation(new Point(mouseX, mouseY));
    formeToDraw.update();
  }
  
  //Check is mae has changed 
  if(!mae.equals(last_mae)){
    iconDisplay.setState(mae);
    last_mae = mae;
  }
  
  println(minConfidence);
}

// fonction d'affichage des formes m
void affiche() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}
