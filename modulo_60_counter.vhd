library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulo_60_counter is
	 port(
		rst_n : in std_logic; -- active low synchronous reset
		clk : in std_logic; -- system clock
		clr_n : in std_logic; -- active low synchronous clear
		load_en : in std_logic; -- parallel load counter
		setting : in std_logic_vector(6 downto 0); -- load value
		cnt_en_1 : in std_logic; -- enable count 1
		cnt_en_2 : in std_logic; -- enable count 2
		max_count : out std_logic; -- maximum count flag
		count : out std_logic_vector(6 downto 0) -- BCD count
		);
end modulo_60_counter;

architecture behavior of modulo_60_counter is	
	
begin		
	process(clk)  
	variable counter_dig1 : integer := 0;  -- this is the tens place  	 
	variable counter_dig2 : integer := 0;  -- this is the ones place 
	variable max_c : std_logic := '0';
	begin
		if(rising_edge(clk)) then 		
			if(rst_n = '0') then
				count <= "0000000";
				counter_dig1 := 0;
				counter_dig2 := 0; 
			else 
				if(max_c= '1') then
					max_count <= '0';
					max_c := '0';
				end if;  
				
				if(load_en = '1') then 
					counter_dig2 := (to_integer(unsigned(setting(6 downto 4))));   -- updates the tens place in bcd
					counter_dig1 := (to_integer(unsigned(setting(3 downto 0))));	    -- updates the ones place in bcd
				elsif(cnt_en_2 = '0') then 
					null; -- do nothing;			
				elsif(cnt_en_1 = '1') then
					if(counter_dig1 = 9) then
						if(counter_dig2 = 5 and counter_dig1 = 9) then
							max_count <= '1';  
							max_c := '1';
							counter_dig1 := 0;
							counter_dig2 := 0; 
						else
							counter_dig2 := counter_dig2 + 1;
							counter_dig1 := 0;
						end if;		
					else
						counter_dig1 := counter_dig1 + 1;		
					end if;	 
					
				end if;
			end if;	
		end if;
		count <= std_logic_vector(to_unsigned(counter_dig2,3)) & std_logic_vector(to_unsigned(counter_dig1,4));
	end process;
end behavior;