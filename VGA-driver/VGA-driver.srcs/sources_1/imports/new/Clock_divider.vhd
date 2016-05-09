----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2015 10:08:45 AM
-- Design Name: 
-- Module Name: Clock_divider - Behavioral
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


entity Clock_divider is
    Port ( clk : in STD_LOGIC;
           clk_slow : out STD_LOGIC);
end Clock_divider;

architecture Behavioral of Clock_divider is

constant base: integer := 7500000;
signal i: integer range 0 to base:=0;
signal int_clk: std_logic:= '0';

begin

process (clk) begin
if rising_edge (clk) then
    i <= i + 1;
    if (i = base) then
        i <= 0;
        int_clk <= not int_clk;
    end if;
end if;
end process;

process (int_clk)
begin
    clk_slow <= int_clk;
end process;

end Behavioral;
