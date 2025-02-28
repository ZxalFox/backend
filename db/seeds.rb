# Criar usuários
user1 = User.create!(email: 'cliente1@example.com', password: 'senha123', role: 'user')
User.create!(email: 'admin@example.com', password: 'senha123', role: 'admin')

# Criar produtos
product1 = Product.create!(name: 'Camiseta Branca', description: 'Camiseta básica de algodão', price: 29.99,
                           category: 'Roupas')
product2 = Product.create!(name: 'Calça Jeans', description: 'Calça jeans azul', price: 89.99, category: 'Roupas')
Product.create!(name: 'Tênis Esportivo', description: 'Tênis para corrida', price: 149.99,
                category: 'Calçados')

# Criar carrinhos e itens
cart1 = Cart.create!(user: user1)
CartItem.create!(cart: cart1, product: product1, quantity: 2)
CartItem.create!(cart: cart1, product: product2, quantity: 1)

# Criar pedidos e itens
order1 = Order.create!(user: user1, total_amount: 209.97, status: 'pending', stripe_payment_id: 'pi_123456789')
OrderItem.create!(order: order1, product: product1, quantity: 2, price: 29.99)
OrderItem.create!(order: order1, product: product2, quantity: 1, price: 89.99)