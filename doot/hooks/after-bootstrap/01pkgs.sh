#!/bin/sh

# Ensure our package state is how we like it
# after bootstrapping.
mise x -- pkgstate fix

# Install our local repo packages
for pkgdir in pkgbuilds/*/; do
	# Skip dirs lacking a PKGBUILD
	[ -f "$pkgdir/PKGBUILD" ] || continue
	(
		cd "$pkgdir"
		makepkg -si
	)
done
