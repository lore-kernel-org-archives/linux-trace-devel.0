Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3798C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 15:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97FC8619BC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 15:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhC3Pct (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhC3Pcm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 11:32:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1AAC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 08:32:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y2so6350813plg.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 08:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XG2BYR/zOtdFKJLRqb0l8PEaRjqYFGFpdWGXMMDgoYc=;
        b=YfvBNo8H5CSmDYdZxSXp/4qDeYbrTedhyFOVLyxEFRCBmDwO/s/uv0qXKURSX0m28z
         KiB1LsYKhcsqOvVRfPDtEmPjHAKMFGa9gki7EwYtYUohjH/035LFF/xEaSK2+tO1fV/2
         TefOa523oJlRp6JPxV9CI+FtV+/WJwahCE2t1sM17yuIuW5LS4L8t0kAqPr8ob4VzpuS
         drdzuK8kY2TmtwR04HQQLizahKP4+Fx7S5EA0rTi45/6bJnORYEze2u9SAF8aDVxjnNU
         BH7Apkw+kqb1YK4rdnyzDbk4xHY+qmquYOL2Ko9RdX7d3KU+9Ge7Hzg5ye8aHoRBzDu7
         ggJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XG2BYR/zOtdFKJLRqb0l8PEaRjqYFGFpdWGXMMDgoYc=;
        b=htn2OLlfVW9DmqrlLPb0Ik9b571jSFVhORSKCTrCLCzLDYmvVms1gwA3toA9ojaa11
         JbT0F8nnev5UGOUgTU+xwZ+JjykTTTYM+8UNJK498AbN+trdbYlqxUIWJyV66tujvbgR
         tJrnb0B+W8V+bcwf7sIdDNC2ltmvDCbcEpDmv9c/GtlRvMqT0HIvbjwc39ZVekWTQMfv
         K6/JVvIqL4kuud96CJxjxriZ5+0JdYS1u0V45fdtg9D7sgmtefZ9vTFDxY/csOdZv3SW
         jCwDa6QmwOw77W6JYY7an+j/i9+dfcMNnrvWH/lVsnkvAHwtB4avjyIjT25lCM16uRWO
         ZF4Q==
X-Gm-Message-State: AOAM533UFM3zChnd+P8Hv825+0EUZDan6pYA4726t//9p740ejJwR8++
        +v2osQ1y4QaOnuPaJMLKQJDsOaZ+ARCjHnvMD8k=
X-Google-Smtp-Source: ABdhPJzRBtAH2PjmL8jrQhSKmEYoPLJ+9zHwU/VNyG5WqtETDhpD5feBiYuaEtHkO6C//fXM9svYWiYZDApnKBtCztk=
X-Received: by 2002:a17:902:d509:b029:e7:1f02:3bd7 with SMTP id
 b9-20020a170902d509b02900e71f023bd7mr22104708plg.26.1617118362241; Tue, 30
 Mar 2021 08:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210330005123.151740983@goodmis.org> <20210330005249.118764252@goodmis.org>
 <CAPpZLN57JrvSNTCGJTe7A9_x9Z4rSsH54jQu5C8wqodii=np4w@mail.gmail.com> <20210330105250.0a7105a1@gandalf.local.home>
In-Reply-To: <20210330105250.0a7105a1@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 30 Mar 2021 18:32:25 +0300
Message-ID: <CAPpZLN4cC4Z7eYP=VTj09XRhQ_jaswcgYXa1MEnvs7RJRVBCeA@mail.gmail.com>
Subject: Re: [PATCH 13/13 v2] libtracefs: Add CONTINUE to tracefs_function_filter()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 30, 2021 at 5:52 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 30 Mar 2021 17:29:57 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > On Tue, Mar 30, 2021 at 3:54 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > >
> > > Add the TRACEFS_FL_CONTINUE flag to the tracefs_function_filter() API that
> > > will allow it to return without closing the set_ftrace_filter file. When
> > > the set_ftrace_filter file is closed, all the changes to it take place,
> > > but not before hand. In the case that multiple modules need to be set in
> > > one activation, the tracefs_function_filter() would need to be called
> > > multiple times without closing the file descriptor.
> > >
> > > Note, the next call to tracefs_function_filter() after it was called with
> > > the CONTINUE flag set, the RESET flag is ignored, as the RESET flag only
> > > takes effect on opening the file. The next call to
> > > tracefs_function_filter() after it was called with the CONTINUE flag (on
> > > the same instance) does not reopen the file, and thus will not reset the
> > > file.
> >
> > I think it is better to not maintain a state in the API context. Let's
> > make it simple and allow the user to take care of the calling order
> > and flags.
> >    If RESET is set - close the file (if it is opened already) and open
> > it with the TRUNC flag.
>
> In the use cases I've played with, it was simple to do:
>
>         for (i = 0; filters[i]; i++)
>                 tracefs_function_filter(instance, filters[i], module,
>                                 TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
>

If the user takes care of the state, instead of the library, this use
case could look like:

   tracefs_function_filter(instance, NULL, NULL, TRACEFS_FL_RESET |
TRACEFS_FL_CONTINUE);
/* or add a wrapper tracefs_function_filter_reset() */

   for (i = 0; filters[i]; i++)
                 tracefs_function_filter(instance, filters[i], module,
TRACEFS_FL_CONTINUE);

   tracefs_function_filter(instance, NULL, NULL, 0);
/* or add a wrapper tracefs_function_filter_commit() */


> And not worry about keeping track of the RESET flag. This is the reason I
> did it this way. Otherwise I would need to be:
>
>         int reset = TRACEFS_FL_RESET;
>         for (i = 0; filters[i]; i++) {
>                 tracefs_function_filter(instance, filters[i], module,
>                                 reset | TRACEFS_FL_CONTINUE);
>                 reset = 0;
>         }
>
> Or something else. But I'm looking to simplify the most common case.
>
> And closing the file can cause issues. If we were to go this way, I would
> make it that if the file is open and RESET is set, it would return an error
> EBUSY.
>
> But no, closing the file just because RESET is set is dangerous.
>
> >    If CONTINUE is set - do not close the file.
> > Also, allow calling the API with no filters and any combination of
> > flags, just to have resting and committing currently written filters.
> > For example:
> >  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET, NULL); //
> > Close the file (if it is opened already), open it with the TRUNC flag
> > and close it.
> >  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_CONTINUE, NULL);
> > //  Open the file with APPEND (if it is not opened already) and do not
> > close it.
> >  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET |
> > TRACEFS_FL_CONTINUE, NULL);  // Close the file (if it is opened
> > already), open it with the TRUNC flag and do not close it.
>
> Yes, I had already planned on adding a patch to allow NULL filter when
> these flags are set. I just didn't get there yet.
>
> -- Steve
>
> >
> >
> > >
> > > If the file is opened, calling tracefs_function_filter() with no filters
> > > and the continue flag not set, will simply close the set_ftrace_filter
> > > file.
> > >
> > > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > ---



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
