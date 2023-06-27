`timescale 1ps/1ps

module keep2mty (
	input logic [15:0] tkeep,
	output logic [3:0] mty
);
	always_comb begin
		if (tkeep[0]) begin
			mty = 4'd0;
		end
		else if (tkeep[1]) begin
			mty = 4'd1;
		end
		else if (tkeep[2]) begin
			mty = 4'd2;
		end
		else if (tkeep[3]) begin
			mty = 4'd3;
		end
		else if (tkeep[4]) begin
			mty = 4'd4;
		end
		else if (tkeep[5]) begin
			mty = 4'd5;
		end
		else if (tkeep[6]) begin
			mty = 4'd6;
		end
		else if (tkeep[7]) begin
			mty = 4'd7;
		end
		else if (tkeep[8]) begin
			mty = 4'd8;
		end
		else if (tkeep[9]) begin
			mty = 4'd9;
		end
		else if (tkeep[10]) begin
			mty = 4'd10;
		end
		else if (tkeep[11]) begin
			mty = 4'd11;
		end
		else if (tkeep[12]) begin
			mty = 4'd12;
		end
		else if (tkeep[13]) begin
			mty = 4'd13;
		end
		else if (tkeep[14]) begin
			mty = 4'd14;
		end
		else if (tkeep[15]) begin
			mty = 4'd15;
		end
		else begin
			mty = 4'd0;
		end
	end
endmodule
