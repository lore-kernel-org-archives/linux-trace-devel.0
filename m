Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE49CC4BA24
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 08:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C237D222C2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 08:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOiYuFo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgB0IbK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 03:31:10 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45314 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbgB0IbK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 03:31:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so827285pls.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 00:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hoh9ZB66qs7fzMZj5nwiLshyNgP1+DrYh/LGgxiBtC4=;
        b=NOiYuFo8BN0pPNrTvvEMH7RRMpcu9tuowH4Spu5mYGUZ4EV/fVwKkmuIlLRuQCrck4
         nseXGYFJ/EOk8YM7WQov7sitHDqCmgT0l9oJW7tywZhwANUTzteQqrDGclS6rIuT/hzP
         UpbtOOdmAq2K3KzFBuPfjMSlUximcsUuvUOSRIysDAwZ6fCgZEcx3S49fGHLAIcLD1FK
         qTIKxZ2ZdTUgk3uKvG9307qi0ZXSG7gGtOx65OQWs+/xPDy2nK7x5eXHdbi9BJlfwDtG
         mWjQVGY5nYmnIwfg59EiaNRkv+mBimCiOO2U/xDds92jGqE92QhvcG6F9T13mfPm4ona
         X+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hoh9ZB66qs7fzMZj5nwiLshyNgP1+DrYh/LGgxiBtC4=;
        b=IBmGksCUe+QFZTh5ot+qPtjHM2cbyQ1EsCLbMl03KLMx2bsTlUV1C0uXjAmAVIr+h6
         nkqt17KNNBvfkyN6riwslG26cjYHDNB6S8ux+8vPCuFCy17jMXcyW31c7ntfh7jXe/dJ
         JewXtn/jHKUq6ddKz6TkeKrs6+MVyeMWeUOJoxrczkaXAmkgDu6W8nQ/r/pNABe2kfjC
         9HmrpoYGue84gqxrJI3MSyjGpkaxJ5d9rvVjm+q7wHz1MZmDz/XQCeNXoxTo6LAPa11z
         Pu9rFMWaDMM9mZdb+H2GEsA44g4pLHqbTC/m5BgEwl2ng59WK0ncQTMzSvFK5/0LSJGE
         Ui5w==
X-Gm-Message-State: APjAAAViTMP8K97muVqDgXw2N81ap5Ki74dH+iLv37Cu0myz1S11YAIs
        2Ep+S/75XuL1zHedcbb0SFYWZDldotFZd3uP7aBRkBpA
X-Google-Smtp-Source: APXvYqyylFiZJdvLVF5BMZFJ5Hsz63e2VNIIFWgRBELGEM8h5nAlZZ1JcvKzfO7hZ6NEKOL3wzJtsvjBpAKjujgdW68=
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr3685044plv.194.1582792268913;
 Thu, 27 Feb 2020 00:31:08 -0800 (PST)
MIME-Version: 1.0
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
 <20200131121111.130355-4-tz.stoyanov@gmail.com> <20200226231314.5d4a6e5f@oasis.local.home>
In-Reply-To: <20200226231314.5d4a6e5f@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 27 Feb 2020 10:30:56 +0200
Message-ID: <CAPpZLN4DGDXxJZ0zsgRDcohKiBdgURUOik+O6hR4Fi1Gx9MsBg@mail.gmail.com>
Subject: Re: [PATCH v19 03/15] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 27, 2020 at 6:13 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 31 Jan 2020 14:10:59 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >
> > In order to match host and guest events, a mapping between guest VCPU
> > and the host task, running this VCPU is needed. Extended existing
> > struct guest to hold such mapping and added logic in read_qemu_guests()
> > function to initialize it. Implemented a new internal API,
> > get_guest_vcpu_pid(), to retrieve VCPU-task mapping for given VM.
> >
> > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > ---
> >  tracecmd/include/trace-local.h |  2 ++
> >  tracecmd/trace-record.c        | 54 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> >
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index 29f2779..a5cf064 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -247,6 +247,8 @@ void update_first_instance(struct buffer_instance *instance, int topt);
> >
> >  void show_instance_file(struct buffer_instance *instance, const char *name);
> >
> > +int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
> > +
> >  /* moved from trace-cmd.h */
> >  void tracecmd_create_top_instance(char *name);
> >  void tracecmd_remove_instances(void);
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 28fe31b..b479e91 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -3031,10 +3031,12 @@ static bool is_digits(const char *s)
> >       return true;
> >  }
> >
> > +#define VCPUS_MAX 256
> >  struct guest {
> >       char *name;
> >       int cid;
> >       int pid;
> > +     int cpu_pid[VCPUS_MAX];
>
> Although this is probably fine for the near future, I don't like
> arbitrary limits that don't have to do with max sizes of the storage
> unit (like max int).
>
> Why is the cpu_pid a static array and not one that is allocated? We
> could use realloc, couldn't we, in the loading of it?
>

I did it to simplify the PoC implementation and never changed it to be
a dynamic array,
I'll reimplement it now.
Thanks Steven!

> -- Steve
>
> >  };
> >
> >  static struct guest *guests;
> > @@ -3052,6 +3054,43 @@ static char *get_qemu_guest_name(char *arg)
> >       return arg;
> >  }
> >
> > +static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
> > +{
> > +     struct dirent *entry;
> > +     char path[PATH_MAX];
> > +     char *buf = NULL;
> > +     size_t n = 0;
> > +     int vcpu;
> > +     DIR *dir;
> > +     FILE *f;
> > +
> > +     snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
> > +     dir = opendir(path);
> > +     if (!dir)
> > +             return;
> > +
> > +     while ((entry = readdir(dir))) {
> > +             if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
> > +                     continue;
> > +
> > +             snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
> > +                      guest_task, entry->d_name);
> > +             f = fopen(path, "r");
> > +             if (!f)
> > +                     continue;
> > +
> > +             if (getline(&buf, &n, f) >= 0 &&
> > +                 strncmp(buf, "CPU ", 4) == 0) {
> > +                     vcpu = atoi(buf + 4);
> > +                     if (vcpu >= 0 && vcpu < VCPUS_MAX)
> > +                             guest->cpu_pid[vcpu] = atoi(entry->d_name);
> > +             }
> > +
> > +             fclose(f);
> > +     }
> > +     free(buf);
> > +}
> > +
> >  static void read_qemu_guests(void)
> >  {
> >       static bool initialized;
> > @@ -3115,6 +3154,8 @@ static void read_qemu_guests(void)
> >               if (!is_qemu)
> >                       goto next;
> >
> > +             read_qemu_guests_pids(entry->d_name, &guest);
> > +
> >               guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
> >               if (!guests)
> >                       die("Can not allocate guest buffer");
> > @@ -3160,6 +3201,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
> >       return guest;
> >  }
> >
> > +int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
> > +{
> > +     int i;
> > +
> > +     if (!guests || guest_vcpu >= VCPUS_MAX)
> > +             return -1;
> > +
> > +     for (i = 0; i < guests_len; i++)
> > +             if (guest_cid == guests[i].cid)
> > +                     return guests[i].cpu_pid[guest_vcpu];
> > +     return -1;
> > +}
> > +
> >  static void set_prio(int prio)
> >  {
> >       struct sched_param sp;
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
