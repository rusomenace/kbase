# Troubleshooting Tip: Possible reasons for FortiClient SSL-VPN connectivity failure at specific percentages

## 10%

- The issue is usually due to network connection.
- Check whether the PC is able to access the internet and reach VPN server on necessary port.
- Check whether the correct remote Gateway and port are configured in FortiClient settings.
- Confirm whether the server certificate has been selected in FortiGate SSL VPN settings. 

## 31%

- Negotiation stops at this percentage with error -5029. If this message appears, there is a mismatch in the TLS version. Check if the TLS version that’s in use by the FortiGate is enabled on your client. This KB article explains how to check the TLS version.

## 40%

- This may occur when FortiClient generates a new pop-up window verifying whether the user wishes to proceed with a non-trusted TLS/SSL certificate.
- It may mean that there is a TLS version mismatch, which will also show as error -5029. If this message appears, there is a mismatch in the TLS version. Check if the TLS version that’s in use by the FortiGate is enabled on your client. This KB article explains how to check the TLS version.
- An application or the FortiGate may cause this error. Check the local machine and network setup.

## 48%

- Negotiation stops at this percentage if there is an issue with two-factor authentication.

## 80%

- Negotiation stops at this stage due to issues with user privileges.

- If negotiation stops at this stage, check whether the username and password were entered correctly.
- Check the user and user group. This issue often occurs if the user is not in the correct user group that has VPN access.
- If a user has a configured user group in the SSL VPN settings, always configure the user group in the firewall policy.
- This issue may occur if a corresponding policy for the users has not been configured.
- Additionally, check whether the correct Realm is being used if any are configured.

## 98%

- Issues at this stage usually occurs due to a corrupted installation of FortiClient or due to OS problems.
- Reinstall the FortiClient software on the system.

- This may also occur when attempting to negotiate SSL VPN with the free version of FortiClient.