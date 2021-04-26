Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B23C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C8D61103
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhDZPpW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:45:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:37332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233934AbhDZPpV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:45:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619451878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ufj8aEmhh3gVBrju7HTQ0brfnXTxPW2TaI+mirxIFLA=;
        b=UNaPdMxeAsy/O0dAu6O5MZe3joBq6JBHJaZVox9sDhioCTday6WDJXSQex/84pF/YRUM28
        +poz7xvXuoYjN3bOHjHd8z4RAJBk5I4XfzS5G1Kz0gJdgrLkbLJ9CvgY9Xeh2VWUXp+eC0
        gfmoh6V8xTGxG4m8XbD0H0C6LD1XJ10=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9F56CAC6A;
        Mon, 26 Apr 2021 15:44:38 +0000 (UTC)
Message-ID: <b38a488a1103feeffe8ac96b2513510f79d75d7e.camel@suse.com>
Subject: Re: Instructions for clock sync for tracing host/guest
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 17:44:37 +0200
In-Reply-To: <20210426113123.3aae06c4@gandalf.local.home>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
         <20210422154830.52f3e4f5@gandalf.local.home>
         <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
         <20210422160313.2eee1f77@gandalf.local.home>
         <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
         <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
         <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
         <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
         <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
         <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
         <20210426084408.581364d9@gandalf.local.home>
         <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
         <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
         <20210426105111.288280bb@gandalf.local.home>
         <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
         <20210426113123.3aae06c4@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-CDF+7A50s9B+UJOip2d3"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-CDF+7A50s9B+UJOip2d3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 11:31 -0400, Steven Rostedt wrote:
> On Mon, 26 Apr 2021 18:02:58 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > >=20
>=20
> > The other approach could be to look in /proc - the relation between
> > KVM thread 129042 and the VM process is there.
>=20
> What would you be looking for?
>=20
Whatever the mechanism, What you need is the PID of the process that
created the thread with PID 129042. Because that is the PID used in
debugfs.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-CDF+7A50s9B+UJOip2d3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCG3+UACgkQFkJ4iaW4
c+5j7hAA2oL1ayRo/cIHPcKTOAD+GtrX94gLW922B7gDfaJDOnZ3euQhhtIqCDKY
DZmQksHllZ5xyB8cZ+ucFhJFIP+YRixa/34Qd3u7fuHQzb1VoeaKIUsHSBYT3sAB
0xayLce8H/Kd1mPYut+/ruCegK4TIQM6hyBsU4O1H9FhAm/d884BEEBuC+n5fUV4
4V7U8FGOC3s64ggy084R9uCUoOf4MtSefIfTyEeF/wWjQ3qJm38vopmQzZe/NdcI
PXYYO5kyd1+oODobeiPwiTxtCL0nnRuCxrLAUk9vfLQ0sG7j1Rfdaniuv5WQ7Pue
a5HGBnvZYfQ4/k2ycFb7cGiAOY6Dvyl23atJbrnIr5EXalz6wO1fH/h+IlpHot18
YKHStamgnyyyoTkCsMvb0ZCvpH0nmqq/2Xtb6JIgQTeuASMPXoOZfuHrr0fodUFF
f0B5UMPssY39/1xX614rFXb6qnyCReYTEmTH+dcYi3WhdwHZDYvkH5uQak8e9uMp
PzgfbWMPTx0B3SryvwW/KMuPTq6Dn4IwC+1gAzrTb0bFsFa3TPY0Z+65mtEnD80B
44CDCscGcg/Y2obIeg/6/yvzHMy+iWt1xkF2xBe/JsoAS/t9O+4vcrY93L6u0EAE
zNryziR3fNAGIckxsfrUaV2GddnPptIPnxOx1j8EYlwTQOzstSs=
=upq0
-----END PGP SIGNATURE-----

--=-CDF+7A50s9B+UJOip2d3--

