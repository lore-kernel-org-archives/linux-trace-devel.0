Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B23C6FD20
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Mar 2023 20:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjCXUBw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjCXUBv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 16:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD326B6
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 13:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C45EB825F3
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Mar 2023 20:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0411FC4339B;
        Fri, 24 Mar 2023 20:01:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pfnbe-001Ciw-2u;
        Fri, 24 Mar 2023 16:01:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtraceevent
Date:   Fri, 24 Mar 2023 16:01:42 -0400
Message-Id: <20230324200145.287158-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Google's fuzz testing found a double free in process_sizeof(). That was an
easy fix, but the reason the bug happened was because of that silly "ok"
variable called "ok", which is meaningless for what it is used for.

Also, remove the unneeded test of !ok at the end of the if/else block.

Steven Rostedt (Google) (3):
  libtraceevent: Fix double free in parsing sizeof()
  libtraceevent: No need for testing ok in else if (!ok) in process_sizeof()
  libtraceevent: Rename "ok" to "end" in process_sizeof()

 src/event-parse.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

-- 
2.39.1

