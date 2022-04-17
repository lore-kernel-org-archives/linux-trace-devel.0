Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA46C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiDQSgf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiDQSge (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD6F1C92A
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 814E060C7E
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19D9C385AC;
        Sun, 17 Apr 2022 18:33:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9id-004NGN-LI;
        Sun, 17 Apr 2022 14:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/5] trace-cmd: Have trace-cmd listen work with vsockets
Date:   Sun, 17 Apr 2022 14:33:49 -0400
Message-Id: <20220417183354.1042657-1-rostedt@goodmis.org>
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

Depends on: https://patchwork.kernel.org/project/linux-trace-devel/list/?series=632868
  https://lore.kernel.org/r/20220417182154.1041513-1-rostedt@goodmis.org

Changes since v2: https://lore.kernel.org/all/20220415011023.938663-1-rostedt@goodmis.org/

 - Fixed freeing of host variable that was not allocated

Changes since v1: https://lore.kernel.org/all/20220412042739.836516-1-rostedt@goodmis.org/

 - Rebased on top of: https://lore.kernel.org/all/20220415010007.938408-1-rostedt@goodmis.org/

 - Added the documentation patch


Steven Rostedt (Google) (5):
  trace-cmd listen: Remove UDP from function names
  trace-cmd listen: Replace bool use_tcp with enum type
  trace-cmd record: Replace bool use_tcp with enum type
  trace-cmd listen: Add vsocket usage
  trace-cmd listen: Add documentation on vsocket usage

 .../trace-cmd/trace-cmd-listen.1.txt          |   4 +
 .../trace-cmd/trace-cmd-record.1.txt          |   8 +
 .../include/private/trace-cmd-private.h       |   1 +
 lib/trace-cmd/trace-msg.c                     |  15 +-
 tracecmd/include/trace-local.h                |   8 +
 tracecmd/trace-listen.c                       | 196 +++++++++++++-----
 tracecmd/trace-record.c                       |  93 +++++++--
 tracecmd/trace-usage.c                        |   2 +
 8 files changed, 256 insertions(+), 71 deletions(-)

-- 
2.35.1

