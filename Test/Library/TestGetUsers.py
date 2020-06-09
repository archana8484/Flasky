#!/usr/local/bin/python3.7
from GetUpdateUsers import *
import pytest
import requests
base_url= "http://localhost:8080/"

def test_get_users():
    assert  get_all_users() == ['sampleuser','testuser1','testuser2']

def test_get_users_fail():
    assert  get_all_users() == ['sample','testuser1']

def test_get_user_info():
    expected_payload = {"firstname" : "Maija",
                        "lastname" : "pekonen",
                        "phone" : "0507897654"}
    resp = requests.get(base_url + "api/auth/token",auth=('testuser1','testuser1'))
    token= resp.json()['token']
    assert get_user_info_internal(token,'testuser1') == expected_payload

def test_get_user_info_fail():
    expected_payload = {"firstname" : "Maija",
                        "lastname" : "pekonen",
                        "phone" : "3565"}
    resp = requests.get(base_url + "api/auth/token",auth=('testuser1','testuser1'))
    token= resp.json()['token']
    assert get_user_info_internal(token,'testuser1') == expected_payload