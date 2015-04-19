fs      = require('fs');
squel   = require('squel');
Chance  = require('chance');
shortid = require('shortid');

chance  = new Chance();

// Read in the file
content = fs.readFileSync('data.csv', 'utf8').split(/\n/);
payload = [];
trackings = [];
packages = [];

/* Drop existing data */
console.log('DELETE FROM recipients;');
console.log('DELETE FROM packages;');

/* Recipients */
for (var i = 0; i < content.length; i++) {

  /*

  00: Oskari,
  01: Jantunen,
  02: 2302 Don Jackson Lane,
  03: Volcano,
  04: HI,
  05: Hawaii,
  06: 96785,
  07: US,
  08: United States,
  09: OskariJantunen@jourrapide.com,
  10: 1Z 487 89W 50 0627 099 5,
  11:575-74-1729,
  12: 2f3a95bd-aaf8-4983-b6a6-1d2d9b55dc68

   */

  raw = content[i].split(/,/);

  if (raw.length < 13) { continue; }

  var entry = {
    id: shortid.generate(),
    name: raw[1] + ' ' + raw[2],
    email: raw[10],
    zip: raw[07],
    address: raw[03] + ', ' + raw[04] + ', ' + raw[05]
  };

  payload.push(entry);

  trackings.push(raw[11]);

  var query = squel.insert()
    .into('recipients')
    .set('id', entry.id)
    .set('name', entry.name)
    .set('email', entry.email)
    .set('zip', entry.zip)
    .set('address', entry.address)
    .toString();


  console.log(query + ';');
}

/* Packages */
for (var j = 0; j < trackings.length; j++) {

  var rec = payload[chance.integer({min: 0, max:payload.length - 1})];



  var entry = {
    id: shortid.generate(),
    user: 'QyvFzJE3',
    recipient: rec.id,
    tracking: trackings[j].replace(/\s/g, ''),
    received: Math.round(chance.date({year: 2014}).getTime() / 1000),
    released: chance.bool() ? null : Math.round(chance.date({year: 2014}).getTime() / 1000),
    status: chance.bool() ? 1 : 0
  };

  packages.push(entry);

  var query = squel.insert()
    .into('packages')
    .set('id', entry.id)
    .set('user', entry.user)
    .set('recipient', entry.recipient)
    .set('tracking', entry.tracking)
    .set('received', entry.received)
    .set('released', entry.released)
    .set('status', entry.status)
    .toString();

  console.log(query + ';');
}
