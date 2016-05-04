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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_divider is
    Port ( clk : in STD_LOGIC;
           div : in STD_LOGIC_VECTOR (1 downto 0);
           clk_slow : out STD_LOGIC);
end Clock_divider;

architecture Behavioral of Clock_divider is

signal i: integer range 0 to 25000000:=0;
signal int_clk: std_logic:= '0';
signal base: integer range 0 to 25000000:= 25000000;
signal prev_div: std_logic:= '0';

begin

process (clk, div) begin
if rising_edge (clk) then
    i <= i + 1;
    if (i = base) then
        i <= 0;
        int_clk <= not int_clk;
    end if;
    case (div) is
        when "00" => base <= 25000000;
        when "01" => base <= 12500000;
        when "10" => base <= 2500000;
        when others => base <= 250000;
    end case;
end if;
end process;
clk_slow <= int_clk;


end Behavioral;
