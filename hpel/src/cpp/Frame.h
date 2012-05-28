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
        void qp_interpolation();

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
        void save_macroblock_as_PPM(int i0, int j0, int i1, int j1, char* filename);

        //test functions
        void gen_test(int i0, int j0);

        //binary files
        void save_as_byte_txt(char* filename);
        void save_as_line_txt(char* filename);
        void save_rcd(int i0, int j0, int i1, int j1);
        void save_rcdHEX(int i0, int j0, int i1, int j1); 
        void save_macroblock(int i0, int j0, int i1, int j1, char* filename);
        void save_macroblockHEX(int i0, int j0, int i1, int j1, char* filename);


    //aux methods
    private:
        void double_frame();
        unsigned char clip(int v);
        unsigned char hp_filter(int i, int j, int option);
        unsigned char qp_filter(int i, int j, int option);
        


};

#endif
