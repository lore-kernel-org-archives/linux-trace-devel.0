Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA0DC433E1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0E612070E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNlRX6/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgGQO3z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgGQO3z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 10:29:55 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3756AC0619D2
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 07:29:55 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so5507484plm.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 07:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPBoF1F3Jq92RVfdjDCjb10HV1yNZIUaG4lGppGW6oQ=;
        b=GNlRX6/eR2Tnmh0jomkuAuRJ7ybi0YNqZGsXff4Duo/PveX40X89aAb+85G+puW3O8
         akhjLrYGwShlsfkVQVaM/WCvLXs34IJDfZS5jJVEgIoAoRquG/rL5mQUhchUtgGkEDjV
         hm9SvyDQq/e29GyXUgDcEh9sRUPAU6hspvjk9k4XpS3sfE5Szu0O7qCuAHHA9xIDA6d9
         +8SyHxxyaiKoJgnyuDk8Otl057hhECodVAsZkPcFCTYrVfM4kI8tMqutyWSRVXTAEJdD
         7mmvmCilTgVFw+pdwRHZoq+e5IqgBB5mnoo3lg+gtXmEvNy5xhaObYsfAeip8O0xKX+1
         I3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPBoF1F3Jq92RVfdjDCjb10HV1yNZIUaG4lGppGW6oQ=;
        b=P1Y2fcJ4kPA7qbXo3H/+O5i+PrA/S9P4OetK9IdFagDtTeT7puWHxqL+B7Q9AILnig
         LrxhlEztXe3se4ivZAlFQbZMCEWvVeDZ878Z/pPAyofxdVllDrWJ6EYuSCluEAHB+mgB
         XF0jcPsOHpbBCxtJrtBT99WElPxAl9tTzd+vxTYEz3h8diQ1IfGfcrcoW8gh4bvWfEPy
         oaQ5YZZpzWFKjeJcZpBWRZ00lQ3tv3T9LWL5WIxqNTaZa80FquhKDUdDstKq/cT1lq0g
         WEnyrIGxoIp6vLSGcH9m2b/KcouTPYFyfUc4E5g+7P+LaVp8Oi8a2EemkfShlMZG41Gp
         NsKQ==
X-Gm-Message-State: AOAM530oqm/t7KRI3++AVcfxpzKOvmyQo5KUyERDvqi7noWElkA7uzcH
        PyF131eppCWlis5Q8JVTPKmYIjEp4DarZosOgEI=
X-Google-Smtp-Source: ABdhPJxhYPXfmcuW0ddeEOJPdkksUOHJnS5UpqSI/KPaJ1ngSEv8HNHaDshI+LwSHJef+IKZxipgySk5zxFevUbKsC4=
X-Received: by 2002:a17:90b:8d0:: with SMTP id ds16mr10754277pjb.2.1594996194563;
 Fri, 17 Jul 2020 07:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200717080326.82151-1-tz.stoyanov@gmail.com> <20200717080326.82151-3-tz.stoyanov@gmail.com>
 <20200717100605.3540f840@oasis.local.home>
In-Reply-To: <20200717100605.3540f840@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 17 Jul 2020 17:29:43 +0300
Message-ID: <CAPpZLN4kT=CiADCY7y5BbXp3o1yrDEC291Did3TGArOqqxM68w@mail.gmail.com>
Subject: Re: [PATCH 2/2] trace-cmd: Enhance "trace-cmd clear" to be instance aware
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 17, 2020 at 5:06 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 17 Jul 2020 11:03:26 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> > --- /dev/null
> > +++ b/tracecmd/trace-clear.c
> > @@ -0,0 +1,124 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +/*
> > + * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * Updates:
> > + * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> > + *
> > + */
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <getopt.h>
> > +
> > +#include "tracefs.h"
> > +#include "trace-local.h"
> > +
> > +struct instances_list {
> > +     struct instances_list *next;
> > +     struct tracefs_instance *instance;
> > +};
> > +
> > +static int add_new_instance(struct instances_list **list, char *name)
> > +{
> > +     struct instances_list *new;
> > +
> > +     new = calloc(1, sizeof(*new));
> > +     if (!new)
> > +             return -1;
> > +     new->instance = tracefs_instance_alloc(name);
> > +     if (!new->instance) {
> > +             free(new);
> > +             return -1;
> > +     }
> > +
> > +     new->next = *list;
> > +     *list = new;
> > +     return 0;
> > +}
> > +
> > +static int add_instance_walk(const char *name, void *data)
> > +{
> > +     return add_new_instance((struct instances_list **)data, (char *)name);
> > +}
> > +
> > +static void clear_list(struct instances_list *list)
> > +{
> > +     struct instances_list *del;
> > +
> > +     while (list) {
> > +             del = list;
> > +             list = list->next;
> > +             tracefs_instance_free(del->instance);
> > +             free(del);
> > +     }
> > +}
>
> BTW, why create this list? (see below).
>
> > +
> > +static void clear_instance_trace(struct tracefs_instance *instance)
> > +{
> > +     FILE *fp;
> > +     char *path;
> > +
> > +     /* reset the trace */
> > +     path = tracefs_instance_get_file(instance, "trace");
> > +     fp = fopen(path, "w");
> > +     if (!fp)
> > +             die("writing to '%s'", path);
> > +     tracefs_put_tracing_file(path);
> > +     fwrite("0", 1, 1, fp);
> > +     fclose(fp);
> > +}
> > +
> > +static void clear_trace(struct instances_list *instances)
> > +{
> > +     if (instances) {
> > +             while (instances) {
> > +                     clear_instance_trace(instances->instance);
> > +                     instances = instances->next;
> > +             }
> > +     } else
> > +             clear_instance_trace(NULL);
> > +}
> > +
> > +void trace_clear(int argc, char **argv)
> > +{
> > +     struct instances_list *instances = NULL;
> > +     bool all = false;
> > +     int c;
> > +
> > +     for (;;) {
> > +             int option_index = 0;
> > +             static struct option long_options[] = {
> > +                     {"all", no_argument, NULL, 'a'},
> > +                     {"help", no_argument, NULL, '?'},
> > +                     {NULL, 0, NULL, 0}
> > +             };
> > +
> > +             c = getopt_long (argc-1, argv+1, "+haB:",
> > +                              long_options, &option_index);
> > +             if (c == -1)
> > +                     break;
> > +             switch (c) {
> > +             case 'B':
> > +                     if (add_new_instance(&instances, optarg))
> > +                             die("Failed to allocate instance %s", optarg);
> > +                     break;
> > +             case 'a':
> > +                     all = true;
>
> All you need to do is set the flag, and don't create the list here.
>
> > +                     if (tracefs_instances_walk(add_instance_walk, &instances))
> > +                             die("Failed to add all instances");
> > +                     break;
> > +             case 'h':
> > +             case '?':
> > +             default:
> > +                     usage(argv);
> > +                     break;
> > +             }
> > +     }
> > +
> > +     clear_trace(instances);
> > +     if (all)
>
> Then here, you would just do:
>
>                 tracefs_instances_iterate(clear_instance_iter, NULL);
>
> Where we have:
>
> static int clear_instance_iter(const char *name, void *data)
> {
>         tracefs_clear(name);
> }
>
> No need for the creating of the list.

There are  two reasons for creating the list:
 - For consistency with the other flow, the"-B" option.
 - The tracefs APIs require "struct tracefs_instance" as input
parameter to identify the instance, do not work with instance name
The list is not needed for "--all", but still needs to create "struct
tracefs_instance" and to pass it to tracefs_instance_get_file() API


>
> -- Steve
>
>
> > +             clear_trace(NULL);
> > +     clear_list(instances);
> > +     exit(0);
> > +}
> > +
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index bd004574..5009eaa1 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -835,21 +835,6 @@ static void clear_trace_instances(void)
> >               __clear_trace(instance);
> >  }
> >
> > -static void clear_trace(void)
> > -{
> > -     FILE *fp;
> > -     char *path;
> > -
> > -     /* reset the trace */
> > -     path = tracefs_get_tracing_file("trace");
> > -     fp = fopen(path, "w");
> > -     if (!fp)
> > -             die("writing to '%s'", path);
> > -     tracefs_put_tracing_file(path);
> > -     fwrite("0", 1, 1, fp);
> > -     fclose(fp);
> > -}
> > -
> >  static void reset_max_latency(struct buffer_instance *instance)
> >  {
> >       tracefs_instance_file_write(instance->tracefs,
> > @@ -6704,15 +6689,6 @@ void trace_profile(int argc, char **argv)
> >       exit(0);
> >  }
> >
> > -void trace_clear(int argc, char **argv)
> > -{
> > -     if (argc > 2)
> > -             usage(argv);
> > -     else
> > -             clear_trace();
> > -     exit(0);
> > -}
> > -
> >  void trace_record(int argc, char **argv)
> >  {
> >       struct common_record_context ctx;
> > diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> > index 3f0b2d07..79610bd3 100644
> > --- a/tracecmd/trace-usage.c
> > +++ b/tracecmd/trace-usage.c
> > @@ -180,7 +180,9 @@ static struct usage_help usage_help[] = {
> >       {
> >               "clear",
> >               "clear the trace buffers",
> > -             " %s clear\n"
> > +             " %s clear [-B buf][-a]\n"
> > +             "          -B clear the given buffer (may specify multiple -B)\n"
> > +             "          -a clear all existing buffers, including the top level one\n"
> >       },
> >       {
> >               "report",
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
