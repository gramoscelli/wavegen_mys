#include "wavegen.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_io.h"

int main () 
{

   print("---Entering main---\n\r");
   // Dirección 0: divisor de frecuencia (1 = divide por 2. 2 = divide por 3, etc)
   WAVEGEN_mWriteReg (XPAR_WAVEGEN_0_S00_AXI_BASEADDR, 1, 1);
   // Dirección 1: amplitud en el rango 0..32767
   WAVEGEN_mWriteReg (XPAR_WAVEGEN_0_S00_AXI_BASEADDR, 1, 10000);
   print("---Exiting main---\n\r");
   return 0;
}
