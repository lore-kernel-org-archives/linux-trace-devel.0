Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BF3C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 07:06:00 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38797206A1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 07:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMIwArYi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38797206A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-trace-devel-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgDMHF7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 03:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbgDMHF7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 03:05:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCCAC008678
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 00:05:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kx8so3465386pjb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 00:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2OC23CwotOT/1IxWlqonNBF0V/vMydcepBB7/KUApQ=;
        b=HMIwArYi9/5wyB1go5o5mXIG15IS77ByNyT1XmoFhkpLc4E0VU1PHNJmI4tzmhu77y
         fRaMq/SvmQH5N8cuUYT24IoVIavtO2oXtVUr1tXTn+VdrfuI0Lp9ZGE1GVRyGRzJpQAe
         z9ibpa0w17du1qzRDGpg2RyoQchttt5q4nifLQ58HBHHJUhvu+KjjYMoHbLszNIfwlFN
         xl6Hz5AHMlL7F39UJEsGg92PJ/w7xEIihAoLOT/ZXBc/FfVF1ligWq4g0PWqubNWNsFW
         W34bHvV4MkvCWw90PCVWO2ITvBOBbYVkiCbrofxXHT2B8DUATwTgeKo0/GWXk5wmgGjU
         V03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2OC23CwotOT/1IxWlqonNBF0V/vMydcepBB7/KUApQ=;
        b=HvPFIjiFZpVjhiM+LGBscgsMhr76tAtymQ5msBQffzzSrFWJcokxeKZCv+7J6VAU99
         nVNs0OPYvl2DaXgkBo9OadJT1EZZDyEz/Ye3pcFq68hTwfwwz6quK7ZNXqnfqmZHYybS
         ZUtVZDTzCfkY3SVfeTQYQ2jUhDPN+6iJSgORGrpT/8bBwhdW4h+J4V6kFd9S7LYWE7Kp
         k/Ha9qs6lurGGCVIhIK1XDzD1utvb/LAfiQJ6luObU/8yIJ2zRcXEsWAOU0K23Zc9zIg
         gPkRAGBFYjV6D8o9Tq9b2quLXVGkpjZH4TDR7iwfeUP/MD4EJPGS5Aol/Q/BTvUbCW44
         U/Zg==
X-Gm-Message-State: AGi0PubT03MA5i0Mdk/C9F6Q+gZ7gP6h9WvN9GC42AcW5LPUZJQtd3Rr
        VRCDnTdTbf7wc8SiL8lZNL3D3k214rpQaem1WwxtRh96
X-Google-Smtp-Source: APiQypI60onaoP3O/ubNPbzDmilODk6D21RuVPXudgMa5ZewLFcHtJyJJ6yBKsEyYklaS98a3nrdNckoRWZjjMdDr5E=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr20016596pjb.145.1586761557376;
 Mon, 13 Apr 2020 00:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200409132835.79530-1-tz.stoyanov@gmail.com> <20200409132835.79530-2-tz.stoyanov@gmail.com>
 <20200409210713.6a0fccfa@oasis.local.home>
In-Reply-To: <20200409210713.6a0fccfa@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 13 Apr 2020 10:05:46 +0300
Message-ID: <CAPpZLN6KDSMbT95EH-PKXTKD7iyJfrA2XHivwWrfKHKP41h60Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace-cmd: Add new API tracecmd_set_merge_peer()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 10, 2020 at 4:07 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  9 Apr 2020 16:28:34 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +/**
> > + * tracecmd_set_merge_peer - Link a tracing peer to this handle
> > + * @handle: input handle for the trace.dat file
> > + * @peer: input handle for the tracing peer
> > + *
> > + * When tracing host and one or more guest machines at the same time,
> > + * guest and host are tracing peers. There is information in both trace
> > + * files, related to host PID to guest vCPU mapping, timestamp synchronization
> > + * and other. This information is useful when opening files at the same time and
> > + * merging the events. When the host is set as a tracing peer to the guest, then
> > + * the timestamps of guest's events are recalculated to match the host event's time
> > + */
> > +int tracecmd_set_merge_peer(struct tracecmd_input *handle,
> > +                         struct tracecmd_input *peer)
>
> I wonder it would be better to call this tracecmd_pair_peer(), like
> pairing a bluetooth headset with your phone?
>
> > +{
> > +     if (!handle)
> > +             return -1;
> > +
>
> This should probably fail if the host.peer_data is already set. Which
> means we should also have a way to unmerge (unpair) the two. Which is
> why I like the term "pair" better, as it is like paring a bluetooth
> device and then unpairing it.
>
> -- Steve
>
>
It makes sense, I'll send the next version with these changes.
Thanks, Steven!

> > +     handle->host.peer_data = peer;
> > +     tracecmd_ref(peer);
> > +     tsync_check_enable(handle);
> > +
> > +     return 0;
> > +}
> > +
> >  /**
> >   * tracecmd_ref - add a reference to the handle
> >   * @handle: input handle for the trace.dat file
> > @@ -3785,7 +3839,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
> >   */
> >  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
> >  {
> > -     return handle->host.trace_id;
> > +     return handle->host.peer_trace_id;
> >  }
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
