Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FD5C47404
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 08:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5833E21A4C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 08:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZbWGadP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfJDIc0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 04:32:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33444 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfJDIcZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 04:32:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so3486585pfl.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 01:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTv8zkN9eWhPge9GZmbHCcRezJCsptlGyJvRzCvRcIw=;
        b=ZbWGadP00R1iT19n3XybIYPS/grNZKDeMTWHTaEIO//OMZBxbiqMf06aiFhvJ+0e30
         fTnc/nx9/0zKugvsaG6PsgtKzKrC49jKa3SsmqLC1lNkKzpLTx9R09g+/81h8J/WLNXP
         6Vgb9mFZT03r5xi5nHjHRvEnyef9Ic32UYBA1HTALVtXdl52/vfwe/iN7AW4le+lnXJ1
         e3AtVcwhMOrLTzZ+15NpZvl5fZ5rqkGPtQqVHzE8BV4WdisAKfzYiKwMx5uq/e1loyYS
         JSIWBADANRRPUr/jsG1V7QjYcz8hX7YRXnzQ7S8cFx3OQbYIQp6GtbN1MGrCiwPC0Zff
         TxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTv8zkN9eWhPge9GZmbHCcRezJCsptlGyJvRzCvRcIw=;
        b=PXkqh0619VnI5hPlh9C5OYKce4wBOflBOn0AkUxW1UPxTdXduCkQC4BmgutfsZv3BC
         9kS1AombN6WT08KwhJxdMUN4/m3E5iaGafAblCDjlc25vPEYEr2UvMCz9o3XdEzNljAV
         MA6ySBj+nJxuAKlZrMPrebBZcA85rLjOPOBJ2gMByBTtb/5Rdb+shEja+nqZs38Pf5kx
         l/5xGahkIrwxQoNXn+Y+5l2uply7aWoPkEeLlqXkORnxhy2ocEc4vp6Y1MyLL7B7JvS6
         T8+WhyZKG76FezKknUdJ+RB3uDZNHVjgBme8upN+w9Gme+FV8oiUbKqZWCFX3TifV8/r
         mXSQ==
X-Gm-Message-State: APjAAAU3ioNAz4fqA/andwo95CCELnf2YNFFKlDaPRh1itVJUsFpHhDP
        wHLPBcAU/wpEhqbBLY5kw/bJStLU1u8Pllw9QzaVmb08
X-Google-Smtp-Source: APXvYqyH5ajAi1jPUxVDRrvCymstKd/46LRfCe2HC6ykr9WOc2DwgLxyO8PJ08J3sk18wZMrksm0QgN1EDOyxuQRiHY=
X-Received: by 2002:a17:90a:3524:: with SMTP id q33mr15078878pjb.37.1570177943382;
 Fri, 04 Oct 2019 01:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191002114152.30048-1-tz.stoyanov@gmail.com> <20191002114152.30048-4-tz.stoyanov@gmail.com>
 <20191002194917.7563c386@gandalf.local.home>
In-Reply-To: <20191002194917.7563c386@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 4 Oct 2019 11:32:11 +0300
Message-ID: <CAPpZLN5ay9Jc48gy2T=0=OQ+8cQS7Z4aw4pr-mEGCBL6_-YQxw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Oct 3, 2019 at 2:49 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed,  2 Oct 2019 14:41:50 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > When a development version of trace-cmd is built and run on the machine,
> > by default it loads only installed plugins, from system drierctories.
> > Thus, the development plugins will not be loaded. To simplify the development
> > process, a new logic is added:
> >   At plugins load time, check the location of trace-cmd application and look
> >   for "plugins" directory around it. If found, load plugins from it. Those
> >   pluigins will be loaded last, so in case of duplication the "development"
> >   plugins win.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/traceevent/event-plugin.c | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
> > index bc10205..4fc4ee3 100644
> > --- a/lib/traceevent/event-plugin.c
> > +++ b/lib/traceevent/event-plugin.c
> > @@ -14,6 +14,7 @@
> >  #include <unistd.h>
> >  #include <dirent.h>
> >  #include <errno.h>
> > +#include <libgen.h>
> >  #include "event-parse.h"
> >  #include "event-parse-local.h"
> >  #include "event-utils.h"
> > @@ -538,6 +539,27 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
> >       closedir(dir);
> >  }
> >
> > +static char *get_source_plugins_dir(void)
> > +{
> > +     char *p, path[PATH_MAX+1];
> > +     int ret;
> > +
> > +     ret = readlink("/proc/self/exe", path, PATH_MAX);
> > +     if (ret > PATH_MAX || ret < 0)
> > +             return NULL;
> > +
> > +     dirname(path);
> > +     p = strrchr(path, '/');
> > +     if (!p)
> > +             return NULL;
> > +     /* Check if we are in the the source tree */
> > +     if (strcmp(p, "/tracecmd") != 0)
>
> Hmm, this is in the lib/libtraceevent directory. We shouldn't be
> referencing trace-cmd code here. We should have a way to override the
> plugins from the trace-cmd side, perhaps after tep_load_plugins_hook()
> gets called?
>

I agree, we should move this check outside of the library.
I'll expose the functionality of load_plugins_dir() as a library API.
Thanks !

> -- Steve
>
>
> > +             return NULL;
> > +
> > +     strcpy(p, "/lib/traceevent/plugins");
> > +     return strdup(path);
> > +}
> > +
> >  void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
> >                          void (*load_plugin)(struct tep_handle *tep,
> >                                              const char *path,
> > @@ -588,6 +610,12 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
> >       load_plugins_dir(tep, suffix, path, load_plugin, data);
> >
> >       free(path);
> > +
> > +     path = get_source_plugins_dir();
> > +     if (path) {
> > +             load_plugins_dir(tep, suffix, path, load_plugin, data);
> > +             free(path);
> > +     }
> >  }
> >
> >  struct tep_plugin_list*
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
