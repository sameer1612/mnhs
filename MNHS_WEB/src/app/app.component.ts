import {Component, OnInit} from '@angular/core';
import * as firebase from 'firebase';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'MNHS';

  ngOnInit(): void {
    // Initialize Firebase
    const config = {
      apiKey: 'AIzaSyD8H5B1k4T4ov58t18ARCkq9zFu_Ih27_4',
      authDomain: 'mnhsapi.firebaseapp.com',
      databaseURL: 'https://mnhsapi.firebaseio.com',
      projectId: 'mnhsapi',
      storageBucket: 'mnhsapi.appspot.com',
      messagingSenderId: '1049002708092'
    };
    firebase.initializeApp(config);
  }
}
