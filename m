Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766CCC56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B9C621534
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbNydkP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgKLFiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgKLFBW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 00:01:22 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C176C0613D1
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Nov 2020 21:01:22 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e7so3359874pfn.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Nov 2020 21:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqzAJ1ej8zEOmgsNjLIVeFtuw6Y9CzIa7wbIRQiFOko=;
        b=SbNydkP5w3ptfsu/YK64hDLUsBe17XE9rbXiWViNRq9E7rxw1yasfgUsRjkzDnCJzT
         WQUkHj9SIyaDqr25FSlP8gE+qRjrV/SXueppp5iYXUfX1n4gP1fCJxXQMnequO7hFcFU
         OttZ5wv+Cv3Ny+irXMAsaW2O3IZv/lXcs5oF3EcJTNPAhVUZ26VsfprjKfOcUhbwTBiT
         kBLQcTfzkOSIgVakfhWSJ7YPjd/1V2nKnFduJUORZtj4c+D9Ws3wuIhVDaCMvP1+15KJ
         d82P+AUWS069U0VRTJkqL9lq20Lwb33I6fJNOvOLKe+KKjPZJwX1nq2qptOaWdUa1rN3
         8DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqzAJ1ej8zEOmgsNjLIVeFtuw6Y9CzIa7wbIRQiFOko=;
        b=R4mbPmCUL0t94ON5V5V6iD1OjuDoW8QOR2UHZCZGaizomHWTprrclUJGX/rQnRL8Wf
         rzn4kHw6fCxgRO9l3wLlBganQOpb15LwpidcL1SHJvA7NnUuKgfYMGOh49VGYRsJn62+
         Htuw2JKFdAmam+YyAy5d9yOt8qIu+1n9dL5q0VxEecTtgEegfnnYQAqwos5pUVXzitHJ
         mp/gGUvJWittuuAq85UE1+4axEpi/UgupPXSCz/pbMCk4EeHnHXuL9M4wdolpYk3//08
         5I9fVmvQUkpre7a0dDGaQRXqI222GPDe/tlOVq1TPBYemtcxqNXcbwYjvA7feUnnVRj6
         qbfA==
X-Gm-Message-State: AOAM533BPMRIvGdudXz424zvfT0V7v1GOVmmTObsR608D/U3B3LOiV4C
        KAE2AxaEM96m3N0HfSM300z+U9mL29BqJsm7jTobRAeK183f7nfn
X-Google-Smtp-Source: ABdhPJytb8Et0R6dZOU9A253j2LKOJZMsy+/S4mblhZd6d9vSry7BGQfodSrU16wg0GzjFwfPwsYWuk7ZQY4A5d62CA=
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id
 f10-20020a056a00228ab029018b212a1af7mr26733842pfe.55.1605157281840; Wed, 11
 Nov 2020 21:01:21 -0800 (PST)
MIME-Version: 1.0
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
 <20201110122249.911664-6-tz.stoyanov@gmail.com> <20201111203130.38d68859@oasis.local.home>
In-Reply-To: <20201111203130.38d68859@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 12 Nov 2020 07:01:05 +0200
Message-ID: <CAPpZLN7qdZYMQvWvd6_uMr+65ZRQYUZXSmossPJeTNJna+o7pg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] libtracefs: Add new tracefs API tracefs_instances_walk()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 12, 2020 at 3:31 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 10 Nov 2020 14:22:48 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> \> +
> > +/**
> > + * tracefs_instances_walk - Iterate through all ftrace instances in the system
> > + * @callback: user callback, called for each instance. Instance name is passed
> > + *         as input parameter. If the @callback returns non-zero,
> > + *         the iteration stops.
> > + * @context: user context, passed to the @callback.
> > + *
> > + * Returns -1 in case of an error, 0 otherwise.
> > + */
> > +int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
> > +{
> > +     struct dirent *dent;
> > +     char *path = NULL;
> > +     DIR *dir = NULL;
> > +     struct stat st;
> > +     int fret = -1;
> > +     int ret;
> > +
> > +     path = tracefs_get_tracing_file("instances");
> > +     if (!path)
> > +             return -1;
> > +     ret = stat(path, &st);
> > +     if (ret < 0 || !S_ISDIR(st.st_mode))
> > +             goto out;
> > +
> > +     dir = opendir(path);
> > +     if (!dir)
> > +             goto out;
> > +     fret = 0;
> > +     while ((dent = readdir(dir))) {
> > +             char *instance;
> > +
> > +             if (strcmp(dent->d_name, ".") == 0 ||
> > +                 strcmp(dent->d_name, "..") == 0)
> > +                     continue;
> > +             instance = trace_append_file(path, dent->d_name);
> > +             ret = stat(instance, &st);
> > +             free(instance);
> > +             if (ret < 0 || !S_ISDIR(st.st_mode))
> > +                     continue;
> > +             if (callback(dent->d_name, context))
>
> Should we notify the caller of this function if the callback returned
> non zero?
>
>
> > +                     break;
> > +     }
> > +
> > +out:
>
> Hmm, would dir ever be anything but non NULL here?
>
It could be NULL if opendir() or stat() fails.

Thanks, Steve! I'll address your comments in the next version of the patch set.
> -- Steve
>
> > +     if (dir)
> > +             closedir(dir);
> > +     tracefs_put_tracing_file(path);
> > +     return fret;
> > +}



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
