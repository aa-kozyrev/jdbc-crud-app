package ru.kozyrev;

import java.sql.*;
import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;
import org.flywaydb.core.Flyway;

public class App {
    private Connection connection;
    private String url;
    private String username;
    private String password;

    public static void main(String[] args) {
        App app = new App();
        try {
            app.loadProperties();
            app.runMigrations();
            app.demoCRUDOperations();
        } catch (Exception e) {
            System.err.println("Ошибка при выполнении программы: " + e.getMessage());
            e.printStackTrace();
        } finally {
            app.disconnect();
        }
    }

    private void loadProperties() throws IOException {
        Properties props = new Properties();

        // Загрузка из classpath (правильный способ для JAR)
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new IOException("Файл application.properties не найден в classpath");
            }
            props.load(input);
        }

        url = props.getProperty("db.url");
        username = props.getProperty("db.username");
        password = props.getProperty("db.password");

        if (url == null || username == null || password == null) {
            throw new IOException("Не все обязательные параметры найдены в application.properties");
        }

        System.out.println("Параметры подключения загружены:");
        System.out.println("URL: " + url);
        System.out.println("Username: " + username);
    }

    private void runMigrations() {
        System.out.println("\n=== Запуск миграций Flyway ===");

        try {
            Flyway flyway = Flyway.configure()
                    .dataSource(url, username, password)
                    .locations("classpath:db/migration")
                    .load();

            flyway.migrate();
            System.out.println("Миграции успешно выполнены!");
        } catch (Exception e) {
            System.err.println("Ошибка при выполнении миграций: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    private void connect() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(url, username, password);
            connection.setAutoCommit(false);
            System.out.println("Подключение к БД установлено");
        }
    }

    private void disconnect() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("\nПодключение к БД закрыто");
            }
        } catch (SQLException e) {
            System.err.println("Ошибка при закрытии подключения: " + e.getMessage());
        }
    }

    private void demoCRUDOperations() {
        Connection conn = null;
        try {
            connect();
            conn = connection;

            System.out.println("\n=== ДЕМОНСТРАЦИЯ CRUD ОПЕРАЦИЙ ===");

            // 1) Вставка нового товара и покупателя
            System.out.println("\n--- 1) Вставка нового товара и покупателя ---");
            int newProductId = insertProduct("Планшет", 500.00, 8);
            int newCustomerId = insertCustomer("Ольга", "Кузнецова", "79020000000","olga.kuznetsova@email.com");

            // 2) Создание заказа для покупателя
            System.out.println("\n--- 2) Создание заказа для покупателя ---");
            int newOrderId = createOrder(newCustomerId, newProductId, 2);

            // 3) Чтение и вывод последних 5 заказов с JOIN на товары и покупателей
            System.out.println("\n--- 3) Чтение и вывод последних 5 заказов с JOIN на товары и покупателей ---");
            readLastFiveOrders();

            // 4) Обновление цены товара и количества на складе
            System.out.println("\n--- 4) Обновление цены товара и количества на складе ---");
            updateProduct(newProductId, 450.00, 5);

            // 5) Удаление тестовых записей
            System.out.println("\n--- 5) Удаление тестовых записей ---");
            //deleteTestRecords(newProductId, newCustomerId, newOrderId);
            deleteTestRecords(1, 12, 1);

            // Коммит транзакции
            conn.commit();
            System.out.println("\n=== Все операции успешно завершены! ===");

        } catch (SQLException e) {
            System.err.println("Ошибка SQL: " + e.getMessage());
            try {
                if (conn != null) {
                    conn.rollback();
                    System.out.println("Транзакция откачена из-за ошибки");
                }
            } catch (SQLException ex) {
                System.err.println("Ошибка при откате транзакции: " + ex.getMessage());
            }
        }
    }

    private int insertProduct(String name, double price, int count) throws SQLException {
        String sql = "INSERT INTO pish.product(name, price, count) VALUES(?, ?, ?) RETURNING id";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.setInt(3, count);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int id = rs.getInt(1);
                System.out.println("Добавлен новый товар: " + name + " (ID: " + id + ")");
                return id;
            }
        }
        throw new SQLException("Не удалось вставить товар");
    }

    private int insertCustomer(String firstName, String lastName, String phone, String email) throws SQLException {
        String sql = "INSERT INTO pish.customer(first_name, last_name, phone, email) VALUES(?, ?, ?, ?)  RETURNING id";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, phone);
            stmt.setString(4, email);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int id = rs.getInt(1);
                System.out.println("Добавлен новый покупатель: " + firstName + " " + lastName + " (ID: " + id + ")");
                return id;
            }
        }
        throw new SQLException("Не удалось вставить покупателя");
    }

    private int createOrder(int customerId, int productId, int count) throws SQLException {
        String Sql = "INSERT INTO pish.order(product_id, customer_id, count, status) VALUES(?, ?, ?, ?) RETURNING id";

        try (PreparedStatement stmt = connection.prepareStatement(Sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, customerId);
            stmt.setInt(3, count);
            stmt.setInt(4, 1); // 1 - NEW

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int id = rs.getInt(1);
                updateProductStock(productId, -count);  // уменьшаем количество товара на складе
                System.out.println("Создан новый заказ ID: " + id);
                return id;
            }
        }
        throw new SQLException("Не удалось создать заказ");
    }

    private void updateProductStock(int productId, int countChange) throws SQLException {
        String sql = "UPDATE pish.product SET count = count + ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, countChange);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        }
    }

    private void readLastFiveOrders() throws SQLException {
        String sql = """
            select o.id, o.order_date, os.description,
            	p.name, o.count, p.price,
            	c.first_name || ' ' || c.last_name as "client"
            from "order" o
            left join order_status os on o.status = os.id
            left join product p on o.product_id = p.id
            left join customer c on o.customer_id = c.id
            order by o.order_date desc
            limit 5;
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("\nПоследние 5 заказов:");
            System.out.println("───────────────────────────────────────────────────────────────────────────────────");
            System.out.printf("%-8s %-12s %-18s %-10s %-8s %-10s %-20s%n",
                    "ID", "Дата", "Статус", "Товар", "Кол-во", "Стоимость", "Покупатель");
            System.out.println("───────────────────────────────────────────────────────────────────────────────────");

            while (rs.next()) {
                int orderId = rs.getInt("id");
                String orderDate = rs.getTimestamp("order_date").toString();
                String description = rs.getString("description");
                String name = rs.getString("name");
                int count = rs.getInt("count");
                double price = rs.getDouble("price");
                String client = rs.getString("client");

                System.out.printf("%-8s %-12s %-18s %-10s %-8s %-10s %-20s%n",
                        orderId, orderDate.substring(0, 10), description, name, count, price, client);
            }
            System.out.println("───────────────────────────────────────────────────────────────────────────────────");
        }
    }

    private void updateProduct(int productId, double newPrice, int newCount) throws SQLException {
        String sql = "UPDATE product SET price = ?, count = ? WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDouble(1, newPrice);
            stmt.setInt(2, newCount);
            stmt.setInt(3, productId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Товар ID " + productId + " обновлен:");
                System.out.println("  Новая цена: " + newPrice);
                System.out.println("  Новое количество: " + newCount);
            } else {
                System.out.println("Товар с ID " + productId + " не найден");
            }
        }
    }

    private void deleteTestRecords(int productId, int customerId, int orderId) throws SQLException {
        String sqlOrder = "DELETE FROM \"order\" WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sqlOrder)) {
            stmt.setInt(1, orderId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("заказ с ID " + orderId + " удален");
            } else {
                System.out.println("заказ с ID " + orderId + " не найден");
            }
        }

        String sqlProduct = "DELETE FROM product WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sqlProduct)) {
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Товар ID " + productId + " удален");
            } else {
                System.out.println("Товар с ID " + productId + " не найден");
            }
        }

        String sqlCustomer = "DELETE FROM customer WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sqlCustomer)) {
            stmt.setInt(1, customerId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Покупатель с ID " + customerId + " удален");
            } else {
                System.out.println("Покупатель с ID " + customerId + " не найден");
            }
        }
    }

}