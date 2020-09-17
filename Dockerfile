FROM nginx
#RUN echo '<h1>Hello, this is IEEE P21451-1-5 working group.</h1>' > /usr/share/nginx/html/index.html
COPY ./index.html /usr/share/nginx/html/index.html
COPY ./bio.png /usr/share/nginx/html/bio.png
