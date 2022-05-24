Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B46C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 May 2022 01:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiEXBug (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 May 2022 21:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiEXBuf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 May 2022 21:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD5737A1
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 18:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01234B8171F
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 01:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5779C385A9;
        Tue, 24 May 2022 01:50:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ntJgr-0015i5-LF;
        Mon, 23 May 2022 21:50:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Fix clock setting of agent proxy
Date:   Mon, 23 May 2022 21:50:26 -0400
Message-Id: <20220524015028.260238-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

trace-cmd record does not set its clock to TSC if it connects to a agent
proxy, when it should. This breaks the synchronization. It works if the user
manually sets the clock to TSC before running the record, but the user
should not need to do that.

Also, if the TSC2NSEC option is set, then print the timing out in seconds
(with fractions) instead of the time stamp in nanoseconcds.

Steven Rostedt (Google) (2):
  trace-cmd library: Keep USECS flag if TSC multiplier is set
  trace-cmd record: Set clock to TSC when connecting to a proxy with kvm

 lib/trace-cmd/trace-input.c |  6 ++++++
 tracecmd/trace-record.c     | 13 +++++++++++++
 2 files changed, 19 insertions(+)

-- 
2.35.1

