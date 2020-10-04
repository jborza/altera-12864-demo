import sys

def str2bin(text):
    for i in range(0, len(text)):
        char = ord(text[i])
        print(f'{char:08b}')

txt = []
txt.append("Hello World!    ")
txt.append("12864 LCD Screen")
txt.append("Lorem ipsum     ")
txt.append("dolor sit amet. ")

str2bin(txt[0])

with open(f'ram.txt', 'w') as f:
    sys.stdout = f
    for i in range(0,4):
        str2bin(txt[i])