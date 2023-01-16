Dear Customer,

Note: This is an un-monitored mailbox. Do not reply. If you have any issues please reach out to your Contracted Support Organization directly.

Our records indicate that you recently redeemed a Transaction Key to generate a FOS product Feature License. Please find below the details of your transaction: 

NOTE: If a License Certificate XML file is attached to this email, The XML file must be installed to the Switch, instead of the License Key provided below. If this is the case, please disregard the License Key provided below.
------------------------------------------------------------------------------
Switch WWN/LID: 	10:00:D8:1F:CC:16:FE:C8
Switch Serial #: 	EZL1927R0DM
Transaction Key Redeemed: 	E4AE96C06D05FED80D05D2
Feature Name: 	PORT
License Capacity:	8
License Key:	NSSYfGMTMaaYAaB7M3FDfYPtL9atYN7SMLMFYHEA7ZJA 

Note: For Capacity based features, a single license key with cumulative capacity count (e.g. number of ports the license will activate) will be generated for all the transaction keys for the same feature. 
If the number of transaction keys entered exceeds the limit set for the device type and the feature, the excess transaction keys will be acknowledged with an error message. 


To enable the software:
---------------------------------

The following instructions assume the switch has been attached to a network and is accessible from your PC or workstation. 
Follow these steps to install the Software License Key or License Certificate XML file to the Switch. Connect to the Switch through the CLI or Brocade Web Tools.

1. CLI: Install the License using one of the following command syntax.
    a. If your FOS version is FOS v8.x, use the following syntax.
         licenseAdd <lic_key>
    b. If your FOS version is FOS v9.x or greater, and the License generated is a License string, use the following command syntax.
        license --install <lic_key>
    c. If your FOS version is FOS v9.x or greater, and the License generated is a License Certificate XML file, save the XML file to a remote server and use the following command syntax.
        license --install  {-h <hostip> -t <protocol> [-m <server_port_number>] -u <user> [-p <password>] -f <filepath/xmlfile>}
        where
        -h: remote host IP address, -t:  transport protocol, -m:  server port number, -u:  username to login into remote server, -p:  password of the remote server, 
        -f:  file path to the remote server with the saved License Certificate XML file.

2. GUI: Connect to the Switch using a Web browser (this will open Web Tools). Log in as Admin and enter your Switch password.
    a. If your FOS version is FOS v8.x, use the Web Tools Switch Admin to add the License string.
    b. If your FOS version is FOS v9.x or greater, select Settings in the Top Menu Bar, then select Services in the left panel, and then select License in the right panel to see the current licenses installed on the switch. Select the plus (+) icon in the top right to add a new License Certificate XML file.


--------------------------------------------------------------------------------------------------------------------------------------------
For further assistance: Contact your contracted support organization if you require additional assistance.
--------------------------------------------------------------------------------------------------------------------------------------------

Disclaimer:

This message, together with any attachments, is solely for the intended recipient, who is an end user of Brocade Communications Systems LLC ("Brocade") products or services. This message contains information that is proprietary and confidential to Brocade. If you are not the intended recipient, you are hereby notified that any use, dissemination, distribution, or copying of this message, or any attachment, is strictly prohibited. If you have received this message in error, please notify the original sender and delete this message, along with any attachments, from your computer.
