# Lab 4: Debug a Problem with a Cloud Deployment and Fix It

## Part 1

***Task***

Our webpage deployed on Cloud VM returns HTTP error status code. Find the root cause, debug, and return the web server to normal.

***Solution***

1. Check the currently running service

    ```shell
    sudo systemctl status apache2
    ```

    In case the service has not been run, run this command.

    ```shell
    sudo systemctl start apache2
    ```

2. The `systemctl status` log shows the Apache HTTP Server failed to start because it failed to bind to port 80. It means port 80 may be in use.

3. To check the network-related information, use the following command  

    ```shell
    sudo netstat -nlp
    ```

4. The output shows that port 80 is currently used by Python3. Investigate the name of Python3 script that is currently running

    ```shell
    ps -ax | grep python3
    ```

5. There is only one Python script currently running, named `jimmytest.py`. Look at the code to make sure the code is actually using port 80

    ```shell
    cat /usr/local/bin/jimmytest.py
    ```

6. Kill the process

    ```shell
    sudo kill [process-id]
    ```

7. Because there is a service named `jimmytest.service` built on top of this Python script, killing the process will only temporarily solve the problem. If the VM reboots, the `systemctl` will `start` the service and use the port 80 again. Thefore, it is important to stop and disable the service as well.

    ```shell
    sudo systemctl stop jimmytest && sudo systemctl disable jimmytest
    ```

8. Double check the latest network status and ensure the port 80 is available

    ```shell
    sudo netstat -nlp
    ```

9. Restart the Apache server

    ```shell
    sudo systemctl start apache2
    ```

10. Obtain the public IP address given at the beginning, paste it in web browser, and confirm the web server has been back to normal.  
