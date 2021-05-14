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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA602C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 04:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95403613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 04:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhENEMW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 00:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhENEMW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 00:12:22 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C817FC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 21:11:09 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id v6so36329483ljj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 21:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnJBMRqs/H+kruSn9ClCrwBK38/67bkgBKAAFf7f76k=;
        b=iq1BzOloErzIIUE1DOmADTakhMB++wvgHHOt/PYa4445Zi5ynjAuB0LJXg7jbiXKJG
         nLEiW3jGajbIRKcCv7du+1EPRxE1ytei5IZ0RjYON1KfVJAO2/G4jI+0OLcCDqk3Qxfe
         noZ70WC0N//RjB3TwDCQMujkO/5mDOCdGHLo5n4dnsSFGlI/osvi9CfoCBwIT03yUFKB
         teKb/SX7mkt32Z3dkhe7SdEZ4sJt3LEFVIDBcVs1S5iKoJw+4DsP3j6QLNzx6WzsZSff
         ZCsVDXX5GUkv/7u5JYxCHZjvlLv5M2LnH9hKrBUWr0jVcRZDds8HvPGp28Y/UlRUyYtM
         VOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnJBMRqs/H+kruSn9ClCrwBK38/67bkgBKAAFf7f76k=;
        b=Mv9/Dmi8FeQ6hETlLTPNUFXZ1kUyEZP+LXsPZCrZnGd9t0qs+Uj2KmWlT91IpX/Oa2
         O/aT/roI2alrwXAp46jUhMBqi7rZyoWbT0io8Kr++/8t5fpi0zqXHYcAptJiW63dL2Fc
         IH60HnhesGLzNibb8wUnDWxh6oY8ytVsSiWWImpXm4pvT/mUcDgHCg1qCk8R7ITA5RBC
         hils3tfSOZE8xlFGKIbS0gV3acelJz9kHqYj7k2LjY6vSCAZ/bT0cDNF33I/jTgyklUj
         4rt3w7ZPmhIfV6F3hQIrHwLZju9rw0BQSLgEN90fwHAdr52gK5heMo5+tMtghWd72mFu
         UWbQ==
X-Gm-Message-State: AOAM533hmbLdU2elbbdcNFouKWRpZ2EXK2eHoTC+JXjTlZcleXA+6hZ2
        uHqp/nJFVVSFHvu41vBWwclj9Q0kyafPTwd0iTEVksjfEf7REQ==
X-Google-Smtp-Source: ABdhPJwmqPqTejsPf3OUoFQwok4n+TLufsjskEBIyMOWq2VEnKFR52VS6SOi6VA7szqIXWk8SCDobASY7zHpX+HjeRY=
X-Received: by 2002:a2e:910a:: with SMTP id m10mr12665139ljg.456.1620965468281;
 Thu, 13 May 2021 21:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210513204315.1206204-1-rostedt@goodmis.org> <20210513204315.1206204-3-rostedt@goodmis.org>
In-Reply-To: <20210513204315.1206204-3-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 14 May 2021 07:10:51 +0300
Message-ID: <CAPpZLN6p2UgghB16=eqpacica6XEOLuCqTds+SdhFbZkPUZ0Hw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] trace-cmd: Trace timesync to find pids that map vCPUs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 14, 2021 at 3:33 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> If qemu is not found, then there's no mapping between the vCPUs of the
> guest and the threads that run them. As the time sync has the agent run on
> all the guest's CPUs, trace it, looking for all kvm_entry, which state
> which vCPU the host thread is entering on the guest, and then use that to
> create the mapping for the data files.
>
> Only parse for qemu if no CID is given on the command line.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v1:
>  - Skipped v2 (added to v3 of this patch series)
>  - Used some of the new APIs of libtracefs 1.2
>  - Call read_qemu_guests is CID is not supplied on the command line.
>
>  tracecmd/include/trace-local.h |   2 +
>  tracecmd/trace-record.c        | 202 ++++++++++++++++++++++++++++++++-
>  2 files changed, 203 insertions(+), 1 deletion(-)
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
> index 5dd8be4a..5219d60b 100644
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
> @@ -3250,10 +3282,18 @@ static char *parse_guest_name(char *gname, int *cid, int *port)
>         } else if (is_digits(gname))
>                 *cid = atoi(gname);
>
> -       read_qemu_guests();
> +       if (*cid < 0)
> +               read_qemu_guests();
> +
> +       if (*cid < 0)
> +               return NULL;

This check is not needed. If cid is not part of the string, let
read_qemu_guests() to try discover the VMs, instead of returning NULL.

[ ... ]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
