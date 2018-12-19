import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import * as firebase from 'firebase';
import {database} from 'firebase';

@Injectable({
  providedIn: 'root'
})

export class UserServiceService {

  constructor(private httpClient: HttpClient) { }

  listUsers() {
    return firebase.database().ref('users/').once('value')
      .then(snapshot => {
        return snapshot;
      });
  }

  addUser(userData) {
    firebase.database().ref('users/' + userData.username + '/').update({
      username : userData.username,
      password : userData.password,
      access: userData.access
    });
  }

  startPackage(data) {
    firebase.database().ref('package/' + data.pid + '/').update(data);
  }

}
