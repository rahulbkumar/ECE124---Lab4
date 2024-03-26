-- Section 201, Group 9, Sunnie Kapar & Rahul Kumar
library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg	: std_logic;


BEGIN

	PROCESS (clk) is
	BEGIN
	if (rising_edge(clk)) then
	-- When the clear or reset signal is recieved, the sreg value is cleared
		if (reset = '1' OR register_clr = '1') then
			sreg <= '0';
		else
		-- sreg will hold on to it's original value or the new din input
			sreg <= din OR sreg;
		end if;
	end if;
	END PROCESS
	dout <= sreg;
end;