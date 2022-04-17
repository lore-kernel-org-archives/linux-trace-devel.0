Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1786C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiDQSsS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiDQSsR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE7812AFD
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B72960C8A
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13CAC385A9;
        Sun, 17 Apr 2022 18:45:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9ty-004Njh-V9;
        Sun, 17 Apr 2022 14:45:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/9] trace-cmd: Allow agent to use networking
Date:   Sun, 17 Apr 2022 14:45:29 -0400
Message-Id: <20220417184538.1044417-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>


There's no reason for trace-cmd agent not to be able to do the communication
over TCP instead of vsockets. Have trace-cmd record pass in a host name or
IP address (IPv4 or IPv6) to the -A option and if the cid or guest name
fails, then try host name or IP address.

This will fall back to the P2P time sync protocol and recordings from
different hosts can be synchronized.

Also add more debug prints when the --debug option is used. This proved
useful to debugging this code.

Depends on: https://patchwork.kernel.org/project/linux-trace-devel/list/?series=632870
  https://lore.kernel.org/r/20220417183354.1042657-1-rostedt@goodmis.org

Changes since v1: https://lore.kernel.org/r/20220417011958.1013591-1-rostedt@goodmis.org
 - Rebased on the above dependency.
 - Added patch to allow compiling of agent without vsocket support.

Steven Rostedt (Google) (9):
  trace-cmd record: Move port_type into instance
  trace-cmd library: Add network roles for time sync
  trace-cmd record: Allow for ip connections to agents
  trace-cmd agent: Allow for ip connections from the agent
  trace-cmd library: Create tracecmd_debug() for debug printing
  trace-cmd: Add debug prints for network connections
  trace-cmd: Add print helpers to show connections
  trace-cmd: Override tracecmd_debug() to show thread id
  trace-cmd agent: Have agent work without vsockets available

 lib/trace-cmd/Makefile                        |   2 +-
 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/include/trace-tsync-local.h     |   6 +-
 lib/trace-cmd/trace-msg.c                     |  12 +-
 lib/trace-cmd/trace-timesync-ptp.c            |   4 +-
 lib/trace-cmd/trace-timesync.c                |   2 +
 lib/trace-cmd/trace-util.c                    |  12 +
 tracecmd/Makefile                             |   5 +-
 tracecmd/include/trace-local.h                |  16 ++
 tracecmd/trace-agent.c                        | 106 ++++++--
 tracecmd/trace-cmd.c                          |  20 +-
 tracecmd/trace-listen.c                       |  84 ++++--
 tracecmd/trace-record.c                       | 256 ++++++++++++------
 tracecmd/trace-usage.c                        |   2 -
 tracecmd/trace-vsock.c                        |  20 ++
 15 files changed, 406 insertions(+), 146 deletions(-)

-- 
2.35.1

