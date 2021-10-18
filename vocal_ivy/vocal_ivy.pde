/*
 *  vocal_ivy -> Demonstration with ivy middleware
 * v. 1.2
 * 
 * (c) Ph. Truillet, October 2018-2019
 * Last Revision: 22/09/2020
 * Gestion de dialogue oral
 */
 
import fr.dgac.ivy.*;

// data

Ivy bus;
PFont f;
String message= "";

int state;
public static final int INIT = 0;
public static final int ATTENTE = 1;
public static final int TEXTE = 2;
public static final int CONCEPT = 3;
public static final int NON_RECONNU = 4;
int upstate;
ArrayList<String> mylist;

void setup()
{
  size(400, 500);
  fill(0,255,0);
  f = loadFont("TwCenMT-Regular-24.vlw");
  state = INIT;
  mylist = new ArrayList<String>();
  
  textFont(f,18);
  try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    bus.bindMsg("^sra5 Text=(.*) Confidence=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Vous avez dit : " + args[0];
        state = TEXTE;
      }        
    });
    
    bus.bindMsg("^sra5 Parsed=(.*) Confidence=(.*) NP=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        if (args[0].contains("ADD")){
          if (args[0].contains("CROISSANT")){
            mylist.add("croiss");
          }else if (args[0].contains("CHOCO")){
            mylist.add("choco");
          }else if (args[0].contains("GRAPE")){
            mylist.add("grape");
          }
        }else if (args[0].contains("DELETE")){
          if (args[0].contains("CROISSANT")){
            mylist.remove("croiss");
          }else if (args[0].contains("CHOCO")){
            mylist.remove("choco");
          }else if (args[0].contains("GRAPE")){
            mylist.remove("grape");
          }
        }
        message = "Vous avez prononcé les concepts : " + args[0] + " avec un taux de confiance de " + args[1];
        state = CONCEPT;
        System.out.println(mylist);
      }        
    });
    
    bus.bindMsg("^sra5 Event=Speech_Rejected", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Malheureusement, je ne vous ai pas compris"; 
        state = NON_RECONNU;
      }        
    });    
  }
  catch (IvyException ie)
  {
  }
}

void draw()
{
  background(0);
  stroke(255);
  line(0, 100, 400, 100);
  
  switch(state) {
    case INIT:
      message = "Bonjour, veuillez parler s'il vous plaît";
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      state = ATTENTE;
      break;
      
    case ATTENTE:
      // cas normal ...
      break;
      
    case TEXTE :
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      state = ATTENTE;
      break;
      
     case CONCEPT:  
       try {
          bus.sendMsg("ppilot5 Say=" + message);
       }
       catch (IvyException e) {}
       state = ATTENTE;
       break; 
       
     case NON_RECONNU:
       state = ATTENTE;
       try {
          bus.sendMsg("ppilot5 Say=" + message); 
       }
       catch (IvyException e) {}
       state = ATTENTE;
       break;
  }
  
  text("************     ETAT COURANT     ************", 20, 20);
  text(state, 20, 50);
}
