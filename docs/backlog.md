# Product Backlog

## Problem Statement
The current state of the mailrooms in Purdue residence halls is mediocre at best.
After a shipping service such as UPS delivers a package, it can be up to several
hours before the package is ready for pickup by the student. This is where Tranzit
comes in; our web- based system will allow for much faster confirmation that a
package has been received and is ready for pickup by the student. It will also
provide an easy interface for the mailroom workers to catalog and release packages
to the students.

## Background Information
Purdue’s residence hall mailroom services suffer from major inefficiencies. In the
most extreme cases, packages delivered at 2pm are only ready for pickup by 11pm,
which constitutes a 9 hour delay. According to our observation, cataloging one
single package involves multiple steps, which are:

 + Click on input field to focus on it
 + Type in entire student name and click ‘search’
 + Wait 10 seconds before search results appear
 + Select package recipient name from search results
 + Fill in tracking number and other information (every field has to be manually focused on)
 + Print mailroom label, scan it and stick it on to the package
 + Wait another 10 seconds for the system to confirm

Releasing packages involves a series of similar steps. We strongly believe that
inefficiencies in the cataloging software are a major factor in the delay between
package delivery and availability for pickup.

It is also a hassle for front desk workers to process packages with the currently
used software, since most of us heard complaints on the days when there are numerous
packages delivered. The aforementioned delay also results in numerous complaints
from students who cannot pick up their packages in a timely manner.

We therefore propose to develop a new software for cataloging the packages, that aims
to address efficiency issues of the currently used system. For example, reducing the
number of clicks, keystrokes and delays during the cataloging and release process.
We believe that reducing the series of steps mentioned above to a single barcode scan
would drastically improve the efficiency of Purdue’s mailroom service and reduce
delays between ￼￼￼package delivery and availability for pickup. Simplification of the
cataloging process would also greatly benefit targeted users of the software:
residence hall front desk workers.

## Requirements

### Functional Requirements
**As a developer**
 + I’d like to easily build project source files into a deployable bundle
 + I’d like to run tests and receive feedback as whether the test passed
 + I’d like to be able to remotely update the software

**As a user**
 + I’d like to see the application page
 + I’d like to authenticate myself to the application to gain access
 + I’d like to log out of the application to revoke access
 + I’d like to modify my login credentials
 + I’d like to register arrival of an incoming package
 + I’d like to register a package pickup by recipient
 + I’d like to find all packages that arrived within the date range
 + I’d like to find all packages that arrived at a specific location
 + I’d like the system to automatically send an email notifying the recipient
 that a package arrived
 + I’d like the system to automatically send daily reminders to recipients of
 packages that have not been picked up
 + I’d like to be notified if a package has been in storage for more than the
 maximum storage period
 + I’d like to delete package entries from the system

### Non-functional requirements
 + The system must be modular and extendable
 + The system must easily interface with external systems
 + The system must be able to handle multiple users at once (only one user per terminal)
 + The system must have a secure centralized storage for data
 + The system must respond to user input quickly
 + The system must display a busy indicator when a long-running operation is taking place
 + The system must be efficient
 + The system must require minimal effort for users to understand and navigate it
 + The system must follow design patterns and standards
 + The system must support the most popular browsers
