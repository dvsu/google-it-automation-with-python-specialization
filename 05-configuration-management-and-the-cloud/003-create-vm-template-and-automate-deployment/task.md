# Lab 3: Create VM Template and Automate Deployment

## Part 1

***Task***

Deploy a virtual machine (VM) as a web server through web UI

***Solution***

1. Log in to GCP using Qwiklab credential
2. Go to  **Compute Engine** -> **VM Instances** and create a new virtual machine as per requirement  
3. SSH to the VM
4. Clone the sample project  

    ```shell
    git clone https://www.github.com/google/it-cert-automation-practice.git
    ```

5. There are 2 files in the sample project folders, a Python script to handle the HTTP/S requests and `.service` file to run the service automatically after reboot.

    Location of files

    ```shell
    cd ~/it-cert-automation-practice/Course5/Lab3
    ```

6. Copy the Python script to `bin` folder

    ```shell
    sudo cp hello_cloud.py /usr/local/bin/
    ```

7. Copy the `.service` file to `system` folder

    ```shell
    sudo cp hello_cloud.service /etc/systemd/system
    ```

8. Enable the service so it will start automatically after reboot

    ```shell
    sudo systemctl enable hello_cloud.service
    ```

9. Stop the VM instance, wait until it completely stop, and then start again

10. Copy the public IP of the instance, paste it on web browser, and ensure the web server is actually running

    ```none
    http://{ip_address}
    ```

## Part 2

***Task***  

Create multiple VM instances using a template.

***Solution***  

1. Stop the running VM
2. Go to **Compute Engine** -> **Images**, and create an image as per requirement
3. Next go to **Compute Engine** -> **Instance templates**, and create a template as per requirement
4. Assuming the [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstart-windows) has been installed and setup on local computer, run the following command on `Terminal` or `Command Prompt`, depending on OS

    ```none
    gcloud compute instances create --zone us-west1-b --source-instance-template vm1-template vm2 vm3 vm4 vm5 vm6 vm7 vm8
    ```

    The command will create 7 new VM instances named `vm2` - `vm8`

5. Once the setup has been completed, get the public IP address of each VM, paste it on web browser, and validate the web server is running

    ```none
    http://{ip_address}
    ```
