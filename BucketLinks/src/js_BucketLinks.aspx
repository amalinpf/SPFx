<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Displays links for invoice and credit card buckets. Directs user to appropriate bucket based on AD values with exceptions below.
Original name: jsTest.aspx.    
Exceptions for Departments: "Parks", "Recreation", "Parks and Recreation"
Exceptions for Users: "Craig Borrenpohl"
10/3/22 ajm, changed filename to js_BucketLinks.aspx: no longer testing and more descriptive
1/27/23 ajm, Removed link to WF, and USB is now generic. Reformatted links with CSS
3/20/23 ajm, Added to SPFx project for a webpart rather than an iframe
 -->

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
<title>Bucket Links</title>
<style>
a:link {
	font-family: "Segoe UI";
    color: DarkBlue;
    font-weight: 600!important;
    font-size: 28px;
	text-decoration: none;
}

a:hover {
  color: silver;
}

</style>

</head>

<body style="padding-left:30px;">

	<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
		var bucketLinksDiv = document.getElementById("cuSpan");
		var CCNumber = '';
		var invFolder = '';
		var cUser = '';
		var cDept = '';
		
		
		$(document).ready(function() {
		     setTimeout(userInfo, 300);
		});
	
	function userInfo() {
		 //var url = "/_api/web/currentuser";  
		 var url = "/_api/SP.UserProfiles.PeopleManager/GetMyProperties?$select=UserProfileProperties";
		 var span = document.getElementById("cuSpan");
		 
	    $.ajax({  
	        url: url,  
	        headers: {  
	            Accept: "application/json;odata=verbose"  
	        },  
	        async: false,  
	        success: function (data) {  
	            var items = data.d; // Data will have user object      
	            //console.log(items);
	            //console.log(JSON.stringify(items.UserProfileProperties.results));
	            //console.log("Your department is: " + items.UserProfileProperties.results[11].Value);
	            cUser = items.UserProfileProperties.results[8].Value;
	            if (items.UserProfileProperties.results[11].Value == "Recreation" || items.UserProfileProperties.results[11].Value == "Parks") 
	            {
	            	cDept = "Parks and Recreation";
            	} else {
		            cDept = items.UserProfileProperties.results[11].Value;
		        }

				if(cUser == "Craig Borrenpohl"){
						cDept = 'Water and WaterRec';
					}
	            
	        },  
	        eror: function (data) {  
	            alert("An error occurred. Please try again.");  
	        }  
	    }); 
	    
	    	getCCNumber();	
	
			

	}
	
	
	function getCCNumber(){	
			
		$.ajax({
		  
		    url: "/Sites/FinanceDepartment/_api/web/lists('68BE4F1C-4E01-4D4B-A3E7-C35448FDFC8E')/items?$select=CardNumber,Department&$filter=Title%20eq%20'"+cUser+"'",
			method: "GET",
			headers:{
			"accept":"application/json;odata=verbose",
			"content-type": "application/json;odata=verbose"
			
			},
			async: false,
			global: false,
			success: function(data){
				data = JSON.parse(JSON.stringify(data.d.results).replace(/\:null/gi, "\:\"\""));
				//console.log('Card number: ' + data[0].CardNumber);
				//alert('Your number is: '+data[0].CardNumber);
				if(data.length > 0){
					CCNumber = data[0].CardNumber;
				} else {
					CCNumber = '1111';
				}
			},
			eror: function (data) {  
	            alert("An error occurred. Please try again.");  
	        }
		})
	} // end of getCCNumber
	

// sets the Invoice Bucket link 
function setInvoiceLink() {
	var invCodingUrl= 'https://postfallsidahoorg.sharepoint.com/sites/FinanceDepartment/InvoiceBucket/Forms/AllItems.aspx?RootFolder=/sites/FinanceDepartment/InvoiceBucket/'+cDept;
    window.top.location.href = invCodingUrl;
}

// sets the credit card Bucket link 
function setCCLink() {
	var ccCodingUrl = '/sites/FinanceDepartment/CCBucketUSB/Forms/AllItems.aspx?RootFolder=/sites/FinanceDepartment/CCBucketUSB/' + CCNumber;
	window.top.location.href = ccCodingUrl;
}
		
	</script>

<br/>
<p>
</p> 
   <a href="#" class="bucket" onclick="setCCLink();">Credit Card Bucket</a>
<p>
</p>
<p>
</p> 
   <a href="#" onclick="setInvoiceLink();">Invoice Bucket</a> 

</body>

</html>
