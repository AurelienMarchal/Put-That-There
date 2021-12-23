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
int myColor = color(0,0,0);

int sliderValue = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;


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
  
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("sliderValue")
     .setPosition(100,50)
     .setRange(0,255)
     ;
  
  // create another slider with tick marks, now without
  // default value, the initial value will be set according to
  // the value of variable sliderTicks2 then.
  cp5.addSlider("sliderTicks1")
     .setPosition(100,140)
     .setSize(20,100)
     .setRange(0,255)
     .setNumberOfTickMarks(5)
     ;
     
     
  // add a vertical slider
  cp5.addSlider("slider")
     .setPosition(100,305)
     .setSize(200,20)
     .setRange(0,200)
     .setValue(128)
     ;
  
  // reposition the Label for controller 'slider'
  cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  

  cp5.addSlider("sliderTicks2")
     .setPosition(100,370)
     .setWidth(400)
     .setRange(255,0) // values can range from big to small as well
     .setValue(128)
     .setNumberOfTickMarks(7)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
  // by default it is Slider.FIX

  
  
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

  fill(sliderValue);
  rect(0,0,width,100);
  
  fill(myColor);
  rect(0,280,width,70);
  
  fill(sliderTicks2);
  rect(0,350,width,50);
  
}

// fonction d'affichage des formes m
void affiche() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}


void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
}
