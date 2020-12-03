Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D8C64E8A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A105D22268
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbgLCNKi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387936AbgLCNKh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:10:37 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8EEC061A51
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Dec 2020 05:09:51 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id t7so1246523pfh.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Dec 2020 05:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtcT/aMYDiI+qJlHbJPtaeUk1i+FZSioDudb80jC3ts=;
        b=UpfZZ91IWriC5NtBkiOoyZhhHfK4hRSOhe9u20OzSTTEg/tnXphYv692D6jiYdWs9l
         t3toFCJMgQ9ulqFvYZPI4zkUly41Z+R0gAw7g+I1iAFmFQ2Z/i37/r1e/V3jkiQtMIfu
         OjDktvlEejbvKgUJFHXjvvzXJ1qCD2xoQB3my983c8lsnvIJkuzufhLmndmEAj7g4ULa
         wK/ICT4OlDYsFWWlF25ulzNaJnnHQ8nHa+Zdfjj/nPUB2JqzN6Gu1l0LkwzjIPfnMqcg
         9Z58wni/GVURo2MoZraWL1A96O2ywhSA3il978hN0jqpzeSFwULWe3Bgb0atwnb3mhp5
         8NpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtcT/aMYDiI+qJlHbJPtaeUk1i+FZSioDudb80jC3ts=;
        b=ntIdDhg+ySitEeZS1i4UsiS3mI2h/Q1J8GWHbaRhVdZ+FaHFhyxp45PLw6izxL2cz2
         EbvSTFb9LvJZ7OlIVhN2MwJCL/9sfWzDC7ZJic/nlq+2t3j8809x12BKAOh4+l3k1zFF
         fRPbMUneVCTurII83mIPPS6tRJ8YTGVCrGEbKoAk4SIvLcJpYsaLC+B5swgZ8kOOS4LM
         /VDx1fsx9TQdCXmW50Xx4Cfs+ZtO6l2provrzEUXa9JNSAm0SFCTOdzldS0x794tnE0O
         1NZWtJwIkjwmm8yJ1AZ6cXL2IJovKONRMfZL8bthI7pAk2C3ZKLEdlhNykVD4Rmecog+
         CVMA==
X-Gm-Message-State: AOAM531+w7A3HYcUf99pk1kzwP+Dbt/5UGPUVqAc3cfM+QvVwRGpdK0W
        lyXyejMWM61VTmW/FrwiHw3RW8JKBpH8dMoXF/Q=
X-Google-Smtp-Source: ABdhPJx42kV5POJmDj7lYlKE/dz5a9RXOc6YnI2ydwGGs1XPo7T4Q8QOuFa9iPNUA7y+oVfA2l+mob0brWEilEHI6+g=
X-Received: by 2002:a63:b1c:: with SMTP id 28mr3005898pgl.206.1607000990742;
 Thu, 03 Dec 2020 05:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
 <20201029111816.247241-6-tz.stoyanov@gmail.com> <20201202174807.1f442e0c@gandalf.local.home>
In-Reply-To: <20201202174807.1f442e0c@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 3 Dec 2020 15:09:34 +0200
Message-ID: <CAPpZLN5oiYqafPd4YLMa3h+CPUQ+i3TAh7eedyF-qDNMvu9dsg@mail.gmail.com>
Subject: Re: [PATCH v25 05/16] trace-cmd: Add clock parameter to timestamp
 synchronization plugins
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 3, 2020 at 12:48 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 29 Oct 2020 13:18:05 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Some timestamp synchronization plugins may not support all ftrace
> > clocks. Added logic to timestamp synchronization plugins to declare what
> > ftace clocks they support. Added logic to select plugin depending on the
>
>  "ftrace clocks"
>
> > ftrace clock used in the current trace session and supported clocks.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/trace-cmd/trace-cmd.h             |  4 ++--
> >  lib/trace-cmd/include/trace-tsync-local.h |  1 +
> >  lib/trace-cmd/trace-timesync.c            | 29 +++++++++++++++++++----
> >  tracecmd/trace-record.c                   | 10 +++++++-
> >  tracecmd/trace-tsync.c                    |  2 +-
> >  5 files changed, 38 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> > index b48381cd..21028940 100644
> > --- a/include/trace-cmd/trace-cmd.h
> > +++ b/include/trace-cmd/trace-cmd.h
> > @@ -448,8 +448,8 @@ struct tracecmd_time_sync {
> >  };
> >
> >  void tracecmd_tsync_init(void);
> > -int tracecmd_tsync_proto_getall(char ***protos);
> > -char *tracecmd_tsync_proto_select(char **protos);
> > +int tracecmd_tsync_proto_getall(char ***protos, const char *clock);
> > +char *tracecmd_tsync_proto_select(char **protos, char *clock);
> >  bool tsync_proto_is_supported(char *proto_name);
> >  void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
> >  void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
> > diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
> > index 1f3bc443..25d5b4e8 100644
> > --- a/lib/trace-cmd/include/trace-tsync-local.h
> > +++ b/lib/trace-cmd/include/trace-tsync-local.h
> > @@ -27,6 +27,7 @@ struct clock_sync_context {
> >  };
> >
> >  int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
> > +                               int supported_clocks,
>
> Is this a bitmask? How is this used?
Yes, it is a bitmask of "enum tracecmd_clocks" values, or just
TRACECMD_CLOCK_UNKNOWN for all clocks supported.

>
> -- Steve
>
> >                                 int (*init)(struct tracecmd_time_sync *),
> >                                 int (*free)(struct tracecmd_time_sync *),
> >                                 int (*calc)(struct tracecmd_time_sync *,
> > diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
