library verilog;
use verilog.vl_types.all;
entity test is
    generic(
        INPUT_DATA      : string  := "IN.DAT";
        EXPECT_DATA     : string  := "EXPECT.DAT"
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INPUT_DATA : constant is 1;
    attribute mti_svvh_generic_type of EXPECT_DATA : constant is 1;
end test;
