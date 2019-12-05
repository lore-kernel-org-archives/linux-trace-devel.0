Return-Path: <SRS0=a/08=Z3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60672C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 15:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C762464F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 15:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRrRaXGL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfLEPJm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 10:09:42 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45544 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbfLEPJl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 10:09:41 -0500
Received: by mail-pl1-f193.google.com with SMTP id w7so1356553plz.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Dec 2019 07:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFMW5nINLoovzKJDh2YW8798FMR8y28FjBnViI58r9g=;
        b=jRrRaXGL8+pIjv3iRdNz6y0ykGVDt+pgFw1IpNhNUKnUrejxJqgV1WV+V3HHKF8ZdM
         ahAdoV1ePCkL10/gyzzWXzl+lZmQKXJn2SgPId0d5pm5lGHuMTgY47VBUnDujBMJsMv7
         VCu3cIfhJLPEQIJ5QepGNHHoXTNFLWeyuIXl0IfPMa2cswKifxvJyNRCDqJHr8wIvbEh
         nAb8eNI5oOjfSfTZ8piwUpuEf7NYxd92lmAzRn9GtCyrtgRgwxvIvVPluwnBLXppoXAR
         thnoL6DrEoOZtbTA7WnpXIDBmT/7/oM/sTefI4EvLTqrnv3Ch0l+Foy1DCEQ1KT03GA9
         Qvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFMW5nINLoovzKJDh2YW8798FMR8y28FjBnViI58r9g=;
        b=MdFmAF0xGh7ohoxGEey78kfGPab3pzObJramXaUJhghQQhJDimePhDhD3FNwIZqlHL
         6nIjr98P+9/i7VcxG17JILjLkXQIQBoK2F2vEPQXnKV0dXx538uqak4wyV7gbcfx7WTB
         TXK0zt3TFiXgdif/4QPoD6lJ/2Ppniz4H8vEhrmI+ToxSAXBI4OiS6LFuJ4pTBWX49Hx
         ueYE9OWXsje+r0R4WjQP6wdaVtKxspTXyxGEmL/t8NlUgJWIbUTKnp1ClRlErs6ucr5L
         xGetpA1cU5FQys/ev3GUZVYJq3h8eoEKJlHTEHkLF/pxKQMzmliLJ4rXg4uR7ABmm7LR
         bpEQ==
X-Gm-Message-State: APjAAAUEVans1q7uMU0ErfZkG47BwLtXBIvTSNIQImAAeEGLo3FdOb9k
        pKEhLW7HjbBq6xYNI2l/PjCinuPajKeg4n7PaXk=
X-Google-Smtp-Source: APXvYqwobbZpOI8RIYhrNk+9LOODAxRcN59AHYtwFE40tR1ZCwmuXYZJODmRt70juy13vl5ukbVsxLc7sb7o4pFM+3E=
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr9845305plo.194.1575558580530;
 Thu, 05 Dec 2019 07:09:40 -0800 (PST)
MIME-Version: 1.0
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
 <20191203103522.482684-13-tz.stoyanov@gmail.com> <20191204194650.7055bc1c@gandalf.local.home>
In-Reply-To: <20191204194650.7055bc1c@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 5 Dec 2019 17:09:29 +0200
Message-ID: <CAPpZLN5Fb29dCnHWBDdLt9d9guikb6KqawhYCwqcZVp91rAWBw@mail.gmail.com>
Subject: Re: [PATCH v17 12/18] trace-cmd: Implement new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 5, 2019 at 2:46 AM Steven Rostedt <rostedt@goodmis.org> wrote:
[ ... ]
> > +static inline unsigned long long
> > +timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
> > +                       struct ts_offset_sample *max)
> > +{
> > +     long long tscor = min->offset +
> > +                     (((((long long)ts) - min->time)*
> > +                     (max->offset-min->offset))/(max->time-min->time));
>
> When every I see a division like this, I'd like to think we should add:
>
>         long long offset = ((long long)ts - min->time) *
>                         (max->offset - min->offset);
>         long long delta = max->time - min->time;
>         long long tscor = min->offset +
>                         (offset + delta / 2) / delta;
>
> This handles rounding of delta instead of truncating. Also, it's best
> to have spaces around operators, as it's hard to see where the variable
> stops and the operation beings with max->time-min->time.
>
> > +
> > +     if (tscor < 0)
> > +             return ts - llabs(tscor);
>
> I'm curious to why the test and using llabs, instead of just returning:
>
>         ts + tscor ?
>
> Is there a difference between that when tscor is negative and using
> llabs?
>
The only reason to use llabs() is mixed signed - unsigned calculation. As time
correction tscor can be negative,  will it be converted to unsigned in
"ts + tscor" ?

> > +
> > +     return ts + tscor;
> > +}
> > +
> > +static unsigned long long timestamp_correct(unsigned long long ts,
> > +                                         struct tracecmd_input *handle)
> > +{
> > +     struct host_trace_info  *host = &handle->host;
> > +     int min, mid, max;
> > +
> > +     if (handle->ts_offset)
> > +             return ts + handle->ts_offset;
> > +
> > +     if (!host->sync_enable || !host->ts_samples_count || !host->ts_samples)
> > +             return ts;
>
> Hmm, perhaps we should make host->sync_enable false when
> host->ts_samples_count or host->ts_samples are NULL and remove the
> extra checks? (slight optimization)
>
> > +
> > +     /* We have one sample, nothing to calc here */
> > +     if (host->ts_samples_count == 1)
> > +             return ts + host->ts_samples[0].offset;
> > +
> > +     /* We have two samples, nothing to search here */
> > +     if (host->ts_samples_count == 2)
> > +             return timestamp_correction_calc(ts, &host->ts_samples[0],
> > +                                              &host->ts_samples[1]);
> > +
> > +     /* We have more than two samples */
> > +     if (ts <= host->ts_samples[0].time)
> > +             return timestamp_correction_calc(ts,
> > +                                              &host->ts_samples[0],
> > +                                              &host->ts_samples[1]);
> > +     else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
> > +             return timestamp_correction_calc(ts,
> > +                                              &host->ts_samples[host->ts_samples_count-2],
> > +                                              &host->ts_samples[host->ts_samples_count-1]);
> > +     min = 0;
> > +     max = host->ts_samples_count-1;
> > +     mid = (min + max)/2;
> > +     while (min <= max) {
> > +             if (ts < host->ts_samples[mid].time)
> > +                     max = mid - 1;
> > +             else if (ts > host->ts_samples[mid].time)
> > +                     min = mid + 1;
> > +             else
> > +                     break;
> > +             mid = (min + max)/2;
> > +     }
>
> Hmm, probably should libc's bsearch() instead of open coding a binary
> search.
>

I do not use bsearch() as there is no exact match it that search - only the
interval in which the timestamp fits should be found. May be there is a way
to use bsearch() in this scenario, I can think about it.

[ ...]

> >  }
> >
> > +static int tsync_offset_cmp(const void *a, const void *b)
> > +{
> > +     struct ts_offset_sample *ts_a = (struct ts_offset_sample *)a;
> > +     struct ts_offset_sample *ts_b = (struct ts_offset_sample *)b;
> > +
> > +     if (ts_a->time > ts_b->time)
> > +             return 1;
> > +     if (ts_a->time < ts_b->time)
> > +             return -1;
> > +     return 0;
> > +}
>
> We have the compare function for bsearch() here.
>

We can use it only for exact match, cannot use the same function for finding the
interval.

[ ... ]

> >  static int trace_pid_map_cmp(const void *a, const void *b)
> >  {
> >       struct tracecmd_proc_addr_map *m_a = (struct tracecmd_proc_addr_map *)a;
> > @@ -2323,6 +2438,7 @@ static int handle_options(struct tracecmd_input *handle)
> >       struct input_buffer_instance *buffer;
> >       struct hook_list *hook;
> >       char *buf;
> > +     int sampes_size;
>
> "sampes"? Is this short for "samples"? Just use "samples_size" then.
>

It's a typo, fixed it :)

>
> >       int cpus;
> >
> >       /* By default, use usecs, unless told otherwise */
> > @@ -2370,6 +2486,28 @@ static int handle_options(struct tracecmd_input *handle)
> >                       offset = strtoll(buf, NULL, 0);
> >                       handle->ts_offset += offset;
> >                       break;
> > +             case TRACECMD_OPTION_TIME_SHIFT:
> > +                     /*
> > +                      * long long int (8 bytes) trace session ID
> > +                      * int (4 bytes) count of timestamp offsets.
> > +                      * long long array of size [count] of times,
> > +                      *      when the offsets were calculated.
> > +                      * long long array of size [count] of timestamp offsets.
> > +                      */
> > +                     if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> > +                             break;
> > +                     handle->host.trace_id = tep_read_number(handle->pevent,
> > +                                                             buf, 8);
> > +                     handle->host.ts_samples_count = tep_read_number(handle->pevent,
> > +                                                                     buf + 8, 4);
> > +                     sampes_size = (8 * handle->host.ts_samples_count);
> > +                     if (size != (12 + (2 * sampes_size)))
> > +                             break;
> > +                     handle->host.ts_samples = malloc(2 * sampes_size);
> > +                     if (!handle->host.ts_samples)
> > +                             return -ENOMEM;
> > +                     tsync_offset_load(handle, buf + 12);
> > +                     break;
> >               case TRACECMD_OPTION_CPUSTAT:
> >                       buf[size-1] = '\n';
> >                       cpustats = realloc(cpustats, cpustats_size + size + 1);
> > @@ -3078,6 +3216,8 @@ void tracecmd_close(struct tracecmd_input *handle)
> >       trace_pid_map_free(handle->pid_maps);
> >       handle->pid_maps = NULL;
> >
> > +     trace_tsync_offset_free(&handle->host);
> > +
> >       if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
> >               tracecmd_close(handle->parent);
> >       else {
> > @@ -3532,3 +3672,29 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
> >  {
> >       return handle->trace_id;
> >  }
> > +
> > +/**
> > + * tracecmd_get_tsync_peer - get the trace session id of the peer host
> > + * @handle: input handle for the trace.dat file
> > + *
> > + * Returns the trace id of the peer host, written in the trace file
> > + *
> > + * This information is stored in guest trace.dat file
> > + */
> > +unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
> > +{
> > +     return handle->host.trace_id;
> > +}
> > +
> > +/**
> > + * tracecmd_enable_tsync - enable / disable the timestamps correction
> > + * @handle: input handle for the trace.dat file
> > + * @enable: enable / disable the timestamps correction
> > + *
> > + * Enables or disables timestamps correction on file load, using the array of
> > + * recorded time offsets
> > + */
> > +void tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
> > +{
>
> Perhaps here we should check if samples are allocated already, and only
> allow it to be enabled if they are.
>
> -- Steve
>
>
> > +     handle->host.sync_enable = enable;
> > +}
>

Thanks !

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
