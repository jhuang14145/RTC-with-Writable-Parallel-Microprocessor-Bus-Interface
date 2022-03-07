-- Testbench for Task 2 Laboratory 11 - clock chain entity
	
-- This testbench tests the basic operatioin of the count chain.
-- It does not verify clr_n, cnt_ent_2, nor setting an initial
-- count. However, you design must have this capability.

library ieee;
use ieee.std_logic_1164.all;  
library Task2;
use Task2.all;

entity clock_chain_tb is
end clock_chain_tb;

architecture tb_architecture of clock_chain_tb is	
	-- stimulus signals
	signal rst_n : std_logic;
	signal clk : std_logic := '0';
	signal clr_n : std_logic;
	signal load_sec_en : std_logic;
	signal load_min_en : std_logic;
	signal load_hour_en : std_logic;
	signal setting_sec : std_logic_vector(6 downto 0);
	signal setting_min : std_logic_vector(6 downto 0);
	signal setting_hour : std_logic_vector(5 downto 0);
	signal cnt_en_1 : std_logic;
	signal cnt_en_2 : std_logic;
	-- observed signals
	signal max_count : std_logic;
	signal count_sec : std_logic_vector(6 downto 0);
	signal count_min : std_logic_vector(6 downto 0);
	signal count_hour : std_logic_vector(5 downto 0);
	
	constant period : time := 1us;
	
begin	
	-- unit under test port map
	uut : entity clock_chain
	port map (
		rst_n => rst_n,
		clk => clk,
		clr_n => clr_n,
		load_sec_en => load_sec_en,
		load_min_en => load_min_en,
		load_hour_en => load_hour_en,
		setting_sec => setting_sec,
		setting_min => setting_min,
		setting_hour => setting_hour,
		cnt_en_1 => cnt_en_1,
		cnt_en_2 => cnt_en_2,
		max_count => max_count,
		count_sec => count_sec,
		count_min => count_min,
		count_hour => count_hour
		);
		
	rst_n <= '0', '1' after 3 * period;	-- reset signal
	
	clr_n <= '1';	-- control and data signals	unused in this sim
	cnt_en_2 <= '1';
	load_sec_en <= '0';
	load_min_en <= '0';
	load_hour_en <= '0';
	setting_sec <= "0000000";
	setting_min <= "0000000";
	setting_hour <= "000000";	
		
	-- count enable pulses generated at an artifically high rate to
	-- speed up  simulation (not at 32.768 kHz)
	cnt_en_pulse: process 
	begin
		-- Every 10 iterations of the following loop gives one
		-- enable pulse. It would take 864000 interations of the  
		-- to rollover the entire chain
		for i in 0 to 6000 loop	-- 600 enable pulses
		wait for 9 us;
		cnt_en_1 <= '1';
		wait for 1us;
		cnt_en_1 <= '0';
		end loop;
		std.env.finish;
	end process;
	
	-- system clock
	sys_clk: process
	begin
		wait for period / 2.0;
		clk <= not clk;
		
	end process;
	
end tb_architecture;



