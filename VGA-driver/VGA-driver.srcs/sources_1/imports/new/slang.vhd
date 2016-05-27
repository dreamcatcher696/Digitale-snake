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
        reset_out : out STD_LOGIC := '0';
        punt_out : out STD_LOGIC := '0'
    );
end slang;

architecture Behavioral of slang is

    signal richting: integer range 0 to 3 := 0;
    signal huidige_richting: integer range 0 to 3 := 0;
    signal pos : bitmap := (others => (others => 0));
    signal xposkop: integer range 0 to 64 := 32;
    signal yposkop: integer range 0 to 48 := 24;
    type xbuffer is array(integer range 1 to 100) of integer range 0 to 64;
    type ybuffer is array(integer range 1 to 100) of integer range 0 to 48;
    type homescreen is array(0 to 15) of std_logic_vector(0 to 63);
    signal xposstaart: xbuffer;
    signal yposstaart: ybuffer;
    signal home: homescreen := (
        "0000111111100110000000100001111111000010000000100011111111100000",
        "0000100000000101000000100010000000100010000001000010000000000000",
        "0000100000000100100000100100000000010010000010000010000000000000",
        "0000100000000100010000100100000000010010000100000010000000000000",
        "0000100000000100001000100100000000010010001000000010000000000000",
        "0000100000000100000100100100000000010010010000000010000000000000",
        "0000100000000100000010100100000000010010100000000010000000000000",
        "0000111111100100000001100111111111110011000000000011111111100000",
        "0000000000100100000000100100000000010010100000000010000000000000",
        "0000000000100100000000100100000000010010010000000010000000000000",
        "0000000000100100000000100100000000010010001000000010000000000000",
        "0000000000100100000000100100000000010010000100000010000000000000",
        "0000000000100100000000100100000000010010000010000010000000000000",
        "0000000000100100000000100100000000010010000001000010000000000000",
        "0000000000100100000000100100000000010010000000100010000000000000",
        "0000111111100100000000100100000000010010000000010011111111100000"
    );
    signal lengte: integer range 6 to 100 := 6;
    signal reset : bit := '0';
    signal xdot : integer range 0 to 63 := 0;
    signal ydot : integer range 0 to 47 := 0;
    signal xdotpos : integer range 0 to 63 := 0;
    signal ydotpos : integer range 0 to 47 := 0;
    signal nieuwe_dot : bit := '0';
    signal start : bit := '0';
    signal eerste_dot : bit := '1';
    signal gametickenable : bit := '1';
    
    function to_int( x : std_logic ) return integer is
    begin
      if x = '1' then
        return 1;
      else
        return 0;
      end if;
    end function;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if(start = '1' and eerste_dot = '1') then
                pos <= (others => (others => 0));
                nieuwe_dot <= '1';
            elsif(start = '0') then
                for i in 0 to 15 loop
                    for j in 0 to 63 loop
                        pos(i+16, j) <= to_int(home(i)(j));
                    end loop;
                end loop;
            end if;
            if(reset = '1') then                            -- als slang dood gaat -> reset
                pos <= (others => (others => 0));
                yposstaart <= (others => 0);
                xposstaart <= (others => 0);
                xposkop <= 32;
                yposkop <= 24;
                lengte <= 6;
                eerste_dot <= '1';
                reset <= '0';                        -- begin positie slang tekenen
                yposstaart(7) <= 24;
                xposstaart(7) <= 32;
            elsif(nieuwe_dot = '1') then                    -- als er een dot moet getekend worden
                if(pos(yposdot, xposdot) = 0) then
                    xdot <= xposdot;
                    ydot <= yposdot;
                    nieuwe_dot <= '0';
                    eerste_dot <= '0';
                else
                    nieuwe_dot <= '1';
                end if;
            end if;
            if(gametick = '1' and start = '1' and gametickenable = '1') then              -- elke gametick uitvoeren
                gametickenable <= '0';
                for i in 1 to 99 loop                   -- de staart 1 blokje opschuiven
                    xposstaart(i) <= xposstaart(i+1);
                    yposstaart(i) <= yposstaart(i+1);
                end loop;
                if(richting = 0) then   -- richting bepalen
                    huidige_richting <= 0;
                    xposkop <= xposkop - 1;
                elsif(richting = 1) then
                    huidige_richting <= 1;
                    xposkop <= xposkop + 1;
                elsif(richting = 2) then
                    huidige_richting <= 2;
                    yposkop <= yposkop - 1;
                elsif(richting = 3) then
                    huidige_richting <= 3;
                    yposkop <= yposkop + 1;
                end if;
                if(xposkop = xdotpos and yposkop = ydotpos) then -- als dot wordt opgegeten -> signaal voor een nieuwe dot te tekenen
                    punt_out <= '1';
                    lengte <= lengte + 1;
                    nieuwe_dot <= '1';
                elsif(pos(yposkop, xposkop) = 1) then
                    reset <= '1';
                else
                    punt_out <= '0';
                end if;
    
                pos(yposstaart(1), xposstaart(1)) <= 0;
                pos(yposkop, xposkop) <= 1;             -- aan de kop een blokje bijzetten
                xposstaart(lengte) <= xposkop;          -- op de laatste positie komt de positie van de kop
                yposstaart(lengte) <= yposkop;
                if(xposkop = 0 or xposkop = 63 or yposkop = 0 or yposkop = 47) then -- reset als muur wordt geraakt
                    reset <= '1';
                end if;
                if(xdot > 0 and ydot > 0) then          -- dot tekenen
                    xdotpos <= xdot;
                    ydotpos <= ydot;
                    pos(ydot, xdot) <= 1;
                    xdot <= 0;
                    ydot <= 0;
                end if;
            elsif (gametick = '0' and gametickenable = '0') then
                gametickenable <= '1';
            end if;           
        end if;
    end process;
    
    process (clk, reset)                                       -- knoppen inlezen
    begin
        if reset = '1' then
            richting <= 0;
            start <= '0';
            reset_out <= '0';
        elsif(rising_edge(clk)) then                   
            if(btnL = '1' and not(huidige_richting = 1)) then
                richting <= 0;
            elsif(btnR = '1' and not(huidige_richting = 0)) then
                richting <= 1;
            elsif(btnU = '1' and not(huidige_richting = 3)) then
                richting <= 2;
            elsif(btnD = '1' and not(huidige_richting = 2)) then
                richting <= 3;
            elsif(btnC = '1' and start = '0') then
                reset_out <= '1';
                start <= '1';
            end if;
        end if; 
    end process;
    
    process (pos)
    begin
        positie <= pos;
    end process;
end Behavioral;
