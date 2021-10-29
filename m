Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCB0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CEF561181
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhJ2Ct3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhJ2Ct2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 22:49:28 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD3C061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 19:47:00 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f5so8417437pgc.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 19:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3serSwYzzGwceJ/+toZXBCWx/38V3T074QzDpoWwnt8=;
        b=FMj8nVRt5WERjLRty78wTuMwjBgIV3RQjjWnnaBvdCLKI5nG9zDPzzkZDRl4pg73sp
         T89uKTw8HgpIhYGKbHtCaBgH4/mqseREaIiSh6C7gGTcN0auHCDdSggYw1BrW8CNvldt
         Nq3LRrnFb1HXwcLE1pcr5+3KKENOC0Mo+wUtW4FN+Th6+oAuCSVFqgIzPb3xyXohIgce
         dhSplxrdi/S4ThqF1fxnGXaVaST1rb1Bs+rTCBnniBny2CS0CpTBVHLgTldWmzOVPnDw
         1FicAz+WK0wQ4akBymWgiRxm0BEgHRVhRpUPy0myMDUN3XjsBRoSAeJE6SfwOK4Txi8s
         A0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3serSwYzzGwceJ/+toZXBCWx/38V3T074QzDpoWwnt8=;
        b=5o/bbJmIiWfkvZuG3nq+2S1g0qE0VNIG54NysnqD3tcJUgJL0kRcZ8Wcy9BiGp4y1v
         wf9eAHhKkMeAjK4/MTzxuFjOoJ3fxPsV51UjzkftYHHnOHPC0Sg01ZyZB+ZtnbDC+hLz
         oR81axwSC89BEiKQyRlQEkn0LMMutCVarZnffSmMkS1n2MV/Xbt1bkXM9QYgqJ8S9aVJ
         29iITNN0BoQFF+uD8gOkHhN77CvhRwNrUSXy4qEoRWwuJPK8hO6x7AN3euMePjEPQGME
         Rg8PtEmzlJeOqBNxw7w8cYJx1QrWKRpNwLkDvdl7gZ2NCC5Mh5w8o0CCaU9W/dyaiEef
         aCpQ==
X-Gm-Message-State: AOAM531cdqCs/rvkethxPe8If6svfsBmRHpwt/3zMi840XYOSAjzDP0W
        8I+y3UoKTSHhdjs4TxvRzdsJzjozunUCTTi4Rkxav/ul0lRBtQ==
X-Google-Smtp-Source: ABdhPJyeMXQptS0d5CjvPwgKvuFxuhv1K8G1JoGXG36RXpogFeO+G23dzl0eF9HeUeWbWsIMRBN7Fl2eejbMpXq2xSM=
X-Received: by 2002:a63:374f:: with SMTP id g15mr6200238pgn.193.1635475619031;
 Thu, 28 Oct 2021 19:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
 <20211028120907.101847-2-tz.stoyanov@gmail.com> <20211028174113.134ae7ce@gandalf.local.home>
In-Reply-To: <20211028174113.134ae7ce@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 29 Oct 2021 05:46:42 +0300
Message-ID: <CAPpZLN6NEHLSvu0jZE=3E5mhLZCX=zw7Sg+G-_6CXb=M38p1HQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] libtracefs: Add new internal APIs for dynamic events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 29, 2021 at 12:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 28 Oct 2021 15:08:56 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
[...]
> > +
> > +struct tracefs_dynevent *
> > +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> > +            const char *event, const char *address, const char *format);
> > +void dynevent_free(struct tracefs_dynevent *devent);
> > +int dynevent_create(struct tracefs_dynevent *devent);
> > +int dynevent_destroy(struct tracefs_dynevent *devent);
> > +int dynevent_get_all(unsigned long type_mask, const char *system,
> > +                  struct tracefs_dynevent ***ret_events);
>
> I usually prefer to have a list returned, and NULL on error, instead of
> passing it in by reference. The "***" gets a bit out of hand.
>

The ret_events argument is optional, that's why it is passed as a
parameter. If ret_events is NULL, the API will return only the count
of the requested events. No array with events will be allocated in
that case.

>
> > +
> >  #endif /* _TRACE_FS_LOCAL_H */
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index a2cda30..4020551 100644
[ ... ]
> > +
> > +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> > +                          char *line, struct tracefs_dynevent **ret_dyn)
>
> Again, I prefer to have the pointer returned, and not assigned as a
> parameter. All this returns is 0 on success or -1 on failure. That doesn't
> give us anything more than having ret_dyn allocated or not. (return NULL or
> non-NULL).
>

The ret_dyn is optional. If it is NULL, the function only checks if
the line contains an event of the requested type, without allocating
any memory.

> > +{
> > +     struct tracefs_dynevent *dyn;
> > +     char *address;
> > +     char *system;
> > +     char *format;
> > +     char *event;
> > +
> > +     if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> > +             return -1;
> > +
> > +     system = strchr(line, ':');
> > +     if (!system)
> > +             return -1;
> > +     event = strchr(line, '/');
> > +     if (!event)
> > +             return -1;
> > +     address = strchr(line, ' ');
> > +     if (!address)
> > +             return -1;
> > +     format = strchr(address+1, ' ');
> > +
> > +     *address = '\0';
> > +     *event = '\0';
>
>
> The above should use strtok_r.
>
>         char *probe;
>         char *sav;
>
>         probe = strtok_r(line, ":", &sav);
>         system = strtok_r(NULL, "/", &sav);
>         event = strtok_r(NULL, " ", &sav);
>         address = strtok_r(NULL, " ", &sav);
>         format = strtok_r(NULL, "\n", &sav);
>

I used strchr() instead of strtok_r() here, because my original idea
was that this function should not modify the original line string, if
the event is not of the requested type. When parsing the
"dynamic_events" file, it contains events from any types. My initial
design was to pass the same line string to all parse functions, until
there is a match. But the design was changed, now a new copy of the
file is used for each event type. I'll change that code to use
strtok_r().

>
>
>
> > +
> > +     /* KPROBEs and UPROBEs share the same prefix, check the format */
> > +     if (desc->type == TRACE_DYNEVENT_UPROBE || desc->type == TRACE_DYNEVENT_URETPROBE) {
> > +             if (!strchr(format, '/'))
> > +                     return -1;
> > +     }
[ ... ]
> > +
> > +static int get_all_type(enum trace_dynevent_type type, const char *system,
> > +                     struct tracefs_dynevent ***ret_all)
> > +{
> > +     struct dyn_events_desc *desc;
> > +     struct tracefs_dynevent *devent, **tmp, **all = NULL;
> > +     char *content;
> > +     int count = 0;
> > +     char *line;
> > +     char *next;
> > +     int ret;
> > +
> > +     desc = get_devent_desc(type);
> > +     if (!desc)
> > +             return -1;
> > +
> > +     content = tracefs_instance_file_read(NULL, desc->file, NULL);
> > +     if (!content)
> > +             return -1;
>
> space.
>
> > +     line = content;
> > +     do {
> > +             next = strchr(line, '\n');
> > +             if (next)
> > +                     *next = '\0';
> > +             ret = desc->dyn_events_parse(desc, system, line, ret_all ? &devent : NULL);
>
> So if ret_all is NULL, then we allocate a bunch of devent and lose them?
>

Hm, no devents are allocated if ret_all is NULL. That's the idea of
that API design - ret_all is an optional input parameter. Without it,
the functions can be used only to get the count of the requested
events, without any memory allocation. I would like to keep that
functionality, even though it is not used at the moment.

> > +             if (!ret) {
> > +                     if (ret_all) {
> > +                             tmp = realloc(all, (count+1)*sizeof(struct tracefs_dynevent *));
> > +                             if (!tmp)
> > +                                     goto error;
> > +                             all = tmp;
> > +                             all[count] = devent;
> > +                     }
> > +                     count++;
> > +             }
> > +             line = next + 1;
> > +     } while (next);
> > +
> > +     free(content);
> > +     if (ret_all)
> > +             *ret_all = all;
>
> We really should just return all, and if we want a count, we can pass a
> pointer to an integer, and put the count in there. Not the other way around.
>
> > +     return count;
> > +
> > +error:
> > +     free(content);
> > +     free(all);
> > +     return -1;
> > +}
> > +
> > +/**
> > + * tracefs_dynevent_list_free - Deletes an array of pointers to dynamic event contexts
> > + * @events: An array of pointers to dynamic event contexts. The last element of the array
> > + *       must be a NULL pointer.
> > + */
> > +void tracefs_dynevent_list_free(struct tracefs_dynevent ***events)
>
> Again, just pass in ** not ***.
>
> > +{
> > +     struct tracefs_dynevent **devent;
> > +     int i = 0;
> > +
> > +     if (!events || !(*events))
> > +             return;
> > +
> > +     devent = *events;
> > +     while (devent[i])
> > +             dynevent_free(devent[i++]);
> > +
> > +     free(*events);
> > +}
> > +
> > +__hidden int dynevent_get_all(unsigned long type_mask, const char *system,
> > +                           struct tracefs_dynevent ***ret_events)
> > +{
> > +     struct tracefs_dynevent **events, **tmp, **all_events = NULL;
> > +     int count, all = 0;
> > +     int i;
> > +
> > +     for (i = 0; i < TRACE_DYNEVENT_MAX; i++) {
> > +             if (!DYNEVENT_CHECK_BIT(type_mask, i))
> > +                     continue;
>
> space.
>
> > +             count = get_all_type(i, system, ret_events ? &events : NULL);
> > +             if (count > 0) {
> > +                     if (ret_events) {
> > +                             tmp = realloc(all_events,
> > +                                          (all + count)*sizeof(struct tracefs_dynevent *));
> > +                             if (!tmp)
> > +                                     goto error;
> > +                             all_events = tmp;
> > +                             memcpy(all_events + all, events,
> > +                                    count*sizeof(struct tracefs_dynevent *));
> > +                     }
> > +                     all += count;
> > +             }
> > +
> > +     }
> > +
> > +     if (ret_events) {
> > +             /* Add a NULL pointer at the end */
> > +             if (all > 0) {
> > +                     tmp = realloc(all_events,
> > +                                  (all + 1)*sizeof(struct tracefs_dynevent *));
> > +                     if (!tmp)
> > +                             goto error;
> > +                     all_events = tmp;
> > +                     all_events[all] = NULL;
> > +             }
> > +             *ret_events = all_events;
> > +     }
> > +
> > +     return all;
> > +
> > +error:
> > +     if (all_events) {
> > +             for (i = 0; i < all; i++)
> > +                     free(all_events[i]);
> > +             free(all_events);
> > +     }
> > +     return -1;
> > +}
>
>
> -- Steve

Thanks Steven! I'll address these comments in the next version, but I
really want to keep the  dynevent_get_all() API more flexible - to
have a way to get only the count, without allocating an array with the
events.


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
