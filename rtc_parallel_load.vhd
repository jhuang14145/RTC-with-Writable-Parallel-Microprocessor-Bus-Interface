library IEEE;
use IEEE.std_logic_1164.all;   
use ieee.numeric_std;
library Task3;
use Task3.all; 


entity rtc_parallel_load is
	 port(
		rst_n : in std_logic; -- active low synchronous reset
		clk : in std_logic; -- system clock
		clr_n : in std_logic; -- active low synchronous clear
		address : in std_logic_vector(3 downto 0);
		data : in std_logic_vector(7 downto 0);
		wr_n : in std_logic; -- write control signal
		cs_n : in std_logic; -- chip select signal
		cnt_en_1 : in std_logic;-- enable count 1
		max_count : out std_logic;
		count_sec : out std_logic_vector(6 downto 0);-- BCD sec count
		count_min : out std_logic_vector(6 downto 0);-- BCD min count
		count_hour : out std_logic_vector(5 downto 0)-- BCD hour count
		);
end rtc_parallel_load;

architecture structure of rtc_parallel_load is		
	signal ape_w: STD_LOGIC; 
	signal y_mux: std_logic_vector(9 downto 0);
	signal load_sec : std_logic; 
	signal load_min : std_logic; 
	signal load_hour : std_logic;
	signal flip_flop_q : std_logic;	   
	signal flip_flop_s: std_logic;
	signal flip_flop_r: std_logic;	 
	signal data_sec : std_logic_vector(6 downto 0);
	signal data_min : std_logic_vector(6 downto 0);
	signal data_hour : std_logic_vector(5 downto 0);
	signal dummy: STD_LOGIC;
	
begin
	data_sec(0) <= data(0);	
	data_min(0) <= data(0);
	data_hour(0) <= data(0);
	
	data_sec(1) <= data(1);	
	data_min(1) <= data(1);
	data_hour(1) <= data(1);
	
	data_sec(2) <= data(2);	
	data_min(2) <= data(2);
	data_hour(2) <= data(2);  
	
	data_sec(3) <= data(3);	
	data_min(3) <= data(3);
	data_hour(3) <= data(3); 
	
	data_sec(4) <= data(4);	
	data_min(4) <= data(4);
	data_hour(4) <= data(4);  
	
	data_sec(5) <= data(5);	
	data_min(5) <= data(5);
	data_hour(5) <= data(5);
	
	data_sec(6) <= data(6);	
	data_min(6) <= data(6);	   
	
	
	
	
	
	u0: entity pos_edge_detector port map(
			a => wr_n, 
			rst_n  => rst_n,
			clk => clk,
			a_pe => ape_w
			);				 
			
	u1: entity write_address_decoder port map(
			wr => ape_w, 
			cs_n => cs_n, 
			address => address, 
			--y => y_mux,
			
			y(0) => flip_flop_r,
			y(1) => load_sec, 
			y(2) => load_min,
			y(3) => load_hour,
			y(4) => flip_flop_s,
			y(5) => dummy,
			y(6) =>	dummy,
			y(7) =>	dummy,
			y(8) =>	dummy,
			y(9) =>	dummy
			); 
			
	u2: entity s_r_flip_flop port map(
			s => flip_flop_s,
			r => flip_flop_r,
			clk => clk, 
			rst_n => rst_n, 		  	 
			q => flip_flop_q
			);
	
	u3: entity clock_chain port map(
			rst_n => rst_n,
			clk => clk,
			clr_n => clr_n, 
			load_sec_en => load_sec, 
			load_min_en => load_min, 
			load_hour_en => load_hour,
			setting_sec => data_sec, 
			setting_min => data_min,
			setting_hour => data_hour, 
			cnt_en_1 => cnt_en_1, 
			cnt_en_2 => flip_flop_q,
			max_count => max_count,
			count_sec => count_sec, 
			count_min => count_min,
			count_hour => count_hour
			);	
			
	
end structure;
