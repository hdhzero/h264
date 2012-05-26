#include "Frame.h"

#include <cstdio>

int main() {
    int i = 68;
    int j = 80;
    FILE* file = fopen("carphone_qcif.yuv", "rb");

    if (file == NULL) { printf("erro\n"); return -1; }

    Frame f(176, 144);
    f.set_from_yuv420_file(file);
    f.save_macroblock_as_PPM(i, j, i + 14, j + 14, "line.ppm");

    f.hp_interpolation();
    f.save_rcdHEX((i + 2) * 2 + 2, (j + 2) * 2 + 2, (i + 11) * 2 + 1, (j + 11) * 2 + 1);
    f.save_macroblock_as_PPM((i + 2) * 2 + 1, (j + 2) * 2 + 1, (i + 11) * 2 + 2, (j + 11) * 2 + 2, "eae.ppm");

//    f.save_macroblock_as_PPM(20, 20, 120, 120, "line.ppm"); 
//    f.hp_interpolation();
//    f.save_macroblock_as_PPM(0, 0, 19, 19, "line.ppm");
//    f.save_macroblock(2, 2, 21, 21, "hp.vidtxt");

//    f.qp_interpolation();
//    f.save_rcd(6, 6, 41, 41);
//    f.save_rcdHEX(6, 6, 41, 41);
//    f.save_macroblock(6, 6, 41, 41, "qp.vidtxt");

    return 0;
}
