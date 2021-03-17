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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BADFC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 09:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3BFA64F6C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 09:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQJ6H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhCQJ57 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 05:57:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4F4C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 02:57:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso1039157pjb.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 02:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyl18XMGxE+8Txknmcl73MXcOcLoWLHaf9klJJ3k61M=;
        b=A3DT1puiZZuIcnIuWbZF7Y9RC4UkSzmIQuEeJ/px5CH0yqA+2N8ARxiCnHDZcHO7Gs
         oYNbvy828/qqDQmWEzuzV6d6ulvsmdVGo5WQWLC5PuQKoMUbDRICOuXtCyRVsby5hQhT
         VVWhh/Ai0K/DogPHz+ybebyT70ELKuKpgrkfjEYFz8VZ2fa4CnjX5xddUZyKhCnenxbx
         wacZamLDWoDWYABA5nnpBYFU2myMlPZKc+Q8ScC80R7wABC3pF8hYEojGqMKJmes4/YJ
         H+W909nVTK2TxmWDtfqJYb4EE0WBJH2w1/HzVPvYLpCtF4YiVW8Vwut7L8OlexA3vhaD
         cudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyl18XMGxE+8Txknmcl73MXcOcLoWLHaf9klJJ3k61M=;
        b=ob95jMk1Y+F/PLxxe2uyZdaKATTapdjvVBCPV0k8zDgrJUJ7hUbH3T/0BS1hwdScFv
         o9JIg3WsKCYxp83hBZK9fjojJVhBDtCUzWSi8SEg4CdkmqVgidTaJoNtm2773E3GYBTz
         c3GlyxT+DXJu8YowHe/OW6UfqPXlI3SH2ifJ7FFBeRFVdFoxttoHylF1n5A5pbGfbf70
         3/ozK+OHSUyvqBnCPmttd5C6OidZjWuRqe/Xe63DcJCqCKKABALr40jCxwdw3MNh9EFy
         uaFb7Ptp6h4sO3+b0Bza8qZBcXog3YQl7+CY/6nnNpPjc5FLGL5SF5WyQXKjkSdsNo9d
         TmCw==
X-Gm-Message-State: AOAM533Ggb3hR7kvUE4g8sUBxq/Ge9G4SW3ScJjezI7NzDIMeWAAa5ve
        LLx+zet38HZoXw2CDopVrRu22wbcJTGXZc8JkPlu21OL2JU=
X-Google-Smtp-Source: ABdhPJwpbYN1L/54XT6hC8DXUQ8cHLOLRfyyGhLnDVre+s4t24CTGV531iZj3vDzwL2eHyb3uGIqzihf5g6sRb04Ojw=
X-Received: by 2002:a17:902:dcd4:b029:e6:5398:609f with SMTP id
 t20-20020a170902dcd4b02900e65398609fmr3740523pll.58.1615975067838; Wed, 17
 Mar 2021 02:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
 <20210315061832.168495-3-tz.stoyanov@gmail.com> <20210316171749.105af2e7@gandalf.local.home>
In-Reply-To: <20210316171749.105af2e7@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 17 Mar 2021 11:57:31 +0200
Message-ID: <CAPpZLN7cx_RswVorUCt+9xOG2C2JbS=SDrrgwMbuZBkrdK+ACQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond conversion
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 16, 2021 at 11:17 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 15 Mar 2021 08:18:22 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added new logic to get multiplier and shift for converting TSC trace clock
> > to nanoseconds, using perf kernel interface. The new logic is used only in
> > host - guest tracing use case, when the user did not specify any tracing
> > clock and KVM time sync plugin is available. Then the x86-tsc clock is
> > auto selected for the current tracing session. There is one limitation -
> > per CPU multiplier or shift is not supported.
>
> I would break this up into two patches. One that adds the perf mult shift
> logic, and even allow users to use it! As TSC clocks are still faster than
> the local clock (as the local clock needs to do the multiplier and shift at
> every event while recording). It would be a feature to have this:
>
>  trace-cmd record --tsc2nsec ...

As the tracing clock is per instance, does it mean this flag should
also be per instance ? I think the below commands should be valid:
   trace-cmd record --tsc2nsec -B foo -C mono  <-- use tsc-x86 clock +
tsc2nsec for the top instance and mono clock for instance foo
   trace-cmd record -C mono -B foo --tsc2nsec  <-- use mono clock for
the top instance and tsc-x86 clock + tsc2nsec clock for instance foo
or even more confusing:
   trace-cmd record -C x86-tsc -B foo --tsc2nsec  <-- use tsc-x86
clock for the top instance and tsc-x86 clock + tsc2nsec clock for
instance foo
This will require changes in the trace.dat file format. The problem is
that tsc2nsec multiplier, shift and offset are stored as an option in
the trace.dat file. Options are global, not per instance. When reading
the file, how to determine events in which instance should be affected
by this option ? We should either add options per instance, or somehow
encode the instance scope of each option.

>
> Where it would use -C x86-tsc clock (or perhaps this can work for other
> architectures), and then use the perf multi/shift to determine the
> nanoseconds.
>
> I would get this working first, before trying to use that for guests and
> hosts.
>
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/include/trace-local.h |   7 ++
> >  tracecmd/trace-record.c        | 124 ++++++++++++++++++++++++++-------
> >  2 files changed, 107 insertions(+), 24 deletions(-)
> >
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index 6e39d27d..8a88ab9c 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -199,6 +199,12 @@ struct filter_pids {
> >       int exclude;
> >  };
> >
> > +struct tsc_nsec {
> > +     int mult;
> > +     int shift;
> > +     int offset;
>
> The above is twelve bytes in size (even on 64 bit machines).
>
> > +};
> > +
> >  struct buffer_instance {
> >       struct buffer_instance  *next;
> >       char                    *name;
> > @@ -234,6 +240,7 @@ struct buffer_instance {
> >       int                     get_procmap;
> >
> >       const char              *clock;
> > +     struct tsc_nsec         tsc2nsec;
> >       unsigned int            *client_ports;
>
> You put the twelve byte structure between two pointers. That's going to
> guarantee a 4 byte hole on 64 bit machines.
>
> You want to try to keep pointers together, and keep 4 byte in pairs such
> that the other fields can line up on 8 byte alignment.
>
>
> >
> >       struct trace_seq        *s_save;
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index a0eb0385..117e4f17 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -57,6 +57,7 @@
> >  #define MAX_LATENCY  "tracing_max_latency"
> >  #define STAMP                "stamp"
> >  #define FUNC_STACK_TRACE "func_stack_trace"
> > +#define TSC_CLOCK    "x86-tsc"
> >
> >  enum trace_type {
> >       TRACE_TYPE_RECORD       = 1,
> > @@ -4104,6 +4105,7 @@ enum {
> >       DATA_FL_NONE            = 0,
> >       DATA_FL_DATE            = 1,
> >       DATA_FL_OFFSET          = 2,
> > +     DATA_FL_GUEST           = 4,
> >  };
> >
> >  static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
> > @@ -5676,6 +5678,100 @@ check_instance_die(struct buffer_instance *instance, char *param)
> >                   tracefs_instance_get_name(instance->tracefs), param);
> >  }
> >
> > +static int get_tsc_nsec(int *shift, int *mult, int *offset)
> > +{
> > +     int cpus = tracecmd_count_cpus();
> > +     int cpu_shift, cpu_mult, cpu_offset;
> > +     struct trace_perf perf;
> > +     int ret;
> > +     int i;
> > +
> > +     ret = trace_perf_init(&perf, 1, 0, getpid());
> > +     if (!ret)
> > +             ret = trace_perf_open(&perf);
> > +     if (ret)
> > +             return ret;
> > +     cpu_shift = perf.mmap->time_shift;
> > +     cpu_mult = perf.mmap->time_mult;
> > +     /* ToDo set the offset, should we use perf.mmap->time_offset ? */
> > +     cpu_offset = 0;
>
> As discussed, may just be creating an instance, setting the clock to
> x86-tsc (we'll need to make this arch independent when other archs have
> similar functionality), write to the trace marker, then read it, and use
> that timestamp as a starting point.
>
> > +     for (i = 1; i < cpus; i++) {
> > +             trace_perf_close(&perf);
> > +             ret = trace_perf_init(&perf, 1, i, getpid());
> > +             if (!ret)
>
> I would just add:
>                 if (ret)
>                         break;
>
> And not have the next call done in the if statement. That's awkward to read.
>
> > +                     ret = trace_perf_open(&perf);
> > +             if (ret)
> > +                     break;
> > +             if (perf.mmap->time_shift != cpu_shift ||
> > +                 perf.mmap->time_mult != cpu_mult) {
> > +                     warning("Found different TSC multiplier and shift for CPU %d: %d;%d instead of %d;%d",
> > +                             i, perf.mmap->time_mult, perf.mmap->time_shift, cpu_mult, cpu_shift);
> > +                     break;
> > +             }
> > +     }
> > +     trace_perf_close(&perf);
> > +     if (i < cpus)
> > +             return -1;
> > +
> > +     *shift = cpu_shift;
> > +     *mult = cpu_mult;
> > +     *offset = cpu_offset;
> > +
> > +     return 0;
> > +}
> > +
> > +static void set_vsync_clock(void)
> > +{
> > +     const char *clock = top_instance.clock;
> > +     struct buffer_instance *instance;
> > +     bool tsc2nsec = false;
> > +     int shift, mult, offset;
> > +
> > +     /*
> > +      * If no clock is specified for the top trace instance AND
> > +      * KVM time sync protocol is available AND
> > +      * TSC to nsec multiplier and shift are available:
> > +      * force using the x86-tsc clock for this host-guest tracing session
> > +      * and store TSC to nsec multiplier and shift.
> > +      */
> > +     if (!clock && tsync_proto_is_supported("kvm") &&
> > +         !get_tsc_nsec(&shift, &mult, &offset) && mult) {
> > +             top_instance.clock = strdup(TSC_CLOCK);
> > +             if (!top_instance.clock)
> > +                     die("Could not allocate top instance clock");
> > +             clock = top_instance.clock;
>
> Why is this using the top_instance? What if the user had done:
>
>  # trace-cmd record -B host -e kvm -e sched -A guest -e sched

You are right, that command is valid. The problem is that guest
timestamps can be synchronized with one clock only. If there are two
instances on the host, each with a different clock, the
synchronization will not work. That's why I look at the top instance
clock only, which is wrong. I'll change that logic to take the first
configured host trace clock, i.e. in case of multiple host instances
with multiple trace clocks, the first wins.

>
>
> -- Steve
>
>
> > +             top_instance.tsc2nsec.mult = mult;
> > +             top_instance.tsc2nsec.shift = shift;
> > +             top_instance.tsc2nsec.offset = offset;
> > +             tsc2nsec = true;
> > +     }
> > +
> > +     if (!clock && !top_instance.tsync_loop_interval)
> > +             return;
> > +     for_all_instances(instance) {
> > +             if (clock) {
> > +                     /* use the same clock in all tracing peers */
> > +                     if (is_guest(instance) &&
> > +                         !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
> > +                             add_argv(instance,
> > +                                      (char *)top_instance.clock, true);
> > +                             add_argv(instance, "-C", true);
> > +                             if (!instance->clock) {
> > +                                     instance->clock = strdup((char *)top_instance.clock);
> > +                                     if (!instance->clock)
> > +                                             die("Could not allocate instance clock");
> > +                             }
> > +                             if (tsc2nsec) {
> > +                                     instance->tsc2nsec.mult = mult;
> > +                                     instance->tsc2nsec.shift = shift;
> > +                                     instance->tsc2nsec.offset = offset;
> > +                             }
> > +                     }
> > +             }
> > +             instance->tsync_loop_interval = top_instance.tsync_loop_interval;
> > +     }
> > +}
> > +
> >  static void parse_record_options(int argc,
> >                                char **argv,
> >                                enum trace_cmd curr_cmd,
> > @@ -5691,7 +5787,6 @@ static void parse_record_options(int argc,
> >       int name_counter = 0;
> >       int negative = 0;
> >       struct buffer_instance *instance, *del_list = NULL;
> > -     bool guest_sync_set = false;
> >       int do_children = 0;
> >       int fpids_count = 0;
> >
> > @@ -5825,6 +5920,7 @@ static void parse_record_options(int argc,
> >                       ctx->instance->port = port;
> >                       ctx->instance->name = name;
> >                       add_instance(ctx->instance, 0);
> > +                     ctx->data_flags |= DATA_FL_GUEST;
> >                       break;
> >               }
> >               case 'F':
> > @@ -5872,8 +5968,6 @@ static void parse_record_options(int argc,
> >                       check_instance_die(ctx->instance, "-C");
> >                       ctx->instance->clock = optarg;
> >                       ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
> > -                     if (is_top_instance(ctx->instance))
> > -                             guest_sync_set = true;
> >                       break;
> >               case 'v':
> >                       negative = 1;
> > @@ -6118,7 +6212,6 @@ static void parse_record_options(int argc,
> >               case OPT_tsyncinterval:
> >                       cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
> >                       top_instance.tsync_loop_interval = atoi(optarg);
> > -                     guest_sync_set = true;
> >                       break;
> >               case OPT_fork:
> >                       if (!IS_START(ctx))
> > @@ -6145,26 +6238,6 @@ static void parse_record_options(int argc,
> >                               add_argv(instance, "--date", true);
> >               }
> >       }
> > -     if (guest_sync_set) {
> > -     /* If -C is specified, prepend clock to all guest VM flags */
> > -             for_all_instances(instance) {
> > -                     if (top_instance.clock) {
> > -                             if (is_guest(instance) &&
> > -                                 !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
> > -                                     add_argv(instance,
> > -                                              (char *)top_instance.clock,
> > -                                              true);
> > -                                     add_argv(instance, "-C", true);
> > -                                     if (!instance->clock) {
> > -                                             instance->clock = strdup((char *)top_instance.clock);
> > -                                             if (!instance->clock)
> > -                                                     die("Could not allocate instance clock");
> > -                                     }
> > -                             }
> > -                     }
> > -                     instance->tsync_loop_interval = top_instance.tsync_loop_interval;
> > -             }
> > -     }
> >
> >       if (!ctx->filtered && ctx->instance->filter_mod)
> >               add_func(&ctx->instance->filter_funcs,
> > @@ -6301,6 +6374,9 @@ static void record_trace(int argc, char **argv,
> >       if (!ctx->output)
> >               ctx->output = DEFAULT_INPUT_FILE;
> >
> > +     if (ctx->data_flags & DATA_FL_GUEST)
> > +             set_vsync_clock();
> > +
> >       make_instances();
> >
> >       /* Save the state of tracing_on before starting */
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
