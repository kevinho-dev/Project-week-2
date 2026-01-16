<?php
//Accessibility settings (CORS) to allow Vue.js to call the API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

include 'db_config.php';

$parentId = (isset($_GET['parent_id']) && $_GET['parent_id'] !== 'null' && $_GET['parent_id'] !== '') 
            ? intval($_GET['parent_id']) 
            : null;
$data =[];
//retrieve the categories belonging to the chosen ID
if($parentId === null || $parentId === '' || $parentId ==='null') {
    // first category
    $sql ="SELECT * FROM categories WHERE parent_id IS NULL";
} else{ 
    // 2 - 4 categories
    $sql = "SELECT *FROM categories WHERE parent_id = $parentId";
}

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
       $data[] = ["type" => "category", "content" => ["category_id" => 
        $row['category_id'], "category_name" => 
        $row['category_name'], "level" => 
        $row['level']
       ]
       ];
    }

}else{
    // does't find any category, that's mean we are in the 5th level.
    //search now for books conect with category_id
     if($parentId !== null){
        $bookSql = "SELECT book_id, title, author, summary, buy_price, rent_price, stock_quantity, is_bestseller, img FROM books WHERE category_id =".intval($parentId);
        $bookResult = $conn->query($bookSql);

        while($bookRow = $bookResult->fetch_assoc()){
            $data[] =[
                  "type" => "book", "content" => $bookRow
            ];
        }
        }

}


echo json_encode($data);
$conn->close();
?>