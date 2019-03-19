Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D44C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 17:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E5B20863
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 17:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfCSRvQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 13:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfCSRvP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 13:51:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5EE220863;
        Tue, 19 Mar 2019 17:51:13 +0000 (UTC)
Date:   Tue, 19 Mar 2019 13:51:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Message-ID: <20190319135111.0061eddb@gandalf.local.home>
In-Reply-To: <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
        <20190319155536.19381-10-tstoyanov@vmware.com>
        <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Mar 2019 17:14:15 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> > index d3e3080..8a73bf7 100644
> > --- a/tracecmd/Makefile
> > +++ b/tracecmd/Makefile
> > @@ -32,6 +32,7 @@ TRACE_CMD_OBJS += trace-list.o
> >  TRACE_CMD_OBJS += trace-output.o
> >  TRACE_CMD_OBJS += trace-usage.o
> >  TRACE_CMD_OBJS += trace-msg.o
> > +TRACE_CMD_OBJS += trace-timesync.o  
> 
> Shouldn't this be on only if $VSOCK_DEFINED, same as trace-agent.o below?
> 
> >
> >  ifeq ($(VSOCK_DEFINED), 1)
> >  TRACE_CMD_OBJS += trace-agent.o
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h

> > +static int find_sync_events(struct tep_handle *pevent,
> > +                           struct tracecmd_time_sync_event *recorded,
> > +                           int rsize, struct tracecmd_time_sync_event *events)
> > +{
> > +       int i = 0, j = 0;
> > +
> > +       while (i < rsize) {
> > +               if (!events[j].ts && events[j].id == recorded[i].id &&
> > +                   (events[j].pid < 0 || events[j].pid == recorded[i].pid)) {
> > +                       events[j].cpu = recorded[i].cpu;
> > +                       events[j].ts = recorded[i].ts;
> > +                       j++;
> > +               } else if (j > 0 && events[j-1].id == recorded[i].id &&
> > +                         (events[j-1].pid < 0 || events[j-1].pid == recorded[i].pid)) {
> > +                       events[j-1].cpu = recorded[i].cpu;
> > +                       events[j-1].ts = recorded[i].ts;
> > +               }
> > +               i++;
> > +       }
> > +       return j;
> > +}
> > +
> > +//#define TSYNC_RBUFFER_DEBUG
> > +static int find_raw_events(struct tep_handle *tep,
> > +                   struct buffer_instance *instance,
> > +                   struct tracecmd_time_sync_event *events)
> > +{
> > +       struct tracecmd_time_sync_event *events_array = NULL;
> > +       int events_count = 0;
> > +       int events_size = 0;
> > +       unsigned int p_size;
> > +       int ts = 0;
> > +       void *page;
> > +       char *path;
> > +       char *file;
> > +       DIR *dir;  
> 
> `dir` is unused besides getting opened and closed below, remove it?
> Or is it supposed to check for the existence of such folder? If so,
> maybe a stat() will suffice or rely on that opening files inside this
> directory will fail too.
> 
> > +       int len;
> > +       int fd;
> > +       int i;
> > +       int r;
> > +
> > +       p_size = getpagesize();
> > +#ifdef TSYNC_RBUFFER_DEBUG
> > +       file = get_instance_file(instance, "trace");
> > +       if (!file)
> > +               return ts;
> > +       {
> > +               char *buf = NULL;
> > +               FILE *fp;
> > +               size_t n;
> > +               int r;
> > +
> > +               printf("Events:\n\r");
> > +               fp = fopen(file, "r");
> > +               while ((r = getline(&buf, &n, fp)) >= 0) {
> > +
> > +                       if (buf[0] != '#')
> > +                               printf("%s", buf);
> > +                       free(buf);
> > +                       buf = NULL;
> > +               }
> > +               fclose(fp);
> > +       }
> > +       tracecmd_put_tracing_file(file);
> > +#endif /* TSYNC_RBUFFER_DEBUG */
> > +       path = get_instance_file(instance, "per_cpu");
> > +       if (!path)
> > +               return ts;
> > +
> > +       dir = opendir(path);
> > +       if (!dir)
> > +               goto out;
> > +
> > +       len = strlen(path);
> > +       file = malloc(len + strlen("trace_pipe_raw") + 32);  
> 
> How about having file defined as
> 
>     char file[PATH_MAX];
> 
> and avoid allocation and computing how much space we need for it?
> 
> > +       page = malloc(p_size);
> > +       if (!file || !page)
> > +               die("Failed to allocate time_stamp info");
> > +       for (i = 0; i < instance->cpu_count; i++) {
> > +               sprintf(file, "%s/cpu%d/trace_pipe_raw", path, i);
> > +               fd = open(file, O_RDONLY | O_NONBLOCK);
> > +               if (fd < 0)
> > +                       continue;
> > +               do {
> > +                       r = read(fd, page, p_size);
> > +                       if (r > 0) {
> > +                               get_events_in_page(tep, page, r, i,
> > +                                                  &events_array, &events_count,
> > +                                                  &events_size);
> > +                       }
> > +               } while (r > 0);
> > +               close(fd);
> > +       }
> > +       qsort(events_array, events_count, sizeof(*events_array), sync_events_cmp);
> > +       r = find_sync_events(tep, events_array, events_count, events);
> > +#ifdef TSYNC_RBUFFER_DEBUG
> > +       len = 0;
> > +       while (events[len].id) {
> > +               printf("Found %d @ cpu %d: %lld pid %d\n\r",
> > +                       events[len].id,  events[len].cpu,
> > +                       events[len].ts, events[len].pid);
> > +               len++;
> > +       }
> > +#endif
> > +
> > +       free(events_array);
> > +       free(file);
> > +       free(page);
> > +       closedir(dir);
> > +
> > + out:
> > +       tracecmd_put_tracing_file(path);
> > +       return r;
> > +}
> > +
> > +static int clock_sync_x86_host_find_events(struct tracecmd_clock_sync *clock,
> > +                                          int pid,
> > +                                          struct tracecmd_time_sync_event *event)
> > +{
> > +       int ret;
> > +
> > +       clock->events[0].pid = pid;
> > +       ret = find_raw_events(clock->tep, clock->vinst, clock->events);
> > +       event->ts = clock->events[0].ts;
> > +       event->cpu = clock->events[0].cpu;
> > +       return ret;
> > +
> > +}
> > +
> > +static int clock_sync_x86_guest_find_events(struct tracecmd_clock_sync *clock,
> > +                                           int pid,
> > +                                           struct tracecmd_time_sync_event *event)
> > +{
> > +       int ret;
> > +
> > +       ret = find_raw_events(clock->tep, clock->vinst, clock->events);
> > +       if (ret != clock->events_count)
> > +               return 0;
> > +       event->ts = clock->events[1].ts;
> > +       event->cpu = clock->events[0].cpu;
> > +       return 1;
> > +
> > +}
> > +
> > +static void tracecmd_clock_sync_reset(struct tracecmd_clock_sync *clock_context)
> > +{
> > +       int i = 0;
> > +
> > +       while (clock_context->events[i].id) {
> > +               clock_context->events[i].cpu = 0;
> > +               clock_context->events[i].ts = 0;
> > +               clock_context->events[i].pid = -1;
> > +               i++;
> > +       }
> > +}
> > +
> > +int tracecmd_clock_find_event(struct tracecmd_clock_sync *clock, int pid,
> > +                             struct tracecmd_time_sync_event *event)
> > +{
> > +       int ret = 0;
> > +       int id;
> > +
> > +       if (clock == NULL ||
> > +           clock->clock_context_id >= CLOCK_CONTEXT_MAX)
> > +               return 0;
> > +
> > +       id = clock->clock_context_id;
> > +       if (clock_sync[id].clock_sync_find_events)
> > +               ret = clock_sync[id].clock_sync_find_events(clock, pid, event);
> > +
> > +       tracecmd_clock_sync_reset(clock);
> > +       return ret;
> > +}
> > +
> > +static void clock_context_copy(struct tracecmd_clock_sync *clock_context,
> > +                              struct tracecmd_ftrace_param *params,
> > +                              struct tracecmd_event_descr *events)
> > +{
> > +       int i;
> > +
> > +       i = 0;
> > +       while (params[i].file)
> > +               i++;
> > +       clock_context->ftrace_params = calloc(i+1, sizeof(struct tracecmd_ftrace_param));
> > +       i = 0;
> > +       while (params[i].file) {
> > +               clock_context->ftrace_params[i].file = strdup(params[i].file);
> > +               if (params[i].set)
> > +                       clock_context->ftrace_params[i].set = strdup(params[i].set);
> > +               if (params[i].reset)
> > +                       clock_context->ftrace_params[i].reset = strdup(params[i].reset);
> > +               i++;
> > +       }
> > +
> > +       i = 0;
> > +       while (events[i].name)
> > +               i++;
> > +       clock_context->events = calloc(i+1, sizeof(struct tracecmd_time_sync_event));
> > +       clock_context->events_count = i;
> > +}
> > +
> > +void trace_instance_reset(struct buffer_instance *vinst)
> > +{
> > +       write_instance_file(vinst, "trace", "\0", NULL);
> > +}
> > +
> > +static struct buffer_instance *
> > +clock_synch_create_instance(const char *clock, unsigned int cid)
> > +{
> > +       struct buffer_instance *vinst;
> > +       char inst_name[256];
> > +
> > +       snprintf(inst_name, 256, "clock_synch-%d", cid);
> > +
> > +       vinst = create_instance(strdup(inst_name));
> > +       tracecmd_init_instance(vinst);
> > +       vinst->cpu_count = tracecmd_local_cpu_count();
> > +       tracecmd_make_instance(vinst);
> > +       trace_instance_reset(vinst);
> > +       if (clock)
> > +               vinst->clock = strdup(clock);
> > +       tracecmd_set_clock(vinst);
> > +       return vinst;
> > +}
> > +
> > +static struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance,
> > +                                             const char * const *systems)
> > +{
> > +       struct tep_handle *tep = NULL;
> > +       char *path;
> > +
> > +       path = get_instance_dir(instance);
> > +       tep = tracecmd_local_events_system(path, systems);
> > +       tracecmd_put_tracing_file(path);
> > +
> > +       tep_set_file_bigendian(tep, tracecmd_host_bigendian());
> > +       tep_set_host_bigendian(tep, tracecmd_host_bigendian());
> > +
> > +       return tep;
> > +}
> > +
> > +static void get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
> > +                              unsigned int *rcid, unsigned int *rport)  
> 
> This static function is called only once in this file and never with
> NULL output arguments. I think we can safely drop all NULL pointer
> checks in it and simplify it.
> 
> > +{
> > +       struct sockaddr_vm addr;
> > +       socklen_t addr_len = sizeof(addr);
> > +
> > +       if (lcid || lport) {
> > +               memset(&addr, 0, sizeof(addr));
> > +               if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
> > +                       return;
> > +               if (addr.svm_family != AF_VSOCK)
> > +                       return;
> > +               if (lport)
> > +                       *lport = addr.svm_port;
> > +               if (lcid)
> > +                       *lcid = addr.svm_cid;
> > +       }
> > +
> > +       if (rcid || rport) {
> > +               memset(&addr, 0, sizeof(addr));
> > +               addr_len = sizeof(addr);
> > +               if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
> > +                       return;
> > +               if (addr.svm_family != AF_VSOCK)
> > +                       return;
> > +
> > +               if (rport)
> > +                       *rport = addr.svm_port;
> > +               if (rcid)
> > +                       *rcid = addr.svm_cid;
> > +       }
> > +}
> > +
> > +struct tracecmd_clock_sync*
> > +tracecmd_clock_context_new(struct tracecmd_msg_handle *msg_handle,
> > +                           const char *clock_str,
> > +                           enum clock_sync_context id)
> > +{
> > +       struct tracecmd_clock_sync *clock_context;
> > +       struct tep_event *event;
> > +       unsigned int i = 0;
> > +
> > +       switch (id) {
> > +#ifdef VSOCK
> > +       case CLOCK_KVM_X86_VSOCK_HOST:
> > +       case CLOCK_KVM_X86_VSOCK_GUEST:
> > +               break;
> > +#endif
> > +       default: /* not supported clock sync context */
> > +               return NULL;
> > +       }
> > +
> > +       if (id >= CLOCK_CONTEXT_MAX || NULL == msg_handle)
> > +               return NULL;
> > +       clock_context = calloc(1, sizeof(struct tracecmd_clock_sync));
> > +       if (!clock_context)
> > +               return NULL;
> > +       clock_context->clock_context_id = id;
> > +       clock_context_copy(clock_context,
> > +                          clock_sync[id].ftrace_params, clock_sync[id].events);
> > +
> > +       get_vsocket_params(msg_handle->fd,
> > +                          &(clock_context->local_cid),
> > +                          &(clock_context->local_port),
> > +                          &(clock_context->remote_cid),
> > +                          &(clock_context->remote_port));  
> 
> Nit: parenthesis are not needed:
> 
>       get_vsocket_params(msg_handle->fd,
>                          &clock_context->local_cid,
>                          &clock_context->local_port,
>                          &clock_context->remote_cid,
>                          &clock_context->remote_port);
> 
> > +
> > +       if (clock_sync[id].clock_sync_init)
> > +               clock_sync[id].clock_sync_init(clock_context);
> > +
> > +       clock_context->vinst = clock_synch_create_instance(clock_str, clock_context->remote_cid);
> > +       clock_context->tep = clock_synch_get_tep(clock_context->vinst,
> > +                                                clock_sync[id].systems);
> > +       i = 0;
> > +       while (clock_sync[id].events[i].name) {
> > +               event = tep_find_event_by_name(clock_context->tep,
> > +                                              clock_sync[id].events[i].system,
> > +                                              clock_sync[id].events[i].name);
> > +               if (!event)
> > +                       break;
> > +               clock_context->events[i].id = event->id;
> > +               i++;
> > +       }

Just an FYI, when replying to large patches, it's recommended to crop
the message to the specifics, that way people don't need to scroll down
forever, and most likely will miss a response. Some kernel developers I
know would ignore replies if they are not properly cropped.

In some cases, that includes me ;-) (If I scroll more than 3 pages, and
don't see a response, I sometimes stop there).

-- Steve
