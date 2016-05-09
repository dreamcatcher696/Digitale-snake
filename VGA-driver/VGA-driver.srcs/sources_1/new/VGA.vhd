----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2016 15:16:22
-- Design Name: 
-- Module Name: VGA - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.bitmap_pak.all;

entity main is
    Port ( 
           clk : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           vgaRed : out  STD_LOGIC_VECTOR (2 downto 0) := "000";
           vgaGreen : out  STD_LOGIC_VECTOR (2 downto 0) := "000";
           vgaBlue : out  STD_LOGIC_VECTOR (2 downto 0) := "000";
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnC : in STD_LOGIC
            );
end main;

architecture Behavioral of main is

component Clock_divider is
    Port ( clk : in STD_LOGIC;
           div : in STD_LOGIC_VECTOR (1 downto 0);
           clk_slow : out STD_LOGIC);
end component Clock_divider;

component Slang is
    Port ( clk : in STD_LOGIC;
        btnC : in STD_LOGIC;
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        positie : out bitmap;
        gametick : in STD_LOGIC;
        xposdot : in integer range 0 to 63;
        yposdot : in integer range 0 to 47;
        score_out : out STD_LOGIC;
        reset_out : out STD_LOGIC;
        punt_out : out STD_LOGIC
    );
end component Slang;

component randomdot is
    Port (
        clk : in std_logic;
        xpos : out integer range 0 to 63;
        ypos : out integer range 0 to 47
    );
end component randomdot;

component vga_driver is
    Port ( 
            clk     : in STD_LOGIC;
            hsync_sig   : out STD_LOGIC;
            vsync_sig   : out STD_LOGIC;
            vgaRed_sig  : out STD_LOGIC_VECTOR (2 downto 0) := "000";
            vgaGreen_sig: out STD_LOGIC_VECTOR (2 downto 0) := "000";
            vgaBlue_sig : out STD_LOGIC_VECTOR (2 downto 0) := "000"; 
            pos_sig     : in  bitmap
    );
end component vga_driver;

component score is
    Port (
            clk     : in STD_LOGIC;
            seg     : out STD_LOGIC_VECTOR(6 downto 0);
            an      : out STD_LOGIC_VECTOR(3 downto 0);
            score_in: in STD_LOGIC;
            reset_sig : in STD_LOGIC;
            punt_sig : in STD_LOGIC            
            );
end component score;

    signal hcounter : integer := 0;
    signal vcounter : integer := 0;
    signal deler : integer range 0 to 4 := 0;
    signal gametick: std_logic;
    signal richting: integer := 0;
    signal pos : bitmap := (others => (others => 0));
    signal xposdot: integer range 0 to 63;
    signal yposdot: integer range 0 to 47;
    signal scorebit: STD_LOGIC := '0';
    signal reset_sig: STD_LOGIC := '0';
    signal punt_sig_temp: STD_LOGIC := '0';

begin

clk_divider: Clock_divider
port map(clk=>clk,div=>"01",clk_slow=>gametick);

rand: randomdot
port map(clk=>clk,xpos=>xposdot,ypos=>yposdot);

Slang1: slang
port map(clk=>clk,btnC=>btnC,btnL=>btnL,btnR=>btnR,btnU=>btnU,btnD=>btnD,gametick=>gametick,positie=>pos,xposdot=>xposdot,yposdot=>yposdot,score_out=>scorebit,reset_out=>reset_sig, punt_out=>punt_sig_temp);

tekenen: vga_driver
port map(clk=>clk,hsync_sig=>hsync,vsync_sig=>vsync,vgaRed_sig=>vgaRed,vgaGreen_sig=>vgaGreen,vgaBlue_sig=>vgaBlue,pos_sig=>pos);

punten: score
port map(clk=>clk, seg=>seg, an=>an, score_in=>scorebit, reset_sig=>reset_sig, punt_sig=>punt_sig_temp);

end Behavioral;