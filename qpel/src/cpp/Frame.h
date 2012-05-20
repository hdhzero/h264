#ifndef FRAME_H
#define FRAME_H

#include <cstdio>

typedef struct Pixel {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Pixel;

typedef enum PixelType { RGB, YCBCR420 } PixelType;

class Frame {
    private:
        PixelType pixel_type;
        int width;
        int height;
        Pixel** pixels;

    public:
        Frame(int w = 640, int h = 480);
        ~Frame();

        //file functions
        void set_from_yuv420_file(FILE* file);

        //interpolation functions
        void hp_interpolation();

        //pixel functions
        void set_red(int i, int j, unsigned char red);
        void set_green(int i, int j, unsigned char green);
        void set_blue(int i, int j, unsigned char blue);

        void set_luma(int i, int j, unsigned char luma);
        void set_cb(int i, int j, unsigned char cb);
        void set_cr(int i, int j, unsigned char cr);

        unsigned char get_red(int i, int j);
        unsigned char get_green(int i, int j);
        unsigned char get_blue(int i, int j);

        unsigned char get_luma(int i, int j);
        unsigned char get_cb(int i, int j);
        unsigned char get_cr(int i, int j);

        //PPM functions
        void save_yuv420_as_PPM(char* filename);

        //binary files
        void save_as_bintxt(char* filename);


    //aux methods
    private:
        void double_frame();
        unsigned char clip(int v);
        unsigned char hp_filter(int i, int j, int option);
        unsigned char qp_filter(int i, int j, int option);
        


};

#endif
