Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A922C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72C720731
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z6s+FH8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgAFOnP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:43:15 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33292 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgAFOnP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 09:43:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id z16so27079393pfk.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 06:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoD+Hn6fpaBjOiEYuduw/Bhe1dQrkZUnH+6Y+KOsy8w=;
        b=Z6s+FH8euzb0Fa4vJghRP1IfPa+3MyCrLhNodQYB5OeG6XQGbc/GGlkfeClulnlEH8
         ag/EJVTdPnizJOPD4Kr/zV3/6AYuGFE+u2HTcPSIOhuvz8g8xKOlvO29YzfBtUygJPHO
         F8wS7innCk0RGQ/ZErGi1wO8QRodwQmG2hCenBVFr4m/yyM+Z+eLD/cQd7+y4QoUWTFX
         /9UUnVFx+1WV3ydu2g41PuzgisKpzggIBhlYyR314CW+EGC3+bQVHTx8Nd3WI5QvcPB5
         jp0eduxwd8VmawsqsLP+hfpnn/JFQBPqxe/DxwrQZhVz46ZuuC97yafYiI1OACwQ0el3
         esAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoD+Hn6fpaBjOiEYuduw/Bhe1dQrkZUnH+6Y+KOsy8w=;
        b=Ro/F8l2OK5dJ6SzHhHjXyGhpSr852wjVcdZeCuKUIaU3ZzRtf+uJHKfrjYczJHqqwZ
         cHTsKMJNUW2Q3fYhOOk7e1GNpxzw7ZK9WwR8eIUusI0P3w2CS+iJ3n84ozzNl4DkjBwp
         niB4Yo5xab7wK1MtuEsr7OK47/ShysdSNmk4YQAT18rAVHdRHcWBHbZ0mT5h1+O8D3D2
         R7qTRQkyt6Rw1Jvy+Y0ka11CBX+M7u3AuAkLAv6d66hc+/mp9BR32RaHCJ45cPNa8GnI
         jIbtJ+JvmDp44GTbkqIASyvs8T1/rVZFvVTrB04NwhBI9i4iB+siQau4T3W9AOnXLC31
         nqrg==
X-Gm-Message-State: APjAAAWdj+Hs8cl+aFdYiZWv07yUpqwCM03d3d2BDa58BCd5GHYSZ3zP
        eDBAYnILihzd8RsbNnJ2R8QabrqmHnJ8Z/L57OTccHxEzVI=
X-Google-Smtp-Source: APXvYqxf0haA4JKW+GFlmDyaL0vhypcCsBtXfHfliOwiSdjvb20YDXrv5SJBONMp5FdiKVXlyMUoMCtXr3KCmsag+fs=
X-Received: by 2002:a63:2cc8:: with SMTP id s191mr110369386pgs.206.1578321794949;
 Mon, 06 Jan 2020 06:43:14 -0800 (PST)
MIME-Version: 1.0
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
 <20191213153029.133570-14-tz.stoyanov@gmail.com> <20191220155221.6face370@gandalf.local.home>
In-Reply-To: <20191220155221.6face370@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Jan 2020 16:43:03 +0200
Message-ID: <CAPpZLN5HaooBR4i=gb874eyTVBjdtwT2e=3G7+1gBv1yqiBOPw@mail.gmail.com>
Subject: Re: [PATCH v18 13/18] trace-cmd: Add guest information in host's
 trace.dat file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 10:52 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 13 Dec 2019 17:30:24 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > New trace.dat option is introduced: TRACECMD_OPTION_GUEST.
> > Written in the host's trace.dat file, it contains information about
> > guests, traced at the same time: guest trace ID, number of VCPUs and
> > PIDs of the host tasks, running those VCPU. The data is stored in
> > the file as NULL terminated string:
> >       "Guest %s %llu %d\n" -> guest name, number of VCPUs
> >       "%d %d\n" -> VCPU, PID of host task
> >       .....
> >       "%d %d\n" -> VCPU, PID of host task
>
> Why is this a string, and not a structure?

To avoid endian long long conversions, and to simplify reading of
trace.dat file, for debug purposes.
I would suggest to keep it text, for two reasons:
 - this information is not huge, the binary format will not reduce the
size of the trace.dat file significantly.
 - it is very useful to be possible to check what guest information is
stored in the file, using simple cat

We could think of implementing some stand alone trace.dat file reader,
to extract and display that meta data information.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
