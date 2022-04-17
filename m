Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFBEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiDQVP5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiDQVP5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 17:15:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C82711A39
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 14:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F80B80D31
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 21:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28FC385A4;
        Sun, 17 Apr 2022 21:13:17 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ngCCq-004P1N-IT;
        Sun, 17 Apr 2022 17:13:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd agent: Add a little security to network connections
Date:   Sun, 17 Apr 2022 17:13:13 -0400
Message-Id: <20220417211315.1049221-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Having an agent connection listening on a network is not the safest thing to do.
This would allow anyone from anywhere to contol and read tracing of the host.
Instead, force the -N to at least take an IP hostname/address to only connect
to. This way the agent will only connect to a single machine. Any task on that
machine can control the agent, so the machine must be fully trusted.

Also noticed that trace-cmd agent is missing a man page. Add that too with
this change included in it.

Depends on: https://patchwork.kernel.org/project/linux-trace-devel/cover/20220417184538.1044417-1-rostedt@goodmis.org/
   https://lore.kernel.org/r/20220417184538.1044417-1-rostedt@goodmis.org

Steven Rostedt (Google) (2):
  trace-cmd agent: Have -N take a host name
  trace-cmd agent: Add documentation

 Documentation/trace-cmd/trace-cmd-agent.1.txt | 60 +++++++++++++++++++
 tracecmd/include/trace-local.h                |  7 ++-
 tracecmd/trace-agent.c                        | 34 ++++++++---
 tracecmd/trace-listen.c                       | 55 +++++++++++++++++
 tracecmd/trace-record.c                       | 13 +++-
 tracecmd/trace-usage.c                        |  1 +
 6 files changed, 158 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-agent.1.txt

-- 
2.35.1

