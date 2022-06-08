Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C38DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbiFHQcT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245711AbiFHQcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC84A2D4714
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D071561986
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20856C3411D;
        Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyyb3-001mfF-2Z;
        Wed, 08 Jun 2022 12:31:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd stat: Add some missing status
Date:   Wed,  8 Jun 2022 12:31:49 -0400
Message-Id: <20220608163152.425352-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add to trace-cmd stat the followin missing items:

 - set_event_notrace_pid
 - set_ftrace_notrace_pid
 - synthetic_events

Steven Rostedt (Google) (3):
  trace-cmd stat: Show set_event_notrace_pid entries
  trace-cmd stat: Show PIDs in set_ftrace_notrace_pid
  trace-cmd stat: List synthetic events in the system

 tracecmd/trace-stat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.35.1

