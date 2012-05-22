#include "Frame.h"

#include <cstdio>

int main() {
    FILE* file = fopen("akiyo_qcif.yuv", "rb");

    if (file == NULL) { printf("erro\n"); return -1; }

    Frame f(176, 144);
    printf("1\n");
    f.set_from_yuv420_file(file);

    f.save_yuv420_as_PPM("pel.ppm");

    f.hp_interpolation();
    f.save_yuv420_as_PPM("hp.ppm");

    f.qp_interpolation();
    f.save_yuv420_as_PPM("qp.ppm");

    return 0;
}
