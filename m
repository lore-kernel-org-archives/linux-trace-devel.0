Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6916C3F2D7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD1321744
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpJztfo1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCDJME (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42609 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDJME (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id h8so686082pgs.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pfEmtZdVNCH0SdA/JRnGjHOOTArIgChCgkopWhJuKyw=;
        b=FpJztfo1yEDzlcD2ETIC18exoQcKX5zrB8gXjcBJKFOK0lCh76OdsF+sKqO4WnzPS6
         tySuwtMqIkvMO7WL9LvjyUdy5uKQ1VfiLGV83GcSa8qbiqi4CXPMDsZ/5Z9EUk+xhRmx
         kmwlIKQI/3/mIUv7UQ8aMxTyh2KHfW522Zkc5t9GG10nvs0w0vYpWZWjF3k04yv8ocbb
         n5jTz82jD4XADmghoho+yezncw26lfM+bZKiciI2kH8TsPD+DrdXAieTW9jQPWvzRrBO
         6ws9A2L/ref7ejvErQR1r3S9ANcRkd28MEYLOUGCzQ3Drl8RB+C9NbtOR4MUr/qZHCjQ
         9xnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pfEmtZdVNCH0SdA/JRnGjHOOTArIgChCgkopWhJuKyw=;
        b=epNiPCP7EBk6Pg1kujuAP86OF1yxzZ1c7ZT0D4+MMY3KHOR+9UN6HEFqr3bTNhvF5X
         00gXLIJwJSM+MskcY75kVc4IyRQJBTgd+SwVnMvZB6MStny9pcSyEBe5u7dZLCHE7Tae
         d4pimdopXyL7J4+oj7NH97A+9gt8OWunxuRHyOrA52+fRM8mMXHjbLJIuNS8Ma78HAxk
         PYddMMCiI1qMbQeayUpkmGfUZKfPf0B/QPFCAund74m2a+21CPBTnoGnhXr1wP/AHzXc
         dnjF6cxevk/dOcFGA0W1oc0i83oDqinHHB5Afaf7LH6SQVBBv2jm4pr/I4zdIsUy1b5u
         XAIw==
X-Gm-Message-State: ANhLgQ1jhRQRQeI9tFycTp4/qA8/zxyMkAMi3fbqvXV8GRKBV4MB++Js
        eodLy3hrmESFKAGulHhlwt1Dc+8eY7zDTjMUByyxNPhZ
X-Google-Smtp-Source: ADFU+vtAQ3zOshOvyW0UQcnP6mkr+CpoBe/5dWAWXqalm3vg4JWrgvrszg1Jxags1EOtYbBd4R1KUE7WNUODuAN0myk=
X-Received: by 2002:a63:30c2:: with SMTP id w185mr1748551pgw.307.1583313123118;
 Wed, 04 Mar 2020 01:12:03 -0800 (PST)
MIME-Version: 1.0
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
 <20200302101404.150035-12-tz.stoyanov@gmail.com> <20200302114335.364b10e1@gandalf.local.home>
In-Reply-To: <20200302114335.364b10e1@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 4 Mar 2020 11:11:51 +0200
Message-ID: <CAPpZLN4EsGJPZzGaXRgXspWmJ5MCLtB_CG2eHKp954OzLxffhg@mail.gmail.com>
Subject: Re: [PATCH v21 11/13] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 2, 2020 at 6:43 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  2 Mar 2020 12:14:02 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -940,7 +1215,11 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
> >       write_uints(msg->buf, data_size, ports, nr_cpus);
> >
> >       msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
> > -     msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
> > +     msg->trace_req.flags = use_fifos ? MSG_TRACE_USE_FIFOS : 0;
>
> Is there a reason to use "msg->trace_req" instead of "msg->trace_resp"?
>

No, it looks like a copy - paste error from a wrong place.

> -- Steve
>
> > +     msg->trace_resp.flags = htonl(msg->trace_resp.flags);
> > +     msg->trace_resp.tsync_proto = htonl(tsync_proto);
> > +     msg->trace_resp.tsync_port = htonl(tsync_port);
> > +
> >       msg->trace_resp.cpus = htonl(nr_cpus);
> >       msg->trace_resp.page_size = htonl(page_size);
> >       msg->trace_resp.trace_id = htonll(trace_id);



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
