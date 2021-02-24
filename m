Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9BFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 05:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613ED64E6C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 05:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhBXFXI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhBXFXH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 00:23:07 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF66BC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 21:22:26 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c11so569745pfp.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 21:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hlSyx/BaQObVZ0mqWie1SAbSxYpBOQjPBs3pMtKAtow=;
        b=I8znXHXubO2ldARPNcTNC+NDfjuaYoR13IiPuLVpOcGlvTwtjz8QpOgb41pqpcek14
         cCT7lk9TcU+njN+YKVaau/jsfDeOwMO2I/9w2tOb+f7KOZkTeo4oUkqjLS3f1qGznHDw
         M7h3p7fka4KXTC3jXTN54otWI4EkKc11zlxTPZhpMZoSF0Am9U+n4AaN1tEPX02vgD2X
         RGd7BOhwH+paL5eY0uqAKeTY+7ribSCtSNuCNMxc+/BMtYBNkBlYo+lBsaXzvGgcs2Xk
         S/HTlBnz1i5bUA+XrGGmFBrbA1D0x+uZRp0UY0eZN1JavUEizTljf2pwx3+GaMYDZvGn
         U6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hlSyx/BaQObVZ0mqWie1SAbSxYpBOQjPBs3pMtKAtow=;
        b=ZB4EZ3YIFcQKPrDXS8G7mhDmEgwxKNM6O5E+RLmgAYtnr5IqrlmImDKqzWPWDSnKSP
         lwQwzb3t2onQ/aHLncepyNLNCFGsvc1piHYwn+d68d+sKQ64/0waMQvMN16he5u+UE7P
         WUcQp3edalz7R6gZ3tFg5HHrE7NrUGRe/Le/LGUCnf7GfmyuNXuLOPWAxZGBXoVykWBF
         xvOsPja0w4om59zlJVSVPZHg1OvaZKUBU5V9Lv3z/0cooGyoGHrlZgyz5++GN9/1X8J3
         YWYUaiP925dye++Uoch8a+qOPkG8DNdv3OZo+xmKUrIukD0K6/MLcWBcbyx8Y5JKq/A2
         TjYw==
X-Gm-Message-State: AOAM5315CEv63fP/EcR7cgutmrzg8ZZZXtFryEoFZQ8KBUUiIeted3ev
        QL6V7cFXm/U4YSEtJriFKu/GwMt7CjiVS7d9mfSHhGFjPygFlw==
X-Google-Smtp-Source: ABdhPJxhnWQHoDCWf10nPd8tsz3ooZI1k+S7Snguu1+tCR+N58AfMZ62NPgh4yJkoYQcy5LocQ0fmJpaMqU2eZsKgI0=
X-Received: by 2002:a62:144f:0:b029:1ed:9646:736a with SMTP id
 76-20020a62144f0000b02901ed9646736amr5721198pfu.81.1614144146313; Tue, 23 Feb
 2021 21:22:26 -0800 (PST)
MIME-Version: 1.0
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
 <20210219053156.2235035-2-tz.stoyanov@gmail.com> <20210223171819.3b42b9e8@gandalf.local.home>
In-Reply-To: <20210223171819.3b42b9e8@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Feb 2021 07:22:09 +0200
Message-ID: <CAPpZLN7Ghth=9uxpu2oYAPbAHO0N2SBYbw0502fEWedEyZPzQg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven


On Wed, Feb 24, 2021 at 12:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 19 Feb 2021 07:31:55 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > trace.dat files have multiple sections, which must be in strict order. A
> > new logic is implemented, which checks the order of all mandatory
> > sections when reading and writing trace files. This validation is
> > useful when the file is constructed in different machines -
> > host / guest or listener tracing. In those use cases, part of the file
> > is generated in the client machine and is transferred to the server as
> > a sequence of bytes. The server should validate the format of the received
> > portion of the file and the order of the sections in it.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
>
> >  /* --- Opening and Reading the trace.dat file --- */
> >
> > +enum  {
> > +     TRACECMD_FILE_INIT,
> > +     TRACECMD_FILE_HEADERS,
> > +     TRACECMD_FILE_FTRACE_EVENTS,
> > +     TRACECMD_FILE_ALL_EVENTS,
> > +     TRACECMD_FILE_KALLSYMS,
> > +     TRACECMD_FILE_PRINTK,
> > +     TRACECMD_FILE_CMD_LINES,
> > +     TRACECMD_FILE_CPU_COUNT,
> > +     TRACECMD_FILE_OPTIONS,
> > +     TRACECMD_FILE_CPU_LATENCY,
> > +     TRACECMD_FILE_CPU_FLYRECORD,
>
> I still really don't think we want to make LATENCY and FLYRECORD states.
> Because they are not a state of the trace.dat file, but a type.

I considered these as states, as any of the previous states, that indicate
what kind of data is currently in the file. We can replace both with a single
TRACECMD_FILE_CPU_DATA state, and use the old TRACECMD_FL_
flags to find what kind of tracing data is in the file.

>
> Unless we document here that they are the last states of the file, and once
> reached, the state can not change.

This is true for the current tarce.dat file format - they are the last states
and as for the all other states - once reached, previously written data
cannot be changed. May be I cannot understand your point here, may
be you mean that once these final states are reached, the tracing data
is still not written in the file (read from the file) ? In that case may be it
is more logical to add additional state, to indicate that all trace data is
in the file, regardless of its type (cpu / latency) ?

>
> But is that the case? We may want states about reading
>

I use the same logic for both reading and writing the file. When reading
a file and if one of the TRACECMD_FILE_CPU_ states is reached, the
tracing data is ready to be read.

> > +};
> > +
> >  enum {
> >       TRACECMD_OPTION_DONE,
> >       TRACECMD_OPTION_DATE,
> > @@ -115,9 +129,7 @@ enum {
> >  enum {
> >       TRACECMD_FL_IGNORE_DATE         = (1 << 0),
> >       TRACECMD_FL_BUFFER_INSTANCE     = (1 << 1),
> > -     TRACECMD_FL_LATENCY             = (1 << 2),
> > -     TRACECMD_FL_IN_USECS            = (1 << 3),
> > -     TRACECMD_FL_FLYRECORD           = (1 << 4),
> > +     TRACECMD_FL_IN_USECS            = (1 << 2),
> >  };
> >
>
> > @@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
> >        * Check if this is a latency report or flyrecord.
> >        */
> >       if (strncmp(buf, "latency", 7) == 0)
> > -             handle->flags |= TRACECMD_FL_LATENCY;
> > +             handle->file_state = TRACECMD_FILE_CPU_LATENCY;
> >       else if (strncmp(buf, "flyrecord", 9) == 0)
> > -             handle->flags |= TRACECMD_FL_FLYRECORD;
> > +             handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
>
> What happens when we change states after this? Or is this going to always
> be the last state of the file?
>
> What if we want to change the state after we read the CPUs, or for the
> latency, we may want to change the state after reading the trace file.
>
> The more I think about this, the more having them be states does not make
> sense. They are the type of file, and should stay as flags.
>
> What benefit do you see for keeping them a state?
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
