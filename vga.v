// adapted from NERP demo vga640x480.v

`default_nettype none


`include "baudgen.vh"

module vga(
	input wire pclk,		//pll clock: 25.13MHz
	input wire clr,			//asynchronous reset
	input wire rx, 			//receive wire
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output wire r0,
	output wire r1,
	output wire g0,
	output wire g1,
	output wire b0,
	output wire b1,
	output wire D5,
	output reg [3:0] leds
	);

wire clk;

localparam BAUD = `B115200;

  SB_PLL40_CORE #(.FEEDBACK_PATH("SIMPLE"),
                  .PLLOUT_SELECT("GENCLK"),
                  .DIVR(4'b0001),
                  .DIVF(7'b1000010),
                  .DIVQ(3'b100),
                  .FILTER_RANGE(3'b001),
                 ) uut (
                         .REFERENCECLK(pclk),
                         .PLLOUTCORE(clk),
                         .LOCK(D5),
                         .RESETB(1'b1),
                         .BYPASS(1'b0)
                        );

// video structure constants
parameter hpixels = 800; // horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;  //size 10
reg [9:0] vc;  //size 10


wire [7:0] data;
wire [7:0] outputcopy;
reg uartreset = 0;
wire dataindicate;



uart_rx #(BAUD)
	UR0 (
		.clk(pclk),
		.rstn(uartreset),
		.rx(rx),
		.rcv(dataindicate),
		.data(data)
	);



always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end



	
	end
	
end



//this is being skipped
always @(posedge pclk)
begin

	uartreset <= 1;
	if (dataindicate == 1'b1)
	begin
				outputcopy <= data[7:0];
      			
	end
	  		
end

//hpulse == 96
//vpulse = 2
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;


always @(hc,vc)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (hc >= hbp && hc < (hbp+640)) //144 --- 224
		begin
			//makes screen all back
			r0 <= 0;
			r1 <= 0;
			g0 <= 0;
			g1 <= 0;
			b0 <= 0;
			b1 <= 0;
		
			//verticle lines
			//first line
			if(vc == 111 || vc == 112 || vc == 113 )  //31 + 120 = 151
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;
			end
			//second
			if(vc  ==  191  || vc == 192 || vc == 193) // 151 + 120   voltage high for uart
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(outputcopy[7] == 1 &&  hc >= 208 && hc <= 272 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[6] == 1 &&  hc >= 272 && hc <= 336 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[5] == 1 &&  hc >= 336 && hc <= 400 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end
				if(outputcopy[4] == 1 && hc >= 400 && hc <= 464)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[3] == 1 && hc >= 464 && hc <= 528)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[2] == 1 && hc >= 528 && hc <= 592)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[1] == 1 && hc >= 592 && hc <= 656)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[0] == 1 && hc >= 656 && hc <= 720)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

			end

			//third
			if(vc == 271 || vc == 272 || vc == 273)   //starting position for uart 
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;
			end

			if(vc == 351 || vc == 352 || vc == 353)  //voltage low for uart
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(outputcopy[7] == 0 &&  hc >= 208 && hc <= 272 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[6] == 0 &&  hc >= 272 && hc <= 336 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[5] == 0 &&  hc >= 336 && hc <= 400 )
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end
				if(outputcopy[4] == 0 && hc >= 400 && hc <= 464)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[3] == 0 && hc >= 464 && hc <= 528)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[2] == 0 && hc >= 528 && hc <= 592)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[1] == 0 && hc >= 592 && hc <= 656)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

				if(outputcopy[0] == 0 && hc >= 656 && hc <= 720)
				begin
					r0 <= 0;
					r1 <= 0;
					g0 <= 1;
					g1 <= 1;
					b0 <= 0;
					b1 <= 0;
				end

		
			end
			
			if(vc == 431 || vc == 432 || vc == 433)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;
			end

			//horizontal lines
			//starts at 144 - 784
			if(hc == 208)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;
			
			end
			
			if(hc == 272) //staring bit
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;


				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[7] == 0 && outputcopy[6] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[7] == 1 && outputcopy[6] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 336)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[6] == 0 && outputcopy[5] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[6] == 1 && outputcopy[5] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end


			if(hc == 400)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[5] == 0 && outputcopy[4] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[5] == 1 && outputcopy[4] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 464)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[4] == 0 && outputcopy[3] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[4] == 1 && outputcopy[3] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 528)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[3] == 0 && outputcopy[2] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[3] == 1 && outputcopy[2] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 592)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[2] == 0 && outputcopy[1] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[2] == 1 && outputcopy[1] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 656)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;

				if(vc >= 191  && vc <= 353)
				begin
					if( outputcopy[1] == 0 && outputcopy[0] == 1)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end

					if( outputcopy[1] == 1 && outputcopy[0] == 0)
					begin
							r0 <= 0;
							r1 <= 0;
							g0 <= 1;
							g1 <= 1;
							b0 <= 0;
							b1 <= 0;
					end
				end
			end

			if(hc == 720)
			begin
			r0 <= 1;
			r1 <= 1;
			g0 <= 1;
			g1 <= 1;
			b0 <= 0;
			b1 <= 0;
			end

		end
			// we're outside active horizontal range so display black
		else
		begin
			r0 <= 0;
			r1 <= 0;
			g0 <= 0;
			g1 <= 0;
			b0 <= 0;
			b1 <= 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
			r0 <= 0;
			r1 <= 0;
			g0 <= 0;
			g1 <= 0;
			b0 <= 0;
			b1 <= 0;
	end
end

endmodule
