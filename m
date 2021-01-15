Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49562C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5A923A34
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbhAOFDO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFDO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:03:14 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05555C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:02:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id g3so4104000plp.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8vg9Quynp+z/KCr2bHtB1ocUsu0Syi/E40dBiThtuFk=;
        b=X6/dG49QyqWqBeW2DEeL/qZvM++2M8omRFEHHgaBWOSP1hE98FsYn1qgUWnFhoXKUK
         TuRoS2bIqiKOBs1K5XEMhRdamcrzQnMPpWRGuAJPRZDxLchpTkswsQ2ZlpUpuU79UXNa
         yC5L3FeAHi4idwN2E2MKXyWNEq8UCAyzxEgRrhYOJsMEHBPhvcf27IXnHu8MAQQp6dGL
         VkH8gd2QPfkUDZ+8h6LBPCxNeiadgq3msqSyy3Nek7EddsLhOveBiOYEQqfH/30mmjbR
         gXey+tDtYb2olNMo/wSpBbB44K4jX+8cS8dqEVCWraDDAcwtL22MR2jesF9OLNpTVT+C
         6FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8vg9Quynp+z/KCr2bHtB1ocUsu0Syi/E40dBiThtuFk=;
        b=pNrZSYH1aBgjGfvATM9y6LqAVk6HlU8rBgMaMozOYp3HSNnGmr3INoE16ugU9CPA62
         wgfufPJdr7JEUbFkV+fzBFsgOT/KFlZt8IpFLidA+33vaSFzL8vqCDmskBGVVn3QKr0m
         L1lttfFK/tbsiYsPfq/CrsRAvFWnlykJjt2oAZghBT3gT++bfjs8B+3mTEJI2JUubbI7
         SMahQdSkXkSF03cw06sf7jGLjnpfnMSLEM7JbjIWr0q78UyFwg4XXNojlG9Ncnxt/byP
         D+JkUGIZ0QpFyuKoPU80jq/9NKrAOo4I9ECzDdq+wSulpQYgoKHKT2Pwh9AufWnLZYyD
         Wvtw==
X-Gm-Message-State: AOAM533h3ZlvISFKjd3UBza6M1JoF+50JTZ7CUxv7Is9XMxj7d++dHvj
        Uy3VItOFs11n3gDa5XWNS3cfI6rx0+zo42iWhyR2JyYXeZQ4lg==
X-Google-Smtp-Source: ABdhPJzXDKZORdevJMA/Bn2OX2n3l978iDYu0LDyd9rhQ4olOXQcysVKSDC4yMMBQh88p72DsQJ3rZ5SvIhRkoQF6xg=
X-Received: by 2002:a17:90b:3886:: with SMTP id mu6mr8593418pjb.153.1610686953539;
 Thu, 14 Jan 2021 21:02:33 -0800 (PST)
MIME-Version: 1.0
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
 <20201223043429.586162-6-tz.stoyanov@gmail.com> <20210113171347.1e75f7a6@gandalf.local.home>
In-Reply-To: <20210113171347.1e75f7a6@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 15 Jan 2021 07:02:17 +0200
Message-ID: <CAPpZLN5excLsRcmcgDMbEGV0LJGFBHRXrVXrFG6YtSgVxLxhzg@mail.gmail.com>
Subject: Re: [PATCH 5/6] trace-cmd library man pages: Manage trace session
 with multiple trace peers.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 14, 2021 at 12:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> I'm assuming that you can pair multiple guests with a single host?

Yes, this use case is tested using KernelShark. I'll extend the
example in the man page.

>
> That is, can we have:
>
>
>         bool g1 = false, g2 = false;
>
>         host = tracecmd_open_head("trace.dat");
>         tracecmd_init_data(host);
>         guest1 = tracecmd_open_head("trace-Guest-1.dat");
>         guest2 = tracecmd_open_head("trace-Guest-2.dat");
>
>         guest_id_1 = tracecmd_get_traceid(guest1);
>         guest_id_2 = tracecmd_get_traceid(guest1);
>
>         if (!tracecmd_get_guest_cpumap(host, guest_id_1, &name1, &vcount1, &cpu_pids1)
>                 g1 = !tracecmd_init_data(guest1);
>
>         if (!tracecmd_get_guest_cpumap(host, guest_id_2, &name2, &vcount2, &cpu_pids2)
>                 g2 = !tracecmd_init_data(guest2);
>
>         if (g1) {
>                 int i;
>                 for (i = 0; i < vcount1; i++) {
>                         printf("Host task id %d maps to guest %s cpu %d\n",
>                                 cpu_pids1[i], name1, i);
>                 }
>                 tracecmd_unpair_peer(guest1);
>         }
>
>         if (g2) {
>                 int i;
>                 for (i = 0; i < vcount2; i++) {
>                         printf("Host task id %d maps to guest %s cpu %d\n",
>                                 cpu_pids2[i], name2, i);
>                 }
>                 tracecmd_unpair_peer(guest2);
>         }
>
> And use something like the above for the example?
>
> -- Steve
>
>
> On Wed, 23 Dec 2020 06:34:28 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +EXAMPLE
> > +-------
> > +[source,c]
> > +--
> > +#include <trace-cmd.h>
> > +...
> > +struct tracecmd_input *host = tracecmd_open_head("trace.dat");
> > +     if (!host) {
> > +             /* Failed to open host trace file */
> > +     }
> > +     tracecmd_init_data(host);
> > +
> > +struct tracecmd_input *guest = tracecmd_open_head("trace-Guest.dat");
> > +     if (!guest) {
> > +             /* Failed to open guest trace file */
> > +     }
> > +
> > +unsigned long long guest_id = tracecmd_get_traceid(guest);
> > +int *cpu_pid;
> > +char *name;
> > +int vcount;
> > +
> > +     if (!tracecmd_get_guest_cpumap(host, guest_id, &name, &vcount, &cpu_pid)) {
> > +             /* The Host and a guest with name was part of the same trace session.
> > +              * Got guest VCPU to host PID mapping.
> > +              */
> > +             if (!tracecmd_pair_peer(guest, host)) {
> > +                     /* Successfully paired host to the guest handler */
> > +                     tracecmd_init_data(guest);
> > +                     ...
> > +                     tracecmd_unpair_peer(guest);
> > +             }
> > +     }
> > +
> > +...
> > +     tracecmd_close(guest);
> > +     tracecmd_close(hadle);
> > +
> > +--



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
