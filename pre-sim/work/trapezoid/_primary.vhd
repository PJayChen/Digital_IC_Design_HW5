library verilog;
use verilog.vl_types.all;
entity trapezoid is
    generic(
        S0_RST          : integer := 0;
        S1_WAIT         : integer := 1;
        S2_START        : integer := 2;
        S3_RX_ENDPOINT  : integer := 3;
        S4_PREPARE_CAL  : integer := 4;
        S5_CAL          : integer := 5;
        S6_TX_RESULT    : integer := 6
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        nt              : in     vl_logic;
        xi              : in     vl_logic_vector(7 downto 0);
        yi              : in     vl_logic_vector(7 downto 0);
        busy            : out    vl_logic;
        po              : out    vl_logic;
        xo              : out    vl_logic_vector(7 downto 0);
        yo              : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S0_RST : constant is 1;
    attribute mti_svvh_generic_type of S1_WAIT : constant is 1;
    attribute mti_svvh_generic_type of S2_START : constant is 1;
    attribute mti_svvh_generic_type of S3_RX_ENDPOINT : constant is 1;
    attribute mti_svvh_generic_type of S4_PREPARE_CAL : constant is 1;
    attribute mti_svvh_generic_type of S5_CAL : constant is 1;
    attribute mti_svvh_generic_type of S6_TX_RESULT : constant is 1;
end trapezoid;
