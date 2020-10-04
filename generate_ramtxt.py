
def str2bin(text):
    for i in range(0, len(text)):
        char = ord(text[i])
        print(f'{char:08b}')

txt3 = "dolor sit amet"

str2bin(txt3)