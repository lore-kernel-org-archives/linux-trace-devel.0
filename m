Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF4BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 04:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28C922B37
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 04:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgLUEzn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Dec 2020 23:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgLUEzn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Dec 2020 23:55:43 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F5AC0613D3
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 20:55:02 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id bd6so3945292qvb.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 20:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MbDZuGV8vGIBS0KtTWaWIRVmDr7xoBBvhvXkiT1Ksss=;
        b=K/GDqzid7LRxip9UWrcVLKlXG0OV1mVli9yEKm7sMKVcqqq3768Lo84pdPyUYP0YOz
         4Hueqf5ynCmtkYYUr7fksMWA/w0NWoz7bv5FfoUiR63X8Y1jlux4Vzy5EjfY6r4rF3tT
         QDCaVPg96RlQXnEaVOuyIb7jfGaweiuHcL9llqk8zNXHob9cIFo1hu2CsY3Uk9xP5AXq
         Xjl37GSacITHH+F1xaYWyuDI2IicKdfjCo3zempT5Nh4FkMfSVtRKHTkJf9E4ffJdjSJ
         ytRxA7qvdwJtoPK9tmrxJexMNQ0UgnCtD2kMpe/Psf0doLzmzvAb7C7yDpEW9lIElubA
         NgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MbDZuGV8vGIBS0KtTWaWIRVmDr7xoBBvhvXkiT1Ksss=;
        b=avsFSGFm4LBS6kv683Eqb7PKg6hqmCKd7YjdU3bfr8rlSijeZgJXEs2Gc7I+IhxUvW
         MSKPyaazx1acqLd/Es5nZLPgliSdwBpYqHOh72Jb0oSXzCD1QxLU9Cw1EbX3p1HcBNIC
         5ULgDAABXK9ctbD8taCgyg9OhHcAKO73R0S1TTqjEgb0twBQmTeDrt9vYVzivV+QZJRi
         Q9ND2aMFo3roVsLU8T4IGy46Lq2miMzsLoT5w7aoQ7hSi40EnoTFFVT3kg6xrF9AiKcu
         jhVACUHOD60vs0x/40TxpCcEsgn+RGjQSlLPftGwLDmNkDOdCsYrNa+Ll6VVTvN38ZsK
         HU6w==
X-Gm-Message-State: AOAM532t0apknFk7AbxagKCBRwD0+J2sWWz0ThJwSxwIUsd6XQ0NMern
        ULqkpAeMqZ3OpaIkCWZCkKqgvOPmpUf7mjHjk2Ob5R56jL8WG6Le
X-Google-Smtp-Source: ABdhPJw9TxK4hmp+ylY01egDmwJ7GA9C131g5LTsllr544ZyVOlXqf9ibjBcrzUXOsBf3IB15fFonVJjSDgO0ioum3E=
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id
 f10-20020a056a00228ab029018b212a1af7mr13452952pfe.55.1608522301394; Sun, 20
 Dec 2020 19:45:01 -0800 (PST)
MIME-Version: 1.0
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
 <20201217094626.1402191-4-tz.stoyanov@gmail.com> <20201218135519.2643e7cd@gandalf.local.home>
In-Reply-To: <20201218135519.2643e7cd@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 21 Dec 2020 05:44:45 +0200
Message-ID: <CAPpZLN5VZMGx9rpUktjSDFiKhOw8BUqSqdDdHOCGMF3O5c8TpA@mail.gmail.com>
Subject: Re: [PATCH 3/9] libtracefs man pages: APIs for locating trace
 directory and files.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 18, 2020 at 8:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 17 Dec 2020 11:46:20 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +DESCRIPTION
> > +-----------
> > +This set of APIs can be used to find the full path of the trace file
> > +system mount point and trace files in it.
> > +
> > +The _tracefs_get_tracing_file()_ function returns the full path of the
> > +file with given _name_ in the trace file system. The function works
> > +only with files in the trasefs main directory, it is not trace instance
> > +aware. It is recommended to use _tracefs_instance_get_file()_ and
> > +_tracefs_instance_get_dir()_ instead. The returned string must be freed
> > +with _tracefs_put_tracing_file()_.
> > +
> > +The _tracefs_put_tracing_file()_ function frees trace file name,
> > +returned by _tracefs_get_tracing_file()_.
> > +
> > +The _tracefs_find_tracing_dir()_ function finds the mount point of the
> > +trace file system and returns a full path to it. If the file system is
> > +not mounted, it will mount it. The returned string must be freed.
>
> How should it be freed?
I'll add " with free()" in the next version of the patch, but I was
wondering if the
user should use "tracefs_put_tracing_file()" instead ? These APIs are not
consistent, may be they should be renamed. Now we have:

   tracefs_get_tracing_file() / tracefs_put_tracing_file()
   tracefs_get_tracing_dir() / returns static, must not be feed.
   tracefs_find_tracing_dir() / free()


>
> > +
> > +The _tracefs_get_tracing_dir()_ function returns the full path to the
> > +trace file system. In the first function call, the mount point of the
> > +tracing file system is located, cached and returned. It will mount it,
> > +if it is not minted. On any subsequent call the cached path is returned.
> > +The return string must _not_ be freed.
> > +
> > +RETURN VALUE
> > +------------
> > +The _tracefs_get_tracing_file()_ function returns a string or NULL in case
> > +of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
> > +
> > +The _tracefs_find_tracing_dir()_ function returns a string or NULL in case
> > +of an error. The returned string must be freed.
>
> Should state how it should be freed. tracefs_put_tracing_file() or free() ?
>
> If it is free(), then stating:
>
>  "The returned string must be freed with free()"
>
> is fine.
>
> > +
> > +The _tracefs_get_tracing_dir()_ function returns a constant string or NULL
> > +in case of an error. The returned string must _not_ be freed.
> > +
> > +EXAMPLE
> > +-------
> > +[source,c]
> > +--
> > +#include <tracefs.h>
> > +...
> > +char *trace_on = tracefs_get_tracing_file("tracing_on");
> > +     if (trace_on) {
> > +             ...
> > +             tracefs_put_tracing_file(trace_on);
> > +     }
> > +...
> > +char *trace_dir = tracefs_find_tracing_dir();
> > +     if (trace_dir) {
> > +             ...
> > +             free(trace_dir);
> > +     }
> > +...
> > +const char *trace_dir = tracefs_get_tracing_dir();
> > +
>
> Not a very useful example ;-)  We we can fix examples at a later time. I
> plan on writing a lot of example code to post, and some can make their way
> into the man pages.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
