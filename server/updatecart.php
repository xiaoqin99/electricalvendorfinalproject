<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE tbl_cart SET qty = '$quantity' WHERE user_email = '$email' AND prid = '$prid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>