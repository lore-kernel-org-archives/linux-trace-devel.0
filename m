Return-Path: <SRS0=xBmi=YK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E097ECE58D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05B2321D7D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Oct 2019 21:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437436AbfJQVGh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 17:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394673AbfJQVGh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 17:06:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFCC521A4C;
        Thu, 17 Oct 2019 21:06:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iLCyi-00069C-0j; Thu, 17 Oct 2019 17:06:36 -0400
Message-Id: <20191017210521.465613686@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 17 Oct 2019 17:05:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 0/2] perf: Remove trace_find_next_event()
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace_find_next_event() is buggy and useless. Open code the current
users (it's not much work), and nuke the function.

Steven Rostedt (VMware) (2):
      perf: Iterate on tep event arrays directly
      perf: Remove unused trace_find_next_event()

----
 .../perf/util/scripting-engines/trace-event-perl.c |  8 ++++--
 .../util/scripting-engines/trace-event-python.c    |  9 +++++--
 tools/perf/util/trace-event-parse.c                | 31 ----------------------
 tools/perf/util/trace-event.h                      |  2 --
 4 files changed, 13 insertions(+), 37 deletions(-)
