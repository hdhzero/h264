#include "Frame.h"

#include <cstdio>

int main() {
    FILE* file = fopen("akiyo_qcif.yuv", "rb");

    if (file == NULL) { printf("erro\n"); return -1; }

    Frame f(176, 144);
    printf("1\n");
    f.set_from_yuv420_file(file);
    f.hp_interpolation();
    printf("2\n");

    f.save_yuv420_as_PPM("teste.ppm");
    f.save_as_bintxt("binario.txt");
    return 0;
}
