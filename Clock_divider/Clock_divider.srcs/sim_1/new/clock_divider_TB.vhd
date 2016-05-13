----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2016 15:38:09
-- Design Name: 
-- Module Name: clock_divider_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider_TB is
--  Port ( );
end clock_divider_TB;

architecture Behavioral of clock_divider_TB is

component Clock_divider is
    Port ( clk : in STD_LOGIC;
           clk_slow : out STD_LOGIC);
end component;

constant clk_period : time := 10 ns;

signal clock: std_logic := '0';
signal gametick: std_logic := '0';

begin

UUT: Clock_divider
Port map (clk=>clock, clk_slow=>gametick);

clk_process: process
begin
    clock <= '0';
    wait for clk_period/2;
    clock <= '1';
    wait for clk_period/2;
end process;

end Behavioral;
