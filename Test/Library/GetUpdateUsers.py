#!/usr/local/bin/python3.7
import requests
import json
from requests.auth import HTTPBasicAuth

base_url= "http://0.0.0.0:8080/"
auth_token=''
g_userid='';

def print_user(userInfo):
    print ('\n'.join("{!s} : {!r}".format(key,val) for (key,val) in userInfo.items()))

def get_all_users():
    resp = requests.get(base_url + 'api/users')
    if resp.ok:
        usersList = resp.json()['payload']
        print('\n Registered Users :\n')
        print('\n'.join(usersList))
        return usersList
    else:
        print('Server error!')

def get_user_info():
    token,userid = auth_user()
    print('\nFetching user details for '+userid + ' ...')
    userDetails = get_user_info_internal(token, userid)
    print_user(userDetails)

def get_user_info_internal(token, userid):
    header_gs = {'Token': token,
                 'Content-Type': 'application/json'}
    response = requests.get(base_url + 'api/users/'+userid, headers=header_gs)
    if response.ok:
        return response.json()["payload"]

def logout():
    global auth_token
    global g_userid
    auth_token='';
    g_userid='';
    print('\n Logged out user.')

def auth_user():
    global auth_token
    global g_userid
    attempt=0;
    if auth_token != '':
        return auth_token,g_userid
    print('\nAuthenticate User:')
    while True:
        attempt+=1;
        userid = input("\nUsername: ")
        passwd = input("Password: ")
        resp = requests.get(base_url + "api/auth/token",auth=(userid,passwd))
        if resp.ok:
            token= resp.json()['token']
            auth_token=token;
            g_userid = userid
            return token,userid
        else :
            print ('\n Invalid username/passowrd. Please try again.')
        if attempt==5 :
            print ('\n Sorry too many attempts. Exiting application.\n');
            exit_();

def update_user():
    token,userid = auth_user()
    userDetails = get_user_info_internal(token, userid)
    print('\nUpdating user details for '+userid + ' ...')
    infolist = {"1":("firstname",userDetails['firstname']),
                "2":("lastname",userDetails['lastname']),
                "3":("phone",userDetails['phone']),
                "4":("save it",''),
                "5":("I changed my mind!", '')}
    new_values = {}
    while True:
        print("\n ----------------------\n")
        for data in sorted(infolist.keys()):
            print(data +" : " + ':'.join(infolist[data]))
            if new_values.get(infolist[data][0]) != None :
                print ('       New Value --> ' + new_values.get(infolist[data][0]))

        update_info = input("\n Choose the information to be updated : ")
        info = infolist.get(update_info, "6")
        if update_info == "5":
            return
        elif update_info == "4":
            payload=json.dumps(new_values)
            print(payload)
            header_gs = {'Token': token,'Content-Type': 'application/json'}
            json_data = json.loads(payload)
            resp = requests.put(base_url + 'api/users/'+userid, headers=header_gs,json=json_data)
            print(resp)
            if resp.ok:
                print('\nUpdated data successfully for '+ userid)
                userDetails = get_user_info_internal(token, userid)
                new_values = {}
        elif update_info in ("1", "2", "3") :
            new_values[info[0]] = input("\n Provide new value for " + info[0] + ": " )
        else :
            invalid_selection

def exit_():
    print('\n Thank You. Good Bye!')
    raise SystemExit

def invalid_selection():
    print('\n **************** Invalid selection! Please make a valid choice. \n')

def main():
    main_menu = {"1":("List Users",get_all_users),
                 "2":("Get User Info",get_user_info),
                 "3":("Update User Info",update_user),
                 "4":("Logout",logout),
                 "5":("Quit",exit_)}
    while True:
        print("\n ----------------------\n")
        for menu_item in sorted(main_menu.keys()):
            print(menu_item +" : " + main_menu[menu_item][0])

        user_input = input("\n Make A Choice : ")
        main_menu.get(user_input,[None,invalid_selection])[1]()

if __name__ == "__main__":
    main()