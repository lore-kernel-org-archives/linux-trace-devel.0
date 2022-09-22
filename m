Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EB7C6FA8E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIVAWw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIVAWv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:22:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F629F8D2
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93CE62985
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155BDC433B5;
        Thu, 22 Sep 2022 00:22:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA0M-00Dr3C-2Q;
        Wed, 21 Sep 2022 20:23:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd: A few fixes
Date:   Wed, 21 Sep 2022 20:23:45 -0400
Message-Id: <20220922002348.3302169-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Fix some issues with connections between host and guest.

Also add --notimeout option so that the host/guest connection will not
timeout when the other end is debugging and stepping through the code.

Steven Rostedt (Google) (3):
  trace-cmd record/agent: Add --notimeout option
  trace-cmd: Close socket descriptor on failed connection
  trace-cmd: Do not return zero length name for guest by name

 .../include/private/trace-cmd-private.h       |  3 +++
 lib/trace-cmd/trace-msg.c                     |  2 +-
 lib/trace-cmd/trace-util.c                    | 25 +++++++++++++++++++
 tracecmd/trace-agent.c                        | 11 +++++---
 tracecmd/trace-record.c                       |  7 +++++-
 tracecmd/trace-vm.c                           |  2 +-
 tracecmd/trace-vsock.c                        |  4 ++-
 7 files changed, 47 insertions(+), 7 deletions(-)

-- 
2.35.1

