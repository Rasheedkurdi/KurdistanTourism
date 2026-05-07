<?php
class Database
{
    private $host = 'localhost';
    private $dbName = 'kurdish_tourism_db';
    private $username = 'root';
    private $password = '00000000';
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
            // Try with provided password first
            $pdo = new PDO(
                "mysql:host={$host};dbname={$dbName};charset=utf8mb4",
                $username,
                $password,
                [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
            );
        } catch (PDOException $e) {
            // If provided password fails, try empty password
            try {
                $pdo = new PDO(
                    "mysql:host={$host};dbname={$dbName};charset=utf8mb4",
                    $username,
                    '',
                    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
                );
            } catch (PDOException $e2) {
                error_log("Database connection failed: " . $e2->getMessage());
                return null;
            }
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
        
        // Build column names and placeholders
        $columns = implode(', ', array_keys($data));
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

        $setClauses = [];
        $values = [];
        foreach ($data as $column => $value) {
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
}
?>
