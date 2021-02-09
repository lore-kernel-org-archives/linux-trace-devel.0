Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E040C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0617464EAA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhBIQOB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:14:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:47990 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhBIQN5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 11:13:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612887190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B3tEVI0BEHgBxQU0oxvAYamy9tLRqqyK4XaYm8KQI0s=;
        b=NPKunZjSL92yZ65uOk6RcZ9476738Aoe8r7iXJbSWIfQwUvk2IM/aH7VAWXG13mZ3rbD01
        vAxKKl+UY+4jgbMxQcezjx1LFe2oDZKjSH5nyb0BkvKmPfgwwW6symGTMPFdUGVJFmwV3J
        3TmQdc+JnQ50/+KWsW7YuONRw7S9NTc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A86A4AF0E;
        Tue,  9 Feb 2021 16:13:10 +0000 (UTC)
Message-ID: <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
Subject: Re: Kernelshark v2 all-black plots area
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 09 Feb 2021 17:13:09 +0100
In-Reply-To: <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
         <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Tlz3SgJNV+zq+QL2IjFS"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-Tlz3SgJNV+zq+QL2IjFS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 15:06 +0200, Yordan Karadzhov (VMware) wrote:
> Ciao Dario,
>=20
Ciao! :-)

> There is a bug in one of the patches from the last patch-set I sent.=20
> This bug was reported by Tzvetomir. My guess is that you are hitting
> the=20
> same issue. If this is the case you must also have an error message=20
> saying "Unable to find FreeSans font".
>=20
Yep, I was seeing that too. And, TBH, for a while I installed font
packages like mad, thinking it was related to something like that. :-P

> You can manually do the fix suggested by Tzvetomir (see his reply to=20
> [PATCH 15/24] kernel-shark: Update KsDualMarker and KsGLWidget) or
> just=20
> get a corrected (rebased) version of the code from
> https://github.com/yordan-karadzhov/kernel-shark-v2.beta
>=20
Ah, great! I updated (rebase included), and now plots are back.

> Please let me know if this fixes your issue.
>
Indeed it does, thanks a lot again.

Now, if I try "KVM Combo Plot":
- I still see super weird results if I use the KVM clock from last
  patch in Tzvetomir series (but I guess I'll report it there).
- If I use PTP, that kind of works.

If I trace a `sleep 1` on the host, the result is like this:

http://xenbits.xen.org/people/dariof/kernelshark-v2-ptp.png

So, there is ~ 1 sec of data from the guest, coming from trace-cmd
agent. The host, however, went on and traced a little bit longer, even
after closing the connection. It's not too terrible, I'm just curious
whether this is known or it's something weird and it's only me seeing
it.

Evaluating the correctness and the accuracy of the synchronization is a
little bit of a challenge, especially for me that I'm not used to it.
And, at least in part, because I still don't have this change in the
kernel I'm using right now, so some kvm_entry trace points are not
recorded, which means it's tricky pairing VMEntries and VMExits:

https://lore.kernel.org/lkml/160873470698.11652.13483635328769030605.stgit@=
Wayrath/

It should come with 5.11, but I think I'll quickly apply it to the 5.10
that I'm running, to try to understand better hat's going on.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Tlz3SgJNV+zq+QL2IjFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAitJUACgkQFkJ4iaW4
c+5yXQ/+NJt+9KxwfW2brA79w18BeICru6+MLjw23xJFDX/e+day7rBZpVJhECW5
ci89mJey/T84hZouGR1nbLHBndHrYfiWKU32AqvAMdW2OsMN+0YF7f1xQzlNPUHg
ysyX87GKkicj7n0vffpupukrTlnzdzBHFWBwqX3NDLfudI33/JTPNkrNOFMzW8/f
Z2OmkwiJQ9AEFxT31VU872m11XSVkJGp05x1U1VhacaZTyh+EO/vrS8/FG3hUT8d
NQeGRnFtYL2r3ArFSTH+8/EDktr2S2dQvlhPtJva+1URsCbfKTTAw4UGAuM8akWo
Bifv1DxdrCQzWPGp577kOXjMlDty53l8KmdCrw6KEmR69IT8Czzsc8VsorSaxgA0
+LjLC2lgS8B4PCANpaCE2Cs+25M6NTN/3+d+dtCMygF22M/OU1hubJCCHKIynGdS
1ZM0+f4Yy+Ope/PV1k7fcH7PofOhxN/0emoyo02y4KYJ8tSK+ruTJlxtz7Z2s/CY
NxwtXWmOFFP4sUJFIAirSk3Y+x5T9nTiMrufB75wJvkyRnLH9+rGVJnG35DxGAib
rihh0/lIR2JIxPg0X2ByNg/PLnKl++Kso1EBdo9tnzRCOvcbMZ/Zu3dSgNcsrOqJ
DgRtGLRIVF0VGB+AiZZ6C1g3BDHrKaLHrFhbIAm44wlkQ4LTaxQ=
=FqY9
-----END PGP SIGNATURE-----

--=-Tlz3SgJNV+zq+QL2IjFS--

