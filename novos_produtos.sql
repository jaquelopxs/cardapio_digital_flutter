-- Script para inserção de novos produtos no Cardápio Digital (Empório Sophia)

-- Limpar a tabela de produtos se quiser começar do zero (OPCIONAL)
-- DELETE FROM produtos;

-- Lanches
INSERT INTO produtos (nome, descricao, imagem, preco, categoria) VALUES 
('Misto Quente', 'Pão de forma tostado com presunto e queijo derretido.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\mistro_quente.jpg', 8.00, 'lanches'),
('Pão na Chapa com Requeijão', 'Pão francês crocante com uma camada generosa de requeijão na chapa.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\pao_requeijao.jpg', 10.00, 'lanches'),
('Sanduíche Natural', 'Pão integral, frango desfiado, maionese light, alface e cenoura.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\sanduiche_natural.jpg', 12.00, 'lanches'),
('Pão de Queijo', 'Porção com 6 unidades de pão de queijo mineiro quentinho.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\paodequeijo.jpg', 12.00, 'lanches'),
('Pão de Queijo Recheado', 'Pão caseiro recheado com presunto, queijo e um toque de orégano.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\pao_queijo_recheado.jpg', 15.00, 'lanches');

-- Bebidas (Cafés)
INSERT INTO produtos (nome, descricao, imagem, preco, categoria) VALUES 
('Café Espresso', 'Café intenso e aromático, tirado na hora.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\cafe.jpg', 8.00, 'bebidas'),
('Café com Leite', 'O clássico café espresso com leite vaporizado.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\cafe_leite.jpg', 8.00, 'bebidas'),
('Cappuccino Tradicional', 'Espresso, leite vaporizado e uma crema densa com cacau.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\cappuccino.jpg', 8.00, 'bebidas'),
('Cappuccino Cremoso com Chocolate', 'Nosso cappuccino especial com calda de chocolate artesanal.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\Cappuccino_Cremoso.jpg', 8.00, 'bebidas'),
('Latte Macchiato', 'Leite manchado com um shot de espresso, formando camadas.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\latte_macchiato.jpg', 8.00, 'bebidas'),

-- Outras Bebidas e Sobremesas
INSERT INTO produtos (nome, descricao, imagem, preco, categoria) VALUES 
('Suco de Laranja Natural', 'Suco puro de laranja, espremido na hora (300ml).', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\suco_laranja.jpg', 10.00, 'bebidas'),
('Chocolate Quente Cremoso', 'Nosso chocolate quente cremoso com cacau 40%.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\chocolate_quente.jpg', 8.00, 'bebidas'),
('Bolo Caseiro de Cenoura', 'Fatia de bolo de cenoura com cobertura de chocolate.', 'C:\Users\ja.lopes\Documents\Demais Arquivos\cardapio_digital_flutter\backend\src\img\bolo_cenoura.jpg', 7.00, 'sobremesas'),
