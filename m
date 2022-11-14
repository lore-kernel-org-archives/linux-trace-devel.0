Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8261AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 22:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiKNWUD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiKNWTp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 17:19:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99DC14022
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 14:19:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91C18B815B1
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 22:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFBFC433C1;
        Mon, 14 Nov 2022 22:19:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ouhoW-00ADfF-2g;
        Mon, 14 Nov 2022 17:20:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Minor fixes
Date:   Mon, 14 Nov 2022 17:20:22 -0500
Message-Id: <20221114222024.2435776-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_cpu_flush*() functions should not return -EAGAIN as they are non
blocking and should only return 0 when there's nothing to read.

Steven Rostedt (Google) (2):
  libtracefs: Do not return negative on EAGAIN for
    tracefs_cpu_flush_write()
  libtracefs: Reset errno to success on EAGAIN for the flush functions

 src/tracefs-record.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.35.1

