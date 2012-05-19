#ifndef FRAME_H
#define FRAME_H

class Frame {
    private:
        int width;
        int height;
        int** pixels;

    public:
        Frame(int w = 640, int h = 480);
        ~Frame();
};

#endif
