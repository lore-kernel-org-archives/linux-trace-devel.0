Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E3AC38142
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Jan 2023 15:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbjAaPjK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 10:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjAaPjH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 10:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CCD17CF8;
        Tue, 31 Jan 2023 07:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA923B81D5C;
        Tue, 31 Jan 2023 15:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16582C4339B;
        Tue, 31 Jan 2023 15:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675179542;
        bh=JPc05D8LI0SwIX1+XVUqEaxjOD2RwL19ZHR2m8W9Nn0=;
        h=From:To:Cc:Subject:Date:From;
        b=KcXH1kqbDnhKFLQoaAzP8by87Dj1nDztVRUeTjc5MsJXa0gALlpMm9wojKgIymG0v
         gJzf+q4fsghwftU5If/2CQ8TcR57Wk3bl6KK6HSpgkVH6l1pd7a5SgptOjfNYsoulw
         GR3hc9KsItAGKwdt7NrEs9WDtJCxBqtN04qlQPnrCmoQJRh5Q0O+aKQUDvsz9N8Cpb
         x5aIMGM2dBiFpcmk7JhDHZKYMndquD7LyaiUTw9i/0mxOHICFB4D9GMuqTu4iDXE8g
         oba0SvjTPJKJ2XUV/q9nBRgYsapIby4H+3Xd76IYXcTR+6c9jo4WeYsQDDBfB1bN0k
         r7/DSSyAyO0Zw==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] rtla: Timerlat auto-analysis
Date:   Tue, 31 Jan 2023 16:38:52 +0100
Message-Id: <cover.1675179318.git.bristot@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, timerlat displays the timerlat tracer latency results, saving
the intuitive timerlat trace for the developer to analyze.

This patch goes a step forward in the automaton of the scheduling latency
analysis by providing a summary of the root cause of a latency higher than
the passed "stop tracing" parameter if the trace stops.

The output is intuitive enough for non-expert users to have a general idea
of the root cause by looking at each factor's contribution percentage
while keeping the technical detail in the output for more expert users
to start an in dept debug or to correlate a root cause with an existing one.

The first patch adds the functionality without using it. The second attaches
it to the timerlat top, and the last one updates the man page.

Daniel Bristot de Oliveira (3):
  rtla/timerlat: Add auto-analysis core
  rtla/timerlat: Add auto-analysis support to timerlat top
  Documentation/rtla: Add timerlat-top auto-analysis options

 .../tools/rtla/common_timerlat_aa.rst         |   7 +
 .../tools/rtla/rtla-timerlat-top.rst          | 164 ++-
 tools/tracing/rtla/src/timerlat_aa.c          | 990 ++++++++++++++++++
 tools/tracing/rtla/src/timerlat_aa.h          |  12 +
 tools/tracing/rtla/src/timerlat_top.c         |  46 +-
 tools/tracing/rtla/src/utils.h                |   3 +
 6 files changed, 1129 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/tools/rtla/common_timerlat_aa.rst
 create mode 100644 tools/tracing/rtla/src/timerlat_aa.c
 create mode 100644 tools/tracing/rtla/src/timerlat_aa.h

-- 
2.38.1

