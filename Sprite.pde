public class Sprite {
    protected float changeX;
    private PImage image;
    private final float wwidth;
    private final float hheight;
    private float centerX;
    private float centerY;
    private float changeY;

    // six-argument constructor
    public Sprite(String filename, float scale, float centerX, float centerY) {
        this.image = loadImage(filename);
        this.wwidth = this.image.width * scale;
        this.hheight = this.image.height * scale;
        this.centerX = centerX;
        this.centerY = centerY;
        this.changeX = 0;
        this.changeY = 0;
    }

    // two-argument constructor
    public Sprite(String filename, float scale) {
        // calls the constructor above
        // same as doing Sprite(filename, scale, 0, 0)
        this(filename, scale, 0, 0);
    }

    public Sprite(PImage img, float scale) {
        this.image = img;
        this.wwidth = this.image.width * scale;
        this.hheight = this.image.height * scale;
        this.centerX = 0;
        this.centerY = 0;
        this.changeX = 0;
        this.changeY = 0;
    }

    public void display() {
        image(this.image, this.centerX, this.centerY, this.wwidth, this.hheight);
    }


    // accessor and mutator methods
    public void setImage(PImage img) {
        this.image = img;
    }

    public float getLeft() {
        return this.centerX - this.wwidth / 2;
    }

    public void setLeft(float left) {
        this.centerX = left + this.wwidth / 2;
    }

    public float getRight() {
        return this.centerX + this.wwidth / 2;
    }

    public void setRight(float right) {
        this.centerX = right - this.wwidth / 2;
    }

    public float getTop() {
        return this.centerY - this.hheight / 2;
    }

    public void setTop(float top) {
        this.centerY = top + this.hheight / 2;
    }

    public float getBottom() {
        return this.centerY + this.hheight / 2;
    }

    public void setBottom(float bottom) {
        this.centerY = bottom - this.hheight / 2;
    }

    public void update() {
        this.centerX += this.changeX; // move horizontally
        this.centerY += this.changeY; // move vertically
    }

    public void setCenterX(float centerX) {
        this.centerX = centerX;
    }

    public void incrementCenterX() {
        this.centerX += this.changeX;
    }

    public void setCenterY(float centerY) {
        this.centerY = centerY;
    }

    public void incrementCenterY(float y) {
        this.centerY += y;
    }

    public void decrementCenterY(float y) {
        this.centerY -= y;
    }

    public void incrementCenterY() {
        this.centerY += this.changeY;
    }

    public void incrementChangeX(float changeX) {
        this.changeX += changeX;
    }

    public void incrementChangeY(float changeY) {
        this.changeY += changeY;
    }

    public float getChangeY() {
        return this.changeY;
    }

    public void setChangeY(float changeY) {
        this.changeY = changeY;
    }

    public float getChangeX() {
        return this.changeX;
    }

    public void setChangeX(float changeX) {
        this.changeX = changeX;
    }
}