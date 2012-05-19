#include "Frame.h"

Frame::Frame(int w, int h) {
    width  = w;
    height = h;

    pixels = new Pixel*[height];

    for (int i = 0; i < height; ++i) {
        pixels[i] = new Pixel[width];
    }
}

Frame::~Frame() {
    for (int i = 0; i < height; ++i) {
        delete[] pixels[i];
    }

    delete[] pixels;
}

void Frame::set_from_yuv420_file(FILE* file) {
    int i;
    int j;
    unsigned char c;

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            c = (unsigned char) fgetc(file);
            set_luma(i, j, c);
        }
    }

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            c = (unsigned char) fgetc(file);
            set_cb(i, j, c);
            set_cb(i, j + 1, c);
            set_cb(i + 1, j, c);
            set_cb(i + 1, j + 1, c);
        }
    }

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            c = (unsigned char) fgetc(file);
            set_cr(i, j, c);
            set_cr(i, j + 1, c);
            set_cr(i + 1, j, c);
            set_cr(i + 1, j + 1, c);
        }
    }
}

void Frame::set_red(int i, int j, unsigned char red) {
    pixels[i][j].red = red; 
}

void Frame::set_green(int i, int j, unsigned char green) {
    pixels[i][j].green = green;
}

void Frame::set_blue(int i, int j, unsigned char blue) {
    pixels[i][j].blue = blue;
}

void Frame::set_luma(int i, int j, unsigned char luma) {
    pixels[i][j].red = luma;
}

void Frame::set_cb(int i, int j, unsigned char cb) {
    pixels[i][j].green = cb;
}

void Frame::set_cr(int i, int j, unsigned char cr) {
    pixels[i][j].blue = cr;
}

unsigned char Frame::get_red(int i, int j) {
    return pixels[i][j].red;
}

unsigned char Frame::get_green(int i, int j) {
    return pixels[i][j].green;
}

unsigned char Frame::get_blue(int i, int j) {
    return pixels[i][j].blue;
}

unsigned char Frame::get_luma(int i, int j) {
    return pixels[i][j].red;
}

unsigned char Frame::get_cb(int i, int j) {
    return pixels[i][j].green;
}

unsigned char Frame::get_cr(int i, int j) {
    return pixels[i][j].blue;
}

//PPM functions
void Frame::save_yuv420_as_PPM(char* filename) {
    FILE* file;
    int i;
    int j;
    unsigned char c;

    file = fopen(filename, "w");
    fprintf(file, "P3\n%i %i\n255\n", width, height);

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            c = get_luma(i, j);
            fprintf(file, "%i %i %i\n", c, c, c);
        }
    }

    fclose(file);
}
