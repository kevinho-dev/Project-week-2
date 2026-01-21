<?php
header("Access-Control-Allow-Origin: http://localhost:5173"); 
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Handle the "Preflight" OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Now include your database and logic
include 'db_config.php';
//read login credentials
$data = json_decode(file_get_contents("php://input"));

if(!empty($data->email) && !empty($data->password)){
$email = $conn->real_escape_string($data->email);
$password = $data->password;

$sql = "SELECT user_id, full_name, password_hash, role FROM users WHERE email = '$email'";
$result = $conn->query($sql);

if($result && $result->num_rows > 0){
$user = $result->fetch_assoc();
if(password_verify($password, $user['password_hash'])){
echo json_encode([
"user_id" => $user['user_id'],
"username" => $user['full_name'],
"role" => $user['role']
]);
}else {
http_response_code(400);
echo json_encode(["error" => "Invalid password"]);
}
} else {
http_response_code(404);
echo json_encode(["error" => "User not found"]);
}
}