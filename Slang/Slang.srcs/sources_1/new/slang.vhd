----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2016 11:55:31
-- Design Name: 
-- Module Name: slang - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

package bitmap_pak is
    type bitmap is array(integer range 1 to 48, integer range 1 to 64) of integer range 0 to 1;
end package;

package body bitmap_pak is
end package body;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.bitmap_pak.all;

entity slang is
    Port ( 
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        sw0 : in STD_LOGIC;
        clk : in STD_LOGIC;
        positie : out bitmap;
        gametick : in STD_LOGIC
    );
end slang;

architecture Behavioral of slang is

    signal richting: integer := 0;
--    type bitmap is array(integer range 1 to 48, integer range 1 to 64) of integer range 0 to 1;
    signal pos : bitmap := (others => (others => 0));
    signal xposkop: integer := 32;
    signal yposkop: integer := 24;
    type xbuffer is array(integer range 1 to 100) of integer range 0 to 64;
    type ybuffer is array(integer range 1 to 100) of integer range 0 to 48;
    signal xposstaart: xbuffer;
    signal yposstaart: ybuffer;
    signal lengte: integer := 6;
    signal teller: integer := 0;
    signal init : bit := '1';

begin
    clk_process : process(clk, gametick)
    begin
        if(init = '1') then
            for i in 0 to 5 loop
                pos(24, 32+i) <= 1;
            end loop;
            for i in 6 downto 1 loop
                yposstaart(i) <= 24;
                xposstaart(i) <= 32+teller;
                teller <= teller + 1;
            end loop;
            teller <= 0;
            init <= '0';
        end if;    
        if(rising_edge(gametick)) then
            for i in 1 to 99 loop
                xposstaart(i) <= xposstaart(i+1);
                yposstaart(i) <= yposstaart(i+1);
            end loop;
            if(richting = 0) and (sw0 = '1') then
                xposkop <= xposkop - 1;
            elsif(richting = 1) and (sw0 = '1') then
                xposkop <= xposkop + 1;
            elsif(richting = 2) and (sw0 = '1') then
                yposkop <= yposkop - 1;
            elsif(richting = 3) and (sw0 = '1') then
                yposkop <= yposkop + 1;
            end if;
            pos(yposkop, xposkop) <= 1;
            xposstaart(lengte+1) <= xposkop;
            yposstaart(lengte+1) <= yposkop;
            pos(yposstaart(1), xposstaart(1)) <= 0;
            
        end if;
        if(rising_edge(clk)) then
            -- knoppen inlezen
            if(btnL = '1' and not(richting = 1)) then
                richting <= 0;
            elsif(btnR = '1' and not(richting = 0)) then
                richting <= 1;
            elsif(btnU = '1' and not(richting = 3)) then
                richting <= 2;
            elsif(btnD = '1' and not(richting = 2)) then
                richting <= 3;
            end if;
        end if;
    end process;
    positie <= pos;
end Behavioral;
