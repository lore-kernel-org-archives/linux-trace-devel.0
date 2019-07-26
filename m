Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D9BC76191
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 14:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5B6218DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 14:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+4dNOZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGZOt5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 10:49:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42991 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfGZOt5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 10:49:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so24891384pgb.9;
        Fri, 26 Jul 2019 07:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pf8jyZ+XGaADnl1mbzDi9sHkjoLVEmn9klGkOm765TY=;
        b=T+4dNOZaqMVE6+R65Jvf+6k3kmzCDv7MvNeof/ifhyZwwLOBzU8rUiK5FkPNphLJ8e
         i7EXjB9fVHELtokllyzcv5i50F6qntHGTyxWBk0KAF7nUbmG8OZeRMPerxjqGG/oI5Ah
         4O0KRffS2Oy2SWoLceVw6QFGhgw9NUpXFka9Ni6zmvi14J8FoknLxMSbaepbwYpM8PJM
         AYqWIMJXa4ZTHa1ruKLtlQHbm0xRpBWxr9OqOX68n0l9ksz++PT8h+aY80e4FAHm16WE
         dzZ0rI9UhjSbnDVQ+AcuUQ1WD+2j0EbHCDM/bZA6AK4bWnympMS5wOTFTI/3cUNSKQsj
         Lh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pf8jyZ+XGaADnl1mbzDi9sHkjoLVEmn9klGkOm765TY=;
        b=REUBSM5ON1SfK/VASyP4SrsRlPnhwC8CxpUtxZ5jK0t9rzukO9XRyHGm3HZUuSeo1r
         /YpnIm/pN+WBCWAnL2ZsSuee8eG2eIxMfO5saFWktlrQrOt7uXX9mx+V3hV2+PGwavfz
         uqXdUMrRJFkxSiT7cWx0o/utQEQWGt5UTFZR0KkFIzxhdN/K2xvGFwyD3+ALQX/l1qN0
         Q7EUv7oSYx4XLs/zx8tvzD1fUTcimEgU9m3f8G5gkiim6hql2e8mm+841STgZXJicOvA
         gDreicyzGx/H4PMIxk70Ki6iUnGi7q0XvFMAnjFJqFGJyRfbMKpqZ1eMhrtvdX4BTzc7
         CulA==
X-Gm-Message-State: APjAAAXC+i53RAeHkdK+g9cWn0qm5o/QY1/JIY9z8ppc2WTVCukKOsYm
        4gIrpBt6l1j823LBSpZpooA=
X-Google-Smtp-Source: APXvYqzLzqIu2vcULIRG4e2RLCLPvPxC1jCdm2Nb+pmpa5X91uxIYw2WTV+E4dcYcJ+YWN6JLF85Hg==
X-Received: by 2002:aa7:9217:: with SMTP id 23mr22982668pfo.239.1564152596389;
        Fri, 26 Jul 2019 07:49:56 -0700 (PDT)
Received: from ArchLinux ([103.231.90.172])
        by smtp.gmail.com with ESMTPSA id a20sm45206116pjo.0.2019.07.26.07.49.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 07:49:55 -0700 (PDT)
Date:   Fri, 26 Jul 2019 20:19:38 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        troyengel@gmail.com, amikhak@wirelessfabric.com,
        valentin.schneider@arm.com, Patrick McLean <chutzpah@gentoo.org>,
        John Kacur <jkacur@redhat.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>, howaboutsynergy@pm.me,
        Bas van Dijk <v.dijk.bas@gmail.com>
Subject: Re: [ANNOUNCE] KernelShark 1.0
Message-ID: <20190726144938.GA3078@ArchLinux>
References: <20190726095730.0674d81d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20190726095730.0674d81d@gandalf.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Kudos to everyone...time to play with it. :)

Thanks,
Bhaskar

On 09:57 Fri 26 Jul 2019, Steven Rostedt wrote:
>Hi Folks,
>
>It is finally official. We have finished and released KernelShark 1.0.
>
> http://www.kernelshark.org
>
>It's a completely new rewrite in Qt from the older KernelShark that was
>written in GTK. It's faster, it's more extensible, and easier to use.
>
>For how to use KernelShark please read:
>
>  http://www.kernelshark.org/Documentation.html
>
>I would like to thank my team that worked tirelessly on this, and
>especially Yordan Karadzhov who did the majority of the work, and even
>came up with several algorithms to speed up the handling. I will be
>transitioning maintainership off to Yordan. We will currently be
>co-maintainers, but eventually we will be splitting KernelShark out of
>the trace-cmd.git repo and into its own. At that time, Yordan will be
>the main maintainer of the project.
>
>Download it and try it out.
>
>Now we can finally start working on KernelShark 2.0 that's going to be
>another huge improvement!
>
>Enjoy!
>
>-- Steve

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl07EvwACgkQsjqdtxFL
KRWkMQgAvsnPNWw7b9MVz1H7HLBK0OM+zf+gVVJ/thtwb3hSp59wxwCOn0PdGQky
FFS0vw1Ehkx4ba2ocw4piBSaJbZJBtfFT0qvpKuDI4ND928XNBdzmr6cZMk9GBQi
U1Ol3QeeIQY6WW7izvjZyzsxKjtvOZG/bnDJ1s/GS95AnAFCwPWfSOXWO7T86BdE
139I39U8HAA7nGFFmAnpYgH0LT3/puA2vI4XSDY1nQTLv3MQOAzJGAeIxOVYsxQ4
GxHDoOAkXRTlkDYA4VzGB8IdGsdIGOGHg/YBaO6GorFVJwdUF7ba/LgcHHDwNJJT
qZ9TIVGsT0NqF+bFSbgBnzPb9zl+fg==
=W4Mg
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
