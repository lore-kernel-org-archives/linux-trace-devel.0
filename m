Return-Path: <SRS0=a/08=Z3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A67C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 14:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC37B21835
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 14:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p9YWSpkW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLEOkx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:40:53 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38784 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfLEOkx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 09:40:53 -0500
Received: by mail-pj1-f66.google.com with SMTP id l4so1383629pjt.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Dec 2019 06:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JgPIifJoBXycjpBHF1cE0pGqMyVaSfFHR36U0SWWDy0=;
        b=p9YWSpkWtXtVrAfUAmEV7e0GzNKoCpDHTi/X+mHBs3B2m4oPT4APMkUiF/iDiNcUuo
         Cj0unwd6vz6HtcCJNgcQCsg/DoHSYlo/rB4Zn/j1bBjLf+BRalf0onidnVW1sTqZ+ThT
         lsbH67paCZidoL1IUEeEBPVf4NumvtuHpkNV5pDnHCz9Gn31nPaPAQ/u10zP2i3O/Ye1
         wMgMIk75r2ATcuoNxR4JkTCE5T1rMIkjXvj32nfF15OGf+ImAYSwGLUnAJuUqGuNclDD
         qBEgshL7LnD1d2CETybp9ic71b+md6O6P1LGUShVS0XEHvHVDe/yh0IgnQ0/hRXzhlTI
         aluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JgPIifJoBXycjpBHF1cE0pGqMyVaSfFHR36U0SWWDy0=;
        b=b2m7ruf3RMknMk6zypB+lkPbXLy00Ld9L0wePCCwMz6RiWEfEicws1SP1S9cn2ckRg
         /zD7w43YvtJbUjWV/Qvk73YL2SdCJ+uahGgYOmoLVRVMGfW7IRh15itZnqodphKwK7qg
         AR3nR23L10tH01mBE0R2yzUAdjXW3FHlaUKos5Xs8R6qMX/xKCGK1rghQSY6BM9vkhwd
         MMvNvmKSoRE2J3rFJyuggmpOA0HLkcGvwdMxuTp91WnZor6NxAcEf5I2ERRuts0CzFGz
         rz1Kdfn0GFrw5S9nKuEHvD9eIZ8rzqxEmgpTl5bYVuKnRMQZfbx4i3uYHzPsqQuEksIZ
         RyuQ==
X-Gm-Message-State: APjAAAXuaAOYQhw9rk5d/l1V0cALfEoUamL0QBXooE/boeI0iyLvF57u
        vmp5A7n2Vul44hfoZFwnSwEZxjngjPsaBYCdUjIWsqBwWbo=
X-Google-Smtp-Source: APXvYqz1f+F4lmkEjcGadD39r4d+v4NLjMYRYqB3BcrqIWoiUPpiYPa8Kp2/Ja1H+u/fqIRCTc/6wk7DZwQeCJla+yg=
X-Received: by 2002:a17:90a:19dd:: with SMTP id 29mr9917770pjj.32.1575556852489;
 Thu, 05 Dec 2019 06:40:52 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-5-tz.stoyanov@gmail.com> <20191204111731.7409abdc@gandalf.local.home>
In-Reply-To: <20191204111731.7409abdc@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 5 Dec 2019 16:40:41 +0200
Message-ID: <CAPpZLN55PuXtN5-9SzPnDaitHVmEUjRyGndbab21LX9DrbeRFQ@mail.gmail.com>
Subject: Re: [PATCH v17 04/18] trace-cmd: Add new library APIs for ftrace instances.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 4, 2019 at 6:17 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> > +     do {
> > +             r = read(fd, buffer, BUFSIZ);
> > +             if (r <= 0)
> > +                     continue;
> > +             if (size)
> > +                     buf = realloc(buf, size+r+1);
> > +             else
> > +                     buf = malloc(r+1);
>
> I know this is only cut and pasted from what the original was, but we
> should probably (either in this patch, or perhaps a separate one) fix
> the above. As realloc(NULL, x) is equivalent to malloc(x), we can just
> have:
>
>                 buf = realloc(buf, size+r+1);
>
>
> > +             if (!buf)
> > +                     die("Failed to allocate instance file buffer");
>
> As this is becoming a library function, we should remove "die()", as
> that is only allowed in the application. Not library calls.
>
> That would also mean we need to clean up anything we allocated on
> failure, and that the realloc would need to be:
>
>                 new_buf = realloc(buf, size + r + 1);
>
>                 if (!new_buf) {
>                         free(buf);
>                         return NULL;
>
> All the functions that are being moved into the library needs to have
> their die() calls removed. This is OK to do in a separate patch.
>
> Preferably right after this patch (so reviewers know it's happening).
>
I fixed most of the comments, except those die() call. There are a lot
of things that
should be fixed in the existing libtracecmd code, in order to become a
real library.
Also, I started to work on a new library providing APIs for
interaction with files
from tracefs, libtraceftrace (this is only a work name, we should
think about more suitable one).
I would suggest changes from this patch set to be considered only as
part of the time stamp sync
feature. There will be at least two library patch sets - for cleaning
up the existing libtracecmd code and
for the new ftrace library.

>
> > +             memcpy(buf+size, buffer, r);
> > +             size += r;
> > +     } while (r);
> > +
> > +     buf[size] = '\0';
> > +     if (psize)
> > +             *psize = size;
> > +     return buf;
> > +}
> > +
> > +/**
> > + * tracecmd_set_clock - Set the clock of ftrace event's timestamps, per instance.
> > + * @instance: Pointer to ftrace instance, containing the desired clock.
> > + * @old_clock: Optional, return the newly allocated string with the old clock.
>
> This looks to be just a copy of the old code and forced into a library
> function. As a library function, it should return an "int" and be
> passed the clock name directly. Not via the instance->clock.

The idea of this API is to apply the clock, already set to the
instance. This follows
the existing logic of configuring the instance clock, that's why I put
the "char *clock"
in the new "struct tracecmd_instance". We can remove the clock from
the structure
and pass it as an argument to tracecmd_set_clock(), so the  "struct
tracecmd_instance"
will hold only the instance name ?

>
> -- Steve
>
> > + *
> > + */
> > +void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock)
> > +{
> > +     char *content;
> > +     char *str;
> > +
> > +     if (!instance->clock)
> > +             return;
> > +
> > +     /* The current clock is in brackets, reset it when we are done */
> > +     content = tracecmd_read_instance_file(instance, "trace_clock", NULL);
> > +
> > +     /* check if first clock is set */
> > +     if (*content == '[')
> > +             str = strtok(content+1, "]");
> > +     else {
> > +             str = strtok(content, "[");
> > +             if (!str)
> > +                     die("Can not find clock in trace_clock");
> > +             str = strtok(NULL, "]");
> > +     }
> > +     if (old_clock)
> > +             *old_clock = strdup(str);
> > +
> > +     free(content);
> > +     tracecmd_write_instance_file(instance,
> > +                                  "trace_clock", instance->clock, "clock");
> > +}
> >

Thanks !

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
