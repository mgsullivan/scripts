message = 'Three can keep a secret, if two of them are dead.'
i = len(message) - 1
translated = ''
while i >= 0:
    translated = translated + message[i]
    i = i - 1
print(translated)
