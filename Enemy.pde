public class Enemy extends AnimatedSprite {
    private final float bLeft;
    private final float bRight;

    public Enemy(PImage img, float scale, float bLeft, float bRight, PImage[] moveLeft, PImage[] moveRight, float changeX) {
        super(img, scale, moveLeft, moveRight, RIGHT_FACING);
        this.bLeft = bLeft;
        this.bRight = bRight;
        this.changeX = changeX;
    }

    public void update() {
        super.update();
        if (getLeft() <= bLeft) {
            setLeft(bLeft);
            this.setChangeX(this.getChangeX() * -1);
        } else if (getRight() >= bRight) {
            setRight(bRight);
            this.setChangeX(this.getChangeX() * -1);
        }
    }
}