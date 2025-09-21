library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port(
	sel:in std_logic;
	I0:in std_logic_vector(15 downto 0);
	I1:in std_logic_vector(15 downto 0);
	out_mux:out std_logic_vector(15 downto 0)
	);
end mux2to1;

architecture behav of mux2to1 is
begin
	process(sel,I0,I1)
	begin
		case sel is
			when '0' => out_mux <= I0;
			when '1' => out_mux <= I1;
			when others => null;
		end case;
	end process;
end behav;
