Return-Path: <SRS0=cf6o=BE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D83C433E0
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jul 2020 01:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BDDE206E3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jul 2020 01:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgGYBGZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Jul 2020 21:06:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54070 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbgGYBGZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Jul 2020 21:06:25 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jz8ds-0005Wt-Ci; Sat, 25 Jul 2020 02:06:24 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jz8dr-000ojG-Vg; Sat, 25 Jul 2020 02:06:23 +0100
Date:   Sat, 25 Jul 2020 02:06:23 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200725010623.GA194964@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In binutils 2.35, 'nm -D' changed to show symbol versions along with
symbol names, with the usual @@ separator.  When generating
libtraceevent-dynamic-list we need just the names, so strip off the
version suffix if present.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 tools/lib/traceevent/plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
index 349bb81482ab..680d883efe05 100644
--- a/tools/lib/traceevent/plugins/Makefile
+++ b/tools/lib/traceevent/plugins/Makefile
@@ -197,7 +197,7 @@ define do_generate_dynamic_list_file
 	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
 	if [ "$$symbol_type" = "U W" ];then				\
 		(echo '{';                                              \
-		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
+		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
 		echo '};';                                              \
 		) > $2;                                                 \
 	else                                                            \

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl8bhYoACgkQ57/I7JWG
EQm8Vg/+KQPovoOKX/NER3jGRmc8QwzaWDKqFX27KxZVpuXiRH4/HkiA+1Fyq+7/
M1i6D9oFlnAzH5BizYtFAyM2TSeznWQauKcpn9JPsgUY+boEe5YktbwpPMqjie60
Cm6zG9UNTn7Yh5u+PhD93Phheiv3qkQwRGMvtcDViz9XhIC43nl290twlEc+u1yf
83630LfU0QGnJhvHD5kvqO5yKE9QdcfR1sT9o5K2zTIMw5vf1UnbD4UNBtKr+eWm
R1MOKgRFg5pBye7yaD51aq3Qge9/0/WC722T3wcZzxtbTT1M9L60ckwualg97uLN
2dfkKg4xcyP6yWDTmcn4NSDj8RXropPQWN/J7aTROAfLGDgGliFm4L5sdlp3+S+L
lhglpEVr1tKDmC+f73QAi3h72Y9/gnburvF64sZOx+NUUsakWqNpjt5YbwaUBxsE
jCjdmVuHqCgzIuEcSs1rKXVMPWt+89x/XkSpgFYmNXWl98rY3SOqC9iB5g1JjhZS
ntFjlLzKSwsJJiR/fGsVN/cMzzkRwwhh7Od8hHDoYsYwT2XfDgQgiitXo6PYsVS0
L7Pp3VmSVO+n/UDaIACi8BtsFunpVRJ8VQaxV0Tr3/GaSe61LgdPAEu7rvvA0iA9
kiLWbtzpbplKbUDbDtK2rBiCP1Pgcxybte0baAFt9AV5kcGdQ8A=
=CD91
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
