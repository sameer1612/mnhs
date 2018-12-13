import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})

export class UserServiceService {

  constructor(private httpClient: HttpClient) { }

  listUsers() {
    return this.httpClient.get('https://nazarethmokama.org/mnhs/getUsers.php');
  }

  addUser(userData) {
    return this.httpClient.get('https://nazarethmokama.org/mnhs/addUser.php/?uname=' + userData.username + '&upass=' + userData.password + '&access=' + userData.access);
  }

}
