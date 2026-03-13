#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int scan_file(const char *filepath, const char **patterns, int pattern_count) {
    FILE *f = fopen(filepath, "rb");
    if (!f) return -1;

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);

    char *buffer = malloc(size);
    if (!buffer) { fclose(f); return -1; }
    fread(buffer, 1, size, f);
    fclose(f);

    int result = 0;
    for (int i = 0; i < pattern_count; i++) {
        long plen = strlen(patterns[i]);
        for (long j = 0; j <= size - plen; j++) {
            if (memcmp(buffer + j, patterns[i], plen) == 0) {
                result |= (1 << i);
                break;
            }
        }
    }

    free(buffer);
    return result;
}
