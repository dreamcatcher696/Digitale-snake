----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2016 10:49:12
-- Design Name: 
-- Module Name: random_dot_TB - Behavioral
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
--use IEEE.math_real.all;         -- voor random getal
use IEEE.std_logic_arith.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity random_dot_TB is
--  Port ( );
end random_dot_TB;

architecture Behavioral of random_dot_TB is

component randomdot is
    Port (
        clk: in std_logic;
        xpos: out integer range 0 to 63;
        ypos: out integer range 0 to 47
     );
end component;

constant clk_period : time := 10 ns;

signal clock: std_logic := '0';
signal xpos_sig: integer range 0 to 63;
signal ypos_sig: integer range 0 to 47;
signal xpos_sig_temp: integer range 0 to 63;
signal ypos_sig_temp: integer range 0 to 47;
--signal delay_sig: integer range 0 to 100;

begin

UUT: randomdot
Port map (xpos=>xpos_sig_temp, ypos=>ypos_sig_temp, clk=>clock);

clk_process: process
begin
    clock <= '0';
    wait for clk_period/2;
    clock <= '1';
    wait for clk_period/2;
end process;

--random: process(clk_sig)
--    variable seed1, seed2: positive;
--    variable rand: real;
--begin
--    if rising_edge(clk_sig) then
--        UNIFORM(seed1, seed2, rand);
--        delay_sig <= INTEGER(TRUNC(rand*99.0));
--    end if;
    
--end process;

stimuli: process
begin
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait for 100 ns;
    xpos_sig <= xpos_sig_temp;
    ypos_sig <= ypos_sig_temp;
    wait;
end process;

end Behavioral;
