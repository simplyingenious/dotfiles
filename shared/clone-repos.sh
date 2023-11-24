#!/bin/bash

# Change this value your custom location
CLONE_PATH='code'

function clone () {
	# CD to folder where git repos are kept
	cd $HOME/$CLONE_PATH

  echo "Cloning repositories"

  # Open source projects
	git clone git@github.com:SectorLabs/crm-classified-admin.git
	git clone git@github.com:SectorLabs/inspection-pro-admin.git
  git clone git@github.com:SectorLabs/inspection-pro-backend.git
	git clone git@github.com:SectorLabs/lamudi-nextjs.git
  git clone git@github.com:simplyingenious/nextjs-blog.git
  git clone git@github.com:simplyingenious/nextjs-ui-components.git
	git clone git@github.com:SectorLabs/olx-ecommerce.git
  git clone git@github.com:SectorLabs/olx-mall-nextjs.git
	git clone git@github.com:SectorLabs/olx-motors-nextjs.git
  # git clone git@github.com:SectorLabs/zameen-discourse.git
  # git clone git@github.com:SectorLabs/zameen-discourse-theme.git
	git clone git@github.com:SectorLabs/zameen_nextjs.git zameen-nextjs
}

clone
unset clone
