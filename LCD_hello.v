//выводит:	hei!

module LCD_hello
(
	input clk,
	
	output reg [7:0] Din, //биты данных
	//RS: 0-команды, 1- data _ RW: 0- write, 1- read
	output reg RS, RW,
	output reg EN //enable
		
);
reg [2:0] a; //вспомогательный регистр. Равен кол-ву выводимых символов
reg [5:0] state, nextstate;

//50MHz * 200ms = 10000000 импульсов. Задержка между операциями 200мс
reg [23:0] count;

parameter init =3'b001; //Инициализация: Шина 8 бит, 2 строки
parameter up =3'b010; //включение дисплея
parameter clear =3'b011; //очистка содержимого
parameter addr_incr =3'b100; //Задает направление перемещения курсора и создаёт сдвиг после каждого введённого символа
//parameter cursor_incr =3'b101; //Сдвиг курсора
parameter data_writing =3'b110; //запись в дисплей


initial 
begin
	a=3'b000;
	state = init;
	nextstate = init;
	RW = 0; 
	RS=0; 
	EN = 0; 
end



//настройка за 1 пройденный цикл
always @(posedge clk)
begin 
state = nextstate;

	case (state)
		
		init: 
		begin
			EN = 1;
			Din = 8'b00111000;
			count = count + 1;
			if (count==10000000)
			begin
				EN = 0;
				count=0;
				nextstate = clear;
			end
			else 
				nextstate = state;
		end
		
		
		clear:
		begin
			EN = 1;
			Din = 8'b00000001;
			count = count + 1;
			if (count==10000000)
			begin
				EN = 0;
				count=0;
				nextstate = addr_incr;
			end
			else 
				nextstate = state;
		end
		
	
		addr_incr:
		begin
			EN = 1;
			Din = 8'b00000110;
			count = count + 1;
			if (count==10000000)
			begin
				EN = 0;
				count=0;
				nextstate = up;
			end
			else 
				nextstate = state;
		end
		
	
		up:
		begin
			EN = 1;
			Din = 8'b00001100;
			count = count + 1;
			if (count==10000000)
			begin
				EN = 0;
				count=0;
				nextstate = data_writing;//cursor_incr;
			end
			else 
				nextstate = state;
		end
		
		/*
		cursor_incr:
		begin
			EN = 1;
			Din = 8'b00010100;
			count = count + 1;
			if (count==10000000)
			begin
				EN = 0;
				count=0;
				nextstate = data_writing;
			end
			else 
				nextstate = state;
		end
		*/
		
		data_writing:
		begin
			RS = 1;
			
			//H
			if (a==3'b000)
			begin
				EN = 1;
				Din = 8'b01001000;
				count = count + 1;
				if (count==10000000)
				begin
					EN = 0;
					count=0;
					a <= 3'b001;
				end
				else 
					nextstate = state;
			end	
			
			
			//e
			if (a==3'b001)
			begin
				EN = 1;
				Din = 8'b01100101;
				count = count + 1;
				if (count==10000000)
				begin
					EN = 0;
					count=0;
					a<=3'b010;
				end
				else 
					nextstate = state;			
			end
			
			//i
			if (a==3'b010)
			begin
				EN = 1;
				Din = 8'b01101001;
				count = count + 1;
				if (count==10000000)
				begin
					EN = 0;
					count=0;
					a<=3'b011;
				end
				else 
					nextstate = state;
			end
				
			//!
			if (a==3'b011)
			begin
				EN = 1;
				Din = 8'b00100001;
				count = count + 1;
				if (count==10000000)
				begin
					EN = 0;
					count=0;
					a<=3'b100;// выход в пустой akways-блок
				end
				else 
					nextstate = state;
			end	
			
		end
	endcase;	
end


endmodule