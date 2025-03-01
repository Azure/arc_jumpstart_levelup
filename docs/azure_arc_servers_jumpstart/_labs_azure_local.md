# Lab track 2 - Azure Local

## Goals

After completion of this session, you will be able to:

- Use the Azure Portal and Windows Admin Center to manage an Azure Local cluster
- Create Azure Arc-enabled servers running on Azure Local

| Module |
|---------------|
|[**1 - Explore Azure Local administrative tools**](#module-1-explore-azure-local-administrative-tools) |
|[**2 - Create and manage Azure Arc-enabled servers running on Azure Local**](#module-2-create-and-manage-azure-arc-enabled-servers-running-on-azure-local) |

## Lab Environment

The lab environment is setup using the Arc Jumpstart scenario HCIBox, which is intended for users who want to experience Azure Local capabilities in a sandbox environment.

The following diagram shows the layout of the lab environment.

<img src="HCIBox-architecture.png" alt="Screenshot showing ArcBox architecture" width="800">

## Modules

### Module 1: Explore Azure Local administrative tools

#### Objective

The objective of this module is to familiarize you with the administrative tools available in Azure Local. You will learn how to navigate and utilize the Azure Portal and Windows Admin Center to manage your Azure Local cluster and Arc-enabled servers.

##### Task 1: Use the Azure portal to examine your Azure Local environment

1. **Log in to the Azure Portal**:
   - Open your web browser and navigate to the [Azure Portal](https://portal.azure.com).
   - Enter your student-credentials to log in.

2. **Navigate to Azure Arc**:
   - In the search bar, search for and select **Azure Arc**.
   - Under **Azure Arc**, expand **Host environments**, select **Azure Local** and navigate to the tab **All systems** to view the list of Azure Local systems available.

3. **Examine the Azure Local environment**:
   - Click on the Azure Local system named **hciboxcluster**
   - Explore the information in the tabs **Properties**, **Get started**, **Monitoring** and **Capabilities**
   - Expand **Infrastructure** in the menu on the left hand-side and select **Machines**
   - You will see a list of (normally physical) servers that are part of your Azure Local environment.
   - Click on any server to view its details, including its status, operating system, and manufacturer.
   - Explore the different options in the menu on the left hand-side such as **Extensions**.
       - The extensions pre-fixed **AzureEdge** are essential extensions for Azure Local to handle various aspects such as deployments and upgrades.

4. **Use the Windows Admin Center**:
   - By having Windows Admin Center integrated with Azure, you can use it to manage your Azure Local cluster from anywhere.
   - Navigate to the Azure Local system named **hciboxcluster**, expand **Settings** and select **Windows Admin Center** from the Azure Portal and connect to your Azure Local cluster.
   - Explore the various management tools available in Windows Admin Center to manage your servers and clusters.

By completing this task, you will gain a better understanding of how to use the Azure Portal and Windows Admin Center to manage your Azure Local environment.

### Module 2: Create and manage Azure Arc-enabled servers running on Azure Local

#### Objective

##### Task 1: Create a virtual machine

1. **Log in to the Azure Portal**:
   - Open your web browser and navigate to the [Azure Portal](https://portal.azure.com).
   - Enter your student-credentials to log in.


Add_Azure_Local_vm1b.png

2. **Navigate to Azure Arc**:
   - In the left-hand menu, select **Azure Arc**.

3. **Add a new server**:
   - There are two ways to access virtual machine provisioning on Azure Local in the Azure portal - you can select either one
       1) Under **Azure Arc**, select **Servers**.
           - Click on **+ Add** and select **Create a machine in a connected host environment**.
       - ![Screenshot of Add/Create option](./Add_Azure_Local_vm1a.png)
   2) Under **Azure Arc**, expand **Host environments**, select **Azure Local** and navigate to the tab **All systems** to view the list of Azure Local systems available.
       - Click on the Azure Local system named **hciboxcluster**
       - Expand **Resources** in the menu on the left hand-side, click **Virtual machines** and select **Create VM**
   - ![Screenshot of Add/Create option](./Add_Azure_Local_vm1b.png)

4. **Configure the virtual machine**:
   - Fill in the required details for your virtual machine:
     - **Subscription**: Select the subscription **Azure Arc Labs**
     - **Resource Group**: Select your resource group (**StudentXX**)
     - **Custom Location**: Select **jumpstart (Australia East)**
         - **Virtual machine kind**: **Azure Local**
     - **Security type**: Select **Standard**
     - **Storage path**: Select **Choose automatically**
     - **Image**: Select the operating system image for your VM.
         - Select **2404-ubuntu** if you want to create a Linux VM
         - Select **2025-datacenter** if you want to create a Windows VM
     - **Name**: Enter a name for your virtual machine
         - **studentXX-lin** if you want to create a Linux VM
         - **studentXX-win** if you want to create a Windows VM
     - **Size**
         - **Virtual processor count**: 2
         - **Memory (MB)**: 4096
         - **Memory type**: Static
    - **VM Extensions**
        - Leave the option **Enable guest management** selected
    - **VM proxy configuration**: Leave default/blank values
    - **Administrator account**: Specify credentials you decide
    - **Domain join**: Leave this option unchecked

    - Click **Next**.

5. **Configure storage**:
   - By default, the virtual machine will be created with one OS disk and no data disks.
   - Leave the default settings and click **Next**.

6. **Configure networking**:
   - Select **Add network interface**
       - Name: Append **-nic** to the VM name. E.g. **studentXX-win-nic**.
       - Network: Select **lnet-vms**.
   - **Allocation Method**: Leave **Automatic** selected
       - The VM will get a static IP address from a pre-defined IP pool assigned.
   - ![Screenshot of Add NIC](./Add_Azure_Local_vm3.png)
   - Click **Add**.
   - Click **Next**.
   - On the **Tags** tab, click **Next**.

7. **Review and create**:
   - Review the configuration settings.
   - ![Screenshot of Add NIC](./Add_Azure_Local_vm4.png)
   - Click on **Create** to deploy the virtual machine.
       - This will take approximately 5 minutes while the virtual machine is being provisioned from the selected image.

8. **Verify the deployment**:
   - Once the deployment is complete, navigate to the **Virtual Machines** section in the Azure Local cluster.
   - Verify that the new virtual machine is listed and check its status.
   - ![Screenshot of new VM](./Add_Azure_Local_vm5.png)

By completing this task, you will learn how to create and configure a virtual machine in your Azure Local environment using the Azure Portal.

