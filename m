Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB09C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 May 2022 23:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348667AbiEaX1B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 May 2022 19:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiEaX1A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 May 2022 19:27:00 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E994DF8A
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 May 2022 16:26:59 -0700 (PDT)
Received: from [10.192.3.229] (unknown [185.234.140.80])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hws@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C757581970;
        Wed,  1 Jun 2022 01:26:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1654039617;
        bh=3EEuWGIY2y2J4vmegkHd0IFiv1+w/YNtL1jMtVDG9XE=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=n5Fcutd8CBmxoEIuF+MmwKOEwkSnfkrpnkUUzDkIq1IPa+Q1kaF6tb5MlWEgU6tPR
         PSfil0eVimXud0cVHZb77ovGXKnPcad6UhdRVvWhxnvcNtSseB/48pHnbOG6APdlQs
         y57IJlSdVgyS2WcXlyd8b1IGAjcP4+c+RkqrcrAh06UZQGEPa0tAJn17ugumIX6B4W
         dptmo9TMyimU3yLQntZX8u/EkKugJ9xjT4gu5c1Eouv+Mdvkanh3mgRDAYpC/F/rXk
         UFa8JMEzM795fADK9GuXYrxs2IbBLYSFbYUGJ6brBaTAfHeNQgG0XFrduWWLCsb7a4
         hMCV1XBKpAZ+Q==
Message-ID: <d52f9d95676ce6849db97c6c512b0745aaddd922.camel@denx.de>
Subject: Re: [PATCH] libtracefs: Allow for the same event to be start and
 end in tracefs_sql()
From:   Harald Seiler <hws@denx.de>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Wed, 01 Jun 2022 01:26:55 +0200
In-Reply-To: <20220531172435.2a51eff3@rorschach.local.home>
References: <20220531172435.2a51eff3@rorschach.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2022-05-31 at 17:24 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>=20
> When creating a synthetic event that is based off of the same event with
> two different fields, it should still work. But the assumption was that
> every field that has a label will have the same label, which is not
> true.
>=20
> For example, to create an event that measures the time a task is
> blocked, it needs to start and end on the same event (sched_switch), but
> just use different fields.
>=20
> =C2=A0 sqlhist -n blocked 'SELECT end.next_pid AS pid,end.next_comm AS co=
mm,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS lat
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FROM sched_switch AS start JOIN sched_swit=
ch AS end ON start.prev_pid =3D end.next_pid WHERE start.prev_state =3D 2'
>=20
> But this gave the following error:
>=20
> =C2=A0=C2=A0 Failed creating synthetic event!: Success
> =C2=A0=C2=A0 SELECT end.next_pid AS pid,end.next_comm AS comm,(end.TIMEST=
AMP_USECS - start.TIMESTAMP_USECS) AS lat FROM sched_switch AS start JOIN s=
ched_switch AS end ON start.prev_pid =3D end.next_pid WHERE
> start.prev_state =3D 2
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
> =C2=A0=C2=A0 ERROR: 'end.next_pid'
> =C2=A0=C2=A0 'start.prev_pid' and 'end.next_pid' must be a field for each=
 event: 'sched_switch' and 'sched_switch'
>=20
> Because the end sched_switch would already have the label "start" and it
> would not create one for "end" making the "end" not resolve correctly.
>=20
> Now it gives the correct answer:
>=20
> =C2=A0 echo 's:blocked pid_t next_pid; char next_comm[16]; u64 lat;' >> /=
sys/kernel/tracing/dynamic_events
> =C2=A0 echo 'hist:keys=3Dprev_pid:__arg_21065_1=3Dnext_pid,__arg_21065_2=
=3Dnext_comm,__arg_21065_3=3Dcommon_timestamp.usecs if prev_state =3D=3D 2'=
 >> /sys/kernel/tracing/events/sched/sched_switch/trigger
> =C2=A0 echo 'hist:keys=3Dnext_pid:next_pid=3D$__arg_21065_1,next_comm=3D$=
__arg_21065_2,lat=3Dcommon_timestamp.usecs-$__arg_21065_3:onmatch(sched.sch=
ed_switch).trace(blocked,$next_pid,$next_comm,$lat)' >>
> /sys/kernel/tracing/events/sched/sched_switch/trigger
>=20
> Fixes: 25446407 ("libtracefs: Added new API tracefs_sql()")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Tested-by: Harald Seiler <hws@denx.de>

Just gave it a spin, this is great!

> ---
> =C2=A0src/tracefs-sqlhist.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
> index 9811362..cee037b 100644
> --- a/src/tracefs-sqlhist.c
> +++ b/src/tracefs-sqlhist.c
> @@ -285,6 +285,8 @@ static struct expr *find_field(struct sqlhist_bison *=
sb,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!strcmp(field->raw, raw)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if =
(label && !field->label)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0field->label =3D label;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (label=
 && strcmp(label, field->label) !=3D 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0continue;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret=
urn expr;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0

--=20
Harald
