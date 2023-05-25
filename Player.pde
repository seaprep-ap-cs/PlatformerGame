public class Player extends AnimatedSprite {
    private int lives;
    private boolean onPlatform;
    private boolean inPlace;
    private final PImage[] standLeft;
    private final PImage[] standRight;

    public Player(PImage img, float scale, int lives, int direction, boolean onPlatform, boolean inPlace, PImage[] standLeft, PImage[] standRight, PImage[] walkLeft, PImage[] walkRight) {
        super(img, scale, walkLeft, walkRight, direction);
        this.lives = lives;
        this.onPlatform = onPlatform;
        this.inPlace = inPlace;
        this.standLeft = standLeft;
        this.standRight = standRight;
    }

    @Override
    public void updateAnimation() {
        // isOnPlatforms is a global method
        this.onPlatform = isOnPlatforms(this, platforms);
        this.inPlace = (getChangeX() == 0 && getChangeY() == 0);
        super.updateAnimation();
    }

    @Override
    public void selectDirection() {
        if (getChangeX() > 0) {
            setDirection(RIGHT_FACING);
        } else if (getChangeX() < 0) {
            setDirection(LEFT_FACING);
        }
    }

    @Override
    public void selectCurrentImages() {
        if (getDirection() == RIGHT_FACING) {
            if (this.inPlace) {
                this.setCurrentImages(this.standRight);
            } else if (!this.onPlatform) {
                this.setCurrentImages(getMoveRight());
            } else {
                this.setCurrentImages(getMoveRight());
            }
        } else if (getDirection() == LEFT_FACING) {
            if (this.inPlace) {
                this.setCurrentImages(this.standLeft);
            } else if (!this.onPlatform) {
                this.setCurrentImages(this.getMoveLeft());
            } else {
                this.setCurrentImages(getMoveLeft());
            }
        }
    }

    public int getLives() {
        return this.lives;
    }

    public void setLives(int lives) {
        this.lives = lives;
    }

    public void decrementLives() {
        this.lives--;
    }

}