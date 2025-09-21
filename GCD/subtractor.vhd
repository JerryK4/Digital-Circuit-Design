library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
    port(
        x   : in  std_logic_vector(15 downto 0);
        y   : in  std_logic_vector(15 downto 0);
        sub : out std_logic_vector(15 downto 0)
    );
end subtractor;

architecture behav of subtractor is
begin
    -- V� lu�n x >= y n�n d�ng unsigned tr? s? kh�ng ra s? �m
    sub <= std_logic_vector(unsigned(x) - unsigned(y));
end behav;

