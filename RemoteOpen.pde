/*
Send commands via UDP to the Leamington Spa Server Room Access Panel
*/ 

import hypermedia.net.*;

UDP udp;  // define the UDP object

PFont fontA;
int openMinutes = 15;
PImage smartie;

void setup() {
  size(300, 300);
  background(102);
  fontA = loadFont("Futura-Medium-32.vlw");
  textFont(fontA);
  smartie = loadImage("100x100.png");
  udp = new UDP(this, 6000);  // create a new datagram connection on port 6000
  udp.listen(true);           // and wait for incoming message
}
 
void draw()
{
  image(smartie, 200, 200);
  fill(0);
  text("Open Door", 10, 50);
  text("LED Test", 10, 100);
  text("Time", 10, 150);
  text("Secure Mode", 10, 200);
  text("View Log", 10, 250);
  showOpenMinutes();
}

void showOpenMinutes() {
  fill(150);
  rect(200, 10, 80, 50);
  fill(0);
  text(openMinutes, 210, 50);
}

void keyPressed() {
  String ip       = "192.168.1.170";	// the remote IP address
  int port        = 8888;		// the destination port
  char udpMessage[] = { 'X', '0', '0', '0', '0', '0', '0' };

  switch (key) {
    case 'l':
      udpMessage[0] = 'L';
      udp.send(new String(udpMessage), ip, port );
      break;

    case 'o':
      udpMessage[0] = 'O';
      udpMessage[1] = char(openMinutes);
      udp.send(new String(udpMessage), ip, port );
      break;
      
    case '=':
    case '+':
      if (++openMinutes > 240) openMinutes = 1;
      showOpenMinutes();
      break;

    case '-':
    case '_':
      if (--openMinutes < 1) openMinutes = 240;
      showOpenMinutes();
      break;

    case 's':
      udpMessage[0] = 'S';
      udp.send(new String(udpMessage), ip, port );
      break;

    case 'i':
      udpMessage[0] = 'I';
      udp.send(new String(udpMessage), ip, port );
      break;
      
    case 'q':
      exit();
      break;      

    case 'v':
      viewAccessLog();
      break;

    case 't':
      GregorianCalendar gcal = new GregorianCalendar();
      int week = gcal.getActualMaximum(Calendar.DAY_OF_WEEK);
      int dow = week - 1;
      if (dow == 0) dow = 7;
      udpMessage[0] = 'T';
      udpMessage[1] = char(hour());        // Hour
      udpMessage[2] = char(minute());      // Minute
      udpMessage[3] = char(dow);           // Day of the Week (1 - 7)      
      udpMessage[4] = char(day());         // Date      
      udpMessage[5] = char(month());       // Month      
      udpMessage[6] = char(year() - 2000); // Year   
      udp.send(new String(udpMessage), ip, port );
      break;    
  }
}

void viewAccessLog() {
  String logFileName = str(year()) + ".TXT";
  String shortmonth[] = new String[12];
  shortmonth[0] = "JAN";
  shortmonth[1] = "FEB";
  shortmonth[2] = "MAR";
  shortmonth[3] = "APR";
  shortmonth[4] = "MAY";
  shortmonth[5] = "JUN";
  shortmonth[6] = "JUL";
  shortmonth[7] = "AUG";
  shortmonth[8] = "SEP";
  shortmonth[9] = "OCT";
  shortmonth[10] = "NOV";
  shortmonth[11] = "DEC";
  
  logFileName = shortmonth[month()-1] + logFileName;
  
  logFileName = "http://192.168.1.170/" + logFileName;
  link(logFileName);
}

void receive(byte[] data) {
  if (data.length >= 2) {
    if (data[0] == 'O' && data[1] == 'K') {
      background(0, 120, 0);
      delay(1000);
      background(102);
    }
  }
}
 


