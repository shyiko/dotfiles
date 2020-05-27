#!/bin/bash
exec google-chrome-stable --app="https://mail.google.com/mail/u/0/#search/label%3Aunread"
