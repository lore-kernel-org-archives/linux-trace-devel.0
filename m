Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B00C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345778AbiARDNQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:13:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54340 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352553AbiARDAI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 22:00:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0AD6137A
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 03:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66877C36AE3;
        Tue, 18 Jan 2022 03:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9ej8-006jFv-Ba;
        Mon, 17 Jan 2022 22:00:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Add get affinity API
Date:   Mon, 17 Jan 2022 22:00:03 -0500
Message-Id: <20220118030005.1603821-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We have tracefs_instance_set_affinity() APIs but no "get_affinity()" APIs.
Change that now by adding matching get_affinity() APIs to the "set_affinity()"
ones.

Also fix a bug that was in the affinity example in the man pages.

Steven Rostedt (2):
  libtracefs: Add tracefs_instance_get_affinity() APIs
  libtracefs: Fix libtracefs-instance-affinity example

 .../libtracefs-instances-affinity.txt         |  43 +++-
 include/tracefs.h                             |   4 +
 src/tracefs-instance.c                        | 192 ++++++++++++++++++
 3 files changed, 233 insertions(+), 6 deletions(-)

-- 
2.33.0

