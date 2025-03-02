# Lab track 3 - Miscellenous

## Goals

In this immersive lab, participants will embark on a hands-on journey to explore the capabilities of Azure Arc. Utilizing the Azure Arc Jumpstart resources, attendees will gain a deep understanding of how Azure Arc functions and its applications in a real-world scenario. The session is crafted to encourage active participation, enabling attendees to not only listen but also engage directly with the material through hands-on labs.

## Modules

### Module 1: How to Use the Key Vault Extension to Acquire Certificates on Arc-Enabled Windows Servers

#### Objective

Managing certificates across multiple servers in a hybrid environment can be a complex and time-consuming task. Whether you’re securing a website with HTTPS or authenticating to another server, the need for secure deployment and renewal of certificates is constant. This challenge becomes even more daunting when you need to share the same certificate across numerous servers. To address these issues, the Azure Key Vault certificate sync extension for Arc-enabled servers offers a streamlined solution By the end of this guide, you will be able to securely acquire and manage certificates using the Azure Key Vault extension on your Azure Arc-enabled servers

![Screenshot of Add/Create option](./KeyVault_extension_1.png)

#### Task

Follow the steps in the Jumpstart Drop [How to Use the Key Vault Extension to Acquire Certificates on Arc-Enabled Windows Servers](https://arcjumpstart.azure.com/azure_jumpstart_drops?drop=How%20to%20Use%20the%20Key%20Vault%20Extension%20to%20Acquire%20Certificates%20on%20Arc-Enabled%20Windows%20Servers)

### Module 2: Certificate-Based Onboarding for Azure Arc-Enabled Servers

#### Objective

Azure Arc version 1.41 introduces certificate-based authentication for connecting and disconnecting servers, replacing the old method of using passwords. This new feature makes managing servers easier and more secure. By the end of this guide, you will be able to use certificates to securely manage and onboard your servers to Azure Arc.

![Screenshot of Add/Create option](./certificate_based_onboarding.jpg)

#### Task

Review the steps in the Jumpstart Drop [Certificate-Based Onboarding for Azure Arc-Enabled Servers](https://arcjumpstart.azure.com/azure_jumpstart_drops?drop=Certificate-Based%20Onboarding%20for%20Azure%20Arc-Enabled%20Servers)

Since no Certificate Services is available in the lab environment, this exercise needs to be performed in an environment where this is available.

For the workshop, read the guide to get an understanding of what is required to leverage certificate based onboarding and consider diving into this in your own lab environment later.
