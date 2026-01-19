<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'db_config.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->email) && !empty($data->$password) && !empty($data->username)){
    $full_name = $conn->real_escape_string($data->username);
    $email = $conn->real_escape_string($data->email);
    $role = $conn->real_escape_string($data->$role);
    $password_hash = password_hash($data->password, PASSWORD_DEFAULT);

    $sql ="INSERT INTO USERS (full_name, email, password_hash, role) 
    VALUES ('$full_name', '$email', '$password_hash', '$role')";

    if ($conn->query($sql)){
        echo json_encode(["message" => "Success"];
    }else{
        http_response_code(400);
        echo json_encode(["error" => "Email already registered"]);
    }
}
?>