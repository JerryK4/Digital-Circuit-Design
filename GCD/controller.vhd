library ieee;
use ieee.std_logic_1164.all;

entity controller is
	port(
		start:in std_logic;
		clk:in std_logic;
		akb:in std_logic;
		alb:in std_logic;
		reset:in std_logic;
		a_sel:out std_logic;
		b_sel:out std_logic;
		en_a:out std_logic;
		en_b:out std_logic;
		en_gcd:out std_logic;
		done:out std_logic
	);
end controller;

architecture fsm of controller is
	type state_type is (S0,S1,S2,S3,S4,S5,S6,S7);
	signal state: state_type;
begin
	-- States transition process
	FSM: process(reset, clk)
	begin
		if reset = '1' then
			state <= S0;
		elsif clk'event and clk = '1' then
			case state is
				when S0 =>
					if start = '1' then
						state <= S1;
					else
						state <= S0;
					end if;
				when S1 =>
					state <= S2;
				when S2 =>
					if akb = '1' then
						state <= S5;
					else
						state <= S3;
					end if;
				when S3 =>
					state <= S3;
				when S4 =>
					state <= S0;
				when S5 =>
					if alb = '1' then
						state <= S6;
					else
						state <= S7;
					end if;  
				when S6 =>
					state <= S2;
				when S7 =>
					state <= S2;
			end case;
		end if;
	end process;

	-- Combinational logic for outputs
	--a_sel  <= '1' when state = S1 else '0';
	--b_sel  <= '1' when state = S1 else '0';
	--done   <= '1' when state = S4 else '0';
	--en_a   <= '1' when (state = S1) or (state = S6) else '0';
	--en_b   <= '1' when (state = S1) or (state = S7) else '0';
	--en_gcd <= '1' when state = S3 else '0';
	-- assume S1 is load, S6 perform A:=A-B, S7 perform B:=B-A
a_sel  <= '0' when state = S1 else '1';  -- '0' selects mem at S1, '1' select asub_out at S6 (if en_a=1)
b_sel  <= '0' when state = S1 else '1';
en_a   <= '1' when (state = S1) or (state = S6) else '0';
en_b   <= '1' when (state = S1) or (state = S7) else '0';
en_gcd <= '1' when state = S3 else '0';
done   <= '1' when (state = S3) or (state = S4) else '0';

end fsm;

