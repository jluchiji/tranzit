# Project Charter

## Team Members
**Leader**: Denis Luchijinzhou  
**Members**: Fangzhou Lin, Austin Ottinger, Alex Rosenberg, Michael Schloss

## Problem Statement
With online shopping gaining popularity, package distribution within Purdue
University is facing increasing loads. It is an essential experience for
anyone living on campus to receive packages via residence hall front desk.
However, it is common that a package is only available for pickup hours after
delivery, which we believe is in part due to poor usability and performance
of the software system used by University Residences. We propose to develop
a highly efficient solution to speed up package processing and cut dow
unnecessary hassle for front desk staff.

## Project Objectives
 + Allow front desk staff to catalog incoming packages with minimal interaction.
 + Implement a highly efficient system to search packages by various criteria.
 + Develop a RESTful API to allow 3rd party tools to access package catalog data.
 + Create a fluent user experience that is easy to learn and use.
 + Minimize the amount of time and effort it takes to catalog packages.

## Stakeholders
**Owner**: Development Team  
**Manager**: [Project Coordinator]  
**Developers**: see Team Members section.  
**Users**: Purdue University residence hall staff working on package processing

## Deliverables
A functional, well designed and easy to use web application that allows
effortless cataloging and search of incoming packages. The solution would
involve a server backend and a client- side front end application, detailed
as following:

### Backend
HTTP web server that hosts both client-side application and RESTful API
for data access.

**Platform**: Node.js  
**Languages**: Javascript, Coffeescript  
**Frameworks**: Express.js  
**Database**: MySQL Server  

### Frontend
Reactive HTML5-based web application that interfaces with the backend’s
RESTful API.

**Platform**: HTML5, CSS3  
**Languages**: HTML, Jade, Javascript, Coffeescript, CSS, LESS  
**Frameworks**: Angular.js, Bootstrap  

### Miscellaneous
Project will utilize Gulp.js with various plugins to build source code into the deployable form of the project.
