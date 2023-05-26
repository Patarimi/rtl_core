-- File: jc2.vhd
-- Generated by MyHDL 0.11
-- Date: Fri May 26 14:30:59 2023


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

use work.pck_myhdl_011.all;

entity jc2 is
    port (
        go_left: in std_logic;
        go_right: in std_logic;
        stop: in std_logic;
        clk: in std_logic;
        q: inout unsigned(3 downto 0)
    );
end entity jc2;
-- A bidirectional 4-bit Johnson counter with stop control.
-- Parameters
-- ----------
-- go_left : input signal to shift left
-- go_right : input signal to shift right
-- stop : input signal to top counting
-- clk : input free-running clock
-- q : 4-bit counter output

architecture MyHDL of jc2 is


type t_enum_DirType_1 is (
	RIGHT,
	LEFT
	);

signal dire: t_enum_DirType_1;
signal run: std_logic;

begin




JC2_LOGIC: process (clk) is
begin
    if rising_edge(clk) then
        if (go_right = '0') then
            dire <= RIGHT;
            run <= '1';
        elsif (go_left = '0') then
            dire <= LEFT;
            run <= '1';
        end if;
        if (stop = '0') then
            run <= '0';
        end if;
        if bool(run) then
            if (dire = LEFT) then
                q(4-1 downto 1) <= q(3-1 downto 0);
                q(0) <= stdl((not bool(q(3))));
            else
                q(3-1 downto 0) <= q(4-1 downto 1);
                q(3) <= stdl((not bool(q(0))));
            end if;
        end if;
    end if;
end process JC2_LOGIC;

end architecture MyHDL;
