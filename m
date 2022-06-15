Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DBCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 02:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiFOCyl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 22:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbiFOCyk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 22:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702F032053
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 19:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE78760DE4
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 02:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D104C3411D;
        Wed, 15 Jun 2022 02:54:38 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1JAy-002Nwz-VB;
        Tue, 14 Jun 2022 22:54:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Fix trace-cmd convert
Date:   Tue, 14 Jun 2022 22:54:34 -0400
Message-Id: <20220615025436.568682-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When fixing tracecmd_read_at() the convert command was broken. This was due
to it using the temp file and not the zpage. The offsets were not accounted
for in this path. trace-cmd convert uses the temp files and not the zpage
so it was a casualty of the situation.


Steven Rostedt (Google) (2):
  trace-cmd library: Fail if tracecmd_init_data() fails
  trace-cmd library: Fix reading of temp file used to decompress

 lib/trace-cmd/trace-input.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.35.1

