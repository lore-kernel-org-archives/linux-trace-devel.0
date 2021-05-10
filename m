Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6CAC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 03:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA91B610A7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 03:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhEJDZM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 9 May 2021 23:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhEJDZM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 9 May 2021 23:25:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F3C061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 20:24:08 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so9464969pjb.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 20:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2NFUenPTzEaYXI6GFz4ZMnnIEn9Zd3WvJaQWYF60R+c=;
        b=VKL5deNH7jXUJIYjQHdY15ZFqzYd+nF3HzJNs1/ppJ5X9FnPe7k0dUeJknK7omUqWl
         nXyL6bSb7ykr1OV7QZPFr3rP+3VhouxjbI+Ua0ftZ+pW5Kzde9fS3HUjbY6PiMluDhUM
         vXAa6740eM3Wh3xpuFGCzmGh9ED0mFwayfMhPpQSZCfRS6ApmEUodjCJvgFR70PZX1bC
         S/ZbsiyAL96/3X+IPTuUWiz6YWSuUvPraAmnaMoqL9u6fa33Si3fKWcAWNkHaWZJOazC
         k9PR0tuUvBBOm8T8RCrl63D06C9ddC09wHnXoxTApJCbSZTdVnJNpK9+DwW0ssd0zfPX
         l/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2NFUenPTzEaYXI6GFz4ZMnnIEn9Zd3WvJaQWYF60R+c=;
        b=unb3CM1X9sO9Mb/7rbZHTJVbED9h8cXTC0LasJE6zLJ7uDwY66aWRbQryZFenU5YMs
         cxmj5yGKoMkUlMXIiCIzHyoA0EPuODuBi3P7GrY2jaulFzQeZvC2IGWMBwEMABlY80lT
         h3hlFbzasHYu2t9Qh8cCHUQu374WjBqvlPNWDo5qxWKJZ3bq/wCmlYKNg7dyHk0Jm9QP
         RFo6mQsXJYaVPis8yprc2u4U9nNOggmWmTpLNd2+LtRisbSuVfZ9V0f8V0C/Ssnxgx6/
         0P4SWoV5qGlztwSmHx4O1mC4rbfuPABvyPwrHlTZfbBr4WU1OCB787/chA6+/hs5RvK3
         viuQ==
X-Gm-Message-State: AOAM5311yaiJnFZ33RPsI3+yAHMBNYbZVSGkvvbAm3BAIlIzeKhCk2Ix
        GNX/2Ie1toPCF9NBBofvKRacT0dWvNQWG00gHr5GmHiCzf8=
X-Google-Smtp-Source: ABdhPJwJxNNDnAfVrf9lIwboJk0t5wQV5uR/gtRow7Ohez9jgfh7qRiyITu7pZ1Fle7xtEZT4XcR+BjIvJMityXW1Sk=
X-Received: by 2002:a17:902:d491:b029:ee:5aa3:7d57 with SMTP id
 c17-20020a170902d491b02900ee5aa37d57mr22600930plg.26.1620617048080; Sun, 09
 May 2021 20:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210507135615.033a6121@gandalf.local.home>
In-Reply-To: <20210507135615.033a6121@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 10 May 2021 06:23:51 +0300
Message-ID: <CAPpZLN4wnkEdvAC37p-7c94axRz6bvsvO=9dXJAQfFZ7LtLDEg@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Trace timesync to find pids that map vCPUs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 7, 2021 at 8:56 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> If qemu is not found, then there's no mapping between the vCPUs of the
> guest and the threads that run them. As the time sync has the agent run on
> all the guest's CPUs, trace it, looking for all kvm_entry, which state
> which vCPU the host thread is entering on the guest, and then use that to
> create the mapping for the data files.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tracecmd/include/trace-local.h |   2 +
>  tracecmd/trace-record.c        | 196 ++++++++++++++++++++++++++++++++-
>  2 files changed, 197 insertions(+), 1 deletion(-)
>
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index b3997d00..4c5669c9 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -298,11 +298,13 @@ void update_first_instance(struct buffer_instance *instance, int topt);
>  void show_instance_file(struct buffer_instance *instance, const char *name);
>
>  struct trace_guest {
> +       struct tracefs_instance *instance;
>         char *name;
>         int cid;
>         int pid;
>         int cpu_max;
>         int *cpu_pid;
> +       int *task_pids;
>  };
>  struct trace_guest *trace_get_guest(unsigned int cid, const char *name);
>  bool trace_have_guests_pid(void);
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 5dd8be4a..143ece6a 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3230,6 +3230,38 @@ static int do_accept(int sd)
>         return -1;
>  }
>
> +/* Find all the tasks associated with the guest pid */
> +static void find_tasks(struct trace_guest *guest)
> +{
> +       struct dirent *dent;
> +       char *path;
> +       DIR *dir;
> +       int ret;
> +       int tasks = 0;
> +
> +       ret = asprintf(&path, "/proc/%d/task", guest->pid);
> +       if (ret < 0)
> +               return;
> +
> +       dir = opendir(path);
> +       free(path);
> +       if (!dir)
> +               return;
> +
> +       while ((dent = readdir(dir))) {
> +               int *pids;
> +               if (!(dent->d_type == DT_DIR && is_digits(dent->d_name)))
> +                       continue;
> +               pids = realloc(guest->task_pids, sizeof(int) * (tasks + 2));
> +               if (!pids)
> +                       break;
> +               pids[tasks++] = strtol(dent->d_name, NULL, 0);
> +               pids[tasks] = -1;
> +               guest->task_pids = pids;
> +       }
> +       closedir(dir);
> +}
> +
>  static char *parse_guest_name(char *gname, int *cid, int *port)
>  {
>         struct trace_guest *guest;
> @@ -3250,10 +3282,12 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
>         } else if (is_digits(gname))
>                 *cid = atoi(gname);
>
> -       read_qemu_guests();

I would suggest to leave the legacy logic for reading existing qemu
VMs. We can reimplement it - instead of parsing the qemu command line,
virhs can be used to get that information, as Stefano Garzarella
suggested in other thread. We can even implement similar auto
discovery logics for other VM emulators. The VMs auto discovery will
be a best effort, if the user passes "-A <guest>" to the command line,
and a guest with that name is not known - trace-cmd will die,
suggesting  to use the more robust "-A <guest>@cid:port" method.

[...]


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
