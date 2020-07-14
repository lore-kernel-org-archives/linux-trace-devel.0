Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A458C433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A32221EB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 15:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/hc7fFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgGNPWo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPWo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 11:22:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55443C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 08:22:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id q17so7710901pfu.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 08:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RGqtpm4h7rQ+He9X09Y7rTtPYGclMA98ukG9dc9iOk=;
        b=D/hc7fFarFb0rZlTFadWGlEI47fhS7u/lkRziFcMCvTXAr5lr3D4gKSs8W2yLdvD5L
         K78ftT3zAdp6G6BPEknWzfRfs/DrvZlghQX6dXR/81C/DSsIhNDwchaM7Qdymi5OB2Ex
         VWC9dmkISWIJzxsdNMm3eQq32EP6P6r11fsDNs7rTSEq3HEmYrrBLsvtds68BaqkSecF
         54F+HbJzGP/acBcyXKcNQh6yiglOFjt7f36b4P9fXgs1XwoMSsUiQYKE8tK1X+dQU7tM
         uZR2Bfg1R6j8Tz+zzRLTIMCJIgZwVhd2f17g2AXcrGHwd+sxZT8bnlttyawVdQgWHjCR
         1dLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RGqtpm4h7rQ+He9X09Y7rTtPYGclMA98ukG9dc9iOk=;
        b=KecqwTONDalxVNU1J1MXBTILUE8vqUHr/ixLPEOHPVyGgw6r0pfCpHNhXHYovwdwAD
         ghhzPKnTMJkIb4t84ifWUXJYhU89RrhVeCs7o0QvSCPtWP8W1rsg4xTqc2KW5SKbfFOg
         Fwok/6KRTu5PJWQ7XAXPPLGJBUQbKg+Kcri189Is3rMUtva/U+MhhINYTNXhIQ7otUO3
         8RtJK0vg9jWsiEsXqU4SpJBZmkBa0pPEwlG5y4zRcaYm4ewmn1f+nuIuAPVl8v1ggloR
         7Ztj5b8wHjvA9CPLc4FXHyIDcVTAqq3Prm2aD/5VREabkEWJSCx2UAeY9encneYeb/JN
         sbXw==
X-Gm-Message-State: AOAM532mIRcvQuHY1aP3e9KiW2c3JJaluDDGFn+HfImD7tI4f+YnY475
        teWnZBy4P0f+yXzWm3QvnthzYG24qpUX2e58n/A=
X-Google-Smtp-Source: ABdhPJxnRgFXIqxXCwmnfRt9qCEssU+85vKqJ2AHwio3f7/M4OR8/7370uV5eFc5TxQx1iyskfqyfqM9GztDfoRuWPY=
X-Received: by 2002:a63:7313:: with SMTP id o19mr3878496pgc.307.1594740163785;
 Tue, 14 Jul 2020 08:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
 <20200714103027.2477584-2-tz.stoyanov@gmail.com> <20200714102813.2d9434d6@oasis.local.home>
In-Reply-To: <20200714102813.2d9434d6@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 14 Jul 2020 18:22:32 +0300
Message-ID: <CAPpZLN7yn9b-ukjP=wD0EWzMc0rAc6mDCx_Asj=AYj3i2Opyig@mail.gmail.com>
Subject: Re: [PATCH 1/8] trace-cmd: Document tep_load_plugins_hook()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jul 14, 2020 at 5:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 14 Jul 2020 13:30:20 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Add description of tep_load_plugins_hook() traceevent API.
> >
>
> Should add:
>
> Link: https://lore.kernel.org/r/CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com
>
> (you get that part after '/r/' from the message ID in the email.)
>

Ok, I'll send the v2 with links and updated subjects to "trace-cmd
libtraceevent:"

> > Suggested-by: Namhyung Kim <namhyung@kernel.org>
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/traceevent/event-plugin.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
> > index 30c1526d..c11636ce 100644
> > --- a/lib/traceevent/event-plugin.c
> > +++ b/lib/traceevent/event-plugin.c
> > @@ -544,6 +544,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
> >       closedir(dir);
> >  }
> >
> > +/**
> > + * tep_load_plugins_hook - call a user specified callback to load a plugin
> > + * @tep: handler to traceevent context
> > + * @suffix: filter only plugin files with given suffix
> > + * @load_plugin: user specified callback, called for each plugin file
> > + * @data: custom context, passed to @load_plugin
> > + *
> > + * Searches for traceevent plugin files and calls @load_plugin for each
> > + * The order of plugins search is:
> > + *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_FIRST
> > + *  - Directory, specified at compile time with PLUGIN_TRACEEVENT_DIR
> > + *  - Directory, specified by environment variable TRACEEVENT_PLUGIN_DIR
> > + *  - In user's home: ~/.local/lib/traceevent/plugins/
> > + *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_LAST
>
> We should probably have a man page as well.
I'm planning to add a man page when backporting these patches from
trace-cmd to kernel repo, as there are no libtraceevent man pages in
trace-cmd, they exist only in the kernel tree.

>
> Thanks Tzvetomir!
>
> -- Steve
>
> > + *
> > + */
> >  void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
> >                          void (*load_plugin)(struct tep_handle *tep,
> >                                              const char *path,
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
