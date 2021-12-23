class ErrorMessageDisplay{
  
  Point point;
  int messageSize = 40;
  String currentMessage;
  int timer;
  int displayTime = 100;
  color col = color(255, 0, 0);
  

  public ErrorMessageDisplay(Point point){
    this.point = point;
    this.currentMessage = null;
    this.timer = 0;
  
  }
  
  
  public void setMessage(String message){
    this.currentMessage = message;
    this.timer = displayTime;
  }
  
  public void display(){
    if(timer <= 0){
      currentMessage = null;
    }
    else if (currentMessage != null){
      textSize(messageSize);
      textAlign(CENTER);
      text(currentMessage, (int)(this.point.getX()), (int)this.point.getY());
      fill(col, timer*256/displayTime);
      timer --;
    }
  }
}
