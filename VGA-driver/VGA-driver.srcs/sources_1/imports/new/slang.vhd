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
library work;
use work.bitmap_pak.all;

entity slang is
    Port ( 
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnC : in STD_LOGIC;
        clk : in STD_LOGIC;
        positie : out bitmap;
        gametick : in STD_LOGIC;
        xposdot : in integer range 0 to 63;
        yposdot : in integer range 0 to 47;
        score_out : out STD_LOGIC := '0';
        reset_out : out STD_LOGIC := '0'
    );
end slang;

architecture Behavioral of slang is

    signal richting: integer range 0 to 3 := 0;
    signal pos : bitmap := (others => (others => 0));
    signal xposkop: integer range 0 to 64 := 32;
    signal yposkop: integer range 0 to 48 := 24;
    type xbuffer is array(integer range 1 to 100) of integer range 0 to 64;
    type ybuffer is array(integer range 1 to 100) of integer range 0 to 48;
    signal xposstaart: xbuffer;
    signal yposstaart: ybuffer;
    signal lengte: integer range 6 to 100 := 6;
    signal init : bit := '1';
    signal reset : bit := '0';
    signal xdot : integer range 0 to 63 := 0;
    signal ydot : integer range 0 to 47 := 0;
    signal xdotpos : integer range 0 to 63 := 0;
    signal ydotpos : integer range 0 to 47 := 0;
    signal nieuwe_dot : bit := '0';
    signal start : bit := '0';
    signal eerste_dot : bit := '1';

begin
    clk_process : process(start, eerste_dot, gametick, reset, init, nieuwe_dot, pos, xposdot, yposdot)
    begin
        if(start = '1' and eerste_dot = '1') then
            nieuwe_dot <= '1';
        end if;
        if(reset = '1') then                            -- als slang dood gaat -> reset
            pos <= (others => (others => 0));
            yposstaart <= (others => 0);
            xposstaart <= (others => 0);
            xposkop <= 32;
            yposkop <= 24;
            lengte <= 6;
            eerste_dot <= '1';
            reset <= '0';
            init <= '1';
        elsif(init = '1') then                          -- begin positie slang tekenen
            yposstaart(7) <= 24;
            xposstaart(7) <= 32;
            init <= '0';
        elsif(nieuwe_dot = '1') then                    -- als er een dot moet getekend worden
            if(pos(yposdot, xposdot) = 0) then
                xdot <= xposdot;
                ydot <= yposdot;
                nieuwe_dot <= '0';
                eerste_dot <= '0';
            else nieuwe_dot <= '1';
            end if;
        elsif(rising_edge(gametick) and start = '1') then              -- elke gametick uitvoeren
            for i in 1 to 99 loop                   -- de staart 1 blokje opschuiven
                xposstaart(i) <= xposstaart(i+1);
                yposstaart(i) <= yposstaart(i+1);
            end loop;
            if(richting = 0) then   -- richting bepalen
                xposkop <= xposkop - 1;
            elsif(richting = 1) then
                xposkop <= xposkop + 1;
            elsif(richting = 2) then
                yposkop <= yposkop - 1;
            elsif(richting = 3) then
                yposkop <= yposkop + 1;
            end if;
            if(xposkop = xdotpos and yposkop = ydotpos) then -- als dot wordt opgegeten -> signaal voor een nieuwe dot te tekenen
                score_out <= '1';
                lengte <= lengte + 1;
                nieuwe_dot <= '1';
            elsif(pos(yposkop, xposkop) = 1) then
                reset <= '1';
            else
                score_out <= '0';
            end if;

            pos(yposstaart(1), xposstaart(1)) <= 0;
            pos(yposkop, xposkop) <= 1;             -- aan de kop een blokje bijzetten
            xposstaart(lengte) <= xposkop;          -- op de laatste positie komt de positie van de kop
            yposstaart(lengte) <= yposkop;
            if(xposkop < 1 or xposkop > 63 or yposkop < 1 or yposkop > 47) then -- reset als muur wordt geraakt
                reset <= '1';
            end if;
            if(xdot > 0 and ydot > 0) then          -- dot tekenen
                xdotpos <= xdot;
                ydotpos <= ydot;
                pos(ydot, xdot) <= 1;
                xdot <= 0;
                ydot <= 0;
            end if;
        end if;  
    end process;
    
    process (clk, reset)                                       -- knoppen inlezen
    begin
        if reset = '1' then
            richting <= 0;
            start <= '0';
        elsif(rising_edge(clk)) then                   
            if(btnL = '1' and not(richting = 1)) then
                richting <= 0;
            elsif(btnR = '1' and not(richting = 0)) then
                richting <= 1;
            elsif(btnU = '1' and not(richting = 3)) then
                richting <= 2;
            elsif(btnD = '1' and not(richting = 2)) then
                richting <= 3;
            elsif(btnC = '1' and start = '0') then
                reset_out <= '1';
                start <= '1';
            else
                reset_out <= '0';
            end if;
        end if; 
    end process;
    
    process (pos)
    begin
        positie <= pos;
    end process;
end Behavioral;
