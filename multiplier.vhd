----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:13:14 10/21/2012 
-- Design Name: 
-- Module Name:    multiplier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
  Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
			  Sum1 : inout STD_LOGIC_VECTOR (7 downto 0);
			  Sum2 : inout STD_LOGIC_VECTOR (7 downto 0);
			  Cout : out  STD_LOGIC);
end multiplier;

architecture Behavioral of multiplier is

component HA
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
			  S : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;

component FA
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
			  Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;
		  
signal rowOne : STD_LOGIC_VECTOR (3 downto 0);
signal rowTwo : STD_LOGIC_VECTOR (3 downto 0);
signal rowThree : STD_LOGIC_VECTOR (3 downto 0);
signal rowZero : STD_LOGIC_VECTOR (3 downto 0);
signal CO : STD_LOGIC_VECTOR (7 downto 0);
signal CO2 : STD_LOGIC_VECTOR (7 downto 0);


begin

rowZero(3 downto 0) <= A(3 downto 0) when B(0) = '1' else "0000";
rowOne(3 downto 0) <= A(3 downto 0) when B(1) = '1' else "0000";
rowTwo(3 downto 0) <= A(3 downto 0) when B(2) = '1' else "0000";
rowThree(3 downto 0) <= A(3 downto 0) when B(3) = '1' else "0000";

--First Level
S(0) <= rowZero(0);--Sum is Set
C0: HA port map (A => rowZero(1), B => rowOne(0), S => S(1), Cout => CO(0)); -- Sum is Set
C1: FA port map (A => rowZero(2), B => rowOne(1), Cin => rowTwo(0), S => Sum1(2), Cout => CO(1));
C2: FA port map (A => rowZero(3), B => rowOne(2), Cin => rowTwo(1), S => Sum1(3), Cout => CO(2));
C3: HA port map (A => rowOne(3), B => rowTwo(2), S => Sum1(4), Cout => CO(3));

--Second Level
C4: HA port map (A => Sum1(2), B => CO(0), S => S(2), Cout => CO2(0)); --Sum is Set
C5: FA port map (A => Sum1(3), B => rowThree(0), Cin => CO(1), S => Sum2(3), Cout => CO2(1));
C6: FA port map (A => Sum1(4), B => rowThree(1), Cin => CO(2), S => Sum2(4), Cout => CO2(2));
C7: FA port map (A => rowTwo(3), B => rowThree(2), Cin => CO(3), S => Sum2(5), Cout => CO2(3));

Sum2(6) <= rowThree(3);
--S(3) <= S(3) + CO(0);
--S(4) <= S(4) + CO(1);
--S(5) <= S(5) + CO(2);
--S(6) <= S(6) + CO(3);

S(7 downto 3) <= ('0' & Sum2(6 downto 3)) + ('0' & CO2(3 downto 0));


end Behavioral;

