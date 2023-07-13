/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12-SP5-5
// Date      : Thu Apr  6 23:34:23 2023
/////////////////////////////////////////////////////////////


module SYNDROME_CHECK ( codeword_in, syndrome_out, error_flag_out );
  input [79:0] codeword_in;
  output [15:0] syndrome_out;
  output error_flag_out;
  wire   \error_flag00/N14 , n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n243, n244, n245, n246, n247, n248, n249, n250, n251, n252,
         n253, n254, n255, n256, n257, n258, n259, n260, n261, n262, n263,
         n264, n265, n266, n267, n268, n269, n270, n271, n272, n273, n274,
         n275, n276, n277, n278, n279, n280, n281, n282, n283, n284, n285,
         n286, n287, n288, n289, n290, n291, n292, n293, n294, n295, n296,
         n297, n298, n299, n300, n301, n302, n303, n304, n305, n306, n307,
         n308, n309, n310, n311, n312, n313, n314, n315, n316, n317, n318,
         n319, n320, n321, n322, n323, n324, n325, n326, n327, n328, n329,
         n330, n331, n332, n333, n334, n335, n336, n337, n338, n339, n340,
         n341, n342, n343, n344, n345, n346, n347, n348, n349, n350, n351,
         n352, n353, n354, n355, n356, n357, n358, n359, n360, n361, n362,
         n363, n364, n365, n366, n367, n368, n369, n370, n371, n372, n373,
         n374, n375, n376, n377, n378, n379, n380, n381, n382, n383, n384,
         n385, n386, n387, n388, n389, n390;
  assign error_flag_out = \error_flag00/N14 ;

  STQ_INV_S_1 U229 ( .A(syndrome_out[8]), .X(n386) );
  STQ_EO3_2 U230 ( .A1(n290), .A2(n289), .A3(n288), .X(syndrome_out[12]) );
  STQ_EN2_S_1 U231 ( .A1(n379), .A2(n357), .X(n212) );
  STQ_INV_S_0P65 U232 ( .A(n268), .X(n213) );
  STQ_EO3_1 U233 ( .A1(n322), .A2(n287), .A3(n378), .X(n288) );
  STQ_EO3_1 U234 ( .A1(n368), .A2(codeword_in[30]), .A3(n263), .X(n337) );
  STQ_EO3_0P5 U235 ( .A1(n276), .A2(codeword_in[65]), .A3(codeword_in[45]), 
        .X(n385) );
  STQ_EO3_2 U236 ( .A1(n276), .A2(n296), .A3(n275), .X(n277) );
  STQ_EO3_2 U237 ( .A1(n265), .A2(n264), .A3(n301), .X(n269) );
  STQ_EO3_2 U238 ( .A1(n247), .A2(n246), .A3(n245), .X(n248) );
  STQ_EO3_2 U239 ( .A1(n307), .A2(n306), .A3(n305), .X(n308) );
  STQ_EN2_S_1 U240 ( .A1(n368), .A2(n263), .X(n301) );
  STQ_EN2_S_1 U241 ( .A1(n231), .A2(codeword_in[55]), .X(n280) );
  STQ_EN2_S_1 U242 ( .A1(n333), .A2(n363), .X(n255) );
  STQ_EN2_S_1 U243 ( .A1(n356), .A2(codeword_in[23]), .X(n379) );
  STQ_EO3_1 U244 ( .A1(n262), .A2(n261), .A3(n363), .X(n264) );
  STQ_EO3_1 U245 ( .A1(n242), .A2(codeword_in[37]), .A3(n266), .X(n244) );
  STQ_EO3_1 U246 ( .A1(n294), .A2(codeword_in[30]), .A3(codeword_in[1]), .X(
        n246) );
  STQ_EO3_1 U247 ( .A1(n252), .A2(codeword_in[10]), .A3(n251), .X(n253) );
  STQ_EO3_2 U248 ( .A1(n345), .A2(n313), .A3(n351), .X(n307) );
  STQ_EO3_1 U249 ( .A1(n367), .A2(codeword_in[21]), .A3(n317), .X(n347) );
  STQ_EO3_1 U250 ( .A1(n300), .A2(n240), .A3(n284), .X(n222) );
  STQ_EO3_2 U251 ( .A1(codeword_in[54]), .A2(codeword_in[59]), .A3(
        codeword_in[30]), .X(n344) );
  STQ_EN2_S_1 U252 ( .A1(n239), .A2(codeword_in[70]), .X(n284) );
  STQ_EN2_S_1 U253 ( .A1(n267), .A2(codeword_in[18]), .X(n333) );
  STQ_EN2_S_1 U254 ( .A1(n311), .A2(codeword_in[76]), .X(n370) );
  STQ_EN2_S_1 U255 ( .A1(n261), .A2(codeword_in[20]), .X(n357) );
  STQ_EO3_1 U256 ( .A1(n235), .A2(codeword_in[60]), .A3(codeword_in[73]), .X(
        n236) );
  STQ_EO3_1 U257 ( .A1(n226), .A2(codeword_in[53]), .A3(codeword_in[29]), .X(
        n227) );
  STQ_EO3_1 U258 ( .A1(n356), .A2(codeword_in[55]), .A3(codeword_in[34]), .X(
        n312) );
  STQ_EO2_1 U259 ( .A1(codeword_in[48]), .A2(codeword_in[53]), .X(n325) );
  STQ_EO2_S_4 U260 ( .A1(codeword_in[27]), .A2(codeword_in[18]), .X(n313) );
  STQ_EO3_1 U261 ( .A1(n331), .A2(codeword_in[19]), .A3(codeword_in[73]), .X(
        n303) );
  STQ_INV_S_0P65 U262 ( .A(codeword_in[21]), .X(n243) );
  STQ_EN2_4 U263 ( .A1(n256), .A2(n319), .X(n368) );
  STQ_EN2_4 U264 ( .A1(codeword_in[48]), .A2(codeword_in[50]), .X(n294) );
  STQ_EN2_4 U265 ( .A1(codeword_in[68]), .A2(codeword_in[26]), .X(n356) );
  STQ_EN2_S_2 U266 ( .A1(n316), .A2(codeword_in[60]), .X(n367) );
  STQ_EN2_4 U267 ( .A1(codeword_in[71]), .A2(codeword_in[67]), .X(n266) );
  STQ_EO2_S_2 U268 ( .A1(codeword_in[16]), .A2(codeword_in[57]), .X(n250) );
  STQ_INV_S_1 U269 ( .A(codeword_in[35]), .X(n238) );
  STQ_EN2_6 U270 ( .A1(codeword_in[65]), .A2(codeword_in[43]), .X(n351) );
  STQ_EN2_S_2 U271 ( .A1(codeword_in[40]), .A2(codeword_in[44]), .X(n331) );
  STQ_OR2_2 U272 ( .A1(syndrome_out[11]), .A2(syndrome_out[7]), .X(n217) );
  STQ_EN3_1 U273 ( .A1(n326), .A2(codeword_in[2]), .A3(n223), .X(n328) );
  STQ_INV_S_1 U274 ( .A(codeword_in[60]), .X(n216) );
  STQ_EN3_1 U275 ( .A1(n385), .A2(n248), .A3(n249), .X(syndrome_out[1]) );
  STQ_EO2_1 U276 ( .A1(n370), .A2(n312), .X(n315) );
  STQ_EO2_1 U277 ( .A1(n356), .A2(n273), .X(n254) );
  STQ_EO2_1 U278 ( .A1(n338), .A2(n351), .X(n340) );
  STQ_EN2_4 U279 ( .A1(codeword_in[77]), .A2(codeword_in[69]), .X(n316) );
  STQ_NR4_2 U280 ( .A1(n217), .A2(syndrome_out[1]), .A3(syndrome_out[9]), .A4(
        syndrome_out[13]), .X(n390) );
  STQ_EO3_2 U281 ( .A1(n310), .A2(n309), .A3(n308), .X(syndrome_out[3]) );
  STQ_EO3_2 U282 ( .A1(n337), .A2(n336), .A3(n335), .X(syndrome_out[2]) );
  STQ_EO3_2 U283 ( .A1(n323), .A2(n322), .A3(n321), .X(syndrome_out[5]) );
  STQ_EO2_S_2 U284 ( .A1(n237), .A2(n241), .X(n220) );
  STQ_EO3_3 U285 ( .A1(n377), .A2(n273), .A3(codeword_in[63]), .X(n247) );
  STQ_EO3_3 U286 ( .A1(n296), .A2(n286), .A3(n285), .X(n322) );
  STQ_EN2_S_2 U287 ( .A1(n231), .A2(codeword_in[35]), .X(n361) );
  STQ_EN2_S_2 U288 ( .A1(n303), .A2(codeword_in[63]), .X(n360) );
  STQ_EO3_1 U289 ( .A1(n312), .A2(n225), .A3(n316), .X(n270) );
  STQ_EO2_1 U290 ( .A1(n382), .A2(n381), .X(n383) );
  STQ_EN2_S_2 U291 ( .A1(n356), .A2(codeword_in[55]), .X(n306) );
  STQ_EN2_4 U292 ( .A1(codeword_in[54]), .A2(codeword_in[33]), .X(n291) );
  STQ_INV_S_1 U293 ( .A(codeword_in[71]), .X(n349) );
  STQ_EO3_2 U294 ( .A1(n291), .A2(codeword_in[69]), .A3(codeword_in[12]), .X(
        n282) );
  STQ_EO3_2 U295 ( .A1(n363), .A2(codeword_in[51]), .A3(n362), .X(n382) );
  STQ_EN2_4 U296 ( .A1(codeword_in[61]), .A2(codeword_in[78]), .X(n362) );
  STQ_EO3_3 U297 ( .A1(codeword_in[49]), .A2(codeword_in[47]), .A3(
        codeword_in[67]), .X(n295) );
  STQ_EN2_4 U298 ( .A1(codeword_in[17]), .A2(codeword_in[47]), .X(n267) );
  STQ_EN2_4 U299 ( .A1(codeword_in[25]), .A2(codeword_in[70]), .X(n256) );
  STQ_EO3_1 U300 ( .A1(n349), .A2(codeword_in[25]), .A3(codeword_in[9]), .X(
        n352) );
  STQ_EN2_S_2 U301 ( .A1(n281), .A2(n243), .X(n263) );
  STQ_EN2_4 U302 ( .A1(codeword_in[31]), .A2(codeword_in[49]), .X(n281) );
  STQ_EO3_2 U303 ( .A1(n250), .A2(codeword_in[66]), .A3(codeword_in[78]), .X(
        n252) );
  STQ_EN2_4 U304 ( .A1(codeword_in[39]), .A2(codeword_in[28]), .X(n366) );
  STQ_INV_S_1 U305 ( .A(n317), .X(n214) );
  STQ_EO2_S_2 U306 ( .A1(codeword_in[50]), .A2(codeword_in[60]), .X(n225) );
  STQ_EN2_S_2 U307 ( .A1(codeword_in[51]), .A2(codeword_in[52]), .X(n232) );
  STQ_EN2_S_2 U308 ( .A1(codeword_in[53]), .A2(codeword_in[24]), .X(n239) );
  STQ_EN2_S_2 U309 ( .A1(codeword_in[46]), .A2(codeword_in[66]), .X(n317) );
  STQ_EN2_S_2 U310 ( .A1(codeword_in[36]), .A2(codeword_in[72]), .X(n311) );
  STQ_EO3_1 U311 ( .A1(n342), .A2(codeword_in[17]), .A3(codeword_in[0]), .X(
        n343) );
  STQ_EO2_S_2 U312 ( .A1(codeword_in[62]), .A2(codeword_in[36]), .X(n342) );
  STQ_INV_S_1 U313 ( .A(codeword_in[19]), .X(n223) );
  STQ_EO2_S_2 U314 ( .A1(codeword_in[68]), .A2(codeword_in[6]), .X(n293) );
  STQ_EO3_1 U315 ( .A1(n291), .A2(codeword_in[25]), .A3(codeword_in[34]), .X(
        n381) );
  STQ_EO3_1 U316 ( .A1(n364), .A2(codeword_in[68]), .A3(codeword_in[31]), .X(
        n365) );
  STQ_EO2_S_2 U317 ( .A1(codeword_in[57]), .A2(codeword_in[8]), .X(n364) );
  STQ_EO2_S_2 U318 ( .A1(codeword_in[40]), .A2(codeword_in[67]), .X(n251) );
  STQ_EN2_S_2 U319 ( .A1(n366), .A2(codeword_in[22]), .X(n327) );
  STQ_EO3_1 U320 ( .A1(n291), .A2(codeword_in[34]), .A3(codeword_in[13]), .X(
        n228) );
  STQ_EO3_1 U321 ( .A1(n366), .A2(codeword_in[34]), .A3(codeword_in[14]), .X(
        n259) );
  STQ_EO2_S_2 U322 ( .A1(codeword_in[56]), .A2(codeword_in[74]), .X(n363) );
  STQ_EO3_2 U323 ( .A1(codeword_in[44]), .A2(codeword_in[24]), .A3(
        codeword_in[15]), .X(n272) );
  STQ_NR4_1 U324 ( .A1(syndrome_out[3]), .A2(syndrome_out[5]), .A3(
        syndrome_out[2]), .A4(syndrome_out[0]), .X(n388) );
  STQ_EO2_S_2 U325 ( .A1(n240), .A2(n357), .X(n218) );
  STQ_EO3_0P5 U326 ( .A1(n355), .A2(n354), .A3(n353), .X(n359) );
  STQ_EO3_2 U327 ( .A1(n279), .A2(n278), .A3(n277), .X(syndrome_out[15]) );
  STQ_EO3_1 U328 ( .A1(n382), .A2(n366), .A3(n365), .X(n373) );
  STQ_EO3_2 U329 ( .A1(n297), .A2(n303), .A3(n296), .X(n298) );
  STQ_EO3_1 U330 ( .A1(n348), .A2(n347), .A3(n346), .X(syndrome_out[0]) );
  STQ_EO3_1 U331 ( .A1(n304), .A2(codeword_in[69]), .A3(codeword_in[33]), .X(
        n305) );
  STQ_EN2_S_2 U332 ( .A1(n261), .A2(codeword_in[32]), .X(n287) );
  STQ_EO3_1 U333 ( .A1(n350), .A2(n325), .A3(n324), .X(n329) );
  STQ_EO3_1 U334 ( .A1(n255), .A2(n254), .A3(n253), .X(n258) );
  STQ_EO3_1 U335 ( .A1(n380), .A2(n379), .A3(n378), .X(n384) );
  STQ_EO3_1 U336 ( .A1(n318), .A2(codeword_in[40]), .A3(codeword_in[33]), .X(
        n320) );
  STQ_EO3_2 U337 ( .A1(n326), .A2(codeword_in[63]), .A3(codeword_in[41]), .X(
        n233) );
  STQ_EN2_S_2 U338 ( .A1(n361), .A2(n339), .X(n257) );
  STQ_EN2_S_2 U339 ( .A1(codeword_in[42]), .A2(codeword_in[27]), .X(n338) );
  STQ_EN2_S_2 U340 ( .A1(codeword_in[35]), .A2(codeword_in[75]), .X(n330) );
  STQ_EO3_1 U341 ( .A1(n274), .A2(codeword_in[29]), .A3(codeword_in[73]), .X(
        n275) );
  STQ_EN3_3 U342 ( .A1(n215), .A2(n255), .A3(n213), .X(syndrome_out[13]) );
  STQ_EN3_1 U343 ( .A1(n233), .A2(n214), .A3(n311), .X(n268) );
  STQ_EO3_3 U344 ( .A1(n230), .A2(n280), .A3(n341), .X(n215) );
  STQ_EN3_3 U345 ( .A1(n359), .A2(n212), .A3(n358), .X(syndrome_out[9]) );
  STQ_EN3_3 U346 ( .A1(n300), .A2(codeword_in[37]), .A3(n216), .X(n358) );
  STQ_EN3_3 U347 ( .A1(n219), .A2(n270), .A3(n218), .X(syndrome_out[7]) );
  STQ_EN3_3 U348 ( .A1(n257), .A2(n247), .A3(n224), .X(n219) );
  STQ_EN3_3 U349 ( .A1(n222), .A2(n221), .A3(n220), .X(syndrome_out[11]) );
  STQ_EN3_3 U350 ( .A1(n334), .A2(n327), .A3(n236), .X(n221) );
  STQ_ND4_MM_1 U351 ( .A1(n389), .A2(n390), .A3(n388), .A4(n387), .X(
        \error_flag00/N14 ) );
  STQ_EN2_S_2 U352 ( .A1(n326), .A2(codeword_in[41]), .X(n377) );
  STQ_EN2_4 U353 ( .A1(codeword_in[59]), .A2(codeword_in[76]), .X(n326) );
  STQ_EO3_2 U354 ( .A1(n334), .A2(n333), .A3(n332), .X(n335) );
  STQ_EN2_S_2 U355 ( .A1(n286), .A2(n238), .X(n354) );
  STQ_EN2_S_2 U356 ( .A1(n287), .A2(codeword_in[54]), .X(n334) );
  STQ_EO3_2 U357 ( .A1(n281), .A2(codeword_in[46]), .A3(codeword_in[28]), .X(
        n283) );
  STQ_EO3_2 U358 ( .A1(n354), .A2(n294), .A3(n266), .X(n241) );
  STQ_EO3_2 U359 ( .A1(codeword_in[42]), .A2(codeword_in[3]), .A3(
        codeword_in[22]), .X(n302) );
  STQ_EN2_4 U360 ( .A1(codeword_in[42]), .A2(codeword_in[64]), .X(n273) );
  STQ_EO3_3 U361 ( .A1(n351), .A2(codeword_in[45]), .A3(codeword_in[58]), .X(
        n231) );
  STQ_EO2_S_2 U362 ( .A1(n239), .A2(n232), .X(n339) );
  STQ_EO3_0P5 U363 ( .A1(n295), .A2(codeword_in[61]), .A3(codeword_in[7]), .X(
        n224) );
  STQ_EN2_4 U364 ( .A1(codeword_in[16]), .A2(codeword_in[38]), .X(n261) );
  STQ_EN2_4 U365 ( .A1(codeword_in[23]), .A2(codeword_in[29]), .X(n319) );
  STQ_EN2_S_1 U366 ( .A1(n319), .A2(codeword_in[74]), .X(n240) );
  STQ_EO2_S_2 U367 ( .A1(codeword_in[20]), .A2(codeword_in[32]), .X(n375) );
  STQ_EO2_S_2 U368 ( .A1(n375), .A2(codeword_in[16]), .X(n314) );
  STQ_EO2_1 U369 ( .A1(codeword_in[71]), .A2(codeword_in[64]), .X(n226) );
  STQ_EO3_2 U370 ( .A1(n314), .A2(n228), .A3(n227), .X(n230) );
  STQ_EO3_1 U371 ( .A1(n294), .A2(codeword_in[39]), .A3(codeword_in[68]), .X(
        n229) );
  STQ_EO3_2 U372 ( .A1(n229), .A2(n256), .A3(n331), .X(n341) );
  STQ_EO3_2 U373 ( .A1(n233), .A2(n232), .A3(n317), .X(n300) );
  STQ_EO2_S_2 U374 ( .A1(codeword_in[77]), .A2(codeword_in[45]), .X(n234) );
  STQ_EO3_1 U375 ( .A1(n234), .A2(codeword_in[11]), .A3(n362), .X(n237) );
  STQ_EO2_S_2 U376 ( .A1(codeword_in[17]), .A2(codeword_in[26]), .X(n235) );
  STQ_EN2_8 U377 ( .A1(codeword_in[75]), .A2(codeword_in[79]), .X(n286) );
  STQ_EN2_S_2 U378 ( .A1(n327), .A2(n354), .X(n276) );
  STQ_EO2_S_2 U379 ( .A1(codeword_in[77]), .A2(codeword_in[46]), .X(n242) );
  STQ_EO3_2 U380 ( .A1(n244), .A2(n306), .A3(n263), .X(n249) );
  STQ_EO2_S_2 U381 ( .A1(n313), .A2(n267), .X(n245) );
  STQ_EO3_2 U382 ( .A1(n258), .A2(n337), .A3(n257), .X(syndrome_out[10]) );
  STQ_EO2_S_2 U383 ( .A1(codeword_in[75]), .A2(codeword_in[58]), .X(n292) );
  STQ_EO2_S_2 U384 ( .A1(n292), .A2(n291), .X(n260) );
  STQ_EO3_2 U385 ( .A1(n260), .A2(n259), .A3(n306), .X(n265) );
  STQ_EO2_S_2 U386 ( .A1(n338), .A2(n362), .X(n262) );
  STQ_EN2_S_2 U387 ( .A1(n267), .A2(n266), .X(n378) );
  STQ_EO3_0P5 U388 ( .A1(n378), .A2(codeword_in[43]), .A3(codeword_in[37]), 
        .X(n271) );
  STQ_EO3_3 U389 ( .A1(n269), .A2(n268), .A3(n271), .X(syndrome_out[14]) );
  STQ_EO2_S_2 U390 ( .A1(n271), .A2(n270), .X(n279) );
  STQ_EO3_1 U391 ( .A1(n313), .A2(codeword_in[30]), .A3(codeword_in[38]), .X(
        n369) );
  STQ_EO3_0P5 U392 ( .A1(n369), .A2(n326), .A3(n272), .X(n278) );
  STQ_EN3_3 U393 ( .A1(n273), .A2(codeword_in[62]), .A3(codeword_in[57]), .X(
        n296) );
  STQ_EO2_S_2 U394 ( .A1(codeword_in[72]), .A2(codeword_in[56]), .X(n274) );
  STQ_EO2_S_2 U395 ( .A1(n360), .A2(n280), .X(n290) );
  STQ_EO3_1 U396 ( .A1(n284), .A2(n283), .A3(n282), .X(n289) );
  STQ_EO2_S_2 U397 ( .A1(codeword_in[52]), .A2(codeword_in[35]), .X(n285) );
  STQ_EO3_1 U398 ( .A1(n327), .A2(n292), .A3(n381), .X(n299) );
  STQ_EO3_0P5 U399 ( .A1(n295), .A2(n294), .A3(n293), .X(n297) );
  STQ_EO3_2 U400 ( .A1(n358), .A2(n299), .A3(n298), .X(syndrome_out[6]) );
  STQ_EO2_S_2 U401 ( .A1(n301), .A2(n300), .X(n310) );
  STQ_EO3_0P5 U402 ( .A1(n303), .A2(n375), .A3(n302), .X(n309) );
  STQ_EO2_S_2 U403 ( .A1(n362), .A2(n330), .X(n345) );
  STQ_EO2_S_2 U404 ( .A1(codeword_in[45]), .A2(codeword_in[71]), .X(n304) );
  STQ_EO2_S_2 U405 ( .A1(n313), .A2(codeword_in[48]), .X(n353) );
  STQ_EO3_0P5 U406 ( .A1(n315), .A2(n353), .A3(n314), .X(n323) );
  STQ_EO2_S_2 U407 ( .A1(codeword_in[56]), .A2(codeword_in[5]), .X(n318) );
  STQ_EO3_3 U408 ( .A1(n347), .A2(n320), .A3(n319), .X(n321) );
  STQ_EO2_S_2 U409 ( .A1(codeword_in[62]), .A2(codeword_in[72]), .X(n350) );
  STQ_EO2_S_2 U410 ( .A1(codeword_in[52]), .A2(codeword_in[61]), .X(n324) );
  STQ_EO3_2 U411 ( .A1(n329), .A2(n328), .A3(n327), .X(n336) );
  STQ_EO2_S_2 U412 ( .A1(n331), .A2(n330), .X(n332) );
  STQ_EO3_0P5 U413 ( .A1(n341), .A2(n340), .A3(n339), .X(n348) );
  STQ_EO3_2 U414 ( .A1(n345), .A2(n344), .A3(n343), .X(n346) );
  STQ_EO3_0P5 U415 ( .A1(n352), .A2(n351), .A3(n350), .X(n355) );
  STQ_EO2_S_2 U416 ( .A1(n361), .A2(n360), .X(n374) );
  STQ_EN2_S_1 U417 ( .A1(n368), .A2(n367), .X(n371) );
  STQ_EO3_3 U418 ( .A1(n371), .A2(n370), .A3(n369), .X(n372) );
  STQ_EO3_3 U419 ( .A1(n374), .A2(n373), .A3(n372), .X(syndrome_out[8]) );
  STQ_EO2_S_2 U420 ( .A1(codeword_in[19]), .A2(codeword_in[4]), .X(n376) );
  STQ_EO3_2 U421 ( .A1(n377), .A2(n376), .A3(n375), .X(n380) );
  STQ_EN3_1 U422 ( .A1(n385), .A2(n384), .A3(n383), .X(syndrome_out[4]) );
  STQ_NR3B_MG_2 U423 ( .A(n386), .B1(syndrome_out[4]), .B2(syndrome_out[6]), 
        .X(n389) );
  STQ_NR4_2 U424 ( .A1(syndrome_out[10]), .A2(syndrome_out[14]), .A3(
        syndrome_out[15]), .A4(syndrome_out[12]), .X(n387) );
endmodule

