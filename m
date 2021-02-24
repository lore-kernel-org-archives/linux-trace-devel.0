Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B640C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB44F60201
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBXGXk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 01:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhBXGXj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 01:23:39 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8FDC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 22:22:59 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ba1so599154plb.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 22:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0d9gzggUmH1i63ekZxDjNdSu7i7hgqkkhFL2hlArbEE=;
        b=Z3esSf+QpcYQecleX7rAFISGn3XIdIH8ytKZ0M5AlZUJboEoTt/mr6WPU4OLHhxbBc
         lMOs3QYUbKXa9FMRpDvTKXaTkNhWuktTz/huZDhQTCUrNaJ+q4TCogsuAU5SHXJP7cil
         50u/OLUyapANPUtPXD3tUr3PgQndS83RnVOF7f6QfMuruz8EqnCH4WUXIdaTjt/QJG8J
         5wmoIOy5J2hHmoQ+kLd+AuASuTsiX9pKd9zzqG2sxIkBQhEvJrX7IrosG90Ce2tuGFAO
         gAJPJilEucTSdaClN7eqUcvtg5MVuTAHOw4bGrHhKBmutmCluW28eMeqyAuhPZl8K/y6
         EYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0d9gzggUmH1i63ekZxDjNdSu7i7hgqkkhFL2hlArbEE=;
        b=jnzlmGMV7AXuoaEu0eKI+DLrlxulZEkrY97t5lgks5hZb7tfSnVEjTWcQrLeJIJVD/
         FPf76xELwl1VxtHbtVuMoi8RoA8rdsx1IHz163zz5+cHRa95iz2m/Zl0ctvHwZtrUnlB
         RVf2MuPQ44xHD2Ue3uDEZ3t08A286fKY5b2JHruAKacsZVMIPdqcoJ5QcKLIn2uPl+v4
         Ddvoq1LIkefeViTXKTc2SKDXa9fTH7gdBmgQ1vISO7xlTuVwcZX0BO5s6Qio+B5TjuLE
         15Xx6sVHWW7Ns7AUJuoRg/Ndct4pxtSZVjFgfFInL7e8Wgln6ZnzPln23fJuO7u641sz
         xmvw==
X-Gm-Message-State: AOAM53059+e5Ottc+7Nv0y1akpmDGqkt8Xm0RVVOD8N5FfcIB/w0syEY
        wXAM1yDDxvJZf0yUgxr4PcLbtEKkLtZ8CsQZjzS3d95585Miow==
X-Google-Smtp-Source: ABdhPJzRnM/mZ4E5JOObjGNhfJ+xXfG16/KZ0m5EjaMBgx+S7AZXtmEGDH+7x8HZ8W5k9+IxZeq9WfQQx8kMp9X44Q4=
X-Received: by 2002:a17:902:d20d:b029:e4:51e:df40 with SMTP id
 t13-20020a170902d20db02900e4051edf40mr6140239ply.58.1614147778866; Tue, 23
 Feb 2021 22:22:58 -0800 (PST)
MIME-Version: 1.0
References: <20210219101457.2345089-1-tz.stoyanov@gmail.com>
 <20210219101457.2345089-6-tz.stoyanov@gmail.com> <20210223163632.438071c7@gandalf.local.home>
In-Reply-To: <20210223163632.438071c7@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Feb 2021 08:22:42 +0200
Message-ID: <CAPpZLN4QvCFgqbSf8xb4LZrdSXY+g8CDpw72SeSpUqgaj64ayA@mail.gmail.com>
Subject: Re: [PATCH v29 5/5] trace-cmd [POC]: Add KVM timestamp
 synchronization plugin
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Tue, Feb 23, 2021 at 11:36 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 19 Feb 2021 12:14:57 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> > index fb18075b..aa3e3fc1 100644
> > --- a/lib/trace-cmd/trace-timesync.c
> > +++ b/lib/trace-cmd/trace-timesync.c
> > @@ -63,6 +63,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
> >  void tracecmd_tsync_init(void)
> >  {
> >       ptp_clock_sync_register();
> > +     kvm_clock_sync_register();
> >  }
> >
> >  int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
> > @@ -433,6 +434,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
> >       }
> >       pthread_mutex_destroy(&tsync->lock);
> >       pthread_cond_destroy(&tsync->cond);
> > +     pthread_barrier_destroy(&tsync->first_sync);
>
> I'm guessing that this was suppose to be added as a separate patch? If not,
> it should be.
>
>
> >       free(tsync->clock_str);
> >  }
> >
> > @@ -630,23 +632,24 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
> >   * It loops infinite, until the timesync semaphore is released
> >   *
> >   */
> > -void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> > +int tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> >  {
> >       struct tsync_probe_request_msg probe;
> >       int ts_array_size = CLOCK_TS_ARRAY;
> >       struct tsync_proto *proto;
> >       struct timespec timeout;
> > +     bool first = true;
> >       bool end = false;
> >       int ret;
> >       int i;
> >
> >       proto = tsync_proto_find(tsync->proto_name);
> >       if (!proto || !proto->clock_sync_calc)
> > -             return;
> > +             return -1;
> >
> >       clock_context_init(tsync, false);
> >       if (!tsync->context)
> > -             return;
> > +             return -1;
> >
> >       if (tsync->loop_interval > 0 &&
> >           tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
> > @@ -664,6 +667,10 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> >                       if (ret)
> >                               break;
> >               }
> > +             if (first) {
> > +                     first = false;
> > +                     pthread_barrier_wait(&tsync->first_sync);
>
> As pthread_barrier_wait() and pthread_barrier_destroy() are used here, this
> should not be in the library code. It should be in the trace-cmd code, or
> the trace-cmd code should be in the library.
>
> A pthread_barrier_wait() is dangerous and needs to be tightly coupled with
> all use cases. Otherwise, you could end with a thread stuck in the barrier
> and nothing wakes it up.
>
> > +             }
> >               if (end || i < tsync->vcpu_count)
> >                       break;
> >               if (tsync->loop_interval > 0) {
> > @@ -685,4 +692,5 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
> >                                   TRACECMD_TSYNC_PROTO_NONE,
> >                                   TRACECMD_TIME_SYNC_CMD_STOP,
> >                                   0, NULL);
> > +     return 0;
> >  }
> > diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
> > index d7de8298..ec4b2d86 100644
> > --- a/tracecmd/trace-tsync.c
> > +++ b/tracecmd/trace-tsync.c
> > @@ -61,14 +61,19 @@ error:
> >  static void *tsync_host_thread(void *data)
> >  {
> >       struct tracecmd_time_sync *tsync = NULL;
> > +     int ret;
> >
> >       tsync = (struct tracecmd_time_sync *)data;
> >
> > -     tracecmd_tsync_with_guest(tsync);
> > +     ret = tracecmd_tsync_with_guest(tsync);
> >
> >       tracecmd_msg_handle_close(tsync->msg_handle);
> >       tsync->msg_handle = NULL;
> >
> > +     /* tsync with guest failed, release the barrier */
> > +     if (ret)
> > +             pthread_barrier_wait(&tsync->first_sync);
>
> This being needed here shows that the barrier logic needs to be separated
> out. As this is in the trace-cmd proper, and its releasing the guest, and
> this is exposing the internal logic of the lib/trace-cmd code, which is not
> acceptable.
>
> We probably want the guest logic moved here?
>
> Either way, we need to make sure there's no path that could cause the guest
> (or host) to get stuck in the barrier.

I think it is better to move the whole logic in the library - running
the ptheads and
synchronizing with mutex and barrier. The API caller (trace-cmd) will receive
only a pthread_t id of the running thread, created by the library.

>
> -- Steve
>
>
> > +
> >       pthread_exit(0);
> >  }
> >
> > @@ -106,6 +111,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
> >               instance->tsync.clock_str = strdup(top_instance.clock);
> >       pthread_mutex_init(&instance->tsync.lock, NULL);
> >       pthread_cond_init(&instance->tsync.cond, NULL);
> > +     pthread_barrier_init(&instance->tsync.first_sync, NULL, 2);
> >
> >       pthread_attr_init(&attrib);
> >       pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> > @@ -117,6 +123,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
> >               if (!get_first_cpu(&pin_mask, &mask_size))
> >                       pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
> >               instance->tsync_thread_running = true;
> > +             pthread_barrier_wait(&instance->tsync.first_sync);
> >       }
> >
> >       if (pin_mask)
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
