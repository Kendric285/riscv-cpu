#include <cstdio>

/*
Basic performance equation in terms of instruction count
I - instrution count
CPI - Average clock cycles per instruction
frequency - clock frequency
*/ 

int performance(int I, int CPI, int frequency){
    int period = (1 / frequency);
    return I * CPI * (1 / period);
}