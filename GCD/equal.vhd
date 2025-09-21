library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity equal is
	port(
	a:in std_logic_vector(15 downto 0);
	b:in std_logic_vector(15 downto 0);
	akb:out std_logic
	);
end equal;

architecture dataflow of equal is
begin
	akb <= '0' when (a = b) else '1';
end dataflow;
