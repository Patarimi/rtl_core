-- File: dff.vhd
-- Generated by MyHDL 0.11
-- Date: Fri May 26 12:33:48 2023


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;

entity dff is
    port (
        q: out std_logic;
        d: in std_logic;
        clk: in std_logic
    );
end entity dff;


architecture MyHDL of dff is




begin




DFF_LOGIC: process (clk) is
begin
    if rising_edge(clk) then
        q <= d;
    end if;
end process DFF_LOGIC;

end architecture MyHDL;