Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41641 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbeJPOfR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 10:35:17 -0400
Received: by mail-ot1-f65.google.com with SMTP id c32so21427130otb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Oct 2018 23:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180830150900.27412-1-tz.stoyanov@gmail.com> <20180831062718.3436-1-tz.stoyanov@gmail.com>
In-Reply-To: <20180831062718.3436-1-tz.stoyanov@gmail.com>
From: Ceco <tz.stoyanov@gmail.com>
Date: Tue, 16 Oct 2018 09:46:07 +0300
Message-ID: <CAPpZLN6bvSTVq6NBXHPKqH4cMXTxSKeTxk0VMiTAZJpt4mY_5Q@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce new libtracevent API: tep_override_comm()
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

ping
Hi Steven, is there a problem with this patch ? Yordan needs these
changes, he wants to use the new API in KernelShark.

On Fri, Aug 31, 2018 at 9:27 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> Added a new API of tracevent library: tep_override_comm()
> It registers a pid / comm mapping. If a mapping with the same
> pid already exists, the entry is updated with the new comm.
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/traceevent/event-parse.h |  1 +
>  lib/traceevent/event-parse.c     | 70 +++++++++++++++++++++++++-------
>  2 files changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
> index 713a4e4..0dcc024 100644
> --- a/include/traceevent/event-parse.h
> +++ b/include/traceevent/event-parse.h
> @@ -607,6 +607,7 @@ int tep_set_function_resolver(struct tep_handle *pevent,
>                               tep_func_resolver_t *func, void *priv);
>  void tep_reset_function_resolver(struct tep_handle *pevent);
>  int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
> +int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid);
>  int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
>  int tep_register_function(struct tep_handle *pevent, char *name,
>                           unsigned long long addr, char *mod);
> diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
> index ce1e202..1954908 100644
> --- a/lib/traceevent/event-parse.c
> +++ b/lib/traceevent/event-parse.c
> @@ -230,11 +230,13 @@ int tep_pid_is_registered(struct tep_handle *pevent, int pid)
>   * we must add this pid. This is much slower than when cmdlines
>   * are added before the array is initialized.
>   */
> -static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
> +static int add_new_comm(struct tep_handle *pevent,
> +                       const char *comm, int pid, bool override)
>  {
>         struct cmdline *cmdlines = pevent->cmdlines;
> -       const struct cmdline *cmdline;
> +       struct cmdline *cmdline;
>         struct cmdline key;
> +       char *new_comm;
>
>         if (!pid)
>                 return 0;
> @@ -245,8 +247,20 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
>         cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
>                        sizeof(*pevent->cmdlines), cmdline_cmp);
>         if (cmdline) {
> -               errno = EEXIST;
> -               return -1;
> +               if (!override) {
> +                       errno = EEXIST;
> +                       return -1;
> +               }
> +               new_comm = strdup(comm);
> +               if(!new_comm) {
> +                       errno = ENOMEM;
> +                       return -1;
> +               }
> +               if (cmdline->comm)
> +                       free(cmdline->comm);
> +               cmdline->comm = new_comm;
> +
> +               return 0;
>         }
>
>         cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
> @@ -273,21 +287,13 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
>         return 0;
>  }
>
> -/**
> - * tep_register_comm - register a pid / comm mapping
> - * @pevent: handle for the pevent
> - * @comm: the command line to register
> - * @pid: the pid to map the command line to
> - *
> - * This adds a mapping to search for command line names with
> - * a given pid. The comm is duplicated.
> - */
> -int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
> +static int _tep_register_comm(struct tep_handle *pevent,
> +                             const char *comm, int pid, bool override)
>  {
>         struct cmdline_list *item;
>
>         if (pevent->cmdlines)
> -               return add_new_comm(pevent, comm, pid);
> +               return add_new_comm(pevent, comm, pid, override);
>
>         item = malloc(sizeof(*item));
>         if (!item)
> @@ -310,6 +316,40 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
>         return 0;
>  }
>
> +/**
> + * tep_register_comm - register a pid / comm mapping
> + * @pevent: handle for the pevent
> + * @comm: the command line to register
> + * @pid: the pid to map the command line to
> + *
> + * This adds a mapping to search for command line names with
> + * a given pid. The comm is duplicated. If a command with the same pid
> + * already exist, -1 is returned and errno is set to EEXIST
> + */
> +int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
> +{
> +       return _tep_register_comm(pevent, comm, pid, false);
> +}
> +
> +/**
> + * tep_override_comm - register a pid / comm mapping
> + * @pevent: handle for the pevent
> + * @comm: the command line to register
> + * @pid: the pid to map the command line to
> + *
> + * This adds a mapping to search for command line names with
> + * a given pid. The comm is duplicated. If a command with the same pid
> + * already exist, the command string is udapted with the new one
> + */
> +int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid)
> +{
> +       if (!pevent->cmdlines && cmdline_init(pevent)) {
> +               errno = ENOMEM;
> +               return -1;
> +       }
> +       return _tep_register_comm(pevent, comm, pid, true);
> +}
> +
>  int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
>  {
>         pevent->trace_clock = strdup(trace_clock);
> --
> 2.17.1
>
