library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;
        a_sel  : in  std_logic;
        b_sel  : in  std_logic;
        en_a   : in  std_logic;
        en_b   : in  std_logic;
        en_gcd : in  std_logic;
        mem_a  : in  std_logic_vector(15 downto 0);
        mem_b  : in  std_logic_vector(15 downto 0);
        akb    : out std_logic;
        alb    : out std_logic;
        gcd    : out std_logic_vector(15 downto 0);
        a_out  : out std_logic_vector(15 downto 0); -- current A register
        b_out  : out std_logic_vector(15 downto 0)  -- current B register
    );
end datapath;

architecture structural of datapath is

    component mux2to1 is
        port(
            sel     : in  std_logic;
            I0      : in  std_logic_vector(15 downto 0);
            I1      : in  std_logic_vector(15 downto 0);
            out_mux : out std_logic_vector(15 downto 0)
        );
    end component;

    component reg16 is
        port(
            clk   : in  std_logic;
            reset : in  std_logic;
            en    : in  std_logic;
            D     : in  std_logic_vector(15 downto 0);
            Q     : out std_logic_vector(15 downto 0)
        );
    end component;

    component bigger is
        port(
            a   : in  std_logic_vector(15 downto 0);
            b   : in  std_logic_vector(15 downto 0);
            alb : out std_logic
        );
    end component;

    component equal is
        port(
            a   : in  std_logic_vector(15 downto 0);
            b   : in  std_logic_vector(15 downto 0);
            akb : out std_logic
        );
    end component;

    component subtractor is
        port(
            x   : in  std_logic_vector(15 downto 0);
            y   : in  std_logic_vector(15 downto 0);
            sub : out std_logic_vector(15 downto 0)
        );
    end component;

    -- internal signals
    signal asub_out   : std_logic_vector(15 downto 0);
    signal bsub_out   : std_logic_vector(15 downto 0);
    signal ain_reg16  : std_logic_vector(15 downto 0);
    signal bin_reg16  : std_logic_vector(15 downto 0);
    signal a_reg      : std_logic_vector(15 downto 0);
    signal b_reg      : std_logic_vector(15 downto 0);

begin

    -- MUX for A input: I0 = mem_a (load), I1 = asub_out (update)
    MUXA: mux2to1
        port map (
            sel     => a_sel,
            I0      => mem_a,
            I1      => asub_out,
            out_mux => ain_reg16
        );

    -- MUX for B input: I0 = mem_b (load), I1 = bsub_out (update)
    MUXB: mux2to1
        port map (
            sel     => b_sel,
            I0      => mem_b,
            I1      => bsub_out,
            out_mux => bin_reg16
        );

    -- Registers A and B
    REGA: reg16
        port map (
            clk   => clk,
            reset => reset,
            en    => en_a,
            D     => ain_reg16,
            Q     => a_reg
        );

    REGB: reg16
        port map (
            clk   => clk,
            reset => reset,
            en    => en_b,
            D     => bin_reg16,
            Q     => b_reg
        );

    -- Subtractors (combinational)
    SUBA: subtractor
        port map (
            x   => a_reg,
            y   => b_reg,
            sub => asub_out
        );

    SUBB: subtractor
        port map (
            x   => b_reg,
            y   => a_reg,
            sub => bsub_out
        );

    -- Comparators
    EQ: equal
        port map (
            a   => a_reg,
            b   => b_reg,
            akb => akb
        );

    BIG: bigger
        port map (
            a   => a_reg,
            b   => b_reg,
            alb => alb
        );

    -- Write GCD when en_gcd asserted (register captures a_reg into gcd)
    REGGCD: reg16
        port map (
            clk   => clk,
            reset => reset,
            en    => en_gcd,
            D     => a_reg,
            Q     => gcd
        );

    -- expose current registers for observation
    a_out <= a_reg;
    b_out <= b_reg;

end structural;

