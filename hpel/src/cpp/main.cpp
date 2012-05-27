#include "Frame.h"

#include <cstdio>

int main() {
    int i = 68;
    int j = 80;
    FILE* file = fopen("akiyo_qcif.yuv", "rb");

    if (file == NULL) { printf("erro\n"); return -1; }

    Frame f(176, 144);
    f.set_from_yuv420_file(file);
    f.gen_hp_macroblock_test(50, 50);

    return 0;
}
