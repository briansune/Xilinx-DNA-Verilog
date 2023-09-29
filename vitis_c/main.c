#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"

#define DNA_ID_L		XPAR_DNA_IP_0_BASEADDR + 0
#define DNA_ID_H		XPAR_DNA_IP_0_BASEADDR + 4
#define DNA_ID_RDY		XPAR_DNA_IP_0_BASEADDR + 8


void usleep(unsigned long useconds){
	usleep_A9(useconds);
}

int main(){

	uint32_t dl, dh, drdy;
	long long d64;

    init_platform();

    dl = Xil_In32(DNA_ID_L);
    dh = Xil_In32(DNA_ID_H);
    drdy = Xil_In32(DNA_ID_RDY);

    d64 = dh;
    d64 = (d64<<32) | dl;

    printf("DNA ID Low: %llX\n\r", d64);
    printf("DNA ID Ready: %lX\n\r", drdy);

    cleanup_platform();

    return 0;
}


