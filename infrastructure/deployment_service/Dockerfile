FROM ruby:2.7
ENV HA_BACKEND=irisvpn \
    IMAGE=panchatattva/irisvpn.com

COPY . .
CMD ruby deployment.rb \
         ${HA_BACKEND} \
         ${IMAGE}
