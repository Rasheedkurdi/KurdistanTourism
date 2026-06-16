<?php
class Database
{
    private $host = 'localhost';
    private $dbName = 'kurdish_tourism_db';
    private $username = 'root';
    private $password = '';
    private static $instance = null;

    public function __construct() {}

    public static function getInstance(): ?Database
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection(): ?PDO
    {
        $host = getenv('DB_HOST') ?: $this->host;
        $dbName = getenv('DB_NAME') ?: $this->dbName;
        $username = getenv('DB_USERNAME') ?: $this->username;
        $password = getenv('DB_PASSWORD') ?: $this->password;

        try {
            $pdo = new PDO(
                "mysql:host={$host};dbname={$dbName};charset=utf8mb4",
                $username,
                $password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (PDOException $e) {
            error_log("Database connection failed: " . $e->getMessage());
            return null;
        }

        return $pdo;
    }
    
    // Insert data into table
    public function insert(string $table, array $data): ?int
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return null;
        }
        
        $table = $this->assertIdentifier($table);
        $columns = implode(', ', array_map([$this, 'assertIdentifier'], array_keys($data)));
        $placeholders = implode(', ', array_fill(0, count($data), '?'));
        
        $sql = "INSERT INTO {$table} ({$columns}) VALUES ({$placeholders})";
        
        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array_values($data));
            return $pdo->lastInsertId();
        } catch (PDOException $e) {
            error_log("Insert error: " . $e->getMessage());
            return null;
        }
    }
    
    // Fetch single record
    public function fetch(string $sql, array $params = []): ?array
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return null;
        }
        
        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute($params);
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            return $result === false ? null : $result;
        } catch (PDOException $e) {
            error_log("Fetch error: " . $e->getMessage());
            return null;
        }
    }
    
    // Fetch multiple records
    public function fetchAll(string $sql, array $params = []): array
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return [];
        }
        
        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute($params);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("FetchAll error: " . $e->getMessage());
            return [];
        }
    }

    // Update records in table
    public function update(string $table, array $data, string $where, array $params = []): bool
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return false;
        }

        $table = $this->assertIdentifier($table);
        $setClauses = [];
        $values = [];
        foreach ($data as $column => $value) {
            $column = $this->assertIdentifier($column);
            $setClauses[] = "{$column} = ?";
            $values[] = $value;
        }
        $setSql = implode(', ', $setClauses);

        $sql = "UPDATE {$table} SET {$setSql} WHERE {$where}";

        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array_merge($values, $params));
            return $stmt->rowCount() >= 0;
        } catch (PDOException $e) {
            error_log("Update error: " . $e->getMessage());
            return false;
        }
    }

    // Delete records from table
    public function delete(string $table, string $where, array $params = []): bool
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return false;
        }

        $table = $this->assertIdentifier($table);
        $sql = "DELETE FROM {$table} WHERE {$where}";

        try {
            $stmt = $pdo->prepare($sql);
            $stmt->execute($params);
            return $stmt->rowCount() >= 0;
        } catch (PDOException $e) {
            error_log("Delete error: " . $e->getMessage());
            return false;
        }
    }

    public function execute(string $sql, array $params = []): bool
    {
        $pdo = $this->getConnection();
        if (!$pdo) {
            return false;
        }

        try {
            $stmt = $pdo->prepare($sql);
            return $stmt->execute($params);
        } catch (PDOException $e) {
            error_log("Execute error: " . $e->getMessage());
            return false;
        }
    }

    private function assertIdentifier(string $identifier): string
    {
        if (!preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/', $identifier)) {
            throw new InvalidArgumentException('Invalid database identifier.');
        }

        return $identifier;
    }
}
?>
