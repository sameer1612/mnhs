import { Component, OnInit } from '@angular/core';
import {UserServiceService} from '../user-service.service';
import {NgForm} from '@angular/forms';

@Component({
  selector: 'app-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.css']
})
export class ModalComponent implements OnInit {

  users: any;

  constructor(private userService: UserServiceService) { }

  ngOnInit() {
    this.userService.listUsers().subscribe(data => {
      this.users = data;
      console.log(this.users);
    });
  }

  onSubmit(form: NgForm) {
    const username = form.value.username;
    const password = form.value.password;
    const access = form.value.access;

    console.log({username, password, access});

    this.userService.addUser({username, password, access}).subscribe(data => {
      if (data === 1) {
        alert('User Successfully Created.');
      } else {
        alert('Oops ! Something went wrong.');
      }
      window.location.reload();
    });

  }

}
