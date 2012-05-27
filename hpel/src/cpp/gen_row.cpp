#include <iostream>
#include <cstdio>

int main() {
    int i;
    int k = 0;

    for (i = 0; i < 72; i += 8) {
        printf("    hp_filter%i : hp_filter\n", k);
        printf("    port map (\n");
        printf("        a => lineA_i(%i downto %i),\n", i + 7 + 40, i + 40);
        printf("        b => lineA_i(%i downto %i),\n", i + 7 + 32, i + 32);
        printf("        c => lineA_i(%i downto %i),\n", i + 7 + 24, i + 24);
        printf("        d => lineA_i(%i downto %i),\n", i + 7 + 16, i + 16);
        printf("        e => lineA_i(%i downto %i),\n", i + 7 + 8, i + 8);
        printf("        f => lineA_i(%i downto %i),\n", i + 7, i);
        printf("        s => dout_o(%i downto %i)\n", i + 7, i);
        printf("    );\n\n");

        ++k;
    }

    return 0;
}
