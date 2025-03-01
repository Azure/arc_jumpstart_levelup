# Azure Arc Masterclass labs

## Goals

After completion of this session, you will be able to:

- Use the Azure Portal and Windows Admin Center to manage an Azure Local cluster
- Create Azure Arc-enabled servers running on Azure Local


| Module |
|---------------|
|[**1 - Onboard Windows and Linux servers running using different onboarding methods**](#module-1-on-boarding-to-azure-arc-enabled-servers) |
|[**2 - Query and inventory your Azure Arc-enabled servers using Azure Resource Graph**](#module-2-query-and-inventory-your-azure-arc-enabled-servers-using-azure-resource-graph) |

## Lab Environment

ArcBox Lab edition is a special “flavor” of ArcBox that is intended for users who want to experience Azure Arc-enabled servers' capabilities in a sandbox environment. Screenshot below shows layout of the lab environment.

  ![Screenshot showing ArcBox architecture](HCIBox-architecture.png)

## Modules

### Module 1: On-boarding to Azure Arc-enabled servers

#### Objective

The deployment process should have set up four VMs running on Hyper-V in the ArcBox-Client machine. Two of these machines have been connected to Azure Arc already. In this exercise you will verify that these two machines are indeed Arc-enabled and you will identify the other two machines that you will Arc-enable.

##### Task 1: Use the Azure portal to examine you Arc-enabled machines inventory
