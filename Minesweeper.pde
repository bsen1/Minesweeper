import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_MINES = 75;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int flagCount = NUM_MINES;
private boolean firstClicked = false;
private boolean playing = true;
private String gameState = "";
void setup ()
{
    size(600, 650);
    textSize(20);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r,c);
    
    
    
}
public void setMines(int row, int col)
{
  
    int random_row = (int)((Math.random()) * NUM_ROWS);
    int random_col = (int)((Math.random()) * NUM_COLS);
    for(MSButton i : mines) {
      if (i.myRow == random_row && i.myCol == random_col) {
        setMines(row, col);
        return;
      }
    }
    
    for(int r = row-1; r <= row+1; r++)
      for(int c = col-1; c <= col+1; c++)
        if (random_row == r && random_col == c) {
        setMines(row, col);
        return;
        }
    
    mines.add(buttons[random_row][random_col]);
  }
  

public void draw ()
{
    background(189, 159, 68);
    
    fill(0);
    text("Flags:" + flagCount, 50,622.5);
    text(gameState, 500, 622.5);
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon()
{
    if(!firstClicked)
      return false;
    for(int r = 0; r < buttons.length; r++)
      for(int c = 0; c < buttons[r].length; c++) {
        if(mines.contains(buttons[r][c]))
          continue;
        else
          if(buttons[r][c].clicked == false)
            return false;
      }
      
    for(MSButton i : mines)
      if (!i.flagged)
        return false;
    
    playing = false;
    return true;
      
}
public void displayLosingMessage()
{
    for(MSButton i : mines) {
        if (i.flagged)
          flagCount++;
      i.clicked = true;
    }
    playing = false;
    gameState = "You Lost!";
}
public void displayWinningMessage()
{
    gameState = "You Won!";
}
public boolean isValid(int r, int c)
{
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1; r++)
      for(int c = col-1; c <= col+1; c++) {
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
      }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, hovering;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        hovering = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(!playing)
        return;
        if(mouseButton == LEFT && !firstClicked) {
          firstClicked = true;
          for(int i = 0; i < NUM_MINES; i++)
            setMines(myRow, myCol);
        }
        if(clicked)
          return;
        if(mouseButton == RIGHT) {
            if (!clicked) {
              if(flagged == true) {
                flagged = false;
                flagCount++;
              }
              else if(flagged == false) {
                if(flagCount <= 0)
                  return;
                flagCount--;
                flagged = true;
              }
            }
          }
        else if(mines.contains(this) && !flagged) {
          displayLosingMessage();
          clicked = true; }
        else if(countMines(myRow, myCol) > 0 && !flagged) {
          setLabel(countMines(myRow,myCol));
          clicked = true; 
        }
        else if(countMines(myRow, myCol) == 0 && !flagged) {
          clicked = true;
          for(int r = myRow-1; r <= myRow+1; r++)
            for(int c = myCol-1; c <= myCol+1; c++) {
              if(isValid(r,c) && (r != myRow || c != myCol)) {
                if(buttons[r][c].flagged)
                  flagCount++;
                buttons[r][c].flagged = false;
                buttons[r][c].mousePressed();
              }
            }
        }
        
    }
    
    public void mouseMoved() {
      if( mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height) {
        hovering = true;
      }
      else
        hovering = false;
    }
    
    
    public void draw () 
    {    

        if( clicked && mines.contains(this) )  {
            fill(255,0,0);
        }
        else if(clicked)
            fill( 200 );
        else if(hovering)
            fill(152, 247, 141);
        else {
            if((myRow + myCol) % 2 == 0)
              fill(0, 204, 68);
            else
              fill(24, 161, 61);
        }
              
        rect(x, y, width, height);
        
        if (flagged) {
          fill(230, 35, 21);
          noStroke();
          rect(x+5,y+5,3,20);
          triangle(x+8,y+5, x+25, y+10, x+8, y+17.5);
          rect(x+3,y+25,7,3);
          stroke(0);
        }
        
        if(clicked && mines.contains(this)) {
          fill(0);
          ellipse(x+width/2, y+height/2, 15,15);
          strokeWeight(2);
          line(x+3, y+height/2, x+27, y+height/2);
          line(x+width/2, y+3, x+width/2, y+27);
          line(x+7,y+7,x+23,y+23);
          line(x+7,y+23,x+23,y+7);
          strokeWeight(1);
        }
        
        switch(parseInt(myLabel)) {
          case(1):
            fill(0,0,255);
            break;
          case(2):
            fill(3, 156, 44);
            break;
          case(3):
            fill(219, 51, 18);
            break;
          case(4):
            fill(139, 7, 240);
            break;
          case(5):
            fill(245, 221, 10);
            break;
          case(6):
            fill(245, 139, 10);
            break;
          case(7):
            fill(247, 0, 223);
            break;
          case(8):
            fill(0, 247, 193);
            break;
        }
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
