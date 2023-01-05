Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC58DC3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 21:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbjAEVxo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 16:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbjAEVw6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 16:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E6B69512
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 13:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6499B81BA8
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 21:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A3C433EF;
        Thu,  5 Jan 2023 21:52:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pDYAP-000wIj-16;
        Thu, 05 Jan 2023 16:52:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Fixups to tracefs_cpu_stop()
Date:   Thu,  5 Jan 2023 16:52:50 -0500
Message-Id: <20230105215252.224044-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Working on trace-cmd stream, there were some issues with stopping the
recorders, as they were getting stuck in the read state. It appears that
tracefs_cpu_stop() doesn't guarantee that the readers are awake. Until it can
be straiten out, always tell the callers that there needs to be a nudge to the
readers (ie. a signal).

Steven Rostedt (Google) (2):
  libtracefs: Have tracefs_cpu_stop() do nothing only with PERM_NONBLOCK
  libtracefs: Have tracefs_cpu_stop() always suggesting nudging

 src/tracefs-record.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

-- 
2.35.1

