#include "Frame.h"

#include <cstdio>

int main() {
    FILE* file = fopen("akiyo_qcif.yuv", "rb");

    if (file == NULL) { printf("erro\n"); return -1; }

    Frame f(176, 144);
    printf("1\n");
    f.set_from_yuv420_file(file);

    f.hp_interpolation();
    f.save_macroblock_as_PPM(0, 0, 19, 19, "line.ppm");
    f.save_macroblock(2, 2, 21, 21, "hp.vidtxt");

    f.qp_interpolation();
    f.save_rcd(6, 6, 41, 41);
    f.save_rcdHEX(6, 6, 41, 41);
    f.save_macroblock(6, 6, 41, 41, "qp.vidtxt");

    return 0;
}
