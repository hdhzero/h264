#ifndef FRAME_H
#define FRAME_H

#include <cstdio>

typedef struct Pixel {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Pixel;

class Frame {
    private:
        int width;
        int height;
        Pixel** pixels;

    public:
        Frame(int w = 640, int h = 480);
        ~Frame();
        void set_from_yuv420_file(FILE* file);

        //pixel functions
        void set_red(int i, int j, unsigned char red);
        void set_green(int i, int j, unsigned char green);
        void set_blue(int i, int j, unsigned char blue);

        void set_luma(int i, int j, unsigned char luma);
        void set_cb(int i, int j, unsigned char cb);
        void set_cr(int i, int j, unsigned char cr);
};

#endif
