-- Section 201, Group 9, Sunnie Kapar & Rahul Kumar
library ieee;
use ieee.std_logic_1164.all;

-- Will inver the outputs of the button from active low to high
entity PB_inverters is port (
	rst_n				: in	std_logic;
	rst				: out std_logic;
 	pb_n_filtered	: in  std_logic_vector (3 downto 0);
	pb					: out	std_logic_vector(3 downto 0)							 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
rst <= NOT(rst_n);
pb <= NOT(pb_n_filtered);


end ckt;