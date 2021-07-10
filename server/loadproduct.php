<?php

include_once("dbconnect.php");
$productname = $_POST['productname'];

if (isset($productname)){
    $sqlloadproducts = "SELECT * FROM tbl_products WHERE prname LIKE '%$productname%' ORDER BY prid DESC";
}
else{
    $sqlloadproducts= "SELECT * FROM tbl_products ORDER BY prid DESC";
}

$result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $productlist = array();
        $productlist[prid] = $row['prid'];
        $productlist[prname] = $row['prname'];
        $productlist[prtype] = $row['prtype'];
        $productlist[prprice] = $row['prprice'];
        $productlist[prqty] = $row['prqty'];
        $productlist[datecreated] = $row['datecreated'];
        array_push($response["products"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>