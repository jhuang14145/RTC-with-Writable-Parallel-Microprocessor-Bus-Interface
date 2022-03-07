library IEEE;
use IEEE.std_logic_1164.all; 
library Task2;
use Task2.all;

entity clock_chain is
	port(
		rst_n : in std_logic; -- active low synchronous reset
		clk : in std_logic; -- system clock
		clr_n : in std_logic; -- active low synchronous clear
		load_sec_en : in std_logic; -- parallel load active high
		load_min_en : in std_logic; -- parallel load active high
		load_hour_en : in std_logic; -- parallel load active high
		setting_sec : in std_logic_vector(6 downto 0); -- load value
		setting_min : in std_logic_vector(6 downto 0); -- load value
		setting_hour : in std_logic_vector(5 downto 0); -- load value
		cnt_en_1 : in std_logic; -- enable count 1
		cnt_en_2 : in std_logic; -- enable count 2
		max_count : out std_logic; -- maximum count flag
		count_sec : out std_logic_vector(6 downto 0); -- BCD count
		count_min : out std_logic_vector(6 downto 0); -- BCD count
		count_hour : out std_logic_vector(5 downto 0) -- BCD count
		);
end clock_chain;

architecture structure of clock_chain is   
	signal count_s : std_logic_vector(6 downto 0);
	signal count_m : std_logic_vector(6 downto 0);
	signal count_h : std_logic_vector(5 downto 0); 
	--signal cnt_en_sec: std_logic;	  
	--signal cnt_en_min: std_logic;
	signal cnt_max_sec: std_logic;
	signal cnt_max_min: std_logic;
	
begin
	
	u0: entity modulo_60_counter port map(
		rst_n => rst_n,
		clk => clk,
		clr_n => clr_n,	  
		load_en => load_sec_en,
		setting => setting_sec,
		cnt_en_1 => cnt_en_1,	
		cnt_en_2 => cnt_en_2, 
		max_count => cnt_max_sec,
		count => count_s); 	 
		count_sec <= count_s;
		
	u1: entity modulo_60_counter port map(
		rst_n => rst_n,
		clk => clk,
		clr_n => clr_n,	  
		load_en => load_min_en,
		setting => setting_min,
		cnt_en_1 => cnt_max_sec, 
		cnt_en_2 => cnt_en_2, 
		max_count => cnt_max_min,
		count => count_m);	 
		count_min <= count_m;
		
	u2: entity modulo_24_counter port map(
		rst_n => rst_n,
		clk => clk,
		clr_n => clr_n,	  
		load_en => load_hour_en,
		setting => setting_hour,
		cnt_en_1 => cnt_max_min,
		cnt_en_2 => cnt_en_2,
		max_count => max_count,
		count => count_h); 
		count_hour <= count_h;
		
end structure;
