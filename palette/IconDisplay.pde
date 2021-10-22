class IconDisplay{

  ArrayList<PImage> imagesToDraw = new ArrayList<PImage>();

  Point origin;
  boolean displayRightToOrigin;
  int imgSize = 32;
  int margin = 8;
  FSM state = FSM.INITIAL;
  
  
  public IconDisplay(Point origin, boolean displayRightToOrigin){
    this.origin = origin;
    this.displayRightToOrigin = displayRightToOrigin;
    setState(FSM.INITIAL);
  }
  
  void setState(FSM state){
    this.state = state;
    updateImagesToDraw();
  }
  
  void updateImagesToDraw(){
    imagesToDraw.clear();
    if(state.icons != null){
      for(int i = 0; i < state.icons.length; i++){
        for(int j = 0; j < state.icons[i].length; j++){
          PImage img = loadImage(state.icons[i][j]);
          imagesToDraw.add(img);
        }
        imagesToDraw.add(loadImage("icons/ou.png"));
      }
      imagesToDraw.remove(imagesToDraw.size()-1);
    }
  }
  
  void display(){
    for (int i = 0; i < imagesToDraw.size(); i++){
      int x = (int)origin.getX() + i * (imgSize + margin);
      int y = (int)origin.getY();
      
      image(imagesToDraw.get(i), x, y);
      
    }
  }
  
}
