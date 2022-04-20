Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ED5C43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380212AbiDTP3e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380232AbiDTP32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECED4579B
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D4F8B81F95
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4083C385A1;
        Wed, 20 Apr 2022 15:26:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003RG-GP;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 00/11] trace-cmd: Allow agent to use networking
Date:   Wed, 20 Apr 2022 11:26:26 -0400
Message-Id: <20220420152637.13105-1-rostedt@goodmis.org>
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

Changes since v2: https://lore.kernel.org/all/20220417184538.1044417-1-rostedt@goodmis.org/
 - Added comments about USE_UDP as being the default, as well as
     explicitly setting it to zero. (Tzvetomir Stoyanov)
 - Appended https://lore.kernel.org/all/20220417211315.1049221-1-rostedt@goodmis.org/
     to the patch set.
 - Added more warnings about the insecurities of using trace-cmd agent
     with the -N option. (Tzvetomir Stoyanov)


Changes since v1: https://lore.kernel.org/r/20220417011958.1013591-1-rostedt@goodmis.org
 - Rebased on the above dependency.
 - Added patch to allow compiling of agent without vsocket support.


Steven Rostedt (Google) (11):
  trace-cmd record: Move port_type into instance
  trace-cmd library: Add network roles for time sync
  trace-cmd record: Allow for ip connections to agents
  trace-cmd agent: Allow for ip connections from the agent
  trace-cmd library: Create tracecmd_debug() for debug printing
  trace-cmd: Add debug prints for network connections
  trace-cmd: Add print helpers to show connections
  trace-cmd: Override tracecmd_debug() to show thread id
  trace-cmd agent: Have agent work without vsockets available
  trace-cmd agent: Have -N take a host name
  trace-cmd agent: Add documentation

 Documentation/trace-cmd/trace-cmd-agent.1.txt |  62 ++++
 lib/trace-cmd/Makefile                        |   2 +-
 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/include/trace-tsync-local.h     |   6 +-
 lib/trace-cmd/trace-msg.c                     |  12 +-
 lib/trace-cmd/trace-timesync-ptp.c            |   4 +-
 lib/trace-cmd/trace-timesync.c                |   2 +
 lib/trace-cmd/trace-util.c                    |  12 +
 tracecmd/Makefile                             |   5 +-
 tracecmd/include/trace-local.h                |  25 +-
 tracecmd/trace-agent.c                        | 126 ++++++--
 tracecmd/trace-cmd.c                          |  20 +-
 tracecmd/trace-listen.c                       | 139 +++++++--
 tracecmd/trace-record.c                       | 269 ++++++++++++------
 tracecmd/trace-usage.c                        |   5 +-
 tracecmd/trace-vsock.c                        |  20 ++
 16 files changed, 562 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-agent.1.txt

-- 
2.35.1

