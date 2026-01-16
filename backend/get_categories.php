<?php
//Accessibility settings (CORS) to allow Vue.js to call the API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

include 'db_config.php';

$parentId = isset($_GET['parent_id']) ? $_GET['parent_id'] : null;

if ($parentId === null) {
    // Fetch Level 1 categories (e.g., Kids, Adults, Seniors)
    $sql = "SELECT * FROM Categories WHERE parent_id IS NULL AND level = 1";
} else {
    // Fetch sub-categories based on selection
    $sql = "SELECT * FROM Categories WHERE parent_id = " . intval($parentId);
}

$result = $conn->query($sql);
$categories = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
}

echo json_encode($categories);
?>