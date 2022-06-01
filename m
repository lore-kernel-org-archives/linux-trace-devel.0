Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04A4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Jun 2022 12:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351131AbiFAMjH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 08:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348875AbiFAMjG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 08:39:06 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493DA6F499
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Jun 2022 05:39:04 -0700 (PDT)
Received: from [10.40.36.66] (unknown [193.52.24.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hws@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1510180FF0;
        Wed,  1 Jun 2022 14:39:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1654087142;
        bh=Hbdk6Cfwa7PixFP9Q7kOaPWcf9jLNvGdztgxDK1wDaM=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=tL7IhfjotG7n+KfhFQU1J1ttH3WkBhXzbfIWQ5CLSrfcWrFJMyDIUN9iMnMv3j3f6
         ekeZM63sttaSanCd5GJe/+eZUVGPyIUkkqcMBSYqwQNf1y/XtNMBKXdunJvvmdFuts
         bW3bEylXiwAr+cDvgO1S0EJgtWI7HAxxJJLcL7acqxV2t1vIRPAect8cERhwXQuxcx
         7Ifl9Ep0SL8seagA+Lrh6wPB00XHmXgaKUpQ0xHwPhUCnuBc6t/GuQxVSt5Lw3zq5M
         8IPkjlJs8d99XUXrcpNm3z2nHNVmiWtNC/l/5l70mAWnqdi9YRAuAYXCynjaY9PBgf
         R++k7ad1r9RpA==
Message-ID: <ca2db232b4d41094bdac55f881a92e256459efdd.camel@denx.de>
Subject: Re: [PATCH] libtracefs: Have labels in selections be synthetic
 fields
From:   Harald Seiler <hws@denx.de>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Wed, 01 Jun 2022 14:38:55 +0200
In-Reply-To: <20220601062619.2f601c8a@rorschach.local.home>
References: <20220601062619.2f601c8a@rorschach.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2022-06-01 at 06:26 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>=20
> The labels in the selection case are suppose to be the fields for the
> created synthetic events. But for some reason they were ignored.
>=20
> For example:
>=20
> =C2=A0 sqlhist -n wakeup_lat 'select end.next_pid as pid, end.next_comm a=
s comm, (end.TIMESTAMP - start.TIMESTAMP) as lat
> =C2=A0=C2=A0 from sched_waking as start join sched_switch as end on start=
.pid =3D end.next_pid'
>=20
> Produces the synthetic event of:
>=20
> =C2=A0 echo 'wakeup_lat pid_t next_pid; char next_comm[16]; u64 lat;' >> =
/sys/kernel/tracing/synthetic_events
>=20
> Where it should have used 'pid' instead of 'next_pid' and 'comm' instead
> of 'next_comm'
>=20
> Fixes: 25446407 ("libtracefs: Added new API tracefs_sql()")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Harald Seiler <hws@denx.de>

> ---
> =C2=A0src/tracefs-sqlhist.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
> index 9811362..8d71800 100644
> --- a/src/tracefs-sqlhist.c
> +++ b/src/tracefs-sqlhist.c
> @@ -253,6 +253,7 @@ __hidden int add_selection(struct sqlhist_bison *sb, =
void *select,
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0switch (expr->type) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case EXPR_FIELD:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0expr->field.label =3D name;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case EXPR_COMPARE:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0expr->compare.name =3D name;
