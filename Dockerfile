FROM mediawiki:1.32.2
MAINTAINER aaraujo@protonmail.ch

# Dependencias
RUN apt-get update && apt-get install -y mysql-client unzip librsvg2-bin && apt-get clean && pear install mail net_smtp

# Composer
RUN curl -S https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin –filename=composer

# Extensiones y customizaciones
WORKDIR /var/www/html/extensions
RUN git clone --recurse-submodules -b REL1_32 https://gerrit.wikimedia.org/r/mediawiki/extensions/VisualEditor.git && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/TemplateStyles/+archive/REL1_32.tar.gz | tar xz --one-top-level=TemplateStyles && \
  cd TemplateStyles && php /usr/local/bin/composer.phar update --no-dev && cd .. && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/PluggableAuth/+archive/REL1_32.tar.gz | tar xz --one-top-level=PluggableAuth && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/OpenIDConnect/+archive/REL1_32.tar.gz | tar xz --one-top-level=OpenIDConnect && \
  cd OpenIDConnect && php /usr/local/bin/composer.phar update --no-dev && cd .. && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/Echo/+archive/REL1_32.tar.gz | tar xz --one-top-level=Echo && \
  cd Echo && php /usr/local/bin/composer.phar update --no-dev && cd .. && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/Flow/+archive/REL1_32.tar.gz | tar xz --one-top-level=Flow && \
  cd Flow && php /usr/local/bin/composer.phar update --no-dev && cd .. && \
  curl -S https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/EditNotify/+archive/REL1_32.tar.gz | tar xz --one-top-level=EditNotify && \
  cd EditNotify/i18n && cp en.json es.json && sed -i -e 's/was modified/tuvo modificaciones/' -e 's/was created/fue creada/' -e 's/Page/La página/' es.json && \
  echo ServerName web >> /etc/apache2/apache2.conf

####OTROS
#Mobile skins
#WORKDIR /var/www/html/skins
#RUN git clone --recurse-submodules https://github.com/hutchy68/pivot.git
#RUN echo '.oo-ui-tool .oo-ui-tool-link{ padding-top: 0em !important; }' >> pivot/assets/stylesheets/pivot.css
#RUN git clone --recurse-submodules --branch v2.2.0 https://github.com/thingles/foreground.git
#RUN git clone --recurse-submodules --branch v1.1.0 https://github.com/thaider/Tweeki.git

# Dejar en root para la shell
WORKDIR /var/www/html
COPY media/icons /opt/icons
COPY conf/LocalSettings.php LocalSettingsINIT.php
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
