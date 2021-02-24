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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC7DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 05:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D052764EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 05:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhBXFg2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhBXFg2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 00:36:28 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80364C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 21:35:47 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d16so539024plg.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 21:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TM+BK7IfXkD6kJr5D/w//cw3vw8omE1Q6nBdhOfV++0=;
        b=vG0sbHiMA/0edJJ25NVwCOSBTKyp3c2PFj41kHrI1KRx789263zUVEXjWeFX8zxWuG
         Twq0k+cpz1QC6W02CEzKJNIXNyvg08kn1w7/zYdmTzBTQBQUvQX19sgLrudQtOXb0//C
         v5tCiCBtbiLKQuM6altztqVN3tRzXcuWJUn/huykA/dMvZwVNUXJfdmd7V+dK6NfheqA
         aC2I7Vz9mXO2gxQxiJsng/qkBK2FS8s4O11+xzZz6P3dQLzAsQeFLdoSf/rS8KRNcrOs
         aYqzSISWds/0KroG2dHBLCQDVzMDTi8hWy4jLziDsvCAhYHT0aWdUdd/FgsEy0PJWFLO
         8rGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TM+BK7IfXkD6kJr5D/w//cw3vw8omE1Q6nBdhOfV++0=;
        b=g3mEmLAfMjhyZFhL5vSgPZNH6SNbQGeQLld76CofiQzDIPRE4ofRnm+rH3DEGS3TJX
         ishtj00cuY4xpRAZpQFh46NxYGdR+WVjAxXsPsoQ6Kl0ZGRGJxs1xDM4PjzLAIaXlqmp
         jhx4WU/FTZ/sPi3Vo6L3EqJXtamZ5WBG+v/huuN/Wga4dSalujq5bXvqttNhjcJp23id
         Nv4Vps8IBa4+UpcJt+Drrj8EHaa37mtjJsJas1O7ZVDCijBCiAFLBtbwZH4c/Tc0DG5l
         +UOXvASfCED4GK0d7DTgHJJyyL6ZJyz3kTyDn0MQ27UU983979OdDbLBkVgykGGlRKEd
         thhQ==
X-Gm-Message-State: AOAM532l526EItkqhb5ItWMCZM5J6he9JMF5U2u/k6Rl5RKnc+CFb3RJ
        fCeYfmTJ4jIynXifI6azAMWXJ6UqCnqiB3iLwVy/8ISrYOsXRQ==
X-Google-Smtp-Source: ABdhPJx5dNYvvmnt8xJeW46yvzX3tk4f62P43a3Lik6wH25ZQdbXosGnK1lc2BhgPkTYdR1WwfspfJv/K7BSWHhLkg8=
X-Received: by 2002:a17:90a:6589:: with SMTP id k9mr2629686pjj.100.1614144947037;
 Tue, 23 Feb 2021 21:35:47 -0800 (PST)
MIME-Version: 1.0
References: <20210219055353.2244340-1-tz.stoyanov@gmail.com> <20210219092642.0f496a19@gandalf.local.home>
In-Reply-To: <20210219092642.0f496a19@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Feb 2021 07:35:30 +0200
Message-ID: <CAPpZLN7GS1WOxrs6-b3brUbx93ZWyUDMregp4xFXUskqSUMWsw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Add new API for open trace marker file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Fri, Feb 19, 2021 at 4:26 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 19 Feb 2021 07:53:53 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added new API for opening trace_marker file of given instance:
> >    tracefs_trace_marker_get_fd();
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >
>
> As I wrote the perf-trace.c program, I was thinking what we really should
> have is the following API. We can keep this API, but what would be nice is:
>
>
>         int tracefs_print_init(struct tracefs_instance *instance);
>
>         int tracefs_print(struct tracefs_instance *instance,
>                          const char *fmt, ...);
>
>         int tracefs_vprint(struct tracefs_instance *instance,
>                            const char *fmt, va_list ap);
>
>         void tracefs_print_reset(struct tracefs_instance *instance);
>
> Where tracefs_print_init() will open the trace_marker for that instance
> (NULL being the top level), and storing it in the instance structure.

You mean to hold the marker fd in the tracefs_instance structure ?
I like such approach, to hold some library specific context in that
structure, internally and not visible from the user. In that case we do
not need tracefs_print_init() at all, the first call to some tracefs_print
API will open the file. But that will make the APIs not thread safe, is
it OK marker fd to be used from multiple threads at the same time ?

>
> tracefs_print() and tracefs_vprint() will check if the trace_marker file
> has already been opened (tracefs_print_init() was previously called), and
> if not, it will open it and keep it open. Then it will write to the
> trace_marker file the passed in print data after formatting it (see my
> trace_print in perf-trace.c).
>
> The tracefs_print_reset() will simply close the trace_marker file if it was
> previously opened, note, so will any of the destructors of the instance.
>
> We could also have:
>
>         int tracefs_raw_print_init(struct tracefs_instance *instance);
>
>         int tracefs_raw_print(struct tracefs_instance *instance,
>                           void *data, int len);
>
>         void tracefs_raw_print_reset(struct tracefs_instance *instance);
>
>
> That is the same, but instead of writing string data to the trace_marker,
> it would write in memory into trace_marker_raw.

I'm afraid that having too many APIs with sort of overlapping functionality
could make the library hard to use ? Actually the proposed new API by this
patch, tracefs_trace_marker_get_fd(), already duplicates the existing
tracefs_instance_file_open() API.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
