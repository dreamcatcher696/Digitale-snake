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
-- use IEEE.math_real.all;         -- voor random getal
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity randomdot is
    Port (
        clk: in std_logic;
        xpos: out integer range 0 to 63;
        ypos: out integer range 0 to 47
     );
end randomdot;

architecture Behavioral of randomdot is
    signal rand1: integer range 0 to 63 := 0;
    signal rand2: integer range 0 to 31 := 0;
    signal rand3: integer range 0 to 15 := 0;
begin
process (clk)
    variable rand_temp1: std_logic_vector(5 downto 0) :=(5 => '1', others => '0');
    variable rand_temp2: std_logic_vector(4 downto 0) :=(3 => '1', others => '0');
    variable rand_temp3: std_logic_vector(3 downto 0) :=(3 => '1', others => '0');
    variable temp1: std_logic := '0';
    variable temp2: std_logic := '0';
    variable temp3: std_logic := '0';
begin
    if rising_edge(clk) then
            temp1 := rand_temp1(5) xor rand_temp1(5-1);
            rand_temp1(5 downto 1) := rand_temp1(5-1 downto 0);
            rand_temp1(0) := temp1;
            
            temp2 := rand_temp2(4) xor rand_temp2(4-1);
            rand_temp2(4 downto 1) := rand_temp2(4-1 downto 0);
            rand_temp2(0) := temp2;        

            temp3 := rand_temp3(3) xor rand_temp3(3-1);
            rand_temp3(3 downto 1) := rand_temp3(3-1 downto 0);
            rand_temp3(0) := temp3;  

            rand1 <= to_integer(unsigned(rand_temp1));
            rand2 <= to_integer(unsigned(rand_temp2));
            rand3 <= to_integer(unsigned(rand_temp3));
    end if;

end process;
process (rand1, rand2, rand3)
begin
    if(rand1 = 63) then
        xpos <= rand1 - rand3 - 1;
    elsif(rand1 = 62) then
        xpos <= rand1;
    else
        xpos <= rand1 + 1;
    end if;
    if((rand2 + rand3) = 47) then
        ypos <= rand2 + rand3 - 1;
    elsif((rand2 + rand3) = 0) then
        ypos <= rand2 + rand3 + 1;
    else
        ypos <= rand2 + rand3;
    end if;    
end process;
end Behavioral;
