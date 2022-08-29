
void clock_config(void){
	/*************>>>>>>> STEPS FOLLOWED <<<<<<<<************
	
	1. ENABLE HSI and wait for the HSI to become Ready
	2. Set the POWER ENABLE CLOCK and VOLTAGE REGULATOR <- Wtf does this do?
	3. Configure the FLASH PREFETCH and the LATENCY Related Settings
	4. Configure the PRESCALARS HCLK, PCLK1, PCLK2
	5. Configure the MAIN PLL
	6. Enable the PLL and wait for it to become ready
	7. Select the Clock Source and wait for it to be set
	
	********************************************************/
	
	// Diable all cache so that we can reset them.  Reset instruction and data caches -- enable Data, Instruction and Prefetch Cache -- Set flash latency delays -- 3 wait states based on 100Mhz
	FLASH -> ACR &= ~(FLASH_ACR_PRFTEN | FLASH_ACR_ICEN | FLASH_ACR_DCEN);
	
	FLASH -> ACR &= (FLASH_ACR_ICRST);
	FLASH -> ACR &= (FLASH_ACR_DCRST);
	
	FLASH -> ACR |= (FLASH_ACR_PRFTEN | FLASH_ACR_ICEN | FLASH_ACR_DCEN);
	
	FLASH -> ACR |= (FLASH_ACR_LATENCY | FLASH_ACR_LATENCY_3WS);
	
	
	//Turn on HSI and wait until it's ready
	//RCC -> CR |= RCC_CR_HSION;
	//while (!(RCC -> CR && RCC_CR_HSIRDY));
	
	
	RCC -> CFGR &= (0x00000000);
	RCC -> CFGR |= (0x00 | RCC_CFGR_HPRE_Pos);
	
	RCC -> CFGR |= (RCC_CFGR_PPRE1_2) | (
	
	//reset PLLCFGR with this magic value from the RM0401 doc
	RCC -> PLLCFGR = (0x7F003010);
	
	RCC -> PLLCFGR |=  (PLL_M << 0) | (PLL_N << 6) | (PLL_P << 16) | (RCC_PLLCFGR_PLLSRC_HSI);
	
	
	//Turn on PLL and wait until it's ready PLL
	RCC -> CR |= RCC_CR_PLLON;
	while (!(RCC-> CR && RCC_CR_PLLRDY));
	
	//Configure PLL 
	
	
}