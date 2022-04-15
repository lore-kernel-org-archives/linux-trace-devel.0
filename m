Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6550C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348394AbiDOBM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348413AbiDOBMz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:12:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9F3B3FA
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D92B82BF3
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFE6C385A1;
        Fri, 15 Apr 2022 01:10:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfATg-003wEk-Bn;
        Thu, 14 Apr 2022 21:10:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/5] trace-cmd: Have trace-cmd listen work with vsockets
Date:   Thu, 14 Apr 2022 21:10:18 -0400
Message-Id: <20220415011023.938663-1-rostedt@goodmis.org>
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
 tracecmd/trace-record.c                       |  95 +++++++--
 tracecmd/trace-usage.c                        |   2 +
 8 files changed, 258 insertions(+), 71 deletions(-)

-- 
2.35.1

