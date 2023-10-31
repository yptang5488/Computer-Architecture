#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

typedef uint64_t ticks;
static inline ticks getticks(void)
{
    uint64_t result;
    uint32_t l, h, h2;
    asm volatile(
        "rdcycleh %0\n"
        "rdcycle %1\n"
        "rdcycleh %2\n"
        "sub %0, %0, %2\n"
        "seqz %0, %0\n"
        "sub %0, zero, %0\n"
        "and %1, %1, %0\n"
        : "=r"(h), "=r"(l), "=r"(h2));
    result = (((uint64_t) h) << 32) | ((uint64_t) l);
    return result;
}

uint32_t count_leading_zeros(uint32_t x){
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x7f));
}

void bit_plane_slicing(int caseNum, int size, uint32_t img[]){   
    int32_t max = -1;

    for (int i = 0; i < size; i++){
        int32_t LZ = (int32_t)count_leading_zeros(img[i]);
        int32_t MSB = 32 - LZ - 1;

        img[i] = MSB;

        if(MSB > max){
            max = MSB;
        }
    }

    printf("Test %d: ", caseNum);
    for (int i = 0; i < size; i++){
        if(img[i] == max){
            img[i] = 255;
        }else{
            img[i] = 0;
        }
        printf("%lu ", img[i]);
    }
    printf("\n");
}

int main()
{
    uint32_t test0[4] = {255, 0, 128, 1};
    uint32_t test1[9] = {167, 133, 111, 144, 140, 135, 159, 154, 148};
    uint32_t test2[6] = {50, 100, 150, 200, 250, 255};

    ticks t0 = getticks();
    bit_plane_slicing(0, 4, test0);
    bit_plane_slicing(1, 9, test1);
    bit_plane_slicing(2, 6, test2);
    ticks t1 = getticks();
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);

    return 0;
}