Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC90C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 06:52:41 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5963E20735
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 06:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nCSJSXlQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5963E20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-trace-devel-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgDMGwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 02:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbgDMGwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 02:52:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49966C008651
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Apr 2020 23:52:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c138so4142980pfc.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Apr 2020 23:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6bWPhH0K8tKXilCNdVeQhs6SHx2lKmDCdiRjFRb6CA=;
        b=nCSJSXlQT0SXIwmYnvqCNBOz65j78THh2/0nDPwYO/dTW0HneOwIB/G9gm5yG1B23/
         +R1QB/Icd7zZDLrKT+dnxFmW5OyHBb7izQK1Blys0LWhcCgCYRQcnHJTlinLB0wYmcFN
         wQFxPaRXnrk5k8+e+hBacAoVUL5/RSWVt6z5P3qsaDNxcLf6T5bOxnK17TP4B1RvGov3
         m5s7+igcjffJuYTR7rgN9eMIpo3T4XPxpURHanTPa3fuvLeXfCQw2EDyifUL4i3Ssw9s
         0MfCE/EKp2lK3wtb4T/a0kglqfg1CyClHwJAJLJdm0ZFXlwCYlhnmLIxqCx3dagvINfm
         koKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6bWPhH0K8tKXilCNdVeQhs6SHx2lKmDCdiRjFRb6CA=;
        b=ldqZcS8zjSQRJO2mnOkIBxuH0HL8OCubq8X2jN9yTpjLhdtOScFA33a7T/smDc7MVB
         l/atn+B0beoi8NFF8cg/g7bMib22u4L+JTQjxjirB0KMHycY0m7J1Z8bqPYsr/nXKPmL
         hkLF8YWktrRvzKN2KRMt96Y9VwXZ+Q39q0m9ESMEb7GGdpk7eRUj9Xr1xjPhnNts7S8J
         6zcPXY8J+a7539caJ2M2kmis4ulf0kpkSLtYw1EIMMdHK1tifR6kQL6n7t4tr0ZLNHUc
         RIYp3njsJuHJSvToqr131f7k3qz1TOK7T+bUhB+hkJ99ci7ubD+nJCtTnlqUtuG2ns6O
         O4Cw==
X-Gm-Message-State: AGi0PuaFxE6eP7IAIMAgcZUiuTRgcIgCazyxG8hpRON3CYbYd8Yj4D23
        VMuyufPddSxCBGuDQFsEQSDPGvoRWmv6IQolreaVBmQsqHI=
X-Google-Smtp-Source: APiQypJtSFjWeRGCiwVrbu3mRw2Fgzpl0tqRv7IaxOIWSm6IN/o0GnUaDIe4ADKrrgQzKC4XGyH3I4hA8nJdkhwjPa4=
X-Received: by 2002:a62:2cc3:: with SMTP id s186mr16618689pfs.236.1586760757761;
 Sun, 12 Apr 2020 23:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200225180733.89344-1-tz.stoyanov@gmail.com> <20200225180733.89344-2-tz.stoyanov@gmail.com>
 <20200409142215.29607d07@gandalf.local.home>
In-Reply-To: <20200409142215.29607d07@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 13 Apr 2020 09:52:26 +0300
Message-ID: <CAPpZLN79nThubAvo_nO1jr8d-N7jzqja9b72DEfuNiWixrD7uA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] trace-cmd: Add new tracefs APIs for checking if a
 ftrace file / directory exists
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 9, 2020 at 9:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 25 Feb 2020 20:07:30 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Some ftrace files and directories are optional, depending on specific kernel configuration or version.
> > It is a good practice to check if the file / directory exist, before trying to access it. There are a lot of places in trace-cmd implementation with such checks.
> > The new libtracefs APIs can be used for this, they are ftarce instance aware:
> >  bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
> >  bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/tracefs/tracefs.h      |  3 +++
> >  lib/tracefs/tracefs-instance.c | 49 +++++++++++++++++++++++++++++++++-
> >  2 files changed, 51 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> > index 85690b66..bc8bebcb 100644
> > --- a/include/tracefs/tracefs.h
> > +++ b/include/tracefs/tracefs.h
> > @@ -33,6 +33,9 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
> >  char *tracefs_instance_file_read(struct tracefs_instance *instance,
> >                                char *file, int *psize);
> >
> > +bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
> > +bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
> > +
> >  /* events */
> >  void tracefs_list_free(char **list);
> >  char **tracefs_event_systems(const char *tracing_dir);
> > diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
> > index b96ab61c..67123e7c 100644
> > --- a/lib/tracefs/tracefs-instance.c
> > +++ b/lib/tracefs/tracefs-instance.c
> > @@ -13,7 +13,7 @@
> >  #include <errno.h>
> >  #include <sys/stat.h>
> >  #include <fcntl.h>
> > -
> > +#include <linux/limits.h>
> >  #include "tracefs.h"
> >  #include "tracefs-local.h"
> >
> > @@ -247,3 +247,50 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
> >
> >       return buf;
> >  }
> > +
> > +static bool check_file_exist(struct tracefs_instance *instance,
> > +                          char *name, bool dir)
> > +{
> > +     char file[PATH_MAX];
> > +     struct stat st;
> > +     char *path;
> > +     int ret;
> > +
> > +     path = tracefs_instance_get_dir(instance);
> > +     snprintf(file, PATH_MAX, "%s/%s", path, name);
> > +     tracefs_put_tracing_file(path);
> > +     ret = stat(file, &st);
> > +     if (ret < 0)
> > +             return false;
> > +
> > +     if (dir && !S_ISDIR(st.st_mode))
> > +             return false;
> > +     if (!dir && S_ISDIR(st.st_mode))
> > +             return false;
> > +
> > +     return true;
>
> BTW, the above can be converted to just:
>
>         return !dir == !S_ISDIR(st.st_mode);
>
>
> > +}
> > +
> > +/**
> > + * tracefs_file_exist - Check if a file with given name exists in given instance
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + * @name: name of the file
> > + *
> > + * Returns true if the file exists, false otherwise
>
> Probably should comment that this will return false if the "file" exists
> but is a directory.
>
> Is there any reason we would not want to return true here if it was a
> directory? A directory is just another kind of "file" (in the Unix world).
>

The use case of the API is to check if a given file exists in tracefs, before
writing to / reading from it. If the user expects file, but it is a directory -
the operation will fail. We can think of adding additional input parameter
to the API, to let the user specify the desired behavior of the API ?
Something like :
bool tracefs_file_exist(struct tracefs_instance *instance, char *name,
bool any);


> -- Steve
>
> > + */
> > +bool tracefs_file_exist(struct tracefs_instance *instance, char *name)
> > +{
> > +     return check_file_exist(instance, name, false);
> > +}
> > +
> > +/**
> > + * tracefs_dir_exist - Check if a directory with given name exists in given instance
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + * @name: name of the directory
> > + *
> > + * Returns true if the directory exists, false otherwise
> > + */
> > +bool tracefs_dir_exist(struct tracefs_instance *instance, char *name)
> > +{
> > +     return check_file_exist(instance, name, true);
> > +}
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
