Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803B0C33CA2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F56421744
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcJSzRUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgAIN3T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 08:29:19 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52210 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731119AbgAIN3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:29:19 -0500
Received: by mail-pj1-f67.google.com with SMTP id j11so1163386pjs.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 05:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RujaieO/eqbOGROysmSvRznbkXcTu1tpE9UuPN9z10M=;
        b=jcJSzRUSs8q8Wn0Po313b+hVz1mMcRNSNF+7b3/3XvO8Y9S9NHqjPaJfm5f+QeHhoR
         khU2WHZplALgXGQ3iWxg83a5R5bwmmf5p3oxnQMjFMFB5oz73P/Dgwgfrg/AW9gEjkui
         pPPgt9+pdBG4mcFiEgHUrcVPdGj19XvVniX7psAwvWbj/5z3f4KpQ6XJQTH3sDttk7BV
         iCb/iufuOB3N68yHax3Rbv571vCtyhH0aLVfw3dW7WnnULgPUDdDkzbEGuWp5SYf2EVK
         3jc4QcUjFBz4CNwbDtnYzn+LSDo006m1+NEE/aC6G6xAngPuBzCnzC9GWhSok0TjAHKM
         NPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RujaieO/eqbOGROysmSvRznbkXcTu1tpE9UuPN9z10M=;
        b=hqidTwbS26gu5wEC9IZ+Q6FFlO4bhHMq8NwY6NIEaSUxWNxuO31J71wCRCrWC/6eBo
         DPzrSOPc5IQ4ArorbjMiZacqUFAUGFLJ0Jczcl0GrVP5Uw1hWVnzeNRO1irTpIluSfMQ
         qmN8MEdw1lQBLt0t3qGaZIHZSgwrAZ5K2Gx7CM2axMthdPS9M9tBe1zhWizUENOSOmVe
         UT2MYSVQoUmaaJ094E9zdAhLLK19IH9+2G9ypYaf8acsN6r88fNqArKe6Ndrp3R16nbw
         2iaC0WXANdrTPsR7/7YKoDqK2bU0ciVugIzddS/05KqnrL3eSmeUwdO4eeZxMYj/DSQF
         OutQ==
X-Gm-Message-State: APjAAAVGcfbHPN8Pr4oKRnZ1zt+7La+D3ldfZQ7xftAp+1GGEy5leOmN
        ave+qdrwvYj4cLAaffk2PwRRxTtJdCXxnVsWtRN76Tqs
X-Google-Smtp-Source: APXvYqwBteEYqdBLVY3Zj+LJSV+Lhdv8oX+aklvXeUP7omYlaWWRWoSUe4XdPlI6WTosHECwBgY7HD/tV4qjLb+l33o=
X-Received: by 2002:a17:90a:a88f:: with SMTP id h15mr5422323pjq.32.1578576557264;
 Thu, 09 Jan 2020 05:29:17 -0800 (PST)
MIME-Version: 1.0
References: <20200106154058.60660-1-tz.stoyanov@gmail.com> <20200106154058.60660-4-tz.stoyanov@gmail.com>
 <20200108143706.20170bb2@gandalf.local.home>
In-Reply-To: <20200108143706.20170bb2@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 9 Jan 2020 15:29:05 +0200
Message-ID: <CAPpZLN7GE69HGxEmVVMargicfoed3V9emxH5X+g6BGF=fO9HQw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] trace-cmd: New libtracefs APIs for ftrace instances
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 8, 2020 at 9:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  6 Jan 2020 17:40:56 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The functionality related to ftrace instances is moved from
> > trace-cmd application to libtracefs. The following new
> > library APIs are introduced:
> >     struct tracefs_instance;
> >     struct tracefs_instance *tracefs_alloc_instance(const char *name);
> >     int tracefs_free_instance(struct tracefs_instance *instance);
> >     int tracefs_make_instance(struct tracefs_instance *instance);
> >     int tracefs_remove_instance(struct tracefs_instance *instance);
>
> I'm thinking that "make" should be "create" and "remove" should be
> "destroy". The "make" and "remove" does match "mkdir" and "rmdir" but
> that's just the behind-the-scenes of what the OS does. But from an
> application point of view, "create" and "destroy" seem more
> appropriate.
>
> What do you think?
>
>
> >     char *tracefs_get_instance_name(struct tracefs_instance *instance);
> >     char *tracefs_get_instance_file(struct tracefs_instance *instance, const char *file);
> >     char *tracefs_get_instance_dir(struct tracefs_instance *instance);
> >     int tracefs_write_instance_file(struct tracefs_instance *instance,
> >                                const char *file, const char *str, const char *type);
> >     char *tracefs_read_instance_file(struct tracefs_instance *instance, char *file, int *psize);
>
> Also, another naming convention used commonly, is when you have a set
> of functions working on the same thing, is to use the name of what it
> is working on first. That is, instead of the above, we should have:
>
>  tracefs_instance_alloc()
>  tracefs_instance_free()
>  tracefs_instance_create() (instead of "make")
>  tracefs_instance_destroy() (instead of "remove")
>  tracefs_instance_get_name()
>  tracefs_instance_get_file()
>  tracefs_instance_file_read()
>  tracefs_instance_file_write()
>
> That way it is easier to find these functions with just searching for
> "tracefs_instance"
>
> The "get_*" is ok to keep, but as I showed above, I think "_file_read"
> and "_file_write" is a better name.
>
> [ more below ]
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/tracefs/tracefs.h           |  17 ++
> >  lib/tracefs/Makefile                |   1 +
> >  lib/tracefs/include/tracefs-local.h |   1 +
> >  lib/tracefs/tracefs-instance.c      | 267 ++++++++++++++++++++++++++++
> >  lib/tracefs/tracefs-utils.c         |  43 +++++
> >  tracecmd/include/trace-local.h      |   5 +-
> >  tracecmd/trace-list.c               |   2 +-
> >  tracecmd/trace-record.c             | 264 +++++++++------------------
> >  tracecmd/trace-show.c               |   2 +
> >  tracecmd/trace-stat.c               |  21 ++-
> >  10 files changed, 431 insertions(+), 192 deletions(-)
> >  create mode 100644 lib/tracefs/tracefs-instance.c
> >
> > diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> > index e844c75..6b27ff7 100644
> > --- a/include/tracefs/tracefs.h
> > +++ b/include/tracefs/tracefs.h
> > @@ -17,4 +17,21 @@ const char *tracefs_get_tracing_dir(void);
> >  /* tracefs_find_tracing_dir must be freed */
> >  char *tracefs_find_tracing_dir(void);
> >
> > +/* ftarce instances */
> > +struct tracefs_instance;
> > +
> > +struct tracefs_instance *tracefs_alloc_instance(const char *name);
> > +int tracefs_free_instance(struct tracefs_instance *instance);
> > +int tracefs_make_instance(struct tracefs_instance *instance);
> > +int tracefs_remove_instance(struct tracefs_instance *instance);
> > +char *tracefs_get_instance_name(struct tracefs_instance *instance);
> > +char *
> > +tracefs_get_instance_file(struct tracefs_instance *instance, const char *file);
> > +char *tracefs_get_instance_dir(struct tracefs_instance *instance);
> > +int tracefs_write_instance_file(struct tracefs_instance *instance,
> > +                             const char *file, const char *str,
> > +                             const char *type);
> > +char *tracefs_read_instance_file(struct tracefs_instance *instance,
> > +                              char *file, int *psize);
> > +
> >  #endif /* _TRACE_FS_H */
> > diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
> > index 86d7845..4030272 100644
> > --- a/lib/tracefs/Makefile
> > +++ b/lib/tracefs/Makefile
> > @@ -8,6 +8,7 @@ DEFAULT_TARGET = $(bdir)/libtracefs.a
> >
> >  OBJS =
> >  OBJS += tracefs-utils.o
> > +OBJS += tracefs-instance.o
> >
> >  OBJS := $(OBJS:%.o=$(bdir)/%.o)
> >  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
> > diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
> > index 231edd1..fe327a0 100644
> > --- a/lib/tracefs/include/tracefs-local.h
> > +++ b/lib/tracefs/include/tracefs-local.h
> > @@ -8,5 +8,6 @@
> >
> >  /* Can be overridden */
> >  void warning(const char *fmt, ...);
> > +int str_read_file(const char *file, char **buffer);
> >
> >  #endif /* _TRACE_FS_LOCAL_H */
> > diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
> > new file mode 100644
> > index 0000000..14e8eed
> > --- /dev/null
> > +++ b/lib/tracefs/tracefs-instance.c
> > @@ -0,0 +1,267 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +/*
> > + * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * Updates:
> > + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> > + *
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <errno.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +
> > +#include "tracefs.h"
> > +#include "tracefs-local.h"
> > +
> > +struct tracefs_instance {
> > +     char *name;
> > +};
> > +
> > +/**
> > + * tracefs_alloc_instance - allocate a new ftrace instance
> > + * @name: The name of the instance (instance will point to this)
> > + *
> > + * Returns a newly allocated instance, or NULL in case of an error.
> > + */
> > +struct tracefs_instance *tracefs_alloc_instance(const char *name)
> > +{
> > +     struct tracefs_instance *instance;
> > +
> > +     instance = calloc(1, sizeof(*instance));
> > +     if (!instance)
> > +             return NULL;
> > +     if (name)
> > +             instance->name = strdup(name);
>
> We can remove make this a little simpler (and with the name check):
>
>         instance = calloc(1, sizeof(*instance));
>         if (instance && name) {
>                 instance->name = strdup(name);
>                 if (!instance->name) {
>                         free(instance);
>                         instance = NULL;
>                 }
>         }
>
>         return instance;
>
> > +
> > +     return instance;
> > +}
> > +
> > +/**
> > + * tracefs_free_instance - Free an instance, previously allocated by
> > +                        tracefs_alloc_instance()
> > + * @instance: Pointer to the instance to be freed
> > + *
> > + * Returns -1 in case of an error, or 0 otherwise.
>
> I don't think the free should return a value. Make it void.
>
> > + */
> > +int tracefs_free_instance(struct tracefs_instance *instance)
> > +{
> > +     if (!instance)
> > +             return -1;
> > +
> > +     free(instance->name);
> > +     free(instance);
> > +     return 0;
> > +}
> > +
> > +/**
> > + * tracefs_make_instance - Create a new ftrace instance
> > + * @instance: Pointer to the instance to be created
> > + *
> > + * Returns 1 if the instance already exist, 0 if the instance
> > + * is created successful or -1 in case of an error
> > + */
> > +int tracefs_make_instance(struct tracefs_instance *instance)
> > +{
> > +     struct stat st;
> > +     char *path;
> > +     int ret;
> > +
> > +     path = tracefs_get_instance_dir(instance);
> > +     ret = stat(path, &st);
> > +     if (ret < 0) {
> > +             ret = mkdir(path, 0777);
> > +             if (ret < 0)
> > +                     return ret;
>
> Remove the check of ret here, as the return skips the freeing of path.
>
> Should be just:
>
>         if (ret < 0)
>                 ret = mkdir(path, 0777);
>         else
>                 ret = 1;
>
> > +
> > +     } else
> > +             ret = 1;
> > +     tracefs_put_tracing_file(path);
> > +     return ret;
> > +}
> > +
> > +/**
> > + * tracefs_remove_instance - Remove a ftrace instance
> > + * @instance: Pointer to the instance to be removed
> > + *
> > + * Returns -1 in case of an error, or 0 otherwise.
> > + */
> > +int tracefs_remove_instance(struct tracefs_instance *instance)
> > +{
> > +     char *path;
> > +     int ret;
> > +
> > +     if (!instance || !instance->name) {
> > +             warning("Cannot remove top instance");
> > +             return -1;
> > +     }
> > +
> > +     path = tracefs_get_instance_dir(instance);
>
> path could be NULL here due to failed allocation. Need to check that
> and return an error.
>
> > +     ret = rmdir(path);
> > +     tracefs_put_tracing_file(path);
> > +
> > +     return ret;
> > +}
> > +
> > +/**
> > + * tracefs_get_instance_file - return the path to an instance file.
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + * @file: name of file to return
> > + *
> > + * Returns the path of the @file for the given @instance, or NULL in
> > + * case of an error.
> > + *
> > + * Must use tracefs_put_tracing_file() to free the returned string.
> > + */
> > +char *
> > +tracefs_get_instance_file(struct tracefs_instance *instance, const char *file)
> > +{
> > +     char *path;
> > +     char *buf;
> > +     int ret;
> > +
> > +     if (instance && instance->name) {
> > +             ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
> > +             if (ret < 0) {
> > +                     warning("Failed to allocate name for %s/%s",
> > +                              instance->name, file);
>
> For this being in a library, we should probably remove warnings.
>
> > +                     return NULL;
> > +             }
> > +             path = tracefs_get_tracing_file(buf);
> > +             free(buf);
> > +     } else
> > +             path = tracefs_get_tracing_file(file);
> > +
> > +     return path;
> > +}
> > +
> > +/**
> > + * tracefs_get_instance_dir - return the path to the instance directory.
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + *
> > + * Returns the full path to the instance directory
> > + *
> > + * Must use tracefs_put_tracing_file() to free the returned string.
> > + */
> > +char *tracefs_get_instance_dir(struct tracefs_instance *instance)
> > +{
> > +     char *buf;
> > +     char *path;
> > +     int ret;
> > +
> > +     if (instance && instance->name) {
> > +             ret = asprintf(&buf, "instances/%s", instance->name);
> > +             if (ret < 0) {
> > +                     warning("Failed to allocate path for instance %s",
> > +                              instance->name);
> > +                     return NULL;
> > +             }
> > +             path = tracefs_get_tracing_file(buf);
> > +             free(buf);
> > +     } else
> > +             path = tracefs_find_tracing_dir();
> > +
> > +     return path;
> > +}
> > +
> > +/**
> > + * tracefs_get_instance_name - return the name of an instance
> > + * @instance: ftrace instance
> > + *
> > + * Returns the name of the given @instance.
> > + * The returned string must *not* be freed.
> > + */
> > +char *tracefs_get_instance_name(struct tracefs_instance *instance)
> > +{
> > +     if (instance)
> > +             return instance->name;
> > +     return NULL;
> > +}
> > +
> > +static int write_file(const char *file, const char *str, const char *type)
> > +{
> > +     char buf[BUFSIZ];
> > +     int ret;
> > +     int fd;
> > +
> > +     fd = open(file, O_WRONLY | O_TRUNC);
> > +     if (fd < 0) {
> > +             warning("Failed to open '%s'", file);
> > +             return -1;
> > +     }
> > +     ret = write(fd, str, strlen(str));
> > +     close(fd);
> > +     if (ret < 0 && type) {
> > +             /* write failed */
> > +             fd = open(file, O_RDONLY);
> > +             if (fd < 0) {
> > +                     warning("Failed to write in '%s'", file);
> > +                     return -1;
> > +             }
> > +
> > +             while ((ret = read(fd, buf, BUFSIZ)) > 0)
> > +                     fprintf(stderr, "%.*s", ret, buf);
> > +             warning("Failed %s of %s\n", type, file);
>
> The library function should not bother reading the file on error. This
> is only applicable for some (one or two) files in the instance
> directory. Thus remove this code.
>
> > +             close(fd);
> > +     }
> > +     return ret;
> > +}
> > +
> > +
> > +/**
> > + * tracefs_write_instance_file - Write in trace file of specific instance.
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + * @file: name of the file
> > + * @str: nul terminated string, that will be written in the file.
> > + * @type: nul terminated string, describing the current write operation.
> > + *     Used for logging purposes.
> > + *
> > + * Returns the number of written bytes, or -1 in case of an error
> > + */
> > +int tracefs_write_instance_file(struct tracefs_instance *instance,
> > +                              const char *file, const char *str,
> > +                              const char *type)
>
> Let's get rid of the "type", it's confusing for a library function. If
> the output should be read, that should be for a different operation.
>
>
> > +{
> > +     struct stat st;
> > +     char *path;
> > +     int ret;
> > +
> > +     path = tracefs_get_instance_file(instance, file);
>
> Need to check for path == NULL.
>
> > +     ret = stat(path, &st);
> > +     if (ret == 0)
> > +             ret = write_file(path, str, type);
> > +     tracefs_put_tracing_file(path);
> > +
> > +     return ret;
> > +}
> > +
> > +/**
> > + * tracefs_read_instance_file - Read from a trace file of specific instance.
> > + * @instance: ftrace instance, can be NULL for the top instance
> > + * @file: name of the file
> > + * @psize: returns the number of bytes read
> > + *
> > + * Returns a pointer to a nul terminated string, read from the file, or NULL in
> > + * case of an error.
> > + * The return string must be freed by free()
> > + */
> > +char *tracefs_read_instance_file(struct tracefs_instance *instance,
> > +                               char *file, int *psize)
> > +{
> > +     char *buf = NULL;
> > +     int size = 0;
> > +     char *path;
> > +
> > +     path = tracefs_get_instance_file(instance, file);
>
> Need to check for path == NULL.
>
> > +
> > +     size = str_read_file(path, &buf);
> > +
> > +     tracefs_put_tracing_file(path);
> > +     if (buf && psize)
> > +             *psize = size;
> > +
> > +     return buf;
> > +}
> > diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
> > index 0ef16fc..bdab130 100644
> > --- a/lib/tracefs/tracefs-utils.c
> > +++ b/lib/tracefs/tracefs-utils.c
> > @@ -10,6 +10,9 @@
> >  #include <sys/mount.h>
> >  #include <sys/stat.h>
> >  #include <linux/limits.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> >
> >  #include "tracefs.h"
> >
> > @@ -181,3 +184,43 @@ void tracefs_put_tracing_file(char *name)
> >  {
> >       free(name);
> >  }
> > +
> > +int str_read_file(const char *file, char **buffer)
> > +{
> > +     char stbuf[BUFSIZ];
> > +     char *buf = NULL;
> > +     int size = 0;
> > +     char *nbuf;
> > +     int fd;
> > +     int r;
> > +
> > +     fd = open(file, O_RDONLY);
> > +     if (fd < 0) {
> > +             warning("File %s not found", file);
> > +             return -1;
> > +     }
> > +
> > +     do {
> > +             r = read(fd, stbuf, BUFSIZ);
> > +             if (r <= 0)
> > +                     continue;
> > +             nbuf = realloc(buf, size+r+1);
> > +             if (!nbuf) {
> > +                     warning("Failed to allocate file buffer");
>
> Again, we should remove warnings from the library function. But this
> can be done later. I just wanted to document that we need to do that.
>
> > +                     size = -1;
> > +                     break;
> > +             }
> > +             buf = nbuf;
> > +             memcpy(buf+size, stbuf, r);
> > +             size += r;
> > +     } while (r);
>
> Hmm, this probably should be:
>
>         } while (r > 0);
>
> (I know this was broken before this patch)
>
> > +
> > +     close(fd);
> > +     if (size > 0) {
>
> Hmm, if r is less than zero here, we have a bug. Perhaps this needs to
> be:
>
>         if (r == 0 && size > 0) {
>
> > +             buf[size] = '\0';
> > +             *buffer = buf;
> > +     } else
> > +             free(buf);
> > +
> > +     return size;
> > +}
>
>
Thanks Steve! It makes sense, will include these changes in the next version.


> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
