Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F0AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 01:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiDQBWh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Apr 2022 21:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiDQBWg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Apr 2022 21:22:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75EA25595
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Apr 2022 18:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B2661044
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 01:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725AFC385A3;
        Sun, 17 Apr 2022 01:20:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfta4-004FiM-2k;
        Sat, 16 Apr 2022 21:20:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/8] trace-cmd: Allow agent to use networking
Date:   Sat, 16 Apr 2022 21:19:50 -0400
Message-Id: <20220417011958.1013591-1-rostedt@goodmis.org>
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

Steven Rostedt (Google) (8):
  trace-cmd record: Move port_type into instance
  trace-cmd library: Add network roles for time sync
  trace-cmd record: Allow for ip connections to agents
  trace-cmd agent: Allow for ip connections from the agent
  trace-cmd library: Create tracecmd_debug() for debug printing
  trace-cmd: Add debug prints for network connections
  trace-cmd: Add print helpers to show connections
  trace-cmd: Override tracecmd_debug() to show thread id

 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/trace-msg.c                     |  12 +-
 lib/trace-cmd/trace-timesync-ptp.c            |   4 +-
 lib/trace-cmd/trace-timesync.c                |   2 +
 lib/trace-cmd/trace-util.c                    |  12 +
 tracecmd/include/trace-local.h                |  16 ++
 tracecmd/trace-agent.c                        | 106 +++++--
 tracecmd/trace-cmd.c                          |  18 ++
 tracecmd/trace-listen.c                       |  84 ++++--
 tracecmd/trace-record.c                       | 258 ++++++++++++------
 tracecmd/trace-vsock.c                        |  20 ++
 11 files changed, 403 insertions(+), 134 deletions(-)

-- 
2.35.1

