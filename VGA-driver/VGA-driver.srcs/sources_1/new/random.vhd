----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2016 10:47:38
-- Design Name: 
-- Module Name: random - Behavioral
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
use IEEE.math_real.all;         -- voor random getal
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity random is
    Port (
        clk: in std_logic;
        xpos: out integer range 0 to 63;
        ypos: out integer range 0 to 47
     );
end random;

architecture Behavioral of random is

begin
process (clk)
    variable seed1: positive;
    variable seed2: positive;
    variable rand1: real;
    variable rand2: real;
    variable int_rand1: integer := 0;
    variable int_rand2: integer := 0;
begin
    if rising_edge(clk) then
        UNIFORM(seed1, seed2, rand1);
        int_rand1 := INTEGER(TRUNC(rand1*63.0));
        UNIFORM(seed1, seed2, rand2);
        int_rand2 := INTEGER(TRUNC(rand2*47.0));
        
        xpos <= int_rand1;
        ypos <= int_rand2;
    end if;

end process;
end Behavioral;
