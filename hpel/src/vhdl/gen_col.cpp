#include <iostream>
#include <cstdio>

int main() {
    int i;
    int k = 0;

    for (i = 0; i < 112; i += 8) {
        printf("    hp_filter%i : hp_filter\n", k);
        printf("    port map (\n");
        printf("        a => lineA_i(%i downto %i),\n", i + 7, i);
        printf("        b => lineB_i(%i downto %i),\n", i + 7, i);
        printf("        c => lineC_i(%i downto %i),\n", i + 7, i);
        printf("        d => lineD_i(%i downto %i),\n", i + 7, i);
        printf("        e => lineE_i(%i downto %i),\n", i + 7, i);
        printf("        f => lineF_i(%i downto %i)\n", i + 7, i);
        printf("    );\n\n");

        ++k;
    }

    return 0;
}
