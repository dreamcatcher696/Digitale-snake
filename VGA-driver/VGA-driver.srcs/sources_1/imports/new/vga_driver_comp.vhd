----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2016 12:12:06 PM
-- Design Name: 
-- Module Name: vga_driver - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_driver is
    Port (  clk     : in STD_LOGIC;
            hsync_sig   : out STD_LOGIC;
            vsync_sig   : out STD_LOGIC;
            vgaRed_sig  : out STD_LOGIC_VECTOR (2 downto 0) := "000";
            vgaGreen_sig: out STD_LOGIC_VECTOR (2 downto 0) := "000";
            vgaBlue_sig : out STD_LOGIC_VECTOR (2 downto 0) := "000"; 
            pos_sig     : in  bitmap
          );
end vga_driver;

architecture Behavioral of vga_driver is

signal hcounter_sig : integer range 0 to 799 := 0 ;
signal vcounter_sig : integer range 0 to 524 := 0;
signal deler        : integer range 0 to 3 := 0;
begin

process(clk) begin
    if(rising_edge(clk)) then
        -- refresh rate van 25 mhz, basys werkt op 100 => delen door 4
        deler <= deler +1;
        if(deler = 3) then
            deler <= 0;
            
            if(hcounter_sig =799) then
                hcounter_sig <= 0;
--                if (vcounter_sig = 524) then
                if (vcounter_sig = 524) then
                    vcounter_sig <= 0;
                else
                    vcounter_sig <= vcounter_sig + 1;
                end if;
            else
                hcounter_sig <= hcounter_sig + 1;
            end if;
            
--            if (vcounter_sig >= 490 and vcounter_sig < 492) then
            if (vcounter_sig >= 494 and vcounter_sig < 496) then
                vsync_sig <= '0';
            else
                vsync_sig <= '1';
            end if;
            
            if (hcounter_sig >= 656 and hcounter_sig < 752) then
                hsync_sig <= '0';
            else
                hsync_sig <= '1';
            end if;
            
            if (hcounter_sig < 640 and vcounter_sig < 480) then
                if (pos_sig(vcounter_sig/10, hcounter_sig/10) = 1) then
                    vgaRed_sig  <= "111";
                    vgaGreen_sig<= "111";
                    vgaBlue_sig <= "111";
                else
                    vgaRed_sig  <= "000";
                    vgaGreen_sig<= "000";
                    vgaBlue_sig <= "000";
                end if;
            else
                vgaRed_sig  <= "000";
                vgaGreen_sig<= "000";
                vgaBlue_sig <= "000";
            end if;
        end if;
    end if;
end process;
end Behavioral;
