import {Component, ElementRef, OnInit, ViewChild} from '@angular/core';
import {UserServiceService} from '../user-service.service';
import {NgForm} from '@angular/forms';
import * as firebase from 'firebase';
import {el} from '@angular/platform-browser/testing/src/browser_util';

@Component({
  selector: 'app-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.css']
})
export class ModalComponent implements OnInit {

  @ViewChild('closeModalAdd') closeModalAdd: ElementRef;
  @ViewChild('closeModalStart') closeModalStart: ElementRef;
  @ViewChild('closeModalTrack') closeModalTrack: ElementRef;
  @ViewChild('closeModalManage') closeModalManage: ElementRef;
  @ViewChild('trackResult') trackResult: ElementRef;

  users: Array<null>;
  records: Array<null>;
  packageList: Array<null>;
  UsersRef: any;
  packageType: any;
  timestamp: any;
  manangePackageData: any;

  constructor(private userService: UserServiceService) { }

  ngOnInit() {
    this.UsersRef = firebase.database().ref('/users/');
    this.UsersRef.on('value', snapshot => {
          this.users = [];
          snapshot.forEach(user => {
              this.users.push(user.val());
          });
      });

    firebase.database().ref('/package/').on('value', snapshot => {
      this.packageList = [];
      snapshot.forEach(packageItem => {
        this.packageList.push(packageItem.val().pid);
      });
    });

  }

  onSubmit(form: NgForm) {
    const username = form.value.username;
    const password = form.value.password;
    const access = form.value.access;
    console.log({username, password, access});
    this.userService.addUser({username, password, access});
    alert('User Successfully Added !!');
    this.closeModalAdd.nativeElement.click();
  }

  generateSeqno () {
    let text = '';
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    for (let i = 0; i < 10; i++) {
      text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
  }

  onPackageStart(form1: NgForm) {
    const seqno = this.generateSeqno();
    const pid = 'NAZAR' + '803302' + 'BR' + 'BH' + '00001' + seqno;
    const type = form1.value.type;
    const timestamp = new Date().toString();
    this.userService.startPackage({pid, type, timestamp});
    alert('package sequence number : ' + seqno);
    this.closeModalStart.nativeElement.click();
  }

  onPackageTrack(form2: NgForm) {
    const pid = 'NAZAR803302BRBH00001' + form2.value.seqno.toString();
    firebase.database().ref('/package/' + pid + '/').once('value')
      .then((snapshot) => {
        if (snapshot.exists()) {
          this.closeModalTrack.nativeElement.click();
          this.trackResult.nativeElement.click();
          this.packageType = snapshot.val().type;
          this.timestamp = snapshot.val().timestamp;
          if (snapshot.val().scan) {
            this.records = Array.from(Object.keys(snapshot.val().scan), k => snapshot.val().scan[k]);
          } else {
            this.records = [];
          }
        } else {
          alert('Invalid Sequence Number !!');
          this.closeModalTrack.nativeElement.click();
        }
      })
      .catch(err => alert(err.message));
    console.log(this.records);
  }

  onPackageManage(form3: NgForm) {
    const pid = form3.value.package;
    const action = form3.value.actions;
    if (pid && action) {
      firebase.database().ref('/package/' + pid + '/').once('value')
        .then((snapshot) => {
          this.closeModalManage.nativeElement.click();
          if (action === 'Track') {
            this.packageType = snapshot.val().type;
            this.timestamp = snapshot.val().timestamp;
            if (snapshot.val().scan) {
              this.records = Array.from(Object.keys(snapshot.val().scan), k => snapshot.val().scan[k]);
            } else {
              this.records = [];
            }
            this.trackResult.nativeElement.click();
          } else {
            firebase.database().ref('/package/' + pid + '/').remove();
            alert('Package Deleted Successfully !!');
          }
        });
    } else {
      alert('Select valid option !!');
    }
  }
}
