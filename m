Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5854C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Apr 2022 04:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345813AbiDLEaJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345601AbiDLEaI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 00:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A03298F
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 21:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B7AE61650
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF59C385A1;
        Tue, 12 Apr 2022 04:27:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ne886-003Ve9-GV;
        Tue, 12 Apr 2022 00:27:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Have trace-cmd listen work with vsockets
Date:   Tue, 12 Apr 2022 00:27:35 -0400
Message-Id: <20220412042739.836516-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

We have a use case where the host is very minimal (like an embedded device)
and does not even have networking enabled. But it does have vsockets. We
need to trace this host and have it send its data to the guest. By running
trace-cmd listen on the guest and have the host use vsockets instead of
networking, can allow this host to be traced.


Steven Rostedt (Google) (4):
  trace-cmd listen: Remove UDP from function names
  trace-cmd listen: Replace bool use_tcp with enum type
  trace-cmd record: Replace bool use_tcp with enum type
  trace-cmd listen: Add vsocket usage

 .../include/private/trace-cmd-private.h       |   1 +
 lib/trace-cmd/trace-msg.c                     |  15 +-
 tracecmd/include/trace-local.h                |   8 +
 tracecmd/trace-agent.c                        |   2 +-
 tracecmd/trace-listen.c                       | 194 +++++++++++++-----
 tracecmd/trace-record.c                       |  97 +++++++--
 6 files changed, 245 insertions(+), 72 deletions(-)

-- 
2.35.1

