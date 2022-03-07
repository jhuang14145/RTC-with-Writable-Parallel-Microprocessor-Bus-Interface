library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library Task3;
use Task3.all;

entity rtc_parallel_load_one_sec is
	port(
		rst_n : in std_logic; -- active low synchronous reset
		clk : in std_logic; -- system clock
		clr_n : in std_logic; -- active low synchronous clear
		address : in std_logic_vector(3 downto 0);
		data : in std_logic_vector(6 downto 0);
		wr_n : in std_logic; -- write control strobe, active low
		cs_n : in std_logic; -- chip select strobe, active low
		f32768hz : in std_logic; -- 32.768 kHz oscillator input
		max_count : out std_logic;-- max count
		one_hz : out std_logic; -- one Hz output square wave
		count_sec : out std_logic_vector(6 downto 0); -- BCD sec count
		count_min : out std_logic_vector(6 downto 0); -- BCD min count
		count_hour : out std_logic_vector(5 downto 0) -- BCD hour count
		); 
		attribute loc: string; 
		attribute loc of f32768hz: signal is "D3";
		attribute loc of rst_n: signal is "F1";
		attribute loc of clk: signal is "J1";
		attribute loc of clr_n: signal is "C2";
		attribute loc of cs_n: signal is "E10";
		attribute loc of wr_n: signal is "B4";
		
		attribute loc of data: signal is "A13,F8,C12,F9,E8,E7,D7";
		attribute loc of address: signal is "C5,E6,A10,D9";

		attribute loc of one_hz: signal is "B5";
		attribute loc of max_count: signal is "D6";
		attribute loc of count_sec: signal is "A3,A4,A5,B7,B9,F7,C4";
		attribute loc of count_min: signal is "B1, E3, F5,F2,E2,D2,C1";
		attribute loc of count_hour: signal is "H2,G2,L3,K4,K1,J3";

end rtc_parallel_load_one_sec;

architecture structural of rtc_parallel_load_one_sec is	  
	signal c_n_1 : std_logic;	
	signal data_longer : std_logic_vector(7 downto 0);
begin  
	data_longer(0) <= data(0);
	data_longer(1) <= data(1);
	data_longer(2) <= data(2);
	data_longer(3) <= data(3);
	data_longer(4) <= data(4);
	data_longer(5) <= data(5);
	data_longer(6) <= data(6);
	data_longer(7) <= '0';
	
	u4: entity rtc_parallel_load port map(
		rst_n => rst_n,
		clk => clk,
		clr_n => clr_n,
		address => address,
		data => data_longer,
		wr_n=> wr_n,
		cs_n => cs_n,
		cnt_en_1 => c_n_1,
		max_count => max_count,
		count_sec => count_sec,
		count_min => count_min,
		count_hour => count_hour
		);		 
	
	u5: entity one_sec_counter port map(											  								  
		f32768hz => f32768hz,
		clk => clk,
		rst_n => rst_n,
		clr_n => clr_n,
		one_sec_tick => c_n_1,
		one_hz => one_hz 
		);
		
end structural;

