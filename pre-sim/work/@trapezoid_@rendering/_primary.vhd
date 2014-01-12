library verilog;
use verilog.vl_types.all;
entity Trapezoid_Rendering is
    generic(
        S0_RST          : integer := 0;
        S1_PAR_INIT     : integer := 1;
        S2_OUTER_LOOP   : integer := 2;
        S3_END_X_INIT   : integer := 3;
        S4_OUTPUT       : integer := 4;
        S5_INCRESE_SLOPE: integer := 5;
        S6_FINISH       : integer := 6
    );
    port(
        finish          : out    vl_logic;
        po              : out    vl_logic;
        xo              : out    vl_logic_vector(7 downto 0);
        yo              : out    vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        count_flag      : in     vl_logic;
        point_x         : in     vl_logic_vector(31 downto 0);
        point_y         : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S0_RST : constant is 1;
    attribute mti_svvh_generic_type of S1_PAR_INIT : constant is 1;
    attribute mti_svvh_generic_type of S2_OUTER_LOOP : constant is 1;
    attribute mti_svvh_generic_type of S3_END_X_INIT : constant is 1;
    attribute mti_svvh_generic_type of S4_OUTPUT : constant is 1;
    attribute mti_svvh_generic_type of S5_INCRESE_SLOPE : constant is 1;
    attribute mti_svvh_generic_type of S6_FINISH : constant is 1;
end Trapezoid_Rendering;
