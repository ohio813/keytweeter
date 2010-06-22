// To run this code, you'll need to download keytweeter.csv:
// http://code.google.com/p/keytweeter/downloads/list

import processing.opengl.*;

float[] yearScale, dayScale;

void setup() {
  size(1024, 768, P2D);
  
  String[] logs = loadStrings("keytweeter.csv");
  
  long startMillis = getMillis(logs, 0);
  long endMillis = getMillis(logs, logs.length - 1);
  long rangeMillis = endMillis - startMillis;
  
  yearScale = new float[logs.length];
  dayScale = new float[logs.length];
  for(int i = 0; i < logs.length; i++) {
    long curMillis = getMillis(logs, i);
    yearScale[i] = width * (float) (curMillis - startMillis) / rangeMillis;
    dayScale[i] = height * getTimeOfDay(logs, i);
  }
  
  stroke(255, 128);
  noLoop();
}

float getTimeOfDay(String[] logs, int i) {
  Calendar cur = getDate(logs, i);
  return  
    (float) (cur.get(Calendar.SECOND) + 
      60 * (cur.get(Calendar.MINUTE) +
      60 * cur.get(Calendar.HOUR_OF_DAY))) /
    (60 * 60 * 24);
}

long getMillis(String[] logs, int i) {
  return getDate(logs, i).getTimeInMillis();
}

// http://java.sun.com/j2se/1.5.0/docs/api/java/util/Calendar.html
Calendar getDate(String[] logs, int i) {
  String[] parts = split(logs[i], '\t');
  Calendar curDate = Calendar.getInstance();
  curDate.set(
    int(parts[1]), int(parts[2]), int(parts[3]),
    int(parts[4]), int(parts[5]), int(parts[6]));
  return curDate;
}

void draw() {
  background(0);
  for(int i = 0; i < yearScale.length; i++)
    point(yearScale[i], dayScale[i]);
  saveFrame("out.png");
}
