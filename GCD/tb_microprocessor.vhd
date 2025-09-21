library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_microprocessor is
end tb_microprocessor;

architecture behavior of tb_microprocessor is

    -- Component under test
    component microprocessor is
        port(
            clk     : in  std_logic;
            reset   : in  std_logic;
            start   : in  std_logic;
            done    : out std_logic;
            a_out   : out std_logic_vector(15 downto 0);
            b_out   : out std_logic_vector(15 downto 0);
            gcd_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal start   : std_logic := '0';
    signal done    : std_logic;
    signal a_out   : std_logic_vector(15 downto 0);
    signal b_out   : std_logic_vector(15 downto 0);
    signal gcd_out : std_logic_vector(15 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    --------------------------------------------------------------------
    -- Instantiate the DUT
    --------------------------------------------------------------------
    uut: microprocessor
        port map (
            clk     => clk,
            reset   => reset,
            start   => start,
            done    => done,
            a_out   => a_out,
            b_out   => b_out,
            gcd_out => gcd_out
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Stimulus process
    --------------------------------------------------------------------
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        wait for clk_period * 5;
        reset <= '0';
        wait for clk_period * 2;

        -- Start the computation
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Wait until done or timeout
        wait until done = '1' for 1 ms;

        if done = '1' then
            report "DONE: GCD = " & integer'image(to_integer(unsigned(gcd_out)));
        else
            report "Timeout: done not asserted!" severity warning;
        end if;

        wait for clk_period * 5;
        assert false report "End of simulation." severity failure;
    end process;

    --------------------------------------------------------------------
    -- Monitor process: print A, B, GCD at every clock
    --------------------------------------------------------------------
    monitor_proc: process(clk)
    begin
        if rising_edge(clk) then
            report "Cycle: A=" & integer'image(to_integer(unsigned(a_out))) &
                   " , B=" & integer'image(to_integer(unsigned(b_out))) &
                   " , GCD=" & integer'image(to_integer(unsigned(gcd_out)));
        end if;
    end process;

end behavior;

