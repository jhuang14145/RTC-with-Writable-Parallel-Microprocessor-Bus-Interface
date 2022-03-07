library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulo_24_counter is
	 port(
		rst_n : in std_logic; -- active low synchronous reset
		clk : in std_logic; -- system clock
		clr_n : in std_logic; -- active low synchronous clear
		load_en : in std_logic; -- parallel load counter
		setting : in std_logic_vector(5 downto 0); -- load value
		cnt_en_1 : in std_logic; -- enable count 1
		cnt_en_2 : in std_logic; -- enable count 2
		max_count : out std_logic; -- maximum count flag
		count : out std_logic_vector(5 downto 0) -- BCD count
		);
end modulo_24_counter;

architecture behavior of modulo_24_counter is	
	signal counter : integer := 0; 
	signal max_c : STD_LOGIC := '0';
begin			
	process(clk)
	begin	   			 
		count <= std_logic_vector(to_unsigned(counter,6));
		if(cnt_en_2 = '0') then
			-- do nothing		
		elsif(rst_n = '0') then
			count <= "000000";
			max_count <= '0'; 
			max_c <= '0';
		else 
			if(max_c= '1' and rising_edge(clk)) then
				max_count <= '0';
				max_c <= '0';
			end if;
			
			if(load_en = '1') then
				count <= setting;
			elsif(cnt_en_1 = '1' and rising_edge(clk)) then
				if(counter = 23) then
					max_count <= '1';  
					max_c <= '1';
					counter <= 0;
				else
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;
end behavior;
