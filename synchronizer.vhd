-- Section 201, Group 9, Sunnie Kapar & Rahul Kumar
library ieee;
use ieee.std_logic_1164.all;

-- The purpose of the synchronizer is to sync the async buttons with the global synchronous clock
entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg: std_logic_vector(1 downto 0);
BEGIN

	PROCESS (clk) is
	BEGIN 
		if (rising_edge(clk)) then
		-- When the reset is on, then the outputs are 0 for the D-flipflops
			if (reset = '1') then
				sreg <= "00";
			else
		-- the shift register represents the output of a D-flipflop and the output of one D-flipflop acts as the input of the next D-flipflop
				sreg <= sreg(0) & din;
			end if;
		end if;
		dout <= sreg;
	END PROCESS;

end;