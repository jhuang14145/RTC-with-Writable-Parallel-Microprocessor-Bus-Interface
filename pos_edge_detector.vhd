library IEEE;
use IEEE.std_logic_1164.all;  
use ieee.numeric_std.all;

entity pos_edge_detector is
	 port(
		 a : in STD_LOGIC;
		 rst_n : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 a_pe : out STD_LOGIC
	     );
end pos_edge_detector;

architecture arch of pos_edge_detector is
	signal c : STD_LOGIC;     -- temp variable
begin  	   
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst_n = '0') then
				a_pe <= '0';  
				c <= '0';
			elsif(rising_edge(clk)) then 
				c <= a;
				a_pe <= not c and a;   -- flip flop
			end if;						
		end if;	
	end process;
end arch;
