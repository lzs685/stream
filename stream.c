
/***************************** Include Files *********************************/
#include "xaxidma.h"
#include "xparameters.h"
#include "xdebug.h"



#define DMA_DEV_ID		XPAR_AXIDMA_0_DEVICE_ID




#define MEM_BASE_ADDR		0x01000000

#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#define MAX_PKT_LEN		0x4

#define TEST_START_VALUE	0x61

#define NUMBER_OF_TRANSFERS	10

/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif

int XAxiDma_SimplePollExample(u16 DeviceId);


/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XAxiDma AxiDma;






int main()
{
//int Status;

	xil_printf("\r\n--- Entering main() --- \r\n");

	/* Run the poll example for simple transfer */
	XAxiDma_SimplePollExample(DMA_DEV_ID);

	xil_printf("my test is Passed\r\n");
	xil_printf("--- 2017/12/03 --- \r\n");



return XST_SUCCESS;

}





/*****************************************************************************/
/**
* The example to do the simple transfer through polling. The constant
* NUMBER_OF_TRANSFERS defines how many times a simple transfer is repeated.
*
* @param	DeviceId is the Device Id of the XAxiDma instance
*
* @return
*		- XST_SUCCESS if example finishes successfully
*		- XST_FAILURE if error occurs
*
* @note		None
*
*
******************************************************************************/
int XAxiDma_SimplePollExample(u16 DeviceId)
{

	XAxiDma_Config *CfgPtr;
	int Status;

	int Index;
	u8 *TxBufferPtr;
//	u8 *RxBufferPtr;
	u8 Value;
     int i;

	TxBufferPtr = (u8 *)TX_BUFFER_BASE ;
//	RxBufferPtr = (u8 *)RX_BUFFER_BASE;

	/* Initialize the XAxiDma device.
	 */
	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(&AxiDma)){
		xil_printf("Device configured as SG mode \r\n");
		return XST_FAILURE;
	}

	/* Disable interrupts, we use polling mode
	 */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);

	Value = TEST_START_VALUE;

	for(Index = 0; Index < MAX_PKT_LEN; Index ++) {
			TxBufferPtr[Index] = Value;

			Value = Value + 1 ;
	}

	/* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, MAX_PKT_LEN);
#ifdef __aarch64__
	Xil_DCacheFlushRange((UINTPTR)RxBufferPtr, MAX_PKT_LEN);
#endif

//	for(Index = 0; Index < NUMBER_OF_TRANSFERS; Index ++) {
while(1){
	//	 XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,\
					MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);



	 XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr,\
					MAX_PKT_LEN, XAXIDMA_DMA_TO_DEVICE);



		while (XAxiDma_Busy(&AxiDma,XAXIDMA_DMA_TO_DEVICE)) {}

		for(i = 0; i < MAX_PKT_LEN; i ++)
		{
		xil_printf("value is %x\n", TxBufferPtr[i]);
		xil_printf("address is %x\r\n", TxBufferPtr+i);
		}
		//xil_printf("Index is %d\r\n",Index );
	}


	return XST_SUCCESS;
}

