#include <ap_int.h>
void keep2mty(
	ap_uint<16> 	keep,
	ap_uint<4>	&mty
) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INLINE
/*
	if (keep[0]) {
		mty = 0;
	} else if (keep[1]) {
		mty = 1;
	} else if (keep[2]) {
                mty = 2;
        } else if (keep[3]) {
                mty = 3;
        } else if (keep[4]) {
                mty = 4;
        } else if (keep[5]) {
                mty = 5;
        } else if (keep[6]) {
                mty = 6;
        } else if (keep[7]) {
                mty = 7;
        } else if (keep[8]) {
                mty = 8;
        } else if (keep[9]) {
                mty = 9;
        } else if (keep[10]) {
                mty = 10;
        } else if (keep[11]) {
                mty = 11;
        } else if (keep[12]) {
                mty = 12;
        } else if (keep[13]) {
                mty = 13;
        } else if (keep[14]) {
                mty = 14;
        } else if (keep[15]) {
                mty = 15;
        } else {
		mty = 0;
	}
*/
	switch(keep) {
		case 65535: //16'b1111111111111111
			mty = 0;
			break;
		case 65534: //16'b1111111111111110
			mty = 1;
			break;
		case 65532: //16'b1111111111111100
			mty = 2;
			break;
		case 65528: //16'b1111111111111000
			mty = 3;
			break;
		case 65520: //16'b1111111111110000
			mty = 4;
			break;
		case 65504: //16'b1111111111100000
			mty = 5;
			break;
		case 65472: //16'b1111111111000000
			mty = 6;
			break;
		case 65408: //16'b1111111110000000
			mty = 7;
			break;
		case 65280: //16'b1111111100000000
			mty = 8;
			break;
		case 65024: //16'b1111111000000000
			mty = 9;
			break;
		case 64512: //16'b1111110000000000
			mty = 10;
			break;
		case 63488: //16'b1111100000000000
			mty = 11;
			break;
		case 61440: //16'b1111000000000000
			mty = 12;
			break;
		case 57344: //16'b1110000000000000
			mty = 13;
			break;
		case 49152: //16'b1100000000000000
			mty = 14;
			break;
		case 32768: //16'b1000000000000000
			mty = 15;
			break;
	}
}
