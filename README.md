
# Agenda Application

## Introduction

This application is designed to demonstrate how to structure and implement the architecture of an agenda system. It uses modern web technologies and a scalable design to handle real-time slot bookings efficiently. 

You can find more projects on my portfolio listing: https://github.com/gustavobap/Portfolio

## Table of Contents

1. [Architecture](#architecture)
2. [Setup Instructions](#setup-instructions)
3. [Usage Instructions](#usage-instructions)
4. [Future Enhancements](#future-enhancements)
5. [Contact Information](#contact-information)
6. [License](#license)

## Architecture

![AgendaApplication](https://github.com/user-attachments/assets/91fe171f-5d36-4a42-b42c-b7c17bf5b70a)

The application comprises:
- **Frontend**: A React application presenting time slots in rows and columns, allowing users to book and view availability.
- **Backend**: A NestJS application handling booking logic, overlap checks, real-time updates, and database interactions.
- **Database**: PostgreSQL, using the `tsRange` type for efficient and straightforward overlap calculations.
- **WebSocket**: Enables real-time updates for users viewing the same day's schedule. ![In Progress](https://img.shields.io/badge/In%20Progress-orange?style=flat-square)

- **Docker**: Used to containerize and orchestrate services with Docker Compose.

## Setup Instructions

### Clone repositories

This is the main repository containing the Docker infrastructure. The backend and frontend codebases are kept in separate private repositories and configured as git submodules. You will need to be granted access to them. To clone this repository together with the submodules, use the `--recurse-submodules` flag, for example:

```bash
git clone --recurse-submodules github.com:gustavobap/AgendaNestReact.git
```

These are the repositories for the submodules:
- NestJS Backend: https://github.com/gustavobap/AgendaNest
- React Frontend: https://github.com/gustavobap/AgendaReact

### Configure and run

This project uses **docker** and **docker-compose** to build all infrastructure. You will need both installed.
**The setup was only tested in Ubuntu**

First configure server's and client's IPs and ports in the **docker/.env** file. Default values are shown bellow.

```bash
CLIENT_IP=localhost
CLIENT_PORT=80
SERVER_IP=localhost
API_PORT=3010
```

Then build infrastructure and apps with the provided script 

```bash
./scripts/prod/install.sh
```

It will take some time for all the building to finish. After it's done you can access the app at the configured URL. 

eg. http://localhost 

You can remove docker images and containers running following script

```bash
./scripts/prod/uninstall.sh
```
## Usage Instructions

1. **Select Time Slot Date and Length**  
   Users can book time slots with lengths that are multiples of 15 minutes. They begin by selecting a date and the desired duration in minutes (maximum of 3 days).
   - For demonstration purposes, the duration can be set by typing in the text input field or by dragging the slider. Both inputs will update accordingly.

2. **Visual Calendar Display**  
   The calendar displays tiles arranged in a grid, each representing a 15-minute time slot starting from midnight (00:00) and covering a full 24-hour day.  
   - **Green tiles**: Indicate that the slot is available as a start time for the booking.  
   - **Red tiles**: Indicate that the slot is unavailable.  

3. **Dynamic Updates Based on Input**  
   Initially, the calendar shows availability for the current day with a 15-minute booking length. When users modify the date or duration inputs, the calendar updates in real time to reflect availability.

4. **Confirming a Booking**  
   Once users select a starting time, the system sends a booking request to the backend.  
   - The backend checks for overlaps (using concurrency management techniques) and registers the slot if it is available.  
   - If the slot is unavailable, the user is notified of the conflict.

5. **Real-Time Updates**  ![In Progress](https://img.shields.io/badge/In%20Progress-orange?style=flat-square)  
   If another user books a slot while you are viewing the calendar, the system immediately reflects the change. Real-time updates are powered by WebSockets, ensuring all users see the latest availability.

![AgendaApplicationScreenshot2](https://github.com/user-attachments/assets/0324ab78-a240-4415-9efb-16d49fb1eaf0)

### Concurrency Management
- The system uses database locks and transactions to prevent overlapping bookings, even when multiple users interact concurrently.
- Targeted locks are created only on the days affected by the schedule during a booking request. This approach avoids locking the entire table, ensuring efficient handling of concurrent operations while maintaining data integrity.

### Real-Time Updates ![In Progress](https://img.shields.io/badge/In%20Progress-orange?style=flat-square)
- WebSocket is used to ensure that schedule availability changes are broadcast only to users actively viewing the relevant calendar days.
- Similar to the strategy for database locking, clients subscribe only to rooms for the days affected by the booking slot length. This approach avoids unnecessary system-wide broadcasts, enhancing both scalability and performance.

### Database Design
- **Time Slot Representation**: The application uses the PostgreSQL `tsRange` type for defining time slots, leveraging PostgreSQL's range features for efficient overlap calculations directly in the database.

---

## Future Enhancements
- Adding automated tests to ensure reliability.
- Improving responsiveness for smaller screens.
- Implementing light/dark mode for better user experience.

## Contact Information
For questions or support, please contact gustavo.peixoto.jobs@gmail.com

## License
GNU General Public License v3
