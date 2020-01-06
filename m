Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4505C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94ED6207FF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFC/hHPX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFWAo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 17:00:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36854 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgAFWAo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 17:00:44 -0500
Received: by mail-qk1-f196.google.com with SMTP id a203so41262014qkc.3;
        Mon, 06 Jan 2020 14:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0qI/WIP6bcYgKcafJAsqXV9B70atJbPQW4w3BJL+MGE=;
        b=sFC/hHPXxaQxTVKScyhGgxFuVGHwopBJyX/r9ZP20yrZLHb2wE9P1uDZcoIXx23FwI
         h7AKeFN4wZuWBLGrLqvHFEAnE68zDfHbCOaIdCkFzj8zGky0wveEh+Z080yDDZONf6ne
         gBuAIzCe72m3rMuua37uGUlqnvHFZwB5vwIQtfSj2Ct7Mf0a+cWrQ533mvmYKD8lJ58F
         jh/QV+/3ing0qkxWcyfKKb9nVaLv6Jp9VF9iQSPAHotCDldqOdTiZQdjfsQ4wMSiwT41
         ucFf5jNirjmjGuFLKOgJBFMYeBSJ+TL6JWLRS/WaMhxSFZpuGQYR3CF4LCYOrP0tPJ7x
         qjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0qI/WIP6bcYgKcafJAsqXV9B70atJbPQW4w3BJL+MGE=;
        b=JsY60IE4PGBlhr4/z6GXF1NvtGF579oaMjyndHPEnzS9H88RjjG4B+3WdTCjVgSyeJ
         L+NXvqdRNI/yfZVU75t9BlQ6053yzku0wdcAHGVlKPiGXEmG4LI42z5ImwRuG3QPRRUG
         bzkxjX6u8TxdHu/fuT0YWNtA009YRQoWzArQC3cCRW6CK+2uNhWd+QOnSdEO2vrmeD7C
         DnR9F8B1zolYAlQ8XV1nKMUGJO4rz05MHQ39Jfjuz0wLQewd+KtBO6IkdXFMfQt2nLa3
         POE+tU+dAIbScIl//nyFH1Lg3M9FaxPAzeGgrCheYsybWFUikDXOpOZqSJJiKr7eGlQJ
         Rv8g==
X-Gm-Message-State: APjAAAUYJkXTffgQzmd7bzlDIAwGc/4+ydqXK9O6lCecz28hxaH3f+vW
        9kIH3aDqIT0SK0XFPM7ZnXU=
X-Google-Smtp-Source: APXvYqyJcPwm/OOgZ747MVxmRu3cIysBOdB09UE8OisvGVHkSAwy0g15whSkf9RjVwVjRRoLruJGyA==
X-Received: by 2002:ae9:dc82:: with SMTP id q124mr85670348qkf.20.1578348042956;
        Mon, 06 Jan 2020 14:00:42 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id z4sm24367312qta.73.2020.01.06.14.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 14:00:42 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2D60D40DFD; Mon,  6 Jan 2020 19:00:40 -0300 (-03)
Date:   Mon, 6 Jan 2020 19:00:40 -0300
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        users@linux.kernel.org
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106220040.GD11285@kernel.org>
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
 <20200106162623.GA11285@kernel.org>
 <20200106113615.4545e3c5@gandalf.local.home>
 <20200106194711.GC11285@kernel.org>
 <20200106201401.hcneggg4xmoazr5e@chatter.i7.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106201401.hcneggg4xmoazr5e@chatter.i7.local>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Jan 06, 2020 at 03:14:01PM -0500, Konstantin Ryabitsev escreveu:
> On Mon, Jan 06, 2020 at 04:47:11PM -0300, Arnaldo Carvalho de Melo wrote:
> > Sure, regardless of where you do source code control you will need to
> > tag, create a tarball, signatures (which kup helps with) for kernel.org,
> > for instance I use:
> > 
> >   kup put perf-${VER}.tar.xz perf-${VER}.tar.sign /pub/linux/kernel/tools/perf/v${VER}/perf-${VER}.tar.xz
> 
> It's worth noting that you don't have to use kup if you don't want to -- 
> we have a mechanism to create tarball releases directly from tag 
> signatures. You just have to add a special note to the tag and the 
> backend does the rest automatically -- we have a handy script [^1] to 
> make it easier.
> 
> Greg KH has been using this process for a while now.
> 
> If you would like to switch to that instead of using kup directly, just 
> let me know.

Sure I wanna know, will read [^1], thanks for the pointer.

On a side note since this is a library/tool that is hosted in the
kernel, like perf, using that /pub/linux/kernel/tools/lib/ path seems
appropriate, i.e. it provides tarballs for things in the tools/
directory of the linux/kernel/ :-)

- Arnaldo
 
> -K
 
> [^1]: https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/git-archive-signer
