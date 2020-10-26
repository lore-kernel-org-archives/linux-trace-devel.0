Return-Path: <SRS0=0pJJ=EB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB34FC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2C7223AB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDoe4FaV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769971AbgJZHiV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Oct 2020 03:38:21 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55980 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769970AbgJZHiU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 03:38:20 -0400
Received: by mail-pj1-f68.google.com with SMTP id c17so2746641pjo.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Oct 2020 00:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztabRgQCO4tzpda0ipjhj3iQW4nXr8tYeNkQTKDBNlY=;
        b=iDoe4FaVziGqU3RYVP8nZQXGQw1GTcnfXTwkbRgHCRwSNEats+yNs/w4w0y89OpSJO
         hC7qGVs8aTKg2N3QiPg7x4xJbLNov5Sn/1tmMKfEmPgrjrYjQkXpUbl9J9Cv33ES4J+C
         NOX0+QIkGOWyecbyopFcOsGrJhI6IsLKbohtczq/LpM3ZQUCI97Ua/ryXZt9H4JNqbmd
         5HOWXuBeGxr7BhkYVXF3/5/fW1O+Knkcj1g7JlcDss/Z4apc8BxpZBAD9r4e8Y8QhYeW
         oPJd8QJZlWc19zD3ais2om9cSQEFW/1mbQQ8ksw3uitAYDTRBD+CZAgFikZW2UjoeZhO
         U/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztabRgQCO4tzpda0ipjhj3iQW4nXr8tYeNkQTKDBNlY=;
        b=M9pZOZw2DnV/5VJKI7wEkAS4Zr/+/Ts+9DsUzRe3XuYnDFBTKcuF790SBpKYksJo3m
         SWbAR7bRpn8gOHsf20/YnXep2lHaRHLK+3vArqtXnZwj2JLwnepjN5h2A7V7wuuvOFWJ
         rN4O258f8mF0rWE+L5dOz0608RM9m1ENXXrbl0Zw6+RggF37TrmLRiSxjNrO81cKl/wu
         Kzh+ddNf+FmyAV58jl30iYfHgdJJelWXpOCSmVW2P0mgtgY/Grb+P0/Hb10LTkyNzB2M
         iFAbP11WkpBGhoKILWbkS1c6MxdkvCV1JgvbVol5XGaHR2+IV2bLcyUZst6WseKmA8Jk
         oBlA==
X-Gm-Message-State: AOAM531FFvUeYvIWiVBSZUT4C3jnzCupFVJmv/LCnzdIGmmLMYY6j6xs
        kX0IWzR2yrXyAUYhF57HcAArILpSwWtAXlSenojBh8/0gtc8lVJ+
X-Google-Smtp-Source: ABdhPJyApIj4VemZ5MZAVj52Z8kr5T7/XrU7wHjAGyCAKY5blFa2txkFsDFKVwYqGJk5K+93i/liI31rIgQLxiwQJM4=
X-Received: by 2002:a17:90a:498d:: with SMTP id d13mr18904360pjh.100.1603697899930;
 Mon, 26 Oct 2020 00:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201009140338.25260-1-tz.stoyanov@gmail.com> <20201009140338.25260-2-tz.stoyanov@gmail.com>
 <20201015172420.699a4cdc@gandalf.local.home>
In-Reply-To: <20201015172420.699a4cdc@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 26 Oct 2020 09:38:03 +0200
Message-ID: <CAPpZLN6C8Q1EJLurdmTTZ44m-eA6Jk0yE8qGA9B+fa7=hbY5sg@mail.gmail.com>
Subject: Re: [PATCH v24 01/10] trace-cmd: [POC] PTP-like algorithm for host -
 guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 16, 2020 at 12:24 AM Steven Rostedt <rostedt@goodmis.org> wrote:
[...]
> > +
> > +static void ptp_probe_store(struct ptp_markers_context *ctx,
> > +                         struct ptp_marker *marker,
> > +                         unsigned long long ts)
> > +{
> > +     int index = -1;
> > +
> > +     if (marker->data.packet_id == 'r' &&
> > +         marker->data.count <= ctx->size) {
> > +             index = marker->data.count - 1;
> > +     } else if (marker->data.packet_id == 's' &&
> > +               marker->data.count*2 <= ctx->size){
> > +             index = ctx->size / 2 + marker->data.count - 1;
>
> These calculations should be turned into macros, or at the very least have
> comments to why this is done.
>
> Also, data.count for both should always be less than or equal ctx->size /
> 2, right?
>
> If the ctx->size is for both, then the count should only be half. Wouldn't
> the 'r' packet start writing over the 's' packets if it is not? If this is
> the case, then we could simplify this to:
>
>         if (marker->data.count > ctx->size / 2)
>                 return;
>
>         index = marker->data_count - 1;
>
>         switch (marker->data.packet_id) {
>         case 'r':
>                 break;
>         case 's':
>                 index += ctx->size / 2;
>                 break;
>         default:
>                 return;
>         }
>
>         ctx->msg.samples[index].id = marker->data.count;
>         ctx->msg.samples[index].ts = ts;
>         ctx->msg.count++;
>
> BTW, when would the samples[index].id ever equal to something other than
> the index + 1, or index + size / 2 + 1?
>
I'll add comment to the ptp_probe_store() function, describing its
logic. It is a little
bit confusing, as it handles both cases - server and client. The
server tracks both sent
and returned probes, in that case the array size is 2 * max data count
- first are stored
returned probes, after them are sent probes. In the client context,
there are only returned
probes and the array size is max data count. The samples[index].id is
always the count
of the current probe, it could be index + 1 or index + size / 2 + 1
only, no other values.
I store it in the ID field, as in the server context there are two
entries (sent and received)
with the same probe count, and it is easier to match both based on
this ID when do the
calculations. I can use the index only, to find both sent and returned
probes and to assume
that both probes match, but I prefered to use this ID to verify if
both records are from
the same probe.

[...]
> > +
> > +     bin = (offset_max - offset_min) / PTP_SYNC_LOOP;
> > +     for (i = 0; i < k; i++) {
> > +             ind = (llabs(offsets[i]) - offset_min) / bin;
> > +             if (ind < PTP_SYNC_LOOP) {
> > +                     hist[ind]++;
> > +                     if (max < hist[ind]) {
> > +                             max = hist[ind];
> > +                             *offset_ret = offsets[i];
> > +                             *ts_ret = timestamps[i];
> > +                     }
>
> I'm curious to how accurate this is?
>
Using the histogram logic, an accuracy from 200ns up to 15 000ns can
be achieved,
results vary a lot. The accuracy of the fastest response logic is
around 1000ns - 3000ns usually.

> -- Steve

Thanks Steve!
I'll send the next version of the patch set addressing these comments.

>
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
