<?php
include_once("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
     $sqlloadcart = "SELECT tbl_products.prid, tbl_products.prname, tbl_products.prprice, tbl_cart.qty FROM tbl_products INNER JOIN tbl_cart ON tbl_cart.prid = tbl_products.prid WHERE tbl_cart.user_email = '$email'";
}

$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0) {
    $response['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $carlist = array();
        $cartlist[prid] = $row['prid'];
        $cartlist[prname] = $row['prname'];
        $cartlist[prtype] = $row['prtype'];
        $cartlist[prprice] = $row['prprice'];
        $cartlist[cartqty] = $row['qty'];
        $cartlist[prqty] = $row['prqty'];
        $cartlist[total_price] = round(doubleval($row["prprice"])*(doubleval($row["prqty"])),2)."";
        $cartlist[datecreated] = $row['datecreated'];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
} else {
    echo "nodata";
}

?>