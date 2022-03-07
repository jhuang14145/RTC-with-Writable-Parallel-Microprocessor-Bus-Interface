library IEEE;
use IEEE.std_logic_1164.all;
library Task3;
use Task3.all;

entity one_sec_counter is
	 port(
		 f32768hz : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 rst_n : in STD_LOGIC;
		 clr_n : in STD_LOGIC;
		 one_sec_tick : out STD_LOGIC;
		 one_hz : out STD_LOGIC
	     );
end one_sec_counter;

architecture structure of one_sec_counter is		
	signal a_pe_temp : STD_LOGIC; 
	signal one_second_tick : STD_LOGIC;
	signal one_hz_wave : STD_LOGIC;
begin	
	
	   
	u0: entity pos_edge_detector port map(
		a => f32768hz,
		rst_n => rst_n,
		clk => clk,
		a_pe => a_pe_temp); 
		
	u1: entity one_sec_prescalar port map(
		clk => clk, 
		rst_n => rst_n, 
		clr_n => clr_n, 
		cnt_en => a_pe_temp, 	 	
		one_hz => one_hz_wave, 
		one_sec_tick => one_second_tick); 
	
	one_sec_tick <= one_second_tick;
	one_hz <= one_hz_wave;

end structure;
