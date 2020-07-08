Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C407EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 02:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD1E20738
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 02:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594173759;
	bh=U/CPRXHTjlD5zdmUHjK63IKcWAyC0L8pfcRRq/jXJhg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=QFR7nd8wz2DyDBswOjZydpFujvXTSLO7JM5vtHDq5oVeQ67+Mn25KHqm0yjPcoZMM
	 zUnu4CXzvP/iVTKTmLEjU7V6aCjI86O63y5wr7fjT9Q6gTSS5cGCHsaz+n9pEZ8e7j
	 0wSiZ1yM3v6Q7Pl1b1SJwr82Fe4WrGJ9HDOuBdEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgGHCCj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:02:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55966 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729215AbgGHCCj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 22:02:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id g75so1264074wme.5;
        Tue, 07 Jul 2020 19:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kkUDf3xOeq1clboWmLuWTwgdl1/CFe1j0EH035FihDw=;
        b=ld94ZTxwu9TBlgvGvWzmdnuFPk8OmwyfizRIhupTAXb3GznehPz7o7MAg9Yz6ISB/h
         rU9FTDStUaIYH8GitYUum0LUc04QVwXrIJyri3yi0BSNWpgC+Q1LVw/wh2s07iHKlZZh
         lLKw6LH0+3RtmzhdLlPM4VCzDwUCVBfcfenE+rBqYpDB6urCG/3rDuC9UzVJg+S5lbKg
         UNrhwqHgqchZF5c5LM+/PhUc/27LHnzVuP/x6GR+xIdv6hvKPS13K4roCd1u0/vmn4+l
         NeMI7gGhHaVRpKdVjtOAS7YxbuYpS1WaC4S/SVB2FKbd9cvDRhOehjCFBwXQSZcATMW3
         bvTg==
X-Gm-Message-State: AOAM532VLQMM4BE+uzyA0EGEcPTAX081FbXcdgwmadMZ0OQp5ub7ShZI
        y3go6PFY3A3VFLTXmwE6muj6u4qeDJo2boZ118PyjQ==
X-Google-Smtp-Source: ABdhPJz3GMIbn/139dQ9Tu1LAbxotAiFc1RZfQX+6qGQOZtOmgGOSZAxmb48P2hrW3b+XsGp0/AZk0gFN8UVOwESlO8=
X-Received: by 2002:a05:600c:410f:: with SMTP id j15mr6675392wmi.128.1594173756980;
 Tue, 07 Jul 2020 19:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org>
In-Reply-To: <20200702185344.913492689@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 8 Jul 2020 11:02:25 +0900
Message-ID: <CAM9d7chesrcBWUtM4CyyDD6mj7t5-HkgQ=x9jVVyM7CRBrnA2w@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] tools lib traceevent: Patches from the trace-cmd repo
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 3, 2020 at 3:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Arnaldo,
>
> I was missing a few patches, here's take two. I also changed some of the
> patches to state that they are coming from trace-cmd.git.
>
> -- Steve
>
> We noticed that the libtraceevent in trace-cmd.git is a bit out of sync with
> what is in the kernel. These patches can help bring it by in sync again.

With future changes to address my earlier comments..

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks
Namhyung

>
>
> Jan Kiszka (2):
>       tools lib traceevent: Add more SVM exit reasons
>       tools lib traceevent: Fix reporting of unknown SVM exit reasons
>
> Julia Cartwright (1):
>       tools lib traceevent: Add plugin for decoding syscalls/sys_enter_futex
>
> Steven Rostedt (Red Hat) (2):
>       tools lib traceevent: Add API to read time information from kbuffer
>       tools lib traceevent: Add plugin for tlb_flush
>
> Steven Rostedt (VMware) (3):
>       tools lib traceevent: Add offset option for function plugin
>       tools lib traceevent: Add builtin handler for trace_marker_raw
>       tools lib traceevent: Change to SPDX License format
>
> Tom Zanussi (1):
>       tools lib traceevent: Add proper KBUFFER_TYPE_TIME_STAMP handling
>
> Tzvetomir Stoyanov (VMware) (6):
>       tools lib traceevent: Add tep_load_plugins_hook() API
>       tools lib traceevent: Add interface for options to plugins
>       tools lib traceevent: Introduced new traceevent API, for adding new plugins directories.
>       tools lib traceevent: Add support for more printk format specifiers
>       tools lib traceevent: Optimize pretty_print() function
>       tools lib traceevent: Move kernel_stack event handler to "function" plugin.
>
> ----
>  tools/lib/traceevent/event-parse-local.h           |   22 +-
>  tools/lib/traceevent/event-parse.c                 | 1004 +++++++++++++++-----
>  tools/lib/traceevent/event-parse.h                 |   34 +-
>  tools/lib/traceevent/event-plugin.c                |  261 ++++-
>  tools/lib/traceevent/kbuffer-parse.c               |   43 +-
>  tools/lib/traceevent/kbuffer.h                     |   19 +-
>  tools/lib/traceevent/plugins/Build                 |    2 +
>  tools/lib/traceevent/plugins/Makefile              |    2 +
>  tools/lib/traceevent/plugins/plugin_function.c     |  123 ++-
>  tools/lib/traceevent/plugins/plugin_futex.c        |  123 +++
>  tools/lib/traceevent/plugins/plugin_hrtimer.c      |   17 +-
>  tools/lib/traceevent/plugins/plugin_jbd2.c         |   17 +-
>  tools/lib/traceevent/plugins/plugin_kmem.c         |   17 +-
>  tools/lib/traceevent/plugins/plugin_kvm.c          |   42 +-
>  tools/lib/traceevent/plugins/plugin_mac80211.c     |   17 +-
>  tools/lib/traceevent/plugins/plugin_sched_switch.c |   17 +-
>  tools/lib/traceevent/plugins/plugin_tlb.c          |   66 ++
>  17 files changed, 1406 insertions(+), 420 deletions(-)
>  create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c
>  create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c
