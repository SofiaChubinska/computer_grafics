int rCircle = 100;  
int numTangents = 10;  
PVector A;
PVector startPoint;

void setup() {
  size(1200, 900);
  A = new PVector(rCircle + 250, 0);  
  startPoint = A.copy();  
  background(255);
  drawCircleAndTangents();
}

void drawCircleAndTangents() {
  translate(width / 2, height / 2);  
  noFill();
  stroke(0);

  ellipse(0, 0, 2 * rCircle, 2 * rCircle);  

  fill(0);
  ellipse(0, 0, 10, 10); 

  // Малюємо дотичні
  for (int i = 0; i < numTangents ; i++) {
    PVector L = findTangentPoint(A);
    
    if (L == null) break; 
    
    // Малюємо дотичну від A до L
    stroke(0, 0, 255);
    line(A.x, A.y, L.x, L.y);

    PVector P = new PVector(2 * L.x - A.x, 2 * L.y - A.y);
    stroke(255, 0, 0);
    dashedLine(L.x, L.y, P.x, P.y);
    
    // Малюємо точки A, L, P
    fill(255, 0, 0);
    ellipse(A.x, A.y, 10, 10);  
    
    fill(0, 255, 0);
    ellipse(L.x, L.y, 10, 10);  
    
    fill(255, 0, 255);
    ellipse(P.x, P.y, 10, 10);  
    
    // Оновлюємо точку A для наступної дотичної
    A = P;
    
    // Перевіряємо, чи точка A виходить за межі вікна
    if (abs(A.x) > width / 2 || abs(A.y) > height / 2) {
      println("Точка A виходить за межі вікна.");
      break;  
    }
  }
}

PVector findTangentPoint(PVector A) {
  PVector CA = A.copy();
  float d = CA.mag();  
  
  // Перевірка, чи знаходиться точка A поза колом
  if (d <= rCircle) {
    println("Точка знаходиться всередині або на колі, дотичну неможливо побудувати.");
    //return null;  
  }
  
  
  // Кут між вектором від центру до точки A і горизонталлю
  float angle = atan2(CA.y, CA.x);
  
  // Обчислення кута для точки дотику
  float alpha = acos(rCircle / d);  // Кут для дотичної
  
  // Дві можливі точки дотику
  //PVector L1 = new PVector(rCircle * cos(angle + alpha), rCircle * sin(angle + alpha));
  PVector L2 = new PVector(rCircle * cos(angle - alpha), rCircle * sin(angle - alpha));
  
  // Вибираємо одну з точок дотику, ту, що знаходиться ближче до точки A
  /*if (PVector.dist(A, L1) < PVector.dist(A, L2)) {
    return L1;
  }*/
  return L2;/*else {
    return L2;
  }*/
}

void dashedLine(float x1, float y1, float x2, float y2) {
  float dashLength = 10;
  float gapLength = 10;
  
  float distance = dist(x1, y1, x2, y2);
  int numDashes = (int) (distance / (dashLength + gapLength));
  
  float dx = (x2 - x1) / distance * (dashLength + gapLength);
  float dy = (y2 - y1) / distance * (dashLength + gapLength);
  
  float startX = x1;
  float startY = y1;
  
  for (int i = 0; i < numDashes; i++) {
    float endX = startX + dx * (dashLength / (dashLength + gapLength));
    float endY = startY + dy * (dashLength / (dashLength + gapLength));
    line(startX, startY, endX, endY);
    
    startX = endX + dx * (gapLength / (dashLength + gapLength));
    startY = endY + dy * (gapLength / (dashLength + gapLength));
  }
}
