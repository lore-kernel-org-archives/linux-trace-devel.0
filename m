Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E72C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbiDOBC7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348324AbiDOBCi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B569286FE
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD80621F9
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6443C385AA;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8R-Lf;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/8] trace-cmd library: Remove dependency to vsockets
Date:   Thu, 14 Apr 2022 20:59:59 -0400
Message-Id: <20220415010007.938408-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

[ Sending again from my server in case my laptop had issues sending ]

In an effort to have trace-cmd agent and the time synchronization to
work with networks, the dependency to vsockets needs to be removed. In
fact, libtracecmd should not have any dependency to vsockets, as
everything can be done externally. This simplifies the code, and allows
the use of trace-msg to be used in more scenarios.

I tested host guest tracing to make sure that it did not break the
existing use cases, although there may still be an outlier that I didn't
cover.

Steven Rostedt (Google) (8):
  trace-cmd: Add NO_VSOCK make option to force vsock code off
  trace-cmd library: Remove ports from clock context
  trace-cmd library: Remove vsocket dependency on P2P protocol
  trace-cmd library: Remove dependency on vsocks for sync identifiers
  trace-cmd library: Have tracecmd_tsync_with_guest() not depend on
    cid/port
  trace-cmd library: Remove dependency on vsocks from
    tracecmd_tsync_get_session_params()
  trace-cmd library: Remove vsock dependency from
    tracecmd_tsync_with_host()
  trace-cmd: Move vsocket code into its own file

 Makefile                                      |   4 +
 .../include/private/trace-cmd-private.h       |  12 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  21 +-
 lib/trace-cmd/trace-msg.c                     |   3 +-
 lib/trace-cmd/trace-timesync-ptp.c            |  25 ++-
 lib/trace-cmd/trace-timesync.c                | 180 ++----------------
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |  49 +++++
 tracecmd/trace-agent.c                        |  96 +++-------
 tracecmd/trace-record.c                       |  94 +--------
 tracecmd/trace-vm.c                           |   2 +-
 tracecmd/trace-vsock.c                        | 156 +++++++++++++++
 12 files changed, 303 insertions(+), 340 deletions(-)
 create mode 100644 tracecmd/trace-vsock.c

-- 
2.35.1

