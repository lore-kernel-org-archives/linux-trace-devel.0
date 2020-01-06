Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB2CC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7E6F20731
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JdlHEE44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgAFOrM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:47:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45264 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgAFOrM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 09:47:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id b9so26970864pgk.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 06:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qkNbcke1LpJ1IIjsn0Lgmb9CgbyED8j8X12d7ortfIc=;
        b=JdlHEE44ZiZXujuD3odWLb9LRkVlVVKgJVIrLpVidxgPv63UILtvF8Eu8UD1LfPeek
         b3ArXJWWdZnqwRvnuDHLqRMLont08SL08P90OARuP5E8bcF9Hc/1m8LnLQkElnG1RWbV
         y9hbfe+Uz9E8KkWeOz+2ADNt4KJJfFCrmlImBbfR7ZB4KgzAzdC+cvqPztjwK35hjZ4b
         cfZRIxW0FdFzPD35U/cLzLcGcse/8ALKDyU6tLksYvyKqgSGZ28M7Cs0wAf1S70yePn+
         L4McnBqsnTFl6X0zbsybYyNkItS6SN9+mWRJDwpu6umYtuPxpNyraENOdEDpORFj/Mlh
         SKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qkNbcke1LpJ1IIjsn0Lgmb9CgbyED8j8X12d7ortfIc=;
        b=OEuaixmLpMXMpArlUTInzEjBogYzgIdiLeeR41dKVQoFhm8kIgEfz/wnRfkNFjHphr
         D6DMgzM+/v/DgMv3OJKJjlOFEiyLjv96N4tKe5dvRNNXdmnuS9t/159fM/ScCQAZYzV+
         UX3okfoRBfi99PAFBGu96SXIML+GGgDw/HyRXO90AptvRjTM3KeZDb2rYOiHgu/awgHI
         nPE4h7q04TXvidItkGh97NmQWgHw4lLV7qrw4M8YKFOXQwGC/63FeMEH3sD0HwsrBdf3
         I/On0YPLScxmV76LaYKdDpF7V8G7Hocl3olFzjxH2vg5H4RmG6FMK1ck7a3i5eq8ZtsY
         XPqw==
X-Gm-Message-State: APjAAAUb6fRmPD9COW+oPi8TRAiYzvyjri9OnE3zwkF+108KQVzdKzTE
        de768kT3m0i86SE6KMqgPn0y69XzTOQQYaaNk3bZhY7m4As=
X-Google-Smtp-Source: APXvYqysLxv9dv/PQ4hGIyJH5LdhOe/Lf7YoDI648orngieKqwf/gUPIdaza9w4+I6/uhZGTIXdl4IQC2mw5kK367pw=
X-Received: by 2002:a65:680f:: with SMTP id l15mr114974337pgt.307.1578322031449;
 Mon, 06 Jan 2020 06:47:11 -0800 (PST)
MIME-Version: 1.0
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
 <20191213153029.133570-5-tz.stoyanov@gmail.com> <20191220220332.517cb36f@rorschach.local.home>
In-Reply-To: <20191220220332.517cb36f@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Jan 2020 16:47:00 +0200
Message-ID: <CAPpZLN5Jk-N-CnKrepL+8F1tHUFPHqDZcmiS=eaMO_0Tw0kV3w@mail.gmail.com>
Subject: Re: [PATCH v18 04/18] trace-cmd: Add new library APIs for ftrace instances.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Dec 21, 2019 at 5:03 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 13 Dec 2019 17:30:15 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +/**
> > + * tracecmd_get_instance_file - return the path to a instance file
> > + * @instance: buffer instance for the file, can be NULL for the top instance
> > + * @file: name of file to return
> > + *
> > + * Returns the path name of the @file for the given @instance
> > + *
> > + * Must use tracecmd_put_tracing_file() to free the returned string
> > + */
> > +char *
> > +tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file)
> > +{
> > +     char *path;
> > +     char *buf;
> > +     int ret;
> > +
> > +     if (instance && instance->name) {
> > +             ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
> > +             if (ret < 0)
> > +                     die("Failed to allocate name for %s/%s", instance->name, file);
> > +             path = tracecmd_get_tracing_file(buf);
> > +             free(buf);
> > +     } else
> > +             path = tracecmd_get_tracing_file(file);
> > +
> > +     return path;
> > +}
> > +
> > +/**
> > + * tracecmd_get_instance_file - return the path to a instance file
> > + * @instance: buffer instance for the file, can be NULL for the top instance
> > + * @file: name of file to return
> > + *
> > + * Returns the path name of the @file for the given @instance
> > + *
> > + * Must use tracecmd_put_tracing_file() to free the returned string
>
> The above is a cut and paste of tracecmd_get_instance_file, not of the
> instance_dir.
>
> > + */
> > +char *tracecmd_get_instance_dir(struct tracecmd_instance *instance)
> > +{
> > +     char *buf;
> > +     char *path;
> > +     int ret;
> > +
> > +     if (instance->name) {
> > +             ret = asprintf(&buf, "instances/%s", instance->name);
> > +             if (ret < 0)
> > +                     die("Failed to allocate for instance %s", instance->name);
> > +             path = tracecmd_get_tracing_file(buf);
> > +             free(buf);
> > +     } else
> > +             path = tracecmd_find_tracing_dir();
> > +
> > +     return path;
> > +}
> > +
> > +/**
> > + * tracecmd_write_instance_file - Write in trace file of specific instance
> > + * @instance: buffer instance for the file, can be NULL for the top instance
> > + * @file: name of the file
> > + * @str: Nul terminated string, that will be written in the file
> > + * @type: Nul terminated string, describing the current write operation
> > + *     Used for logging purposes
> > + *
> > + * Returns the number of written bytes, or -1 in case of an error
> > + */
> > +int tracecmd_write_instance_file(struct tracecmd_instance *instance,
> > +                              const char *file, const char *str,
> > +                              const char *type)
>
> I think we should get rid of the type and move the logic that needs it
> to the callers.
>
>
> > +{
> > +     struct stat st;
> > +     char *path;
> > +     int ret;
> > +
> > +     path = tracecmd_get_instance_file(instance, file);
> > +     ret = stat(path, &st);
> > +     if (ret == 0)
> > +             ret = tracecmd_write_file(path, str, type);
> > +     tracecmd_put_tracing_file(path);
> > +
> > +     return ret;
> > +}
> > +
>
> [..]
>
> > +/*
> > + * tracecmd_write_file - Write in trace file
> > + * @file: Full name of the trace file.
> > + * @str: Null terminated string, that will be written in the file.
> > + * @type: Null terminated string, describing the current write operation.
> > + *     Used for logging purposes.
> > + *
> > + * Returns the number of written bytes, or -1 in case of an error
> > + */
> > +int tracecmd_write_file(const char *file, const char *str, const char *type)
> > +{
> > +     char buf[BUFSIZ];
> > +     int ret;
> > +     int fd;
> > +
> > +     fd = open(file, O_WRONLY | O_TRUNC);
> > +     if (fd < 0)
> > +             die("opening to '%s'", file);
> > +     ret = write(fd, str, strlen(str));
> > +     close(fd);
> > +     if (ret < 0 && type) {
> > +             /* write failed */
> > +             fd = open(file, O_RDONLY);
> > +             if (fd < 0)
> > +                     die("writing to '%s'", file);
> > +             /* the filter has the error */
> > +             while ((ret = read(fd, buf, BUFSIZ)) > 0)
> > +                     fprintf(stderr, "%.*s", ret, buf);
> > +             die("Failed %s of %s\n", type, file);
>
> Yeah, the above needs to be moved to the upper layers. It even has a
> comment about "the filter has the error". That's reference to the
> filter file of trace events, which is the only file that really does
> that.
>
> -- Steve
>

These new instance APIs are going to be part of the new libtracefs,
I'll remove this patch
from the series, when the libtracefs code is merged.

> > +             close(fd);
> > +     }
> > +     return ret;
> > +}
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
