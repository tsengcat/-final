module AEC(clk, rst, ascii_in, ready, valid, result);

// Input signal
input clk;
input rst;
input ready;
input [7:0] ascii_in;

// Output signal
output reg valid;
output reg [6:0] result;


//-----Your design-----//
parameter  idle=3'd0,read=3'd1,postfix=3'd2,clear=3'd5,cal=3'd3,finish=3'd4;
reg [2:0] CS ,NS;
reg postfix_finish , cal_finish;
reg clear_flag , clear_p_flag;
reg [7:0] temp [15:0];
reg [4:0] temp_index;
reg [3:0] temp_index2;

reg [7:0] number [15:0];
reg [7:0] operator [15:0];

reg [4:0] number_index;
reg [4:0] operator_index;

integer i;
always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		CS <= idle;
	end
	else
	begin
		CS <= NS;
	end
end
//state trans
always@(*) 
begin
	case (CS)
		idle: NS = (ready)? read : idle;
		read: NS = (ascii_in == 8'd61)? postfix : read;
		postfix: NS =() ;
		clear: NS = (postfix_finish)? cal : postfix;
		cal: NS =(cal_finish)? finish :cal;
		finish: NS = idle;
		default: NS = idle;
	endcase
end

always@(posedge clk)
begin
	if(rst)
	begin
        postfix_finish = 1'b0;
        cal_finish = 1'b0;
        temp_index = 4'd1;
        for(i=0;i<16;i=i+1)
            temp[i] = 8'd0;
        temp_index2 = 4'd0;
        number_index = 5'd0;
        operator_index = 5'd0;
          
	end
	else if(CS == idle)
	begin
        if(ready)
            temp[0] = ascii_in;
	end
	else if(CS == read)
	begin
        temp[temp_index[3:0]] = ascii_in;
        temp_index = temp_index + 5'd1;
	end	
	else if(CS == postfix)
	begin
       if((temp[temp_index2]>=8'd48&&temp[temp_index2]<=8'd57)||(temp[temp_index2]>=8'd97&&temp[temp_index2]<=8'd102))
       begin
           number[number_index] = temp[temp_index2];
           number_index = number_index + 5'd1;
           temp_index2 = temp_index2 + 4'd1;
       end
       else if(temp[temp_index2] == 8'd42 || temp[temp_index2] == 8'd43 || temp[temp_index2] == 8'd45)
       begin
           if( operator_index == 5'd0 ||operator[operator_index-5'd1] == 8'd40)
           begin
                operator[operator_index] = temp[temp_index2];
                operator_index = operator_index + 5'd1;
                temp_index2 = temp_index2 + 4'd1;
           end
           else if ((operator[operator_index - 5'd1] == 8'd43 ||operator[operator_index - 5'd1] == 8'd45) && (temp[temp_index2] == 8'd43 || temp[temp_index2] == 8'd45))
           begin
                clear_flag = 1'b1;
           end
           else if((operator[operator_index - 5'd1] == 8'd43 ||operator[operator_index - 5'd1] == 8'd45) && temp[temp_index2] == 8'd42)
           begin
                operator[operator_index] = temp[temp_index2];
                operator_index = operator_index + 5'd1;
                temp_index2 = temp_index2 + 4'd1;
           end
           else if(operator[operator_index - 5'd1] == 8'd42 && (temp[temp_index2] == 8'd43 || temp[temp_index2] == 8'd45))
           begin
                clear_flag = 1'b1;
           end
           else if(operator[operator_index - 5'd1] == 8'd42 && temp[temp_index2] == 8'd42)
           begin
                clear_flag = 1'b1;
           end
       end
       else if(temp[temp_index2] == 8'd40)
       begin
            operator[operator_index] = temp[temp_index2];
            operator_index = operator_index + 5'd1;
            temp_index2 = temp_index2 + 4'd1;
       end
       else if(temp[temp_index2] == 8'd41)
            clear_p_flag = 1'b1;
       else if(temp[temp_index2] == 8'd61)
            clear_flag = 1'b1;
	end
    else if(CS == clear)
	begin
        clear_flag = 1'b0;
        if(temp[temp_index2] == 8'd61)
        begin
            if(operator_index >= 5'd1)
            begin
                number[number_index] = operator[operator_index-5'd1];
                number_index = number_index + 5'd1;
                operator_index = operator_index - 5'd1;            
            end
            else
                postfix_finish = 1'b1;

        end
        else
        begin
            
        end
	end
	else if(CS == cal)
	begin

	end
	else
	begin
		
	end
end

always@(*)
begin
	case(CS)
		idle:
		begin
			valid = 1'b0;

		end
		read:
		begin
			valid = 1'b0;

		end
		postfix:
		begin
			valid = 1'b0;

		end
		cal:
		begin
			valid = 1'b0;

		end
		finish:
		begin
			valid = 1'b1;

		end
		default:
		begin
			valid = 1'b0;

		end
	endcase
	
end



endmodule