library ieee;
use ieee.std_logic_1164.all;

entity microprocessor is 
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;
        done    : out std_logic;
        a_out   : out std_logic_vector(15 downto 0);
        b_out   : out std_logic_vector(15 downto 0);
        gcd_out : out std_logic_vector(15 downto 0)
    );
end microprocessor;

architecture structural of microprocessor is

    ----------------------------------------------------------------
    -- Component declarations (must match your compiled components)
    ----------------------------------------------------------------
    component memory is
        port(
            mem_a : out std_logic_vector(15 downto 0);
            mem_b : out std_logic_vector(15 downto 0)
        );
    end component;

    component controller is
        port(
            start  : in  std_logic;
            clk    : in  std_logic;
            akb    : in  std_logic;
            alb    : in  std_logic;
            reset  : in  std_logic;
            a_sel  : out std_logic;
            b_sel  : out std_logic;
            en_a   : out std_logic;
            en_b   : out std_logic;
            en_gcd : out std_logic;
            done   : out std_logic
        );
    end component;

    component datapath is
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
    end component;

    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal mem_a_sig, mem_b_sig : std_logic_vector(15 downto 0);
    signal akb_sig, alb_sig     : std_logic;
    signal a_sel_sig, b_sel_sig : std_logic;
    signal en_a_sig, en_b_sig   : std_logic;
    signal en_gcd_sig           : std_logic;

begin

    ----------------------------------------------------------------
    -- Memory instance
    ----------------------------------------------------------------
    ROM: memory
        port map (
            mem_a => mem_a_sig,
            mem_b => mem_b_sig
        );

    ----------------------------------------------------------------
    -- Datapath instance
    ----------------------------------------------------------------
    DP: datapath
        port map (
            clk    => clk,
            reset  => reset,
            a_sel  => a_sel_sig,
            b_sel  => b_sel_sig,
            en_a   => en_a_sig,
            en_b   => en_b_sig,
            en_gcd => en_gcd_sig,
            mem_a  => mem_a_sig,
            mem_b  => mem_b_sig,
            akb    => akb_sig,
            alb    => alb_sig,
            gcd    => gcd_out,
            a_out  => a_out,
            b_out  => b_out
        );

    ----------------------------------------------------------------
    -- Controller instance
    ----------------------------------------------------------------
    CU: controller
        port map (
            start  => start,
            clk    => clk,
            akb    => akb_sig,
            alb    => alb_sig,
            reset  => reset,
            a_sel  => a_sel_sig,
            b_sel  => b_sel_sig,
            en_a   => en_a_sig,
            en_b   => en_b_sig,
            en_gcd => en_gcd_sig,
            done   => done
        );

end structural;

