#include "Frame.h"

Frame::Frame(int w = 640, int h = 480) {
    width  = w;
    height = h;

    pixels = new int*[height];

    for (int i = 0; i < height; ++i) {
        pixels[i] = new int[width];
    }
}

Frame::~Frame() {
    for (int i = 0; i < height; ++i) {
        delete[] pixels[i];
    }

    delete[] pixels;
}


