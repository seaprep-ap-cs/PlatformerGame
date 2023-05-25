public class AnimatedSprite extends Sprite {
    private PImage[] currentImages;
    private PImage[] standNeutral;
    private PImage[] moveLeft;
    private PImage[] moveRight;
    private int direction;
    private int index;
    private int frame;

    public AnimatedSprite(PImage img, float scale) {
        super(img, scale);
        this.direction = NEUTRAL_FACING;
        this.index = 0;
        this.frame = 0;
    }

    public AnimatedSprite(PImage img, float scale, PImage[] standNeutral) {
        super(img, scale);
        this.standNeutral = standNeutral;
        this.currentImages = this.standNeutral;
        this.index = 0;
        this.frame = 0;
    }

    public AnimatedSprite(PImage img, float scale, PImage[] moveLeft, PImage[] moveRight, int direction) {
        super(img, scale);
        this.moveLeft = moveLeft;
        this.moveRight = moveRight;
        this.direction = direction;
        this.index = 0;
        this.frame = 0;
    }

    //public AnimatedSprite(PImage img, float scale, int direction) {
    //   super(img, scale);
    //   this.moveLeft = moveLeft;
    //   this.moveRight = moveRight;
    //   this.direction = direction;
    //   this.index = 0;
    //   this.frame = 0;
    //}

    public void updateAnimation() {
        this.frame++;
        if (this.frame % 5 == 0) {
            selectDirection();
            selectCurrentImages();
            advanceToNextImage();
        }
    }

    public void selectDirection() {
        if (this.getChangeX() > 0) {
            this.direction = RIGHT_FACING;
        } else if (this.getChangeX() < 0) {
            this.direction = LEFT_FACING;
        } else {
            this.direction = NEUTRAL_FACING;
        }
    }

    public void selectCurrentImages() {
        if (this.direction == RIGHT_FACING) {
            this.currentImages = moveRight;
        } else if (direction == LEFT_FACING) {
            this.currentImages = moveLeft;
        } else {
            this.currentImages = standNeutral;
        }
    }

    public void advanceToNextImage() {
        this.index++;
        if (this.index == currentImages.length) {
            this.index = 0;
        }

        // TODO: fix bud on Out of Bounds error
        if (this.index > this.currentImages.length) {
            this.index = 0;
        }
        setImage(this.currentImages[this.index]);
    }

    public int getDirection() {
        return this.direction;
    }

    public void setDirection(int direction) {
        this.direction = direction;
    }

    public void setCurrentImages(PImage[] imgs) {
        this.currentImages = imgs;
    }

    public PImage[] getMoveRight() {
        return this.moveRight;
    }

    public PImage[] getMoveLeft() {
        return this.moveLeft;
    }
}