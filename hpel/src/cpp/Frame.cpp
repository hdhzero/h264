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

void Frame::qp_interpolation() {
    int i, j;
    int option;

    option = 4;
    double_frame();

    for (i = 0; i < height; ++i) {
        for (j = 0; j < width; ++j) {
            if (i % 2 == 0 && j % 2 != 0)
                set_luma(i, j, qp_filter(i, j, 0));
            else if (i % 2 != 0 && j % 2 == 0)
                set_luma(i, j, qp_filter(i, j, 1));
        }
    }

    for (i = 0; i < height; i += 2) {
        for (j = 0; j < width; j += 2) {
            if (i % 2 == 0 && j % 2 == 0) {
                option = option == 4 ? 3 : 4;
                set_luma(i, j, qp_filter(i, j, option));
            }
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

void Frame::save_macroblock_as_PPM(int i0, int j0, int i1, int j1, char* filename) {
    FILE* file;
    int i;
    int j;
    unsigned char c;

    file = fopen(filename, "w");
    fprintf(file, "P3\n%i %i\n255\n", j1 - j0, i1 - i0);

    for (i = i0; i < i1; ++i) {
        for (j = j0; j < j1; ++j) {
            c = get_luma(i, j);
            fprintf(file, "%i %i %i\n", c, c, c);
        }
    }

    fclose(file);
}

//test functions
void Frame::gen_test(int i0, int j0) {
    int i;
    int j;
    int k;
    int i1;
    int j1;
    int i2;
    int j2;
    unsigned char c;
    bool flag;

    FILE* file_bin;
    FILE* file_hex;

    FILE* hp_bin     = fopen("hp_bin.txt", "w");
    FILE* hp_hex     = fopen("hp_hex.txt", "w");
    FILE* qp_bin     = fopen("qp_bin.txt", "w");
    FILE* qp_hex     = fopen("qp_hex.txt", "w");
    FILE* hp_rowHEX  = fopen("hp_rowHEX.txt", "w");
    FILE* hp_colHEX  = fopen("hp_colHEX.txt", "w");
    FILE* hp_diagHEX = fopen("hp_diagHEX.txt", "w");
    FILE* hp_rowBIN  = fopen("hp_rowBIN.txt", "w");
    FILE* hp_colBIN  = fopen("hp_colBIN.txt", "w");
    FILE* hp_diagBIN = fopen("hp_diagBIN.txt", "w");

    flag = hp_bin == NULL;
    flag = flag || hp_hex == NULL;
    flag = flag || qp_bin == NULL;
    flag = flag || qp_hex == NULL;
    flag = flag || hp_rowHEX == NULL;
    flag = flag || hp_colHEX == NULL;
    flag = flag || hp_diagHEX == NULL;
    flag = flag || hp_rowBIN == NULL;
    flag = flag || hp_colBIN == NULL;
    flag = flag || hp_diagBIN == NULL;

    if (flag) {
        printf("Erro ao abrir os arquivos para escrita\n");
        return;
    }

    for (i = i0; i < i0 + 14; ++i) {
        for (j = j0; j < j0 + 14; ++j) {
            c = get_luma(i, j);

            for (k = 7; k >= 0; --k) {
                if (c & (1 << k)) {
                    fprintf(hp_bin, "1");
                }
                else {
                    fprintf(hp_bin, "0");
                }
            }

            if (c < 10) {
                fprintf(hp_hex, "0%X", (unsigned int) c);
            }
            else {
                fprintf(hp_hex, "%X", (unsigned int) c);
            }
        }

        fprintf(hp_bin, "\n");
        fprintf(hp_hex, "\n");
    }

    hp_interpolation();
    i1 = (i0 + 2) * 2 + 1;
    j1 = (j0 + 2) * 2 + 1;
    i2 = (i0 + 11) * 2 + 1;
    j2 = (j0 + 11) * 2 + 1;

    for (i = i1; i <= i2; ++i) {
        for (j = j1; j <= j2; ++j) {
            c = get_luma(i, j);

            if (i % 2 == 0 && j % 2 == 0) {
                file_hex = hp_diagHEX;
                file_bin = hp_diagBIN;
            }
            else if (i % 2 != 0 && j % 2 == 0) {
                file_hex = hp_rowHEX;
                file_bin = hp_rowBIN;
            }
            else if (i % 2 == 0 && j % 2 != 0) {
                file_hex = hp_colHEX;
                file_bin = hp_colBIN;
            }
            else {
                file_hex = NULL;
                file_bin = NULL;
            }

            for (k = 7; file_bin != NULL && k >= 0; --k) {
                if (c & (1 << k))
                    fprintf(file_bin, "1");
                else
                    fprintf(file_bin, "0");
            }
            
            if (file_hex != NULL) {
                if (c < 10)
                    fprintf(file_hex, "0%X", (unsigned int) c);
                else
                    fprintf(file_hex, "%X", (unsigned int) c);
            }

            for (k = 7; k >= 0; --k) {
                if (c & (1 << k))
                    fprintf(qp_bin, "1");
                else
                    fprintf(qp_bin, "0");
            }
            
            if (c < 10)
                fprintf(qp_hex, "0%X", (unsigned int) c);
            else
                fprintf(qp_hex, "%X", (unsigned int) c);
        }

        fprintf(qp_bin, "\n");
        fprintf(qp_hex, "\n");

        if (i % 2 == 0) {
            fprintf(hp_colHEX, "\n");
            fprintf(hp_diagHEX, "\n");
            fprintf(hp_colBIN, "\n");
            fprintf(hp_diagBIN, "\n");
        }
        else {
            fprintf(hp_rowHEX, "\n");
            fprintf(hp_rowBIN, "\n");
        }
    }

    fclose(hp_bin);
    fclose(hp_hex);
    fclose(qp_bin);
    fclose(qp_hex);
    fclose(hp_rowHEX);
    fclose(hp_colHEX);
    fclose(hp_diagHEX);
    fclose(hp_rowBIN);
    fclose(hp_colBIN);
    fclose(hp_diagBIN);
}


void Frame::save_as_byte_txt(char* filename) {
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

void Frame::save_as_line_txt(char* filename) {
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
        }

        fprintf(file, "\n");
    }
}

void Frame::save_rcd(int i0, int j0, int i1, int j1) {
    FILE* row;
    FILE* col;
    FILE* diag;
    FILE* file = NULL;
    int i;
    int j;
    int k;
    unsigned char c;

    row  = fopen("row.txt", "w");
    col  = fopen("col.txt", "w");
    diag = fopen("diag.txt", "w");
    

    for (i = i0; i < i1; ++i) {
        for (j = j0; j < j1; ++j) {
            c = get_luma(i, j);
            file = NULL;

            if (i % 2 == 0 && j % 2 == 0) {
                file = diag; 
            }
            else if (i % 2 == 0 && j % 2 != 0) {
                file = col;
            }
            else if (i % 2 != 0 && j % 2 == 0) {
                file = row;
            }

            for (k = 7; file != NULL && k >= 0; --k) {
                if (c & (1 << k))
                    fprintf(file, "1");
                else
                    fprintf(file, "0");
            }
        }

        if (i % 2 == 0) {
            fprintf(diag, "\n");
            fprintf(col, "\n");
        }
        else {
            fprintf(row, "\n");
        }
    }

    fclose(row);
    fclose(col);
    fclose(diag);
}

void Frame::save_rcdHEX(int i0, int j0, int i1, int j1) {
    FILE* row;
    FILE* col;
    FILE* diag;
    FILE* file = NULL;
    int i;
    int j;
    int k;
    unsigned char c;

    row  = fopen("rowHEX.txt", "w");
    col  = fopen("colHEX.txt", "w");
    diag = fopen("diagHEX.txt", "w");
    

    for (i = i0; i < i1; ++i) {
        for (j = j0; j < j1; ++j) {
            c = get_luma(i, j);
            file = NULL;

            if (i % 2 == 0 && j % 2 == 0) {
                file = diag; 
            }
            else if (i % 2 == 0 && j % 2 != 0) {
                file = col;
            }
            else if (i % 2 != 0 && j % 2 == 0) {
                file = row;
            }

            if (file != NULL) {
                if (c < 10 ) {
                    fprintf(file, "0%X", (unsigned int) c);
                }
                else {
                    fprintf(file, "%X", (unsigned int) c);
                }
            }
        }

        if (i % 2 == 0) {
            fprintf(diag, "\n");
            fprintf(col, "\n");
        }
        else {
            fprintf(row, "\n");
        }
    }

    fclose(row);
    fclose(col);
    fclose(diag);
}

void Frame::save_macroblock(int i0, int j0, int i1, int j1, char* filename) {
    FILE* file;
    int i;
    int j;
    int k;
    unsigned char c;

    file = fopen(filename, "w");

    for (i = i0; i < i1; ++i) {
        for (j = j0; j < j1; ++j) {
            c = get_luma(i, j);

            for (k = 7; k >= 0; --k) {
                if (c & (1 << k))
                    fprintf(file, "1");
                else
                    fprintf(file, "0");
            }
        }

        fprintf(file, "\n");
    }

}

void Frame::save_macroblockHEX(int i0, int j0, int i1, int j1, char* filename) {
    FILE* file;
    int i;
    int j;
    int k;
    unsigned char c;

    file = fopen(filename, "w");

    for (i = i0; i < i1; ++i) {
        for (j = j0; j < j1; ++j) {
            c = get_luma(i, j);

            if (c < 10)
                fprintf(file, "0%X", (unsigned int) c);
            else
                fprintf(file, "%X", (unsigned int) c);
            
        }

        fprintf(file, "\n");
    }
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

