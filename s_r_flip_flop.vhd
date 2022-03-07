library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;

entity s_r_flip_flop is
	port(
		s : in std_logic; -- set input
		r : in std_logic; -- reset input
		clk : in std_logic; -- system clock
		rst_n : in std_logic; -- synchronous SET of FF
		q : out std_logic -- FF output
		);
end s_r_flip_flop;

architecture behavior of s_r_flip_flop is 
	signal q_sig: std_logic := '1';
begin	 
	process(clk)
	begin	  			 
		if(rising_edge(clk)) then 
			if(rst_n = '0') then
				q <= '1';
			elsif(s = '1' and r = '0') then		
				q <= '1';	
			elsif(s = '0' and r = '1') then		
				q <= '0';  
			elsif(s = '1' and r = '1') then		
				null;  -- do nothing
			elsif(s = '0' and r = '0') then		
				null; -- do nothing
			end if;
		end if;
	end process;
end behavior;
