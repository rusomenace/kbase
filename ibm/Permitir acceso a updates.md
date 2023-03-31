# Setting up call home with cloud services
Last Updated: 2022-09-01

Call Home with cloud services sends notifications directly to a centralized file repository that contains troubleshooting information that is gathered from customers. Support personnel can access this repository and be assigned issues automatically as problem reports. This method of transmitting notifications from the system to support removes the need for customers to create problem reports manually.

As part of Call Home with cloud services configuration, you can define an internal proxy server within your network to manage connections between the system and the support center. Other connection configurations are supported for Call Home with cloud services.

## Prerequisites
If you are using Call Home with cloud services to send notifications to the support center, you need to ensure that the system can connect to the support center.

Before you configure Call Home with cloud services, ensure that the following prerequisites are configured on the system:
Ensure that all the nodes on the system have internet access.
Ensure that a valid service IP address is configured on each node on the system.
Call Home with cloud services support the following configurations that have extra network requirements.

Table 1. Supported network configurations for Call Home with cloud services
|                 **Supported configuration**                 |   **DNS configuration**   |                                                                                       **Firewall requirements**                                                                                      |
|:-----------------------------------------------------------:|:-------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Call Home with cloud services with an internal proxy server | Required                  | Configure firewall to allow outbound traffic on port 443 to esupport.ibm.com                                                                                                                         |
| Call Home with cloud services with a DNS server             | Defined, but not required | Configure firewall to allow outbound traffic on port 443 to esupport.ibm.com. Optionally allow outbound traffic on port 443 to the following IP addresses: 129.42.56.189 129.42.54.189 129.42.60.189 |
| Call Home with cloud services                               | None                      | Configure firewall to allow outbound traffic on port 443 to the following support IP addresses: 129.42.56.189 129.42.54.189 129.42.60.189                                                            |

## Using the management GUI
If you did not configure Call Home during system setup, you can configure this function in the management GUI. You can also change or update current settings on the Call Home page. To configure or update Call Home with cloud services, complete these steps:
1. In the management GUI, select Settings > Support > Call Home.
2. On the Call Home page, select Send data with Call Home cloud services and click Edit.
3. Verify that the connection status is Active and a message displays that indicates the connection was successful. If the connection status displays Error, select Monitoring > Events. If Call Home with cloud services is configured, the following connection statuses can be displayed:
   
**Active**

    Indicates that the connection is active between the system and the support center. A timestamp displays with the last successful connection between the system and the support center.

**Error**

    Indicates that the system cannot connect to the support center through Call Home with cloud services. The system attempts connections every 30 minutes and if the connection continually fails for four hours, an event error is raised and is displayed. A timestamp displays when the failed connection attempt occurred. Select Monitoring > Events to determine the cause of the problem. Use the lscloudcallhome command to display the status of the connection. The system attempts connections for four hours and if the connection continually fails, an event error is raised. If the connection parameter displays error_sequence_number, the last attempt to connect to the support center failed. The error_sequence_number indicates the error number that can be used to determine the cause of the problem. One common issue that causes connection errors between the system and support center is firewall filters that exclude connections to the support center.

**Untried**

    Indicates that Call Home with cloud services is enabled but the system is waiting for the results from the connection test to the support center. After the test completes, the connection status changes to either Active or Error.

4. To define an internal proxy server to manage connections between the system and support, click Add Proxy. A DNS server is required to use an internal proxy server with Call Home with cloud services. The management GUI prompts you to define a DNS server if one is not configured.
5. Under Additional Settings, enter your preferences for inventory intervals and configuration reporting. Inventory reports can be configured with Call Home and provides additional information to support personnel. An inventory report summarizes the hardware components and configuration of a system. Support personnel can use this information to contact you when relevant updates are available or when an issue that can affect your configuration is discovered. By default, these reports include configuration data that support personnel can use to automatically generate recommendations that are based on your actual configuration. You can have sensitive data redacted from these reports, if necessary.
Click Save.

## Using the command-line interface
To configure Call Home with cloud services in the command-line interface, complete these steps:
1. To create at least one DNS server for Call Home with cloud services, enter the following command:
```
mkdnsserver -name mydns
            –ip x.x.x.x.x'
```

Where mydns is the name of the DNS server and x.x.x.x.x is the IP address for the DNS server.

2. To use an internal proxy server to manage outbound connections to the support center, enter one of the following set of commands:
    * To create an open proxy without any access controls, enter the following command:
         ```
        mkproxy -url http://proxy.mycompany.com -port 8080 
         ```
    where https://proxy1.mycompany.com is the URL for the proxy server and 8080 is the port.

    * To create a proxy server that requires basic authentication for connections, enter the following command:
        ```
        mkproxy -url http://proxy.mycompany.com -port 8080 -username myusername -password mypassword
        ```
    * To encrypt packages that sent to support through a proxy server, enter the following command:
        ```
        mkproxy -url https://proxy1.mycompany.com -port 4128 -sslcert /cert/mycert.pem
        ```

    * To use both basic authentication and encryption, enter the following command:
        ```
        mkproxy -url http://proxy.mycompany.com -port 8080 -username myusername -password mypassword -sslcert /cert/mycert.pem
        ```
3. To enable Call Home with cloud services, enter the following command :
```
chcloudcallhome -enable
```
4. To verify that the connection was established between the system and support center through cloud services, enter the following command:
```
lscloudcallhome
```
In the results that display, verify that the status is enabled and the connection is active. These values indicate that the system is enabled for Call Home with cloud services and that a valid connection between the system and the support center is established. The system attempts connections every 30 minutes and if the connection continually fails for four hours, an event error is raised and is displayed in the error_sequence_number parameter. If the value in the connection parameter is error, the error_sequence_number parameter indicates the event code that was created. Check the event log for more details on the error.

[Source](https://www.ibm.com/docs/en/flashsystem-5x00/8.4.x?topic=home-setting-up-call-cloud-services)