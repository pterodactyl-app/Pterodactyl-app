# Contributing

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

### Code of Conduct
This project and everyone participating in it is governed by our [Code of Conduct](https://github.com/rubentalstra/Pterodactyl-app/blob/master/CODE_OF_CONDUCT.md). By participating you are expected to uphold this code.

### Branches
This does not apply just yet, as the project is not in a production ready state at the moment, but will apply when the first stable release has been released.

The `master` branch should **always** be in a runnable and stable state, and should only be written to when there's a new release, or when a fix for a major bug has to be released.

Development should be done in the `develop` branch, this branch should - just like `master` - be in a runnable state at all times.

### Add Language

Make a Json file in: ```assets/lang/```, and name it like this ```en.json``` first 2 letter of the country code.

Then you copy this code:

```json
{
    "url_login":"URL (example https://panel.pterodactyl.app)",
    "api_key_login":"API KEY",
    "remember_me":"Remember me",
    "clear":"CLEAR",
    "next":"NEXT",
    "login_error":"username or password \ncan't be empty",
    "login_error_ok":"OK",
    "dashboard":"Dashboard",
    "logout":"Logout",
    "logout_sub":"Disconnect",
    "total_servers":"Total Servers",
    "settings":"Settings",
    "settings_sub":"Data, Night Mode",
    "license":"Licenses",
    "license_sub":"Get informations about the licenses",
    "alerts":"Alerts",
    "alerts_sub":"All ",
    "coming_soon":"Coming Soon",
    "coming_soon_sub":"Coming Soon",
    "server_list":"Server List",
    "total_disk":"Total Disk:",
    "total_ram":"Total Ram:",
    "action_start":"Start",
    "action_stop":"Stop",
    "action_restart":"Restart",
    "action_kill":"Kill",
    "action_stats": "Stats",
    "action_file": "File List (coming panel 0.8)",
    "dark_mode":"Dark mode",
    "dark_mode_sub":"Black and Grey Theme",
    "cores":"Cores",
    "console":"Console",
    "type_command_here":"Type command here...",
    "send_command":"Send a command",
    "app_version":"App Version",
    "notifications":"Enable notifications",
    "notifications_sub":"Get notifications in the main menu",
    "delete_data": "Delete all the data",
    "delete_data_sub": "This button delete all the data of the app!",
    "utilization_stats": "Stats",
    "utilization_stats_on": "State: $_stats",
    "utilization_performance_memory": "PERFORMANCE REPORT",
    "utilization_memory": "Memory",
    "utilization_performance_cpu": "PERFORMANCE REPORT",
    "utilization_cpu": "CPU",
    "utilization_performance_disk": "PERFORMANCE REPORT",
    "utilization_disk": "Disk",
    
    "Admin_Login": "ADMIN LOGIN",
    "Admin_NoAdminAccount": "Dont have an Admin account? Tap then here",
    "Admin_HomePanel": "Admin Panel",
    "Admin_HomeTotalNodes": "Total Nodes",
    "Admin_HomeTotalUsers": "Total Users",
    "Admin_Actionnodes_List_off_allocations": "List of all allocations",
    "Admin_Actionnodes_Create_allocation": "Create allocation",
    "Admin_ActionServer_Rebuild_server": "Rebuild Server",
    "Admin_Alert_Rebuild_server_info": "This will trigger a rebuild of the server container when it next starts up. This is useful if you modified the server configuration file manually, or something just didn't work out correctly.",
    "Admin_ActionServer_Reinstall_server": "Reinstall Server",
    "Admin_Alert_Reinstall_server_info": "This will reinstall the server with the assigned pack and service scripts. Danger! This could overwrite server data.",
    "Admin_ActionServer_suspend_server": "Suspend Server",
    "Admin_Alert_Suspend_server_info": "This will suspend the server, stop any running processes, and immediately block the user from being able to access their files or otherwise manage the server through the panel or API.",
    "Admin_ActionServer_unsuspend_server": "Unsuspend Server",
    "Admin_Alert_Unsuspend_server_info": "Your give the owner of this server his access back to his server do you want that?",
    "NO": "NO",
    "YES": "YES",
    "Admin_allocations_List": "List specific node allocations",
    "Admin_allocations_ID": "ID",
    "Admin_allocations_Assigned": "assigned",
    "Admin_allocations_Port": "Port",
    "Admin_allocationscreate_assign": "Assign New Allocations",
    "Admin_allocationscreate_IP": "IP Alias (not required)",
    "Admin_allocationscreate_Port": "Port (only one)",
    "Admin_create_user_Titel": "Create User",
    "Admin_create_user_username": "username",
    "Admin_create_user_email": "email",
    "Admin_create_user_first_name": "first name",
    "Admin_create_user_last_name": "last name",
    "Admin_create_user_last_password": "password",
    "Admin_create_user_Create_A_User": "Ceate a new user",
    "Admin_nodes_Nodes": "Nodes",
    "Admin_server_list":"Admin server list",
    "Admin_User_List_list": "Admin user list"    
}
```
And change to the languge you are working on. 

##Done !


Then make a pull requests and post your discord name#1234 with it so i can add you to the file with translators. 

Thank you very much.
