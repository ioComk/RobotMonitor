import processing.serial.*;
import controlP5.*;
PGraphics pg;
PrintWriter file;

Serial port;

ControlP5 redButton, blueButton, startButton, stopButton;

int fieldSet = 1;
float encX, encY;
int signX, signY;
int[] buf = new int[3];
boolean isLogging = false;

float px, py;

String[] comPort = port.list();

long loopCounter;

void setup() 
{
  size(850, 600);
  frameRate(60);
  colorMode(RGB, 256); 

  file = createWriter("log.csv");

  pg = createGraphics(width, height);

  px = 0.0;
  py = 0.0;

  /*****************************
   SerialPort Setting
   ******************************/
  int num = comPort.length;
  for (int i=0; i<num; i++)
  {
    print(comPort[i]+"    ");
    try
    {
      port = new Serial(this, comPort[i], 115200);
      println("OK");
    }
    catch(Exception e)
    {
      println("failed");
      continue;
    }
  }

  /*****************************
   GUI
   ******************************/
  redButton = new ControlP5(this);
  redButton.addButton("redMode")
    .setLabel("Red")
    .setPosition(10, 525)
    .setSize(80, 40)
    .setColorBackground(color(255, 50, 50))
    .setColorForeground(color(255, 80, 80))
    .setColorCaptionLabel(color(255, 255, 255));

  blueButton = new ControlP5(this);
  blueButton.addButton("blueMode")
    .setLabel("Blue")
    .setPosition(100, 525)
    .setSize(80, 40)
    .setColorCaptionLabel(color(255, 255, 255));

  startButton = new ControlP5(this);
  startButton.addButton("start")
    .setLabel("Start")
    .setPosition(200, 510)
    .setSize(80, 40)
    .setColorBackground(color(255, 255, 255))
    .setColorCaptionLabel(color(0, 0, 0));

  stopButton = new ControlP5(this);
  stopButton.addButton("stop")
    .setLabel("Stop")
    .setPosition(200, 560)
    .setSize(80, 40)
    .setColorBackground(color(255, 255, 255))
    .setColorCaptionLabel(color(0, 0, 0));
}

void draw()
{

  background(200);

  drawField();

  pg.beginDraw();
  pg.point(encX/10, encY/10);
  pg.endDraw();

  image(pg, 0, 0);

  if (isLogging) 
  {
    file.print(loopCounter++);
    file.print(",");
    file.print(encX);
    file.print(",");
    file.println(encY);
    file.flush();
  }
}

void redMode()
{
  fieldSet = 1;
}

void blueMode()
{
  fieldSet = 2;
}

void start()
{
  isLogging = true;
}

void stop()
{
  isLogging = false;
}

void drawField()
{
  //red field
  if (fieldSet == 1)
  {
    strokeWeight(1);
    fill(177, 130, 97);
    rect(-1, -1, 851, 501);

    strokeWeight(0);
    fill(149, 37, 17);
    rect(650-8.9, 380, 200, 120);

    fill(255, 255, 255);
    rect(100-2.5, 0, 5, 500);
    rect(200-2.5, 0, 5, 500);
    rect(300-2.5, 0, 5, 500);

    rect(841.1, 0, 8.9, 500);

    rect(500-2.5, 0, 5, 500);

    strokeWeight(1);
    fill(149, 37, 17);

    rect(500-40, 200-40, 80, 80);


    rect(850-125-50, 200-25, 50, 50);
    rect(850-75-50, 100-25, 50, 50);
    rect(850-75-50, 300-25, 50, 50);

    // absolute point
    fill(0);
    textSize(25);
    text("(x,y) = (" + encX + "," + encY + ")", 500, 565);
    noFill();

    // robot point
    strokeWeight(2);
    fill(160, 200, 12);

    //rect(650-8.9+(encX/10), 380-(encY/10), 90, 90);
    rect(650-8.9+(encX/10), 410-(encY/10), 90, 90);

    if (frameCount>=2) {
      strokeWeight(40);
      fill(0, 255, 0);
      pg.beginDraw();
      pg.line(px+45, py+45, 650-8.9+(encX/10)+45, 380-(encY/10)+45);
      pg.endDraw();
    }

    image(pg, 0, 0);

    px = 650-8.9+(encX/10);
    py = 380-(encY/10);
  } 
  //blue field
  else if (fieldSet == 2)
  {
    strokeWeight(1);
    fill(177, 130, 97);
    rect(-1, -1, 851, 501);

    strokeWeight(0);
    fill(22, 53, 122);
    rect(8.9, 380, 200, 120);

    fill(255, 255, 255);

    rect(850-100-2.5, 0, 5, 500);
    rect(850-200-2.5, 0, 5, 500);
    rect(850-300-2.5, 0, 5, 500);

    rect(0, 0, 8.9, 500);

    rect(850-500-2.5, 0, 5, 500);

    strokeWeight(1);
    fill(22, 53, 122);
    rect(850-500-40, 200-40, 80, 80);

    rect(125, 200-25, 50, 50);
    rect(75, 100-25, 50, 50);
    rect(75, 300-25, 50, 50);

    //absolute point
    fill(0);
    textSize(25);
    text("(x,y) = (" + encX + "," + encY + ")", 500, 565);
    noFill();

    // robot point
    strokeWeight(2);
    fill(160, 200, 12);
    rect(110+8.9+(encX/10), 380-(encY/10), 90, 90);
  }
}

void serialEvent(Serial p)
{

  if (p.available()>=9)
  {
    if (p.read() == 'H')
    {
      signX = p.read();
      buf[0] =(p.read()<<16) | (p.read()<<8) | p.read();
      signY = p.read();
      buf[1] =(p.read()<<16) | (p.read()<<8) | p.read();
    }
  }

  encX = signX == 1 ? -buf[0] : buf[0];
  encY = signY == 1 ? -buf[1] : buf[1];
}