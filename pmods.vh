/********************************************************************************/
/*                            PMOD OLED RGB                                     */
/********************************************************************************/
`define PMOD_OLED_RGB_CONNECT(con) \
	output con``_1, \
	output con``_2, \
	output con``_4, \
	output con``_7, \
	output con``_8, \
	output con``_9, \
	output con``_10

`define PMOD_OLED_RGB_ATTACH(con, mod) \
wire mod``_cs; \
assign con``_1 = mod``_cs; \
wire mod``_sdout; \
assign con``_2 = mod``_sdout; \
wire mod``_sck; \
assign con``_4 = mod``_sck; \
reg mod``_dc; \
assign con``_7 = mod``_dc; \
reg mod``_res; \
assign con``_8 = mod``_res; \
reg mod``_vccen; \
assign con``_9 = mod``_vccen; \
reg mod``_pmoden; \
assign con``_10 = mod``_pmoden

`define PMOD_OLED_RGB_INST_FROM_TOP(con, mod, reset, clock, freq, busy) \
SSD1331 # ( \
.clk_freq(freq) \
) mod``pmod_oled_rgb_inst( \
	.rst(reset), \
	.clk(clock), \
	.mod_1(con``_1), \
	.mod_2(con``_2), \
	.mod_4(con``_4), \
	.mod_7(con``_7), \
	.mod_8(con``_8), \
	.mod_9(con``_9), \
	.mod_10(con``_10), \
	.init_busy(busy) \
)

/********************************************************************************/
/*                            PMOD MIC3                                         */
/********************************************************************************/
`define PMOD_MIC3_CONNECT(con) \
	output con``_7, \
	input con``_9, \
	output con``_10

`define PMOD_MIC3_ATTACH(con, mod) \
wire mod``_cs; \
assign con``_7 = mod``_cs; \
wire mod``_sdin = con``_9; \
wire mod``_sck; \
assign con``_10 = mod``_sck; \

/********************************************************************************/
/*                            PMOD NAV SPI                                      */
/********************************************************************************/
`define PMOD_NAV_SPI_CONNECT(con) \
	output con``_1, \
	input con``_2, \
	output con``_3, \
	output con``_4, \
	input con``_7, \
	input con``_8, \
	output con``_9, \
	output con``_10

`define PMOD_NAV_SPI_ATTACH(con, mod) \
wire mod``_cs_av; \
assign con``_1 = mod``_cs; \
wire mod``_sdin = con``_2; \
wire mod``_sdo; \
assign con``_3 = mod``_sdo; \
wire mod``_spc; \
assign con``_4 = mod``_spc; \
wire mod``_int = con``_7; \
wire mod``_drdy_m = con``_8; \
wire mod``_cs_m; \
assign con``_9 = mod``_cs_m; \
wire mod``_cs_alt; \
assign con``_10 = mod``_cs_alt

/********************************************************************************/
/*                            PMOD NAV I2C                                      */
/********************************************************************************/
`define PMOD_NAV_I2C_CONNECT(con) \
	output con``_1, \
	inout con``_2, \
	output con``_3, \
	output con``_4, \
	input con``_7, \
	input con``_8, \
	output con``_9, \
	output con``_10

`define PMOD_NAV_I2C_ATTACH(con, mod, addr) \
assign con``_1 = 1'b1; \
wire mod``_sda_out; \
assign con``_2 = mod``_sda_out; \
wire mod``_sda_in = con``_2; \
assign con``_3 = addr; \
wire mod``_scl; \
assign con``_4 = mod``_scl; \
wire mod``_int = con``_7; \
wire mod``_drdy_m = con``_8; \
wire mod``_cs_m; \
assign con``_9 = mod``_cs_m; \
wire mod``_cs_alt; \
assign con``_10 = mod``_cs_alt

/********************************************************************************/
/*                            PMOD RTCC                                      */
/********************************************************************************/
`define PMOD_RTCC_CONNECT(con) \
	output con``_3, \
	inout con``_4

`define PMOD_RTCC_ATTACH(con, mod, addr) \
wire mod``_scl; \
assign con``_3 = mod``_scl; \
wire mod``_sda_out; \
assign con``_4 = mod``_sda_out; \
wire mod``_sda_in = con``_4

