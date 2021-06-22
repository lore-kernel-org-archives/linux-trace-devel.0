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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60421C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 11:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F916128C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 11:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVLH7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 07:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLH6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 07:07:58 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370BDC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 04:05:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d12so2222329pgd.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Jun 2021 04:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FLPwcFT8N6yMYgdiUAZERsFpyu3agUdHQJQpTW5Xn64=;
        b=bIfY0fWQHsYW9XmiH/5G8msbZALYi/Qte2WwHmflo0ZiMBuKyVwdUvlR9XEhcfUgKE
         EGb/q4I8aGpK/keDD/oMCNXtnuXi/D3fEVqqzYEKu/c0x0sq3+gZHo4iuquNH2sxyN6d
         HFE4nGkeArizeU1lNP7YcxP2XRuHCGBCm6m4+OQv0P4GCckvOnC77s2r158v6Wtu5ItW
         eP1clJA6yvuJxeiCVxcDqFem0qwPI4A3qV186n7CZhPZlPgQHbK9tARY+059zyB4S6qz
         m/dpZmnKXCpTCb6mnkdXvKsbdSiG+d2YL/MmDkNvKCEdtgC1K9CzSUT9JfL85ubcLC1P
         JniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FLPwcFT8N6yMYgdiUAZERsFpyu3agUdHQJQpTW5Xn64=;
        b=hffFw25vXeWlu4rOmYcwPAjEz3TMQdPJDj2oUeK76MYc+VT4/iPPvXVuN5fLvMYptb
         XuUP6IqICLDP/wpsZ0YQx1RChIz33pKAZ7e/nk2IpSNfxwJ9jfjMIM8xmnNj0zETIY5N
         2Df16Vul6HfverfNjBjKCy4frnQDEK0jj0tUOytvdo6s4byW8LdXpl7Bm2YeBbc4XX1K
         am2M/hYZ1jueOmacRuyYCgSwHzVXHBOlXQLb/6t+MbesxHr6ntU3QMQ87usGXz3GxcDh
         fgL9KLSDjt1JU98NMxx6yh6QhrfhSiwxIVI/emuuB7aISKFG0nKAUqgOTnL/PuPNj22u
         6E+g==
X-Gm-Message-State: AOAM531SqPhWKb+F04/MpJf8MlIijRfxCFCpfM3tW1Jewy6tKkGBzzHc
        hSM2z4NhrnkgPWVy2MYFQjkIdqahZbN2r78t1B4=
X-Google-Smtp-Source: ABdhPJwnlGskJx0FMESjkTibZ4c2z9rwcY12e0sbl/T0UE6NsCRe4yd9Q5V5leN6niEvJEnXvyYOWr0ISHu8hjj5wlo=
X-Received: by 2002:a65:41c6:: with SMTP id b6mr3271506pgq.206.1624359941698;
 Tue, 22 Jun 2021 04:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
 <20210614075029.598048-46-tz.stoyanov@gmail.com> <20210621203716.17121623@oasis.local.home>
In-Reply-To: <20210621203716.17121623@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Jun 2021 14:05:25 +0300
Message-ID: <CAPpZLN5NA9mTN-C8x3DwrrxukKns1gSucZr1DxBCq=KAOES-LA@mail.gmail.com>
Subject: Re: [PATCH v6 45/45] trace-cmd: Update trace.dat man page
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 3:37 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 14 Jun 2021 10:50:29 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Updated the trace.dat man page with the changes related to file
> > version 7 and compression.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  Documentation/trace-cmd/trace-cmd.dat.5.txt | 56 ++++++++++++++++++---
> >  1 file changed, 50 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/trace-cmd/trace-cmd.dat.5.txt b/Documentation/trace-cmd/trace-cmd.dat.5.txt
> > index 8d285353..e80d460e 100644
> > --- a/Documentation/trace-cmd/trace-cmd.dat.5.txt
> > +++ b/Documentation/trace-cmd/trace-cmd.dat.5.txt
> > @@ -52,6 +52,23 @@ INITIAL FORMAT
> >    The next 4 bytes are a 32-bit word that defines what the traced
> >    host machine page size was.
> >
> > +  If the file version is 7 or greater, the compression header is
> > +  written next:
> > +     "name version\0"
>
> I wonder if we should make it: "name\0version\0"
>
> Also, I think "none" is acceptable, where none of the sections are
> compressed. If we add something special for a version 7 but don't want
> to compress, we need to support that.
>
> > +  where "name" and "version" are strings, name and version of the
> > +  compression algorithm used to compress the trace file.
> > +
> > +COMPRESSION FORMAT OF THE HEADER SECTIONS
> > +-----------------------------------------
> > +  If the file version is 7 or greater, some header sections are compressed
> > +  with the compression algorithm, specified in the compression header.
> > +  The format of these compressed sections is:
> > +     <4 bytes> unsigned int, size of compressed data in the next block.
> > +     <4 bytes> unsigned int, size of uncompressed data.
> > +     <data> binary compressed data, with the specified size.
> > +  These sections must be uncompressed on reading. The described format of
> > +  the sections refers to the uncomperssed data.
>
> I think each section should have a flag that states that it is
> compressed or not. That way we could have options that determine "what"
> gets compressed, and not have it be all or none.

I was thinking the same, but could not find a use case. That means to
give control to the user to decide what parts should be compressed.
This will complicate the implementation, new trace-cmd parameters
should be added. As I couldn't thought of a use case, decided to go
with the simpler approach. May be it makes sense only for the trace
data, but the metadata should be always compressed if possible.

>
> > +
> >  HEADER INFO FORMAT
> >  ------------------
> >
> > @@ -93,7 +110,8 @@ FTRACE EVENT FORMATS
> >
> >    Directly after the header information comes the information about
> >    the Ftrace specific events. These are the events used by the Ftrace plugins
> > -  and are not enabled by the event tracing.
> > +  and are not enabled by the event tracing. If the file version is 7 or
> > +  greater, this section is compressed.
>
> Perhaps add a single byte ahead of each section, where "0" is not
> compressed, and "1" is compressed?
>
> >
> >    The next 4 bytes contain a 32-bit word of the number of Ftrace event
> >    format files that are stored in the file.
> > @@ -110,7 +128,8 @@ EVENT FORMATS
> >  -------------
> >
> >    Directly after the Ftrace formats comes the information about
> > -  the event layout.
> > +  the event layout. If the file version is 7 or greater, this section
> > +  is compressed.
> >
> >    The next 4 bytes are a 32-bit word containing the number of
> >    event systems that are stored in the file. These are the
> > @@ -137,7 +156,8 @@ KALLSYMS INFORMATION
> >  --------------------
> >
> >    Directly after the event formats comes the information of the mapping
> > -  of function addresses to the function names.
> > +  of function addresses to the function names. If the file version is 7
> > +  or greater, this section is compressed.
> >
> >    The next 4 bytes are a 32-bit word containing the size of the
> >    data holding the function mappings.
> > @@ -154,6 +174,7 @@ TRACE_PRINTK INFORMATION
> >    store the format string outside the ring buffer.
> >    This information can be found in:
> >    debugfs/tracing/printk_formats
> > +  If the file version is 7 or greater, this section is compressed.
> >
> >    The next 4 bytes are a 32-bit word containing the size of the
> >    data holding the printk formats.
> > @@ -166,7 +187,8 @@ PROCESS INFORMATION
> >  -------------------
> >
> >    Directly after the trace_printk formats comes the information mapping
> > -  a PID to a process name.
> > +  a PID to a process name. If the file version is 7 or greater, this
> > +  section is compressed.
> >
> >    The next 8 bytes contain a 64-bit word that holds the size of the
> >    data mapping the PID to a process name.
> > @@ -193,10 +215,11 @@ REST OF TRACE-CMD HEADER
> >
> >      "flyrecord\0"
> >
> > -  If it is "options  \0" then:
> > +  If it is "options  \0" then follows a section with trace options.
> > +  If the file version is 7 or greater, this section is compressed.
> >
> >    The next 2 bytes are a 16-bit word defining the current option.
> > -  If the the value is zero then there are no more options.
> > +  If the value is zero then there are no more options.
> >
> >    Otherwise, the next 4 bytes contain a 32-bit word containing the
> >    option size. If the reader does not know how to handle the option
> > @@ -206,6 +229,25 @@ REST OF TRACE-CMD HEADER
> >    The next option will be directly after the previous option, and
> >    the options ends with a zero in the option type field.
> >
> > +COMPRESSION FORMAT OF THE TRACE DATA
> > +------------------------------------
> > +
> > +  If the file version is 7 or greater, the tarce data is compressed
>
> Typo "trace data"
>
> And this is where we definitely need to make it optional. We currently
> do not have a safe way to read this file. The "uncompress to /tmp" is
> not a reliable way to do this. And again, people can likely want to
> have the header compressed but not the data, due to speed in reading.
>
> -- Steve
>
> > +  with the compression algorithm, specified in the compression header.
> > +  The data is compressed in chunks. The size of one compression chunk
> > +  is defined when the file is written. The format of compressed trace
> > +  data is:
> > +     <4 bytes> unsigned int, count of chunks.
> > +     Follows the compressed chunks of givent count. For each chunk:
> > +        <4 bytes> unsigned int, size of compressed data in this chunk.
> > +        <4 bytes> unsigned int, size of uncompressed data.
> > +        <data> binary compressed data, with the specified size.
> > +  These chunks must be uncompressed on reading. The described format of
> > +  trace data refers to the uncomperssed data.
> > +
> > +TRACE DATA
> > +----------
> > +
> >    The next 10 bytes after the options are one of the following:
> >
> >    "latency  \0"
> > @@ -217,6 +259,7 @@ REST OF TRACE-CMD HEADER
> >    If the value is "latency  \0", then the rest of the file is
> >    simply ASCII text that was taken from the target's:
> >    debugfs/tracing/trace
> > +  If the file version is 7 or greater, the latency data is compressed.
> >
> >    If the value is "flyrecord\0", the following is present:
> >
> > @@ -232,6 +275,7 @@ REST OF TRACE-CMD HEADER
> >  CPU DATA
> >  --------
> >
> > +  If the file version is 7 or greater, the CPU data is compressed.
> >    The CPU data is located in the part of the file that is specified
> >    in the end of the header. Padding is placed between the header and
> >    the CPU data, placing the CPU data at a page aligned (target page) position
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
