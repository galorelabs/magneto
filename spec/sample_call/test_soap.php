<?php
error_reporting(E_ALL); 
ini_set("display_errors", 1);

$proxy = new SoapClient('http://jeckerson.stage.h-art.it/index.php/api/soap/?wsdl', array('trace'=>1));

function printxml($proxy,$msg=''){
	echo "<h1>".$msg."</h1><textarea>".$proxy->__getLastRequest()."</textarea></br>";
}

$sessionId = $proxy->login('soap', 'qwerty123456');
echo $sessionId;

$shoppingCartIncrementId = $proxy->call( $sessionId, 'cart.create',array( 1 ));

$sku = "24PRJUPA01ST00111-7007-33";
$product_id = "9987";

$arrProducts = array(
array(
  //"sku" => '24PRJUPA01ST00111-7007-33',
  "product_id" => $product_id,
  "quantity" => 2
),
array(
//  //"sku" => $sku,
"product_id" => 9884,
 "quantity" => 2
),
//array(
//  //"sku" => $sku,
//    "product_id" => 9988,
//  "quantity" => 1
//),
//array(
//  //"sku" => $sku,
//    "product_id" => 9957,
//  "quantity" => 1
//),
//


);


$resultCartProductAdd = $proxy->call(
$sessionId,
"cart_product.add",
array(
  $shoppingCartIncrementId,
  $arrProducts
)
);
echo "\n Inseriamo nel carrello...\n";
if ($resultCartProductAdd) {
echo "Prodotto SKU:".$sku." aggiunto al carrello con id:".$shoppingCartIncrementId; 
} else {
echo "Prodotto SKU:".$sku." non carrellizzato"; 
}
echo "\n";

printxml($proxy, 'cart_product.add');


$shoppingCartId = $shoppingCartIncrementId;

// Set customer, for example guest
$customerAsGuest = array(
    "firstname" => "Mattia",
    "lastname" => "BB",
    
    //"customer_id" => 261,
    "website_id" => "1",
    "group_id" => "1",
    "store_id" => "1",
    "email" => "l516077@rtrtr.com",
    "mode" => "guest",


    //"mode" => "customer"
);
echo "\nImposto Customer...";
$resultCustomerSet = $proxy->call($sessionId, 'cart_customer.set', array( $shoppingCartId, $customerAsGuest) );
if ($resultCustomerSet === TRUE) {
    echo "\nOK Customer settato";    
} else {
    echo "\nOK Customer NON settato";    
}
printxml($proxy, 'cart_customer.set');
// Set customer addresses, for example guest's addresses
$arrAddresses = array(
    array(
        "mode" => "shipping",
        "firstname" => "testFirstname",
        "lastname" => "testLastname",
        "company" => "testCompany",
        "street" => "testStreet",
        "city" => "Treviso",
        "region" => "TV",
        "postcode" => "31056",
        "country_id" => "IT",
        "telephone" => "0123456789",
        "fax" => "0123456789",
        "is_default_shipping" => 0,
        "is_default_billing" => 0
    ),
    array(
        "mode" => "billing",

        "firstname" => "testFirstname",
        "lastname" => "testLastname",
        "company" => "testCompany",
        "street" => "testStreet",
        "city" => "Treviso",
        "region" => "TV",
        "postcode" => "31056",
        "country_id" => "IT",
        "telephone" => "0123456789",
        "fax" => "0123456789",
        "is_default_shipping" => 0,
        "is_default_billing" => 0
    )
);
echo "\nImpostazione Indirizzo...";
$resultCustomerAddresses = $proxy->call($sessionId, "cart_customer.addresses", array($shoppingCartId, $arrAddresses));
if ($resultCustomerAddresses === TRUE) {
    echo "\nOK indirizzo impostato"; 
} else {
    echo "\nKO  indirizzo NON impostato"; 
}

printxml($proxy, 'cart_customer.addresses');
// get list of shipping methods
$resultShippingMethods = $proxy->call($sessionId, "cart_shipping.list", array($shoppingCartId));
print_r( $resultShippingMethods );
printxml($proxy, 'cart_shipping.list');


// set shipping method
$randShippingMethodIndex = rand(0, count($resultShippingMethods)-1 );
$shippingMethod = $resultShippingMethods[$randShippingMethodIndex]["code"];
echo "\nShipping method:".$shippingMethod; 
$resultShippingMethod = $proxy->call($sessionId, "cart_shipping.method", array($shoppingCartId, 'flatrate_flatrate'));

printxml($proxy, "cart_shipping.method");

echo "\nVerifico il totale dell'ordine...";
$resultTotalOrder = $proxy->call($sessionId,'cart.totals',array($shoppingCartId));
print_r($resultTotalOrder);

printxml($proxy, 'cart.totals');

echo "\nVerifico i prodotti dell'ordine...";
$resultProductOrder = $proxy->call($sessionId,'cart_product.list',array($shoppingCartId));
print_r($resultProductOrder);

printxml($proxy, 'cart_product.list');

// get list of payment methods
echo "\nVerifico l'elenco dei metodi di pagamento...";
$resultPaymentMethods = $proxy->call($sessionId, "cart_payment.list", array($shoppingCartId));
print_r($resultPaymentMethods);

printxml($proxy, "cart_payment.list");

// set payment method
$paymentMethodString= "checkmo";
echo "\nImpoosto il metodo di pagamento $paymentMethodString.";
$paymentMethod = array(
    "method" => $paymentMethodString
);
$resultPaymentMethod = $proxy->call($sessionId, "cart_payment.method", array($shoppingCartId, $paymentMethod));

printxml($proxy, "cart_payment.method");

// get full information about shopping cart
echo "\nRecupero le info del carrello: ";
$shoppingCartInfo = $proxy->call($sessionId, "cart.info", array($shoppingCartId));
print_r( $shoppingCartInfo );

printxml($proxy, "cart.info");

// get list of licenses
//$shoppingCartLicenses = $proxy->call($sessionId, "cart.license", array($shoppingCartId));
//echo 'licenze';
//print_r( $shoppingCartLicenses );
//
//
//printxml($proxy, "cart.license");
//
//// check if license is existed
//$licenseForOrderCreation = null;
//if (count($shoppingCartLicenses)) {
//    $licenseForOrderCreation = array();
//    foreach ($shoppingCartLicenses as $license) {
//        $licenseForOrderCreation[] = $license['agreement_id'];
//    }
//}


// create order
echo "\nCreo l'ordine: ";
$resultOrderCreation = $proxy->call($sessionId,"cart.order",array($shoppingCartId, null, null));
echo "\nORdine creato con codice:".$resultOrderCreation."\n";

printxml($proxy, "cart.order");

?>
