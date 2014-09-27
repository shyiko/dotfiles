alias ipfw-show='sudo ipfw show'
alias ipfw-80-to-8000='sudo ipfw add 100 fwd 127.0.0.1,8000 tcp from any to any 80 in'
alias ipfw-reset='sudo ipfw flush'

