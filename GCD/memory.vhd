library ieee;
use ieee.std_logic_1164.all;

entity memory is
	port(
	mem_a:out std_logic_vector(15 downto 0);
	mem_b:out std_logic_vector(15 downto 0)
	);
end memory;

architecture mem of memory is
	constant INIT_A : std_logic_vector(15 downto 0) := x"0008"; -- decimal 42
    	constant INIT_B : std_logic_vector(15 downto 0) := x"002A"; -- decimal 8
begin
	mem_a <= INIT_A;
	mem_b <= INIT_B;
end mem;
