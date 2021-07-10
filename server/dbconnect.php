<?php
$servername = "localhost";
$username = "javathre_electricalvendoradmin";
$password = "TANxiaoqin991101";
$dbname = "javathre_electricalvendordb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>