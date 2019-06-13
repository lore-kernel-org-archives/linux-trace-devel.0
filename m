Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URIBL_RHS_DOB,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA28C31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 23:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD402147A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 23:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uzbPfvsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfFMXBV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 19:01:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44559 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfFMXBV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 19:01:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id n2so335482pgp.11;
        Thu, 13 Jun 2019 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PVIgDtF1wvLIcWb+5+2PM7U0AThtnIetXRWXknWoqCY=;
        b=uzbPfvskQFWXlSFaigtDdFJyRIiOYER+l7iTsR+mXNMKU+G+5qDvrK+4wu+afDTpuZ
         flPC2SRB7RjzQdMGkOWjEf0anIxw/PqBa3RZjsxhKlfQL2sGM8nazY9yoScJH51IzpRQ
         2CA/lRIrvIP4LF67pvZB7ANDDUpXOwMLl1lho/pnmFheuojK+jHUdlNSWMhmZVXmCPQH
         biL3epAhc83l7mCEIkuF/YcE+gaklc8Pl+7L90fyR2vpQa/eGH3e3qY/13akUGJYmSK3
         jipmDUnT6hP6QWQxHHPEWaBoys7/aG4fCP7zX5xYG4S78DaCVNorf2yhgE8tgrKnqJIJ
         JvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PVIgDtF1wvLIcWb+5+2PM7U0AThtnIetXRWXknWoqCY=;
        b=arNgSBVx2CkRBKAFwQZPz6sw26NDR4/jOisa9OcvznPj9QWWMU5Z8JQmeQNkHMWv5y
         MPOoCmXsYime4HjWisS4SB2M8+xHwkJJirZVjnu/OBdTIoYL362L4t6hCA/mNNOYhjZz
         i3FxQ5wr2IW7CfNWBL1imzP9FlcCJ7GnDtFdBEOTSguT4qhw6mEpzA9kugEqndqdzVxp
         oGA3kp52cXOqf8nzhn+VCIjzAVYtxk8+a3jektRdM0EcBxKu4gYhiqauIXHfQ0jdBL6v
         9FHQFedP0cf1wG+sgkgzVKm6JPDf9LeqIOsomq8QOqj8rJwCDnYNT57p2DodxcGiK6Lj
         dPAw==
X-Gm-Message-State: APjAAAWfYhZMzkqFT+GBdoj0yadF/qG73sIWCTzSL7bgdIIqR+ElgKlu
        +8s9IPSWtDmrAJX3tRODlBw=
X-Google-Smtp-Source: APXvYqwpk5gSoHRDG25kKn5kAXkxGlfn8nDbBtAFV4Tei4/TOeto72I42ANQCjuef8powiqCmrfmKA==
X-Received: by 2002:a62:5c84:: with SMTP id q126mr69038980pfb.247.1560466880167;
        Thu, 13 Jun 2019 16:01:20 -0700 (PDT)
Received: from UbuntuLinux ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id y22sm695832pfm.70.2019.06.13.16.01.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 16:01:19 -0700 (PDT)
Date:   Fri, 14 Jun 2019 04:31:06 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [ANNOUNCE] trace-cmd v2.8
Message-ID: <20190613230106.GA11097@UbuntuLinux>
References: <20190613122035.7d19f318@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20190613122035.7d19f318@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Cool ! Steven :)
On 12:20 Thu 13 Jun , Steven Rostedt wrote:
>
>Finally, after a long time, trace-cmd version 2.8 is released!
>
>This will give us a path to release KernelShark 1.0 (after we fix a few
>more bugs).
>
> http://trace-cmd.org
>
>Enjoy!
>
>-- Steve
>
>Features since 2.7:
>
> o Restructure of the source directory layout
>
> o Loading of plugins from build directory (over other locations)
>
> o trace-cmd reset updates (restores more, and keeps tracing_on enabled)
>
> o trace-cmd stat shows more information about the state of ftrace
>
> o Better accuracy with trace-cmd record --date
>
> o Version of executable now saved in trace.dat file
>    trace-cmd report --version, will show that version
>
> o trace-cmd listen has a V3 protocal (V2 is no longer used)
>    This is a big step toward a virt-server implementation
>
> o trace-cmd record --no-filter option added to not filter out
>    the trace-cmd tasks while tracing.
>
> o Better bash completion for trace-cmd commands
>
> o The "mono" clock is shown now in seconds
>
> o --max-graph-depth can be used by instances
>
> And of course a ton of fixes and clean ups.

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0C1a4ACgkQsjqdtxFL
KRXR2wgAxiCv+t41nkzBpXWshoOvmJse582RwQcoz+WJJlG8zEXAomJnUq4qNhd9
SErkP2Ql3kPvBuoXhIFMyHf1dkl/0McAmQKI3iHhLc2411Tq3u/8Gm9Fi3qFzQ+g
LMrDOG5IkLJfeI8kgrIx7Xr0BGGAqwnrYDKpyZIG/mLddaepAfNjMOZPSzD6V3mB
9IDihfmj0YiUcB3BkFFGwL6LcAkZ5GajJ+QGOeKYPNRaZpCFueG62Xp1nOZOYja4
oIR12fja0HK1B0aJoqSfDSuFXVPE/brJEKnWlkeFtpIGeCGizIVN2kpvIY95n5dN
emN9rVoDNwthCphA+Z7hqYkETNUjBQ==
=8f84
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
