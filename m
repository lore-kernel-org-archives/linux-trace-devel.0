Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAA2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347487AbiD1PJ4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbiD1PJz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 11:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2647E26572
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 08:06:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD615B82CB7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 15:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9263FC385A0;
        Thu, 28 Apr 2022 15:06:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nk5j2-003JH3-7m;
        Thu, 28 Apr 2022 11:06:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Clean ups for agent communications
Date:   Thu, 28 Apr 2022 11:06:31 -0400
Message-Id: <20220428150635.789051-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation to have an agent proxy, these are some clean up patches to
the agent code that should help simplify the modifications.

Steven Rostedt (Google) (4):
  trace-cmd: Move add_guest_info() into trace-vm.c
  trace-cmd: Simplify add_guest()
  trace-cmd: Move find_tasks() into add_guest()
  trace-cmd: Move find_pid_by_cid() into add_guest()

 tracecmd/include/trace-local.h |   1 +
 tracecmd/trace-record.c        |  89 +------------------------
 tracecmd/trace-vm.c            | 117 ++++++++++++++++++++++++++++-----
 3 files changed, 104 insertions(+), 103 deletions(-)

-- 
2.35.1

