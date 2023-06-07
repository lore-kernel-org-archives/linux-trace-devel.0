Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09F8C7EE25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjFGS21 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjFGS20 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 14:28:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81A26BC
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C829611B7
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F6FC433D2;
        Wed,  7 Jun 2023 18:28:01 +0000 (UTC)
Date:   Wed, 7 Jun 2023 14:28:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Stevie Alvarez <steviea@google.com>
Subject: [PATCH] libtracefs doc: State that tracefs_dynevent_create() is
 needed for tracefs_kprobe_alloc()
Message-ID: <20230607142800.61e56f3b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page for tracefs_kprobe_alloc() states that it does not create a
kprobe in the system, but fails to state how one should be created. Add a
comment that informs the reader that the returned descriptor can be passed
to tracefs_dynevent_create() to create it in the system.

Reported-by: Stevie Alvarez <steviea@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-kprobes.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index f03b096778a5..199379ade7f7 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -30,6 +30,8 @@ int *tracefs_kprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_ev
 DESCRIPTION
 -----------
 *tracefs_kprobe_alloc*() allocates a new kprobe context. The kbrobe is not configured in the system.
+The kprobe can be added to the system by passing in the returned descriptor into
+*tracefs_dynevent_create(3)*.
 The new kprobe will be in the _system_ group (or kprobes if _system_ is NULL) and have the name of
 _event_ (or _addr_ if _event_ is NULL). The kprobe will be inserted to _addr_ (function name, with
 or without offset, or a address), and the _format_ will define the format of the kprobe. See the
-- 
2.39.2

