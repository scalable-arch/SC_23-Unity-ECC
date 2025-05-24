/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12-SP5-5
// Date      : Wed Apr 19 15:04:07 2023
/////////////////////////////////////////////////////////////


module UNITY_ENCODER ( data_in, codeword_out );
  input [63:0] data_in;
  output [79:0] codeword_out;
  wire   n186, n187, n188, n189, n190, n191, n192, n193, n194, n195, n196,
         n197, n198, n199, n200, n201, n202, n203, n204, n205, n206, n207,
         n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n223, n224, n225, n226, n227, n228, n229,
         n230, n231, n232, n233, n234, n235, n236, n237, n238, n239, n240,
         n241, n242, n243, n244, n245, n246, n247, n248, n249, n250, n251,
         n252, n253, n254, n255, n256, n257, n258, n259, n260, n261, n262,
         n263, n264, n265, n266, n267, n268, n269, n270, n271, n272, n273,
         n274, n275, n276, n277, n278, n279, n280, n281, n282, n283, n284,
         n285, n286, n287, n288, n289, n290, n291, n292, n293, n294, n295,
         n296, n297, n298, n299, n300, n301, n302, n303, n304, n305, n306,
         n307, n308, n309, n310, n311, n312, n313, n314, n315, n316, n317,
         n318, n319, n320, n321, n322, n323, n324, n325, n326, n327, n328,
         n329, n330, n331, n332, n333, n334, n335;
  assign codeword_out[79] = data_in[63];
  assign codeword_out[78] = data_in[62];
  assign codeword_out[77] = data_in[61];
  assign codeword_out[76] = data_in[60];
  assign codeword_out[75] = data_in[59];
  assign codeword_out[74] = data_in[58];
  assign codeword_out[73] = data_in[57];
  assign codeword_out[72] = data_in[56];
  assign codeword_out[71] = data_in[55];
  assign codeword_out[70] = data_in[54];
  assign codeword_out[69] = data_in[53];
  assign codeword_out[68] = data_in[52];
  assign codeword_out[67] = data_in[51];
  assign codeword_out[66] = data_in[50];
  assign codeword_out[65] = data_in[49];
  assign codeword_out[64] = data_in[48];
  assign codeword_out[63] = data_in[47];
  assign codeword_out[62] = data_in[46];
  assign codeword_out[61] = data_in[45];
  assign codeword_out[60] = data_in[44];
  assign codeword_out[59] = data_in[43];
  assign codeword_out[58] = data_in[42];
  assign codeword_out[57] = data_in[41];
  assign codeword_out[56] = data_in[40];
  assign codeword_out[55] = data_in[39];
  assign codeword_out[54] = data_in[38];
  assign codeword_out[53] = data_in[37];
  assign codeword_out[52] = data_in[36];
  assign codeword_out[51] = data_in[35];
  assign codeword_out[50] = data_in[34];
  assign codeword_out[49] = data_in[33];
  assign codeword_out[48] = data_in[32];
  assign codeword_out[47] = data_in[31];
  assign codeword_out[46] = data_in[30];
  assign codeword_out[45] = data_in[29];
  assign codeword_out[44] = data_in[28];
  assign codeword_out[43] = data_in[27];
  assign codeword_out[42] = data_in[26];
  assign codeword_out[41] = data_in[25];
  assign codeword_out[40] = data_in[24];
  assign codeword_out[39] = data_in[23];
  assign codeword_out[38] = data_in[22];
  assign codeword_out[37] = data_in[21];
  assign codeword_out[36] = data_in[20];
  assign codeword_out[35] = data_in[19];
  assign codeword_out[34] = data_in[18];
  assign codeword_out[33] = data_in[17];
  assign codeword_out[32] = data_in[16];
  assign codeword_out[31] = data_in[15];
  assign codeword_out[30] = data_in[14];
  assign codeword_out[29] = data_in[13];
  assign codeword_out[28] = data_in[12];
  assign codeword_out[27] = data_in[11];
  assign codeword_out[26] = data_in[10];
  assign codeword_out[25] = data_in[9];
  assign codeword_out[24] = data_in[8];
  assign codeword_out[23] = data_in[7];
  assign codeword_out[22] = data_in[6];
  assign codeword_out[21] = data_in[5];
  assign codeword_out[20] = data_in[4];
  assign codeword_out[19] = data_in[3];
  assign codeword_out[18] = data_in[2];
  assign codeword_out[17] = data_in[1];
  assign codeword_out[16] = data_in[0];

  STQ_EN3_1 U204 ( .A1(n223), .A2(n295), .A3(n222), .X(n224) );
  STQ_EO3_2 U205 ( .A1(n219), .A2(data_in[30]), .A3(data_in[5]), .X(n238) );
  STQ_EN2_S_1 U206 ( .A1(n253), .A2(data_in[46]), .X(n295) );
  STQ_EO2_1 U207 ( .A1(n334), .A2(n238), .X(n207) );
  STQ_EO2_1 U208 ( .A1(n308), .A2(n307), .X(n311) );
  STQ_EO2_1 U209 ( .A1(n329), .A2(n328), .X(n332) );
  STQ_EO2_1 U210 ( .A1(n293), .A2(n292), .X(n296) );
  STQ_EO2_1 U211 ( .A1(n228), .A2(data_in[37]), .X(n250) );
  STQ_EO2_1 U212 ( .A1(n242), .A2(n241), .X(n245) );
  STQ_EO3_1 U213 ( .A1(data_in[59]), .A2(data_in[39]), .A3(data_in[48]), .X(
        n205) );
  STQ_EO3_1 U214 ( .A1(n315), .A2(data_in[6]), .A3(n291), .X(n227) );
  STQ_EO2_S_2 U215 ( .A1(data_in[61]), .A2(data_in[44]), .X(n286) );
  STQ_EO2_S_0P5 U216 ( .A1(data_in[29]), .A2(data_in[53]), .X(n196) );
  STQ_EO3_0P5 U217 ( .A1(data_in[55]), .A2(data_in[16]), .A3(data_in[54]), .X(
        n197) );
  STQ_EO2_S_0P5 U218 ( .A1(data_in[3]), .A2(data_in[9]), .X(n211) );
  STQ_INV_S_0P65 U219 ( .A(n261), .X(n254) );
  STQ_EO3_1 U220 ( .A1(n276), .A2(n275), .A3(n274), .X(n277) );
  STQ_EO3_0P5 U221 ( .A1(n227), .A2(n295), .A3(n226), .X(n232) );
  STQ_EO3_0P5 U222 ( .A1(n189), .A2(n269), .A3(n188), .X(codeword_out[11]) );
  STQ_EN3_1 U223 ( .A1(n202), .A2(n297), .A3(n268), .X(codeword_out[12]) );
  STQ_EN3_1 U224 ( .A1(n200), .A2(n210), .A3(n289), .X(n202) );
  STQ_EO3_0P5 U225 ( .A1(n225), .A2(n210), .A3(n190), .X(n195) );
  STQ_EN3_1 U226 ( .A1(n215), .A2(n214), .A3(n256), .X(n216) );
  STQ_EO3_0P5 U227 ( .A1(n209), .A2(n208), .A3(n207), .X(codeword_out[5]) );
  STQ_EO2_S_2 U228 ( .A1(data_in[47]), .A2(data_in[30]), .X(n201) );
  STQ_EO2_S_2 U229 ( .A1(data_in[25]), .A2(data_in[55]), .X(n212) );
  STQ_EO2_S_2 U230 ( .A1(n201), .A2(n212), .X(n271) );
  STQ_EO2_S_2 U231 ( .A1(data_in[45]), .A2(data_in[62]), .X(n243) );
  STQ_EO2_S_2 U232 ( .A1(n271), .A2(n243), .X(n190) );
  STQ_EO2_S_2 U233 ( .A1(n190), .A2(data_in[57]), .X(n326) );
  STQ_EO2_S_2 U234 ( .A1(data_in[19]), .A2(data_in[36]), .X(n237) );
  STQ_EO2_S_2 U235 ( .A1(n237), .A2(data_in[0]), .X(n308) );
  STQ_EO2_S_2 U236 ( .A1(n308), .A2(data_in[63]), .X(n204) );
  STQ_EO2_S_2 U237 ( .A1(data_in[13]), .A2(data_in[7]), .X(n306) );
  STQ_EO2_S_2 U238 ( .A1(n306), .A2(data_in[22]), .X(n226) );
  STQ_EO2_S_2 U239 ( .A1(data_in[29]), .A2(data_in[35]), .X(n327) );
  STQ_EO2_S_2 U240 ( .A1(n327), .A2(data_in[58]), .X(n310) );
  STQ_EO2_S_2 U241 ( .A1(n226), .A2(n310), .X(n288) );
  STQ_EO3_0P5 U242 ( .A1(n326), .A2(n204), .A3(n288), .X(n189) );
  STQ_EO2_S_2 U243 ( .A1(data_in[12]), .A2(data_in[23]), .X(n315) );
  STQ_EO2_S_2 U244 ( .A1(data_in[43]), .A2(data_in[59]), .X(n291) );
  STQ_EO2_S_2 U245 ( .A1(n227), .A2(data_in[51]), .X(n269) );
  STQ_EO2_S_2 U246 ( .A1(data_in[8]), .A2(data_in[37]), .X(n199) );
  STQ_EO3_1 U247 ( .A1(n199), .A2(data_in[1]), .A3(data_in[34]), .X(n244) );
  STQ_EO2_S_2 U248 ( .A1(data_in[32]), .A2(data_in[50]), .X(n259) );
  STQ_EO3_0P5 U249 ( .A1(n244), .A2(n286), .A3(n259), .X(n187) );
  STQ_EO2_S_2 U250 ( .A1(data_in[60]), .A2(data_in[16]), .X(n229) );
  STQ_EO3_0P5 U251 ( .A1(data_in[10]), .A2(data_in[38]), .A3(data_in[54]), .X(
        n186) );
  STQ_EO3_0P5 U252 ( .A1(n187), .A2(n229), .A3(n186), .X(n188) );
  STQ_EO2_S_2 U253 ( .A1(data_in[60]), .A2(data_in[52]), .X(n261) );
  STQ_EO3_2 U254 ( .A1(n261), .A2(data_in[10]), .A3(data_in[11]), .X(n206) );
  STQ_EO2_S_2 U255 ( .A1(n206), .A2(data_in[21]), .X(n272) );
  STQ_EO2_S_2 U256 ( .A1(data_in[40]), .A2(data_in[18]), .X(n203) );
  STQ_EO3_0P5 U257 ( .A1(n272), .A2(data_in[27]), .A3(n203), .X(n225) );
  STQ_EO2_S_2 U258 ( .A1(data_in[31]), .A2(data_in[1]), .X(n228) );
  STQ_EO2_S_2 U259 ( .A1(n228), .A2(data_in[51]), .X(n217) );
  STQ_EO2_S_2 U260 ( .A1(data_in[17]), .A2(data_in[38]), .X(n263) );
  STQ_EO2_S_2 U261 ( .A1(n217), .A2(n263), .X(n210) );
  STQ_EO2_3 U262 ( .A1(data_in[33]), .A2(data_in[26]), .X(n273) );
  STQ_EO2_S_2 U263 ( .A1(n273), .A2(data_in[42]), .X(n265) );
  STQ_EO2_S_2 U264 ( .A1(data_in[0]), .A2(data_in[58]), .X(n249) );
  STQ_EO3_0P5 U265 ( .A1(n291), .A2(data_in[56]), .A3(data_in[20]), .X(n191)
         );
  STQ_EO3_1 U266 ( .A1(n265), .A2(n249), .A3(n191), .X(n193) );
  STQ_EO2_S_2 U267 ( .A1(data_in[54]), .A2(data_in[9]), .X(n236) );
  STQ_EO3_0P5 U268 ( .A1(n226), .A2(n315), .A3(n236), .X(n192) );
  STQ_EO2_S_2 U269 ( .A1(data_in[15]), .A2(data_in[5]), .X(n233) );
  STQ_EO2_S_2 U270 ( .A1(n233), .A2(data_in[50]), .X(n305) );
  STQ_EO2_S_2 U271 ( .A1(n305), .A2(data_in[39]), .X(n325) );
  STQ_EO3_0P5 U272 ( .A1(n193), .A2(n192), .A3(n325), .X(n194) );
  STQ_EO2_S_0P5 U273 ( .A1(n195), .A2(n194), .X(codeword_out[14]) );
  STQ_EO3_0P5 U274 ( .A1(n196), .A2(data_in[12]), .A3(data_in[15]), .X(n198)
         );
  STQ_EO3_0P5 U275 ( .A1(n198), .A2(n197), .A3(n205), .X(n200) );
  STQ_EO2_S_2 U276 ( .A1(n265), .A2(n199), .X(n300) );
  STQ_EO2_S_2 U277 ( .A1(data_in[49]), .A2(data_in[27]), .X(n292) );
  STQ_EO2_S_2 U278 ( .A1(n300), .A2(n292), .X(n289) );
  STQ_EO2_S_2 U279 ( .A1(n204), .A2(data_in[22]), .X(n297) );
  STQ_EO2_S_2 U280 ( .A1(data_in[28]), .A2(data_in[24]), .X(n239) );
  STQ_EO2_S_2 U281 ( .A1(n239), .A2(data_in[3]), .X(n330) );
  STQ_EO2_S_2 U282 ( .A1(data_in[41]), .A2(data_in[57]), .X(n221) );
  STQ_EO2_S_2 U283 ( .A1(n330), .A2(n221), .X(n319) );
  STQ_EO3_0P5 U284 ( .A1(n319), .A2(n201), .A3(data_in[46]), .X(n268) );
  STQ_EN2_S_2 U285 ( .A1(data_in[2]), .A2(data_in[56]), .X(n253) );
  STQ_EO2_S_2 U286 ( .A1(data_in[16]), .A2(data_in[4]), .X(n328) );
  STQ_EO2_S_2 U287 ( .A1(n203), .A2(n328), .X(n256) );
  STQ_EO3_0P5 U288 ( .A1(n204), .A2(n295), .A3(n256), .X(n209) );
  STQ_EO2_S_2 U289 ( .A1(n259), .A2(data_in[20]), .X(n240) );
  STQ_EO2_S_2 U290 ( .A1(data_in[41]), .A2(data_in[24]), .X(n304) );
  STQ_EO3_0P5 U291 ( .A1(n240), .A2(n304), .A3(n205), .X(n208) );
  STQ_EO3_0P5 U292 ( .A1(n206), .A2(data_in[17]), .A3(n306), .X(n334) );
  STQ_EO3_1 U293 ( .A1(n286), .A2(data_in[26]), .A3(data_in[53]), .X(n219) );
  STQ_EO2_S_2 U294 ( .A1(n261), .A2(data_in[10]), .X(n281) );
  STQ_EO3_0P5 U295 ( .A1(n210), .A2(n310), .A3(n281), .X(n215) );
  STQ_EO3_0P5 U296 ( .A1(n211), .A2(data_in[49]), .A3(data_in[7]), .X(n213) );
  STQ_EO3_0P5 U297 ( .A1(n213), .A2(n212), .A3(n243), .X(n214) );
  STQ_EO3_0P5 U298 ( .A1(n227), .A2(data_in[63]), .A3(data_in[19]), .X(n218)
         );
  STQ_EN2_S_1 U299 ( .A1(n216), .A2(n218), .X(codeword_out[4]) );
  STQ_EO2_S_2 U300 ( .A1(n217), .A2(data_in[14]), .X(n301) );
  STQ_EO2_S_2 U301 ( .A1(n218), .A2(n301), .X(n278) );
  STQ_EO3_0P5 U302 ( .A1(data_in[55]), .A2(data_in[8]), .A3(data_in[22]), .X(
        n220) );
  STQ_EO2_S_2 U303 ( .A1(data_in[48]), .A2(data_in[34]), .X(n264) );
  STQ_EO2_S_2 U304 ( .A1(n264), .A2(data_in[39]), .X(n282) );
  STQ_EN3_3 U305 ( .A1(n220), .A2(n282), .A3(n219), .X(n223) );
  STQ_EO3_0P5 U306 ( .A1(n221), .A2(data_in[13]), .A3(data_in[28]), .X(n222)
         );
  STQ_EO3_1 U307 ( .A1(n278), .A2(n225), .A3(n224), .X(codeword_out[15]) );
  STQ_EO2_S_2 U308 ( .A1(n236), .A2(data_in[33]), .X(n230) );
  STQ_EO2_S_2 U309 ( .A1(data_in[14]), .A2(data_in[38]), .X(n241) );
  STQ_EO3_0P5 U310 ( .A1(n230), .A2(n229), .A3(n241), .X(n231) );
  STQ_EO3_0P5 U311 ( .A1(n232), .A2(n250), .A3(n231), .X(n235) );
  STQ_EO2_S_2 U312 ( .A1(n308), .A2(data_in[45]), .X(n284) );
  STQ_EO2_S_2 U313 ( .A1(n233), .A2(data_in[32]), .X(n275) );
  STQ_EO3_0P5 U314 ( .A1(n284), .A2(n275), .A3(n330), .X(n234) );
  STQ_EO2_S_0P5 U315 ( .A1(n235), .A2(n234), .X(codeword_out[2]) );
  STQ_EO2_S_2 U316 ( .A1(n292), .A2(n236), .X(n309) );
  STQ_EO3_0P5 U317 ( .A1(n309), .A2(n291), .A3(n237), .X(n324) );
  STQ_EO2_S_2 U318 ( .A1(n324), .A2(n238), .X(n247) );
  STQ_EO3_0P5 U319 ( .A1(n240), .A2(data_in[23]), .A3(n239), .X(n251) );
  STQ_EO3_0P5 U320 ( .A1(data_in[52]), .A2(data_in[46]), .A3(data_in[35]), .X(
        n242) );
  STQ_EO2_S_2 U321 ( .A1(n243), .A2(data_in[11]), .X(n318) );
  STQ_EO3_0P5 U322 ( .A1(n245), .A2(n244), .A3(n318), .X(n246) );
  STQ_EO3_0P5 U323 ( .A1(n247), .A2(n251), .A3(n246), .X(codeword_out[0]) );
  STQ_EO3_0P5 U324 ( .A1(n263), .A2(data_in[43]), .A3(data_in[13]), .X(n248)
         );
  STQ_EO3_0P5 U325 ( .A1(n250), .A2(n249), .A3(n248), .X(n252) );
  STQ_EO2_S_2 U326 ( .A1(n252), .A2(n251), .X(n258) );
  STQ_EO3_0P5 U327 ( .A1(n254), .A2(data_in[42]), .A3(n253), .X(n255) );
  STQ_EO2_S_2 U328 ( .A1(n255), .A2(n309), .X(n322) );
  STQ_EO2_S_2 U329 ( .A1(n282), .A2(data_in[29]), .X(n276) );
  STQ_EO3_0P5 U330 ( .A1(n276), .A2(n271), .A3(n256), .X(n257) );
  STQ_EO3_0P5 U331 ( .A1(n258), .A2(n322), .A3(n257), .X(codeword_out[13]) );
  STQ_EO3_0P5 U332 ( .A1(data_in[44]), .A2(data_in[9]), .A3(data_in[35]), .X(
        n260) );
  STQ_EO2_S_2 U333 ( .A1(n260), .A2(n259), .X(n294) );
  STQ_EO3_0P5 U334 ( .A1(data_in[31]), .A2(data_in[25]), .A3(data_in[18]), .X(
        n280) );
  STQ_EO3_0P5 U335 ( .A1(n261), .A2(data_in[21]), .A3(data_in[36]), .X(n262)
         );
  STQ_EO3_1 U336 ( .A1(n294), .A2(n280), .A3(n262), .X(n267) );
  STQ_EO3_0P5 U337 ( .A1(n265), .A2(n264), .A3(n263), .X(n266) );
  STQ_EO2_S_2 U338 ( .A1(n267), .A2(n266), .X(n270) );
  STQ_EO3_0P5 U339 ( .A1(n270), .A2(n269), .A3(n268), .X(codeword_out[6]) );
  STQ_EO2_S_2 U340 ( .A1(n272), .A2(n271), .X(n298) );
  STQ_EO2_S_2 U341 ( .A1(n273), .A2(data_in[2]), .X(n331) );
  STQ_EO3_0P5 U342 ( .A1(n331), .A2(data_in[49]), .A3(data_in[61]), .X(n274)
         );
  STQ_EO3_0P5 U343 ( .A1(n278), .A2(n298), .A3(n277), .X(codeword_out[1]) );
  STQ_EO3_0P5 U344 ( .A1(data_in[43]), .A2(data_in[51]), .A3(data_in[4]), .X(
        n279) );
  STQ_EO2_S_2 U345 ( .A1(n280), .A2(n279), .X(n283) );
  STQ_EO3_0P5 U346 ( .A1(n283), .A2(n282), .A3(n281), .X(n285) );
  STQ_EO2_S_2 U347 ( .A1(n285), .A2(n284), .X(n290) );
  STQ_EO3_0P5 U348 ( .A1(n286), .A2(data_in[47]), .A3(data_in[53]), .X(n287)
         );
  STQ_EO2_S_2 U349 ( .A1(n288), .A2(n287), .X(n321) );
  STQ_EO3_0P5 U350 ( .A1(n290), .A2(n289), .A3(n321), .X(codeword_out[7]) );
  STQ_EO3_0P5 U351 ( .A1(n291), .A2(data_in[7]), .A3(data_in[4]), .X(n293) );
  STQ_EO3_0P5 U352 ( .A1(n296), .A2(n295), .A3(n294), .X(n299) );
  STQ_EO3_0P5 U353 ( .A1(n299), .A2(n298), .A3(n297), .X(codeword_out[9]) );
  STQ_EO2_S_2 U354 ( .A1(n301), .A2(n300), .X(n314) );
  STQ_EO2_S_2 U355 ( .A1(data_in[10]), .A2(data_in[2]), .X(n302) );
  STQ_EO3_0P5 U356 ( .A1(n302), .A2(data_in[52]), .A3(data_in[40]), .X(n303)
         );
  STQ_EO3_0P5 U357 ( .A1(n305), .A2(n304), .A3(n303), .X(n313) );
  STQ_EO3_0P5 U358 ( .A1(n306), .A2(data_in[48]), .A3(data_in[62]), .X(n307)
         );
  STQ_EO3_0P5 U359 ( .A1(n311), .A2(n310), .A3(n309), .X(n312) );
  STQ_EO3_0P5 U360 ( .A1(n314), .A2(n313), .A3(n312), .X(codeword_out[10]) );
  STQ_EO3_0P5 U361 ( .A1(data_in[19]), .A2(data_in[14]), .A3(data_in[40]), .X(
        n317) );
  STQ_EO3_0P5 U362 ( .A1(n315), .A2(data_in[15]), .A3(data_in[20]), .X(n316)
         );
  STQ_EO3_0P5 U363 ( .A1(n318), .A2(n317), .A3(n316), .X(n320) );
  STQ_EO2_S_2 U364 ( .A1(n320), .A2(n319), .X(n323) );
  STQ_EO3_0P5 U365 ( .A1(n323), .A2(n322), .A3(n321), .X(codeword_out[8]) );
  STQ_EO3_0P5 U366 ( .A1(n326), .A2(n325), .A3(n324), .X(n335) );
  STQ_EO3_0P5 U367 ( .A1(n327), .A2(data_in[6]), .A3(data_in[53]), .X(n329) );
  STQ_EO3_0P5 U368 ( .A1(n332), .A2(n331), .A3(n330), .X(n333) );
  STQ_EO3_0P5 U369 ( .A1(n335), .A2(n334), .A3(n333), .X(codeword_out[3]) );
endmodule

