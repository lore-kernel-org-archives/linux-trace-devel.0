Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283B8C432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE93C21741
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2hauguA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK1PIq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 10:08:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44385 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1PIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 10:08:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id w8so11997830pjh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 07:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1BX9TpRfttL6wG2miaxB3O9B1b8UFBfqREvadO+UD8=;
        b=L2hauguAc48lGfI7pJd9Iqs273qnkUUMQm7A72Ah7tASrilvTXud82uHvLibo5nbzF
         +72JBzUL08G3Du+K0s9Nu9HL7d9SVuiNSB7y3qNmL+ifDgzB0mCAhcVN2tRRRByIHuyl
         ZqMqjSeDmXBVyQZhVnuvZvLr2oMXF9OfBhr4poCE8/VJ41Zh1a6e0Z4+jEM2CXy/SYRN
         5dZKpCgeTkDXPh84Sl6HdsgK7PpF97+oH3ry2ZJXiug3VUrCiDPjMwpizRtbhG4z+6hg
         amI9MQbNoNWVAfR1Oc82wVfHKRPMRwvQwAqNIANE9CMzw3JqtVZH9RIPlU6XLUaqLFkt
         hMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1BX9TpRfttL6wG2miaxB3O9B1b8UFBfqREvadO+UD8=;
        b=Wjpbx4pWrxesrIagzks4sn6ICrBp6cqdbCTHlnNqarDfxBUcXoXg9I/dzcj18COXp/
         2MNe60cbcNe5Y0Cdj6h0ncmLhXmS7pF/6oyAPfEvIzfxbTgE8cFQix6xhGxLYrvn7ra4
         QkEVz5s/xvx9koxGdBjq+jl32PVEA8BAu8EeXJdxALSpR6E9cuh0K85EqWhBnOncnN5g
         QcqNlTJ0KoI5HdcmlhqeUK2WDMcFly0NWN7gY/OTRlxDgxJvN2lHh7Sopjz/XHrm+YcR
         lsRdd++PJw7yHa18MGEiRx5y17VMPh15Lxg4lvktPcAeJvKUwtZPpkjfjJru6XXBL9bX
         Rz7Q==
X-Gm-Message-State: APjAAAXnBLa0yg69h+KZPlu/ZrmkBx4ejZVEahsS/YXomuMinR3+AZ+t
        Q6ZgTEQNnwDcStxMhHOR4Wswh4J9xDoMHA4/Bj0=
X-Google-Smtp-Source: APXvYqzlBQQuRBgjYR2omRNbh+eolRE/ebpo6nZNyBTwBtWu8odMJ/DcgcgpOzpYqUnadLnanUuZ9T65bC9K8R1USQY=
X-Received: by 2002:a17:90a:2947:: with SMTP id x7mr13008318pjf.136.1574953724460;
 Thu, 28 Nov 2019 07:08:44 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
 <20191128085409.289684-16-tz.stoyanov@gmail.com> <CAE0o1NupdFjJLnQ1dKVEUh91_fBiTt1nok+_7mLiOSZpcbFGKg@mail.gmail.com>
In-Reply-To: <CAE0o1NupdFjJLnQ1dKVEUh91_fBiTt1nok+_7mLiOSZpcbFGKg@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 28 Nov 2019 17:08:33 +0200
Message-ID: <CAPpZLN7s=FwSPitTYCftR+yWuVK=18yXfw5bRm=o_xCGDcPWAA@mail.gmail.com>
Subject: Re: [PATCH v15 15/18] trace-cmd: Refactor few trace-cmd internal functions.
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 4:51 PM Slavomir Kaslev
<slavomir.kaslev@gmail.com> wrote:
>
> On Thu, Nov 28, 2019 at 11:01 AM Tzvetomir Stoyanov (VMware)
> <tz.stoyanov@gmail.com> wrote:
> >
> > In order to reuse code inside trace-cmd application context,
> > few functions are made non static:
> >         int make_vsock(unsigned int port);
> >         int get_vsock_port(int sd, unsigned int *port);
> >         int open_vsock(unsigned int cid, unsigned int port);
> >         char *get_guest_file(const char *file, const char *guest);
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/include/trace-local.h | 8 ++++++++
> >  tracecmd/trace-agent.c         | 4 ++--
> >  tracecmd/trace-record.c        | 8 ++++----
> >  3 files changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index a6f79c5..17ef31a 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -19,6 +19,8 @@
> >  #define GUEST_FIFO_FMT         GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
> >  #define VIRTIO_FIFO_FMT                "/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
> >
> > +#define TRACE_FILENAME         "trace.dat"
> > +
> >  /* fix stupid glib guint64 typecasts and printf formats */
> >  typedef unsigned long long u64;
> >
> > @@ -258,6 +260,12 @@ void tracecmd_disable_tracing(void);
> >  void tracecmd_enable_tracing(void);
> >  void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
> >
> > +int make_vsock(unsigned int port);
> > +int get_vsock_port(int sd, unsigned int *port);
>
> trace-agent.c is not getting compiled if VSOCK isn't defined so those
> functions won't be available then. Put them undef #ifdef VSOCK here
> too? Or have all vsock functions in a separate .c file, #ifdef-ed so
> that those functions do nothing when VSOCK is not defined?
>

The implementation is not tested yet with not defined VSOCK, I'll test
and fix those.
Thanks!

> > +int open_vsock(unsigned int cid, unsigned int port);
> > +
> > +char *get_guest_file(const char *file, const char *guest);
>
> Cheers,
>
> -- Slavi



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
