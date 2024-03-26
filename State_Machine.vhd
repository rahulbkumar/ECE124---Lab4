-- Section 201, Group 9, Sunnie Kapar & Rahul Kumar
library ieee;
use ieee.std_logic_1164.all;

-- A mealy state machine is created as the outputs depend on the current state.
-- The input signal also depends on the current state. 

entity TLC_State_Machine is port (
 	clk, clk_enable, reset, NS_INPUT, EW_INPUT, blink_signal		: in std_logic; -- inputs signal connected to the outputs of the registers
	NS_Red, NS_Yellow, NS_Green, EW_Red, EW_Yellow, EW_Green, NS_Clear, EW_Clear, NS_Green_display, EW_Green_display	: out std_logic;
	State_Number		: out std_logic_vector(3 downto 0)
	); 
end TLC_State_Machine;

-- EW_Red, EW_Yellow, EW_Green are the outputs for the second digit to be displayed
-- NS_Red, NS_Yellow, NS_Green are the outputs for the second digit to be displayed
-- NS_Clear, EW_Clear connects to the registar output to clear the appropriate state
-- EW_input is the button to request to cross in the EW direction
-- NS_input is the button to request to cross in the NS direction

architecture processState of TLC_State_Machine is

type STATE_NAMES is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15); -- All STATE_NAMES values

signal Current_State, Next_State		: STATE_NAMES; -- Creating signals of types STATE_NAMES

BEGIN

-- Logic for Register --

Registar_Logic: process (clk, clk_enable) 
begin
	
	if (rising_edge(clk)) then -- At the rising edge is when the state machine works
		if (reset = '1') then -- A reset is conducted when the reset variable is on
			Current_State <= s0; 
		elsif (reset = '0' AND clk_enable = '1') then
			Current_State <= Next_State;
		end if;
	end if;
end process;


-- STATE TRANSITION LOGIC --
Transition_Logic: process (NS_INPUT, EW_INPUT, Current_State)

	begin
		case Current_State is
			when s0 => 
			-- If EW is active and NS is not, then the state jumps to 6
				if ((NS_INPUT = '0') AND (EW_INPUT = '1')) THEN 
					Next_State <= s6;
				else 	
					-- Otherwise it goes to the next state
					Next_State <= s1;
				end if;
				
			when s1 => 
			-- Same reasoning as State 0
				if ((NS_INPUT = '0') AND (EW_INPUT = '1')) THEN 
					Next_State <= s6;
				else 
				-- Same reasoning as State 0
					Next_State <= s2; 									
				end if;
			
			-- These proceeding states will just go to the next state
			when s2 =>
				Next_State <= s3; 
			
			when s3 =>
				Next_State <= s4; 
			
			when s4 =>
				Next_State <= s5; 
			
			when s5 =>
				Next_State <= s6; 
			
			when s6 =>
				Next_State <= s7; 
				
			when s7 =>
				Next_State <= s8; 
			
			when s8 => 
				if ((NS_INPUT = '1') AND (EW_INPUT = '0')) THEN
				-- If NS is active and EW is not, then the state jumps to 14					
				Next_State <= s14;
				else 															
				-- Otherwise it goes to the next state
					Next_State <= s9;
				end if;
				
			when s9 => 
				if ((NS_INPUT = '1') AND (EW_INPUT = '0')) THEN 
				-- when the holding registar for EW is active and NW is not, it jumps
					Next_State <= s14;
				else 															
				-- when the holding registar for EW is active and NW is also active, it continues
					Next_State <= s10;
				end if;
			
			-- These proceeding states will just go to the next state
			when s10 =>
				Next_State <= s11; 
			
			when s11 =>
				Next_State <= s12; 
				
			when s12 =>
				Next_State <= s13; 
				
			when s13 =>
				Next_State <= s14; 
				
			when s14 =>
				Next_State <= s15;
				
			when s15 =>
				Next_State <= s0; 
				
		end case;
		
	end process;

-- DECODER LOGIC PROCESS --
-- In accordance to the current state, the decoder outputs the desired values, 
-- which is related to the red, amber, green light, NS light, EW light, the pedestrian signal, and current state number

 Decoder_Logic: process (blink_signal, Current_State)
	
	begin
		
		case Current_State is
			
			when s0 => 
				State_Number <= "0000";
				NS_Red <= '0';
				NS_Yellow <= '0';
				-- The blink signal causes the NS_Green to visually blink
				NS_Green <= blink_signal; 
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';
				
			when s1 => 
				State_Number <= "0001";
				NS_Red <= '0';
				NS_Yellow <= '0';
				-- The blink signal causes the NS_Green to visually blink
				NS_Green <= blink_signal;
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';		
				
			when s2 => 
				State_Number <= "0010";
				NS_Red <= '0';
				NS_Yellow <= '0';
				NS_Green <= '1';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '1';
				EW_Green_display <= '0';				
				
			when s3 => 
				State_Number <= "0011";
				NS_Red <= '0';
				NS_Yellow <= '0';
				NS_Green <= '1';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '1';
				EW_Green_display <= '0';
						
			when s4 => 
				State_Number <= "0100";
				NS_Red <= '0';
				NS_Yellow <= '0';
				NS_Green <= '1';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '1';
				EW_Green_display <= '0';
					
			when s5 => 
				State_Number <= "0101";
				NS_Red <= '0';
				NS_Yellow <= '0';
				NS_Green <= '1';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '1';
				EW_Green_display <= '0';
						
			when s6 => 
				State_Number <= "0110";
				NS_Red <= '0';
				NS_Yellow <= '1';
				NS_Green <= '0';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '1'; 
				-- the clear for the NS register
				NS_Green_display <= '0';
				EW_Green_display <= '0';			
				
			when s7 => 
				State_Number <= "0111";
				NS_Red <= '0';
				NS_Yellow <= '1';
				NS_Green <= '0';
				EW_Red <= '1';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';
							
			when s8 => 
				State_Number <= "1000";
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				-- The blink signal causes the EW_Green to visually blink
				EW_Green <= blink_signal;
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';		
			
			when s9 => 
				State_Number <= "1001";
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				-- The blink signal causes the EW_Green to visually blink
				EW_Green <= blink_signal;
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';
				
			when s10 =>
				State_Number <= "1010";	
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				EW_Green <= '1';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '1';
						
			when s11 => 
				State_Number <= "1011";
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				EW_Green <= '1';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '1';		
			
			when s12 =>
				State_Number <= "1100";	
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				EW_Green <= '1';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '1';	
			
			when s13 =>
				State_Number <= "1101";	
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				EW_Green <= '1';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '1';
				
			when s14 =>
				State_Number <= "1110";	
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '1';
				EW_Green <= '0';
				-- the clear for the EW register
				EW_Clear <= '1'; 
				NS_Clear <= '0'; 
				NS_Green_display <= '0';
				EW_Green_display <= '0';
				
			when s15 => 
				State_Number <= "1111";
				NS_Red <= '1';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '1';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';
				
			when others => 
				NS_Red <= '0';
				NS_Yellow <= '0';
				NS_Green <= '0';
				EW_Red <= '0';
				EW_Yellow <= '0';
				EW_Green <= '0';
				
				EW_Clear <= '0';
				NS_Clear <= '0';
				NS_Green_display <= '0';
				EW_Green_display <= '0';
				
		end case;
	end process;
	
end architecture processState;