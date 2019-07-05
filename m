Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ADBC468A7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 21:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8E521738
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 21:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsGlQ4mo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfGEVUr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 17:20:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39104 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfGEVUr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 17:20:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so4305654pgi.6;
        Fri, 05 Jul 2019 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zw1DqtEpgkxDHmdzTS2NeIepAYygAlaNpdKUQpiKqlw=;
        b=AsGlQ4morK3OgoGmmt8vFhPKAFfSqQyaA+hVQnhbkc2Zxe2xANbmhH+umGAH+oTpTe
         vp1nWCsjXA6E4mFzplxKxTn4PEp3cD80Zs6WDr7eyiLvrLfpwCo+dXxFJAJoJ/6oZLUm
         iAoB6MhyNyW7S2sAqT1WZMWRnJg/a9pIkFPyHuBYO4ynKPiH3w9dvEUk543BQGI8NctJ
         upBSuwtrSSPAr+SGlT1ci+rEkAWZWGJK8CpGNVyQWv8aP0PJ4YJ651fRPQZBVkndjfEL
         2PTgcj3z+HFVffpEUR7lXKNgqqEzzPtaopAScKwWrfL/zymQsvVZZRWu6fQsiDYf9rMv
         f5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zw1DqtEpgkxDHmdzTS2NeIepAYygAlaNpdKUQpiKqlw=;
        b=I/CTaDwTHAqHequv1A/WP8ayM9h0CoULaV3/9xnohkw86f3/l7KG+FwFFVShTepyME
         jkVRw9HPXJFn0NaVt4zpb8F77SiYk2hIBTBt/Yf3jb4lga5qR+qYP0646Mjzx9LWnWR4
         qg7c9wSHDxeeixVTa5tQdFCxQRDF28tGo11x8mMUzCxnmaPP8EkmhxOYjjUZFsKOUzdI
         5s9zQBMAkT1Z2MgtIE/0JruB8+k6tZ441BHf9CZRB5rBubik0PVbBbzuPg2Qsvp39KEX
         GcYzNezN4zzoDrcBBxXuft7FuVm0gBeCKy4+LmO95U/fTlT7X/C28n90IyBnGAqiI7ov
         ck7A==
X-Gm-Message-State: APjAAAVP4Wm0fIDvKSOtPSR4c+VtsGitTBf96S+I+FbZvb0BBshDUQln
        I1YP/Aid2R+k2D391EwvPQHOVBEEvgyfyA==
X-Google-Smtp-Source: APXvYqx0BWoplT5Y09tbWUDPjb14Vy2lFmdjL2HEsUFvct/Pr1kXbJw/95+8w8eaaJelmb893E2+8Q==
X-Received: by 2002:a63:360d:: with SMTP id d13mr7683690pga.80.1562361646433;
        Fri, 05 Jul 2019 14:20:46 -0700 (PDT)
Received: from Gentoo ([103.231.91.70])
        by smtp.gmail.com with ESMTPSA id r15sm10160847pfh.121.2019.07.05.14.20.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 14:20:45 -0700 (PDT)
Date:   Sat, 6 Jul 2019 02:50:35 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [ANNOUNCE] trace-cmd v2.8.1
Message-ID: <20190705212031.GA17046@Gentoo>
References: <20190705123411.4285e625@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20190705123411.4285e625@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Cool !!

On 12:34 Fri 05 Jul , Steven Rostedt wrote:
>
>Just after releasing 2.8, some bugs were found (isn't that always the
>case?). Now we have 2.8.1 stable release:
>
>  http://trace-cmd.org
>
>-- Steve
>
>Short log here:
>
>Greg Thelen (2):
>      trace-cmd: Always initialize write_record() len
>      trace-cmd: Avoid using uninitialized handle
>
>Steven Rostedt (VMware) (1):
>      trace-cmd: Version 2.8.1
>
>Tzvetomir Stoyanov (VMware) (1):
>      trace-cmd: Do not free pages from the lookup table in struct cpu_data in case trace file is loaded.

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0fvxsACgkQsjqdtxFL
KRXR8ggAvaGgxhwLVezX3ugzwXNOd5beJKNDQjoIq3XWe22ThZtVzgc5U2dUnPO2
H4npYnDMhJvh0nBOQnvm6da0MI1pYPn8wioRnnFoGWNDD14aHebUVpTzmnh8mone
YzWFJJrFVISJmuWbmQSgzvfPCnfLaeU0xeC7ysBT5/yrijMEeoE48EuWoPWcesE1
ljDGVphR0pZSq2FzIQY/2bppcykX/JgVXZ8gwbOXWuCJj9div+nluq9O2xzZHQ8f
wtQBmEXfekHl1+rMznAAvv4BrFuGoxRf2cWZ6XDt56WDpyUBp+/daOctdNQs947r
MeYEyFTd+k5WrSKyGYLvKKSKPHnMyA==
=DG65
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
