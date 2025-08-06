class EncodedDataAlgorithms:
    def __init__(self):
        self.start_ascii = 33
        self.end_ascii = 126

    def create_vigenere_table(self):
        total_characters = self.end_ascii - self.start_ascii + 1
        vigenere_table = [['' for _ in range(total_characters + 1)] for _ in range(total_characters + 1)]

        for i in range(1, total_characters + 1):
            ascii_value = self.start_ascii + (i - 1)
            vigenere_table[0][i] = chr(ascii_value)
            vigenere_table[i][0] = chr(ascii_value)

        for i in range(1, total_characters + 1):
            for j in range(1, total_characters + 1):
                ascii_value = self.start_ascii + ((i + j - 2) % total_characters)
                vigenere_table[i][j] = chr(ascii_value)

        return vigenere_table

    def encrypt_text(self, text, key):
        encrypted_text = ""
        key_length = len(key)
        vigenere_table = self.create_vigenere_table()

        for index, char in enumerate(text):
            key_char = key[index % key_length]
            encrypted_char = self.find_index(vigenere_table, char, key_char)
            encrypted_text += encrypted_char

        return encrypted_text

    def find_index(self, vigenere_table, row_text, col_text):
        total_characters = self.end_ascii - self.start_ascii + 1
        row, col = 0, 0

        for i in range(1, total_characters + 1):
            if vigenere_table[0][i] == row_text:
                row = i
                break

        for i in range(1, total_characters + 1):
            if vigenere_table[i][0] == col_text:
                col = i
                break

        return vigenere_table[row][col]

    def decrypt_text(self, encrypted_text, key):
        decrypted_text = ""
        key_length = len(key)
        vigenere_table = self.create_vigenere_table()

        for index, char in enumerate(encrypted_text):
            key_char = key[index % key_length]

            row, col = 0, 0
            for i in range(1, len(vigenere_table)):
                if vigenere_table[i][0] == key_char:
                    row = i
                    break

            for i in range(1, len(vigenere_table)):
                if vigenere_table[row][i] == char:
                    col = i
                    break

            decrypted_char = vigenere_table[0][col]
            decrypted_text += decrypted_char

        return decrypted_text