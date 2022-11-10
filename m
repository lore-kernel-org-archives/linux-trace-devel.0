Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DDFC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKJW7g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiKJW7d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 17:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C52F5F85E
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 14:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 231FD61B89
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 22:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848B8C433C1;
        Thu, 10 Nov 2022 22:59:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1otGWf-009ahY-2i;
        Thu, 10 Nov 2022 18:00:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Handle EAGAIN case in flush functions
Date:   Thu, 10 Nov 2022 17:59:57 -0500
Message-Id: <20221110225959.2285998-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have tracefs_cpu_flush_write() not error on EGAIN.

Have bothe tracefs_cpu_flush() and tracefs_cpu_flush_write() reset errno
back to zero when it finishes with EAGAIN.

Steven Rostedt (Google) (2):
  libtracefs: Do not return negative on EAGAIN for
    tracefs_cpu_flush_write()
  libtracefs: Reset errno to success on EAGAIN for the flush functions

 src/tracefs-record.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.35.1

