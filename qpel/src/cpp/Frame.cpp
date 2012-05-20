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

//file functions
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

    for (i = 0; i < height; i += 2) {
        for (j = 0; j < width; j += 2) {
            c = (unsigned char) fgetc(file);
            set_cb(i, j, c);
            set_cb(i, j + 1, c);
            set_cb(i + 1, j, c);
            set_cb(i + 1, j + 1, c);
        }
    }

    for (i = 0; i < height; i += 2) {
        for (j = 0; j < width; j += 2) {
            c = (unsigned char) fgetc(file);
            set_cr(i, j, c);
            set_cr(i, j + 1, c);
            set_cr(i + 1, j, c);
            set_cr(i + 1, j + 1, c);
        }
    }
}


//interpolation functions
void Frame::hp_interpolation() {
    int i;
    int j;

    double_frame();

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            if (i % 2 != 0 && j % 2 == 0) {
                set_luma(i, j, hp_filter(i, j, 1));
            }
            else if (i % 2 == 0 && j % 2 != 0) {
                set_luma(i, j, hp_filter(i, j, 0));
            }
        }
    }

    for (i = 0; i < height; i += 2) {
        for (j = 0; j < width; j += 2) {
            set_luma(i, j, hp_filter(i, j, 2));
        }
    }
}


//pixel functions
void Frame::set_red(int i, int j, unsigned char red) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].red = red; 
}

void Frame::set_green(int i, int j, unsigned char green) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].green = green;
}

void Frame::set_blue(int i, int j, unsigned char blue) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].blue = blue;
}

void Frame::set_luma(int i, int j, unsigned char luma) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].red = luma;
}

void Frame::set_cb(int i, int j, unsigned char cb) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].green = cb;
}

void Frame::set_cr(int i, int j, unsigned char cr) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    pixels[i][j].blue = cr;
}

unsigned char Frame::get_red(int i, int j) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    return pixels[i][j].red;
}

unsigned char Frame::get_green(int i, int j) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    return pixels[i][j].green;
}

unsigned char Frame::get_blue(int i, int j) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    return pixels[i][j].blue;
}

unsigned char Frame::get_luma(int i, int j) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    return pixels[i][j].red;
}

unsigned char Frame::get_cb(int i, int j) {
    if (i < 0)
        i = 0;
        else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

    return pixels[i][j].green;
}

unsigned char Frame::get_cr(int i, int j) {
    if (i < 0)
        i = 0;
    else if (i >= height)
        i = height - 1;

    if (j < 0)
        j = 0;
    else if (j >= width)
        j = width - 1;

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

void Frame::save_as_bintxt(char* filename) {
    FILE* file;
    int i;
    int j;
    int k;
    unsigned char c;

    file = fopen(filename, "w");

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            c = get_luma(i, j);

            for (k = 7; k >= 0; --k) {
                if (c & (1 << k))
                    fprintf(file, "1");
                else
                    fprintf(file, "0");
            }

            fprintf(file, "\n");
        }
    }

    fclose(file);            
}

//aux methods
void Frame::double_frame() {
    int i;
    int j;
    int k;
    int l;
    Pixel** tmp;

    tmp = new Pixel*[height * 2 + 1];

    for (i = 0; i < height * 2 + 1; ++i) {
        tmp[i] = new Pixel[width * 2 + 1];
    }

    for (i = 0; i < height * 2 + 1; ++i) {
        k = i / 2;
        l = 0;

        for (j = 0; j < width * 2 + 1; ++j) {
            if (i % 2 != 0 && j % 2 != 0) {
                tmp[i][j].red = get_luma(k, l);
                l = l + 1;
            }
            else {
                tmp[i][j].red = 0;
            }
        }
    }

    for (i = 0; i < height; ++i) {
        delete[] pixels[i];
    }

    delete[] pixels;

    pixels = tmp;
    width  = width * 2 + 1;
    height = height * 2 + 1;
}

unsigned char Frame::clip(int v) {
    if (v < 0)
        v = 0;
    else if (v > 255)
        v = 255;
    
    return (unsigned char) v;
}

unsigned char Frame::hp_filter(int i, int j, int option) {
    int A, B, C, D, E, F;
    int res;

    /* vertical & diagonal */
    if (option == 0 || option == 2) {
        A = get_luma(i - 5, j);
        B = get_luma(i - 3, j);
        C = get_luma(i - 1, j);
        D = get_luma(i + 1, j);
        E = get_luma(i + 3, j);
        F = get_luma(i + 5, j);
    }
    else { /* horizontal */
        A = get_luma(i, j - 5);
        B = get_luma(i, j - 3);
        C = get_luma(i, j - 1);
        D = get_luma(i, j + 1);
        E = get_luma(i, j + 3);
        F = get_luma(i, j + 5);
    }

    res = A - 5 * B + 20 * C + 20 * D - 5 * E + F;

//    if (option != 2)
        return clip((res + 16) >> 5);
//    else
  //      return clip((res + 512) >> 10);
}

unsigned char Frame::qp_filter(int i, int j, int option) {
    int tmp;

    if (option == 0) {
        tmp =  get_luma(i - 1, j);
        tmp += get_luma(i + 1, j); 
    }
    else if (option == 1) {
        tmp =  get_luma(i, j - 1);
        tmp += get_luma(i, j + 1);
    }
    else if (option == 3) {
        tmp =  get_luma(i - 1, j + 1);
        tmp += get_luma(i + 1, j - 1);
    }
    else if (option == 4) {
        tmp =  get_luma(i - 1, j - 1);
        tmp += get_luma(i + 1, j + 1);
    }

    return (char) ((tmp + 1) >> 1);

}

