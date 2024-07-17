w = int(input())
h = int(input())

change = float(input())

newW = w * change
newH = h * change

print(f"""A largura original da foto era {w} e a altura original era {h}.\n
          O tamanho foi mudado por um fator de {change}.\n
          As novas medidas são {newW} e {newH}""")