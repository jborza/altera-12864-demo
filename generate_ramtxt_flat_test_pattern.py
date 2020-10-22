import sys

def str2bin(text):
    for i in range(0, len(text)):
        char = ord(text[i])
        print(f'{char:08b}')

txt = []
txt.append("000.00 STOPWATCH")
txt.append("   Incremented  ")
txt.append("  EVERY *10* MS ")
txt.append("~Verilog is fun~")

with open(f'ram.txt', 'w') as f:
    sys.stdout = f
    for i in range(0,4):
        str2bin(txt[i])