Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F7FC3A59F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 20:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AED2023403
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 20:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9vN29Ul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfH2Uh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 16:37:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36811 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfH2Uh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 16:37:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id z4so5277298qtc.3;
        Thu, 29 Aug 2019 13:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D8YaKbd+JHKjI+D6p/bmY5IbCPptvKYKqAvwvx7X4CE=;
        b=D9vN29Ul2nLc32nl2hSyksmt85n1n6lpwBKTJuJcv/u7rbxhtr85T+9rX73/mLeuWG
         gWa3lNmdnyLDrnvdCsAn4L3efCj/y5YASLUUxlpLVKkNtlJBX6YmsraowwTek1WvlLxC
         ACzkkk2E6NSG67Adc3RNTEZKTtsP1ti6jJgJRXf4PHU7qtRtNzjkV9vNROo7yWdZhzc+
         RvMZZe+d71p3QrCyLnk+/3YAMHuvu2K80H54YXz08ho7qupjcy49KKTUYzU5aODBVMUa
         4D3wTdza0TU4xI5l1x9rwse0hFmHYgxnyk6sl/Bt/zKJ5E6VbHPprtdnosGwHzdbnBZX
         c2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D8YaKbd+JHKjI+D6p/bmY5IbCPptvKYKqAvwvx7X4CE=;
        b=J+TuFDx9zaa8oPUEjb/CTbkvKZMV+yomQyo2Ha6riiWSHDjSyAihVrN0uNqXDARIvV
         yTJXBbDw92k3jibPAk3IzJfl0z8fMpVO79KMFFM/OswGR4sY4+JmJOG8A33D9mah9z04
         FKxSkmF4CXwCBBVqtjK3Ruo6vQOFzTiFyFIBUka93sFoMmEc+Ezg8usFB0z7WGh+wzeX
         8YFMLp4ZbH0PRCj9Yht3WR81x7Ny6YcIgzdIus0ghqCP1UYDT9lV/ihWgkJV8BnzaOCo
         g/Vw0En32LWkyWStBA102ieEkXSGD/E3ekf9pdUzG6UtH6ZHT0EGmUeUz6mvQO5UcGUO
         nXDw==
X-Gm-Message-State: APjAAAWCj1DFYuQLYWL9n/U/nCyxEfe8mTTnvAJOmaN1zVb7XMUtS2tw
        YngYafnXXQtpAhmlaDRBIqM9/S+m
X-Google-Smtp-Source: APXvYqzoZHLp8A4IRdAj5CqJEEedKSYC2CzfAykzJcYUyKKBcLjeJYgdrXTFaEFKqiu5Uo1Iy4B9VQ==
X-Received: by 2002:ac8:5048:: with SMTP id h8mr11997553qtm.190.1567111076787;
        Thu, 29 Aug 2019 13:37:56 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.212.176])
        by smtp.gmail.com with ESMTPSA id e17sm1878616qkn.61.2019.08.29.13.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 13:37:54 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id AA3ED41146; Thu, 29 Aug 2019 17:37:51 -0300 (-03)
Date:   Thu, 29 Aug 2019 17:37:51 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick McLean <chutzpah@gentoo.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH 0/3] tools lib traceevent: Fixing the API to be less
 policy driven
Message-ID: <20190829203751.GE28011@kernel.org>
References: <20190805204312.169565525@goodmis.org>
 <20190829140010.60d75297@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829140010.60d75297@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Aug 29, 2019 at 02:00:10PM -0400, Steven Rostedt escreveu:
> On Mon, 05 Aug 2019 16:43:12 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Hi Arnaldo and Jiri,
> 
> Hi Arnaldo,
> 
> I think these fell through the cracks.

Got it now, pushed to my perf/core branch, soon to be pushed upstream.

Thanks,

- Arnaldo
 
> -- Steve
> 
> > 
> > We are still working on getting libtraceevent ready to be a stand alone
> > library. Part of that is to audit all the interfaces. We noticed
> > that the most the tep_print_*() interfaces define policy and limit
> > the way an application can display data. Instead of fixing this later
> > and being stuck with a limiting API that we must maintain for backward
> > compatibility, we removed and replaced most of it. perf was only affected
> > by a single function that was removed. These functions are replaced
> > by a more flexible one that allows the user to place what they want
> > where they want it (timestamps, event info, latency format, COMM, PID, etc).
> > 
> > The other noticeable perf change, is that we changed the location to
> > where the plugins are loaded from:
> > 
> >  ${HOME}/.traceevent/plugins
> > 
> > to
> > 
> >  ${HOME}/.local/lib/traceevent/plugins
> > 
> > As Patrick McLean (Gentoo package maintainer) informed us of the
> > XGD layout.
> > 
> > Should we have something the warns people if they have plugins in
> > the old directory. Should we move them on install? Currently, we
> > just ignore them.
> > 
> > Anyway, please add these patches to tip.
> > 
> > Thanks!
> > 
> > -- Steve
> > 
> > 
> > Tzvetomir Stoyanov (3):
> >       tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
> >       tools/lib/traceevent: Remove tep_register_trace_clock()
> >       tools/lib/traceevent: Change user's plugin directory
> > 
> > ----
> >  tools/lib/traceevent/Makefile            |   6 +-
> >  tools/lib/traceevent/event-parse-api.c   |  40 ----
> >  tools/lib/traceevent/event-parse-local.h |   6 -
> >  tools/lib/traceevent/event-parse.c       | 333 +++++++++++++++++--------------
> >  tools/lib/traceevent/event-parse.h       |  30 +--
> >  tools/lib/traceevent/event-plugin.c      |   2 +-
> >  tools/perf/builtin-kmem.c                |   3 +-
> >  tools/perf/util/sort.c                   |   3 +-
> >  tools/perf/util/trace-event-parse.c      |   2 +-
> >  9 files changed, 207 insertions(+), 218 deletions(-)

-- 

- Arnaldo
