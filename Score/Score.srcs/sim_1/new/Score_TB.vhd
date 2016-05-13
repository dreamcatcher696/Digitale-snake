----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2016 16:30:50
-- Design Name: 
-- Module Name: Score_TB - Behavioral
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

entity Score_TB is
--  Port ( );
end Score_TB;

architecture Behavioral of Score_TB is

component score is
    Port ( 
            reset_sig : in STD_LOGIC;
            punt_sig : in STD_LOGIC;
            clk : in STD_LOGIC;
            seg : out STD_LOGIC_VECTOR (6 downto 0);
            an : out STD_LOGIC_VECTOR (3 downto 0)
          );
end component;

constant clk_period : time := 10 ns;

signal clock: std_logic := '0';
signal reset : std_logic := '0';
signal punt : std_logic := '0';
signal seg_out : std_logic_vector (6 downto 0) := "1111111";
signal an_out : std_logic_vector (3 downto 0) := "0000";

begin

UUT: score
Port map (reset_sig=>reset, punt_sig=>punt, clk=>clock, seg=>seg_out, an=>an_out);

clk_process: process
begin
    clock <= '0';
    wait for clk_period/2;
    clock <= '1';
    wait for clk_period/2;
end process;

stimuli: process
begin
    punt <= '1';
    wait for 100 ns;
    punt <= '0';
    wait for 100 ns;
    punt <= '1';
    wait for 100 ns;
    punt <= '0';
    wait for 100 ns;
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;
    punt <= '1';
    wait for 100 ns;
    punt <= '0';
    wait for 100 ns;
    punt <= '1';
    wait for 100 ns;
    punt <= '0';
    wait for 100 ns;
    punt <= '1';
    wait for 100 ns;
    punt <= '0';
end process;

end Behavioral;
