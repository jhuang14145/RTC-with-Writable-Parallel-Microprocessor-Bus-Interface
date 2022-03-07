library IEEE;
use IEEE.std_logic_1164.all;  
use ieee.numeric_std.all;

entity one_sec_prescalar is
	 port(
		 clk : in STD_LOGIC;
		 rst_n : in STD_LOGIC;
		 clr_n : in STD_LOGIC;
		 cnt_en : in STD_LOGIC;
		 one_hz : out STD_LOGIC;
		 one_sec_tick : out STD_LOGIC
	     );
end one_sec_prescalar;

architecture arch of one_sec_prescalar is	 
	signal counter : integer; 
	signal hz : STD_LOGIC;	  	   				   
	signal one_hz_prev: STD_LOGIC;	 -- used as a flag for the one second pulse	
begin
	process(clk)
	begin		  
		if(rising_edge(clk)) then
			if(hz = '1') then
					hz <= '0';			  		  
					one_sec_tick <= '0'; 
			end if;
			
			if(rst_n = '0') then	 
				one_hz <= '0'; 
				counter <= 0;		   
				one_sec_tick <= '0';
				one_hz_prev <= '0';
			elsif(cnt_en = '1' and rising_edge(clk)) then  
				
				if(counter = 16338) then
					one_hz_prev <= not one_hz_prev;
					one_hz <= one_hz_prev;
				end if;
				
				if(counter = 32767) then
					counter <= 0; 	
					hz <= '1';
					one_sec_tick <= '1';
				else
					counter <= counter + 1;	
				end if;	 
			end if;	
		end if;	
	end process;
	--one_hz <= one_hz_prev;
end arch;
