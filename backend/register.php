<?php
header("Access-Control-Allow-Origin: http://localhost:5173"); // Specific origin for security
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// 2. Handle the "Preflight" OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 3. Now include your database and logic
include 'db_config.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->email) && !empty($data->password) && !empty($data->username)){
    $full_name = $conn->real_escape_string($data->username);
    $email = $conn->real_escape_string($data->email);
    $role = $conn->real_escape_string($data->$role);
    $password_hash = password_hash($data->password, PASSWORD_DEFAULT);

  $sql = "INSERT INTO users (full_name, email, password_hash, role) 
        VALUES ('$full_name', '$email', '$password_hash', '$role')";

    if ($conn->query($sql)){
        echo json_encode(["message" => "Success"]);
    }else{
        http_response_code(400);
        echo json_encode(["error" => "Email already registered"]);
    }
}
?>