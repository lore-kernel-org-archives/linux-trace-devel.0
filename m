Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C289BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 07:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67FBB64ED1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 07:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhBXHkr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 02:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhBXHkq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 02:40:46 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBC3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 23:40:06 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z7so682391plk.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 23:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TL1bVqst89YIrRU61+jXB2LptmjUDNjwuDdZ6Klc61o=;
        b=XXMR1PzVnrlkKUAtR/gyBSN8Bg25t/++fPm6O1/bPdLX9B1BxGMLOYhX0Ia1FlEgjg
         6DaIzGjBDcE2Dd2P5JXd5f9hBJ470O+9Awdu1izxgqU9T04T1QDqvwBFr6vmWK4Jbd7H
         dibxUHHaH3Fn5RY0YHa4uTPDLY/twDScQf6VjCQ1JdC1BvyZQqS/DrzgVp+clT2wTt/G
         HNkG+bt5lsg8bYUpDgKfpMM2VxUAZENh3fr1/91n9rJ2QDFwpJk62pQIqH6SEGKLTOf8
         QLi8WW/VWe49cUgBJd8nEmzkdWUH2JUxTBVNl2Sn33U4Kav36N+XIS+7HPxuFBMl63/g
         WBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TL1bVqst89YIrRU61+jXB2LptmjUDNjwuDdZ6Klc61o=;
        b=t/N7CLcCn94m+UfhLecp45wsQwye42ZCL8hgRPtDX1Gv21uGpIFUBZ2k/0DRarYtZ7
         kEQMoGegdPygVk00aae2ZCBqHUIFr2pTscumHMx1rYNsbAVEg0islJgJszAm4o8toRXO
         EedM/wbXg5NxAZlwZXlTokiPVl5w7QK9DpG9cFm2rG7PiqVIC0H9MR1q9PjiJMQxZ105
         xwLunL+IkHdyvMNZRoky5lkGkJdhADDhOndqVLe16e+kC1EzovwPlgePclrnxf6WBsLg
         ECL1216Xl7WNExrlcjITSagIOs6+mcCWVmeeD1qPJLl633YRtl6bWSpXo+4y39axAw7Y
         aAlg==
X-Gm-Message-State: AOAM530Ti57G4e+Ix48uLVJYDvNSAE/V3FAQdab8+lqKgggD0l0YG9wq
        gw8/pBADnsT1g1rxRSUkrhkPaKF6qlqFXjIth571/kpgZ3bcPQ==
X-Google-Smtp-Source: ABdhPJx54Q29pPRlvuN5/rG2dHpw92TVbr8Vke83O/gQ7d0AtDiD24AtEFqsCH9X6OdLKGaL3KDA2kkYmdasXUdFQyQ=
X-Received: by 2002:a17:902:d20d:b029:e4:51e:df40 with SMTP id
 t13-20020a170902d20db02900e4051edf40mr6409491ply.58.1614152406063; Tue, 23
 Feb 2021 23:40:06 -0800 (PST)
MIME-Version: 1.0
References: <20210223120130.280e7838@gandalf.local.home>
In-Reply-To: <20210223120130.280e7838@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Feb 2021 09:39:49 +0200
Message-ID: <CAPpZLN7tsF8=o1RQJc2rMAdbrFgmFvZmKWK9avbCPCa42U_iDw@mail.gmail.com>
Subject: Re: Fw: [Bug 210643] libtracefs: Add ways to set the filtering of
 function tracing
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 23, 2021 at 7:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> Forwarding this to the mailing list, as well. Any discussions on this may
> be easier to discuss here than on the bugzilla.
>
> -- Steve
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=210643
>
> --- Comment #7 from Steven Rostedt (rostedt@goodmis.org) ---
> After some discussions on the mailing lists, I found that it is important to
> establish the requirements that I expect of this API. I'm doing it in the
> bugzilla instead of the mailing list (but will also forward this to the
> mailing list), as this is more about the feature request and not about the
> development of it.
>
> The prototype should be:
>
>  int tracefs_function_filter(struct tracefs_instance *instance,
>                              const char * const *filters,
>                              const char *module,
>                              boolean reset);

I think there should be a complementary API for deleting the filters,
may be something like
  int tracefs_function_filter_remove(struct tracefs_instance *instance,
                                                        const char *
const *filters,
                                                        const char *module)
It should be able to remove the filters, configured by the first API
with the same "filters, module" input parameters.

>
> If @instance is NULL, the filter for the top level tracing directory is
> used. Otherwise the filter is for the given instance.
>
> The @filters is an array of strings that holds one or more filters, and the
> array ends with a NULL pointer.
>
> If @module is set, only apply the filter to functions for a given module.
> This is ignored if NULL is passed in. I added this to the interface because
> it is commonly used, and the set_ftrace_filter has a special way to handle
> it (see more below).
>
> If @reset is set, the function filter for the given instance (or toplevel if
> @instance is NULL), is cleared before applying the new filter functions.
> Otherwise, the function filters are appended.
>
> Note on reset being set: This is an important implementation detail. The
> reset must be done by opening the file with O_WRONLY|O_TRUNC set. And the
> file is not closed until all the new filters are added. It must not clear
> the file and close it before setting the new filters. The reason is, if it
> does, then all functions will start to be traced!
>
> If the function filter has some functions in set_ftrace_filter, and the
> function tracer is active, then it is only tracing those functions in
> set_ftrace_filter. If you want to change that set of functions to a new set,
> you open the set_ftrace_filter file with O_WRONLY|O_TRUNC and add your new
> functions. On closing the file, the change takes place. The old functions
> being filtered will no longer be traced, and the new functions being filter
> will start to be traced.
>
> If the set_ftrace_filter is truncated and closed without setting the new
> functions, then the function tracer will start tracing *all* functions!
> That is not what this API should do. This is why it is important that you
> write the new filters after opening with O_TRUNC and before closing the
> file descriptor. This is another reason to use an array of filters instead
> of having the application call this function multiple times with different
> filters strings.
>
> Now when writing the filters, the following should be done for each filter.
> Write the filter to set_ftrace_filter file, and if it succeeds, then
> continue to the next filter. If it does not succeed, then check if it is a
> regex. If so, then add all the functions that match the regex that are in
> available_filter_functions.
>
> Note, if @module is not NULL, then before writing the filter strings for the
> non regex write, append ":mod:@module" to each filter string. That is, if
> @module is "bridge" and the filter is "br_*", then what should be written
> into the set_ftrace_filter file is: "br_*:mod:bridge", and the kernel will
> only apply the "br_*" to the module "bridge". Implementation detail, you
> can simply write the filter unmodified, then write ":mod:" then write
> "bridge", before writing any spaces to separate the filters. The kernel
> will process that as one string "br_*:mod:bridge". This way the function
> does not need to worry about allocating extra memory and copying the string
> to append the ":mod:bridge" before writing.
>
> If a regex is used, then the search of available_filter_functions should
> only look for function names that have the module name behind it. That is,
> if @module is "bridge" and the filter is ".*switchdev_\\(port\\|fdb\\).*",
> and @module is set, then the search over available_filter_functions should
> run the regex only on functions that have a matching module name "[bridge]".
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You reported the bug.
> You are watching the assignee of the bug.
> You are watching the reporter of the bug.



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
