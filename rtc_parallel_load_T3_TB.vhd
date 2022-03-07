-- Testbench for Task 3 Laboratory 11 Top-Level rtc_parallel_load

-- Ken Short
	
-- This testbench uses procedures to simulate the bus functional
-- operation of an 80C188EB microprocessor to provide stimulus to
-- the rtc_parallel_load UUT. This micoprocessor uses "Intel Style"
-- bus signals and is representative of many micropprocessor system
-- buses.

-- Two procedures are given a write procedure and a read procedure.
-- Only the write procedure is actually used in this testbench.
-- You do not need to understand the details of VHDL procedures to
-- follow this testbench. These details will be covered later in the
-- course.

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;   

library Task3;
use Task3.all;

entity rtc_parallel_load_tb is
end rtc_parallel_load_tb;

architecture tb_architecture of rtc_parallel_load_tb is	

	constant cpu_clk_period : time := 8 us; -- 125 kHZ up clock
	constant tclov2_min : time := 3 ns; -- for 13 MHz speed grade
	constant tclov2_max : time := 30 ns; -- for 13 MHz speed grade
	constant tpd_addr_latch : time := 7 ns; -- for address latch
		
	procedure read_cycle (
		addr : in std_logic_vector(19 downto 0); -- address specified
		signal data_rd : out std_logic_vector(7 downto 0); -- data read
		wait_states : in integer; -- number of wait states
		signal clk : in std_logic;
		signal addr_out : out std_logic_vector(19 downto 0); -- address generated
		signal data : inout std_logic_vector(7 downto 0); -- data written or read
		signal rd_bar : out std_logic) -- cpu read control signal
		is
	begin
		wait on clk until clk = '0'; -- T1
		addr_out <= addr after tclov2_max + tpd_addr_latch;
		data <= (others => 'Z') after tclov2_max;
		wait on clk until clk = '0'; -- T2
		rd_bar <= '0' after tclov2_max;
		wait on clk until clk = '0'; -- T3
		for i in 1 to wait_states loop -- TW
			wait on clk until clk = '0';
		end loop;
		wait on clk until clk = '0'; -- T4
		
		data_rd <= data;
		rd_bar <= '1' after tclov2_min;
		wait on clk until clk = '1';
		addr_out <= (others => 'X') after tclov2_min + tpd_addr_latch;
	end read_cycle;
	
	procedure write_cycle (
		addr : in std_logic_vector(19 downto 0); -- address specified
		data_wr : in std_logic_vector(7 downto 0); -- data to write
		wait_states : in integer; -- number of wait states
		signal clk : in std_logic;
		signal addr_out : out std_logic_vector(19 downto 0); -- address generated
		signal data : inout std_logic_vector(7 downto 0); -- data writen or read
		signal wr_bar : out std_logic) -- cpu write control signal
		is
	begin
		wait on clk until clk = '0'; -- T1
		addr_out <= addr after tclov2_max + tpd_addr_latch;
		data <= (others => 'Z') after tclov2_max;
		wait on clk until clk = '0'; -- T2
		data <= data_wr after tclov2_max;
		wr_bar <= '0' after tclov2_max;
		wait on clk until clk = '0'; -- T3
		for i in 1 to wait_states loop -- TW
			wait on clk until clk = '0';
		end loop;
		wait on clk until clk = '0'; -- T4
		wr_bar <= '1' after tclov2_min;
		wait on clk until clk = '1';
		addr_out <= (others => 'X') after tclov2_min + tpd_addr_latch;
		data <= (others => 'Z') after tclov2_min;
	end write_cycle;
	
	procedure bus_idle (
		signal clk : in std_logic;
		signal rd_bar : out std_logic; -- cpu read control signal
		signal wr_bar : out std_logic) -- cpu write control signal
		is
	begin
		wait on clk until clk = '0'; -- T idle
		rd_bar <= '1' after tclov2_max;
		wr_bar <= '1' after tclov2_max;
		wait on clk until clk = '1';
	end bus_idle;	
	
	---------------- end procedure declarations	

	
	-------------------- FPGA signals

	signal fpga_clk : std_logic := '0';
	signal clr_n : std_logic;
	signal cs_n : std_logic;
	signal cnt_en_1 : std_logic;
	-- Observed signals
	signal max_count : std_logic;
	signal count_sec : std_logic_vector(6 downto 0);
	signal count_min : std_logic_vector(6 downto 0);
	signal count_hour : std_logic_vector(5 downto 0);
	
	constant fpga_period : time := 1us;
	
	--------------------- Microprocessor signals

	signal addr_cpu: std_logic_vector (19 downto 0);
	signal data_cpu: std_logic_vector (7 downto 0);
	signal wr_bar_cpu: std_logic;
	signal rd_bar_cpu: std_logic;
	signal clkout: std_logic := '0';
	signal cpu_reset_bar : std_logic;
	
	-------------------------------------------
	
begin	
	-- Unit Under Test port map
	UUT : entity rtc_parallel_load
	port map (
		rst_n => cpu_reset_bar,
		clk => fpga_clk,
		clr_n => clr_n,
		address => addr_cpu(3 downto 0),
		data => data_cpu,
		wr_n => wr_bar_cpu,
		cs_n => cs_n,
		cnt_en_1 => cnt_en_1,
		max_count => max_count,
		count_sec => count_sec,
		count_min => count_min,
		count_hour => count_hour
		);
	
	-------------------------	
	
	cpu_reset_bar <= '0', '1' after 3 * cpu_clk_period;	-- reset signal
	
	clr_n <= '1';			-- unused control and data signals
	
	-- count enable pulses generated at artifically high rate to
	-- speed up the simulation
	cnt_en_pulse: process 
	begin
		for i in 0 to 6000 loop
			wait for 9 us;
			cnt_en_1 <= '1';
			wait for 1us;
			cnt_en_1 <= '0';
		end loop;
		--	std.env.finish;
	end process;
	
	-- microprocessor clock
	cpu_clock_gen : clkout <= not clkout after cpu_clk_period/2;

	
	-- system clock for FPGA ("clk")
	sys_clk: process
	begin
		wait for fpga_period / 2.0;
		fpga_clk <= not fpga_clk;
		
	end process;
	
	--------------------------- Stimulous from microprocessor	
	
	-- The write procedure is called five times to stop the clock chain
	-- set the seconds, minutes, and hours, and then start the clock chain
	cpu_stimulus: process
	begin		
		rd_bar_cpu <= '1';
		wr_bar_cpu <= '1';
		cs_n <= '1';
		wait for 100 us;
		cs_n <= '0';		-- select RTC
		
		-- stop clock chain from counting
		write_cycle(x"08000", x"00", 0, clkout, addr_cpu, data_cpu, wr_bar_cpu);
		
		-- set seconds
		write_cycle(x"08001", x"56", 0, clkout, addr_cpu, data_cpu, wr_bar_cpu);
		
		-- set minutes
		write_cycle(x"08002", x"59", 0, clkout, addr_cpu, data_cpu, wr_bar_cpu);
		
		-- set hours
		write_cycle(x"08003", x"01", 0, clkout, addr_cpu, data_cpu, wr_bar_cpu);
		
		-- start clock chain
		write_cycle(x"08004", x"00", 0, clkout, addr_cpu, data_cpu, wr_bar_cpu);
		
		cs_n <= '1';		-- unselect RTC		
		wait for 30 sec;
		std.env.finish;		
	end process;
	
	
end tb_architecture;



