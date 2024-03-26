
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	
	--sm_clk_en					: out std_logic;
	--blink_signal				: out std_logic;
	--NS_Aled			: out std_logic;
	--NS_Rled				: out std_logic;
	--NS_Gled			: out std_logic;
	--EW_Aled				: out std_logic;
	--EW_Rled			: out std_logic;
	--EW_Gled			: out std_logic;
	-------------------------------------------------------------
	
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
          clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
		clk					: in std_logic;
		reset					: in std_logic;
		din					: in std_logic;
		dout					: out std_logic
);
	end component; 

	component holding_register port (
		clk					: in std_logic;
		reset					: in std_logic;
		register_clr		: in std_logic;
		din					: in std_logic;
		dout					: out std_logic
);
	end component;			
	
	component State_Machine port(
		clk, clk_enable, reset, NS_INPUT, EW_INPUT, blink_signal		: in std_logic; 
		ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green, ns_clear, ew_clear, ns_green_display, ew_green_display	: out std_logic;
		state_number		: out std_logic_vector(3 downto 0)
);
	end component;
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := TRUE;  -- set to FALSE for LogicalStep board downloads
																			  	-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic;
	SIGNAL sm_clken, blink_sig							: std_logic; 
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); 
	signal ns_synch_output					: std_logic; -- synchronizer output for NS
	signal ew_synch_output					: std_logic; -- synchronzier output for EW
	signal ns_register_out					: std_logic; -- holding registar output for NS
	signal ew_register_out					: std_logic; -- holding registar output for EW
	signal ns_red, ns_amber, ns_green	: std_logic; -- signals associated with the state of the light for NS
	signal ns_output 							: std_logic_vector (6 downto 0); -- concatenated output to display on FBGA board for NS
	signal ew_red, ew_amber, ew_green	: std_logic; -- signals associated with the state of the light for EW
	signal ew_output 							: std_logic_vector (6 downto 0); -- concatenated output to display on FBGA board for EW
	signal ns_clear, ew_clear				: std_logic; -- signals used to clear the pedestrian signals
	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);
INST3: synchronizer     port map (clkin_50,synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST4: synchronizer 		port map (clkin_50, synch_rst, 
INST9: State_Machine port map (clkin_50, sm_clken, synch_rst, ns_register_out, ew_register_out,
											  blink_sig, ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green,
  										     ns_clear, ew_clear, leds(0), leds(2), leds(7 downto 4)); -- state machine

END SimpleCircuit;
