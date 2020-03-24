Return-Path: <SRS0=3OGB=5J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548EBC54EEB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA87208D5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCXUJ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgCXUJ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 16:09:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A608A2074D;
        Tue, 24 Mar 2020 20:09:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jGps4-001hPb-Fn; Tue, 24 Mar 2020 16:09:56 -0400
Message-Id: <20200324200845.763565368@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 24 Mar 2020 16:08:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/3] tool lib traceevent: Fix some parsing errors
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Arnaldo,

Here's a few patches for lib traceevent.

The first one adds an "append()" helper function for appending to strings,
which will also simplify the next patch.

The second patch handles "__attribute__((user))" in the field of a
trace event. This is needed after the stack leak code added this
to parameters of system call events.

The last patch adds handling of __builtin_expect(), as someone wanted
to move IS_ERR_VALUE() from the fast path into the print fmt section,
which breaks the parsing. This should also be useful for other macros
that may evaluate down to a __builtin_expect().

Steven Rostedt (VMware) (3):
      tools lib traceevent: Add append() function helper for appending strings
      tools lib traceevent: Handle __attribute__((user)) in field names
      tools lib traceevent: Add handler for __builtin_expect()

----
 tools/lib/traceevent/event-parse.c | 168 ++++++++++++++++++++++++-------------
 1 file changed, 111 insertions(+), 57 deletions(-)
