library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity bigger is
	port(
	a:in std_logic_vector(15 downto 0);
	b:in std_logic_vector(15 downto 0);
	alb:out std_logic
	);
end bigger;

architecture dataflow of bigger is
begin
	alb <= '1' when (a > b) else '0';
end dataflow;
