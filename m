Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA20C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Nov 2022 20:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiKNUoo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 15:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiKNUon (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 15:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DE15FD5
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 12:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4314B6145D
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E8DC43470;
        Mon, 14 Nov 2022 20:44:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ougKZ-00AD5l-3C;
        Mon, 14 Nov 2022 15:45:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/4] Add some helpful APIS
Date:   Mon, 14 Nov 2022 15:45:18 -0500
Message-Id: <20221114204522.2433500-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_event_is_enabled() and tracefs_tracing_dir_is mounted().

Also add getting and setting the ring buffer size.

Changes since v1: https://lore.kernel.org/all/20221112004130.2305589-1-rostedt@goodmis.org/

 - Add tracefs_instance_set_buffer_size() prototype in tracefs.h

 - Added tracefs_tracing_dir_is_mounted() API.


Steven Rostedt (Google) (4):
  libtracefs: Add tracefs_event_is_enabled() API
  libtracefs: Add tracefs_instance_get_buffer_size() API
  libtracefs: Add tracefs_instance_set_buffer_size() API
  libtracefs: Add tracefs_tracing_dir_is_mounted() API

 Documentation/libtracefs-events.txt          |  33 ++++-
 Documentation/libtracefs-files.txt           |  14 +-
 Documentation/libtracefs-instances-utils.txt |  22 +++-
 Documentation/libtracefs.txt                 |   5 +
 include/tracefs.h                            |  12 ++
 src/tracefs-events.c                         | 128 +++++++++++++++++--
 src/tracefs-instance.c                       |  64 ++++++++++
 src/tracefs-utils.c                          |  62 +++++++--
 8 files changed, 312 insertions(+), 28 deletions(-)

-- 
2.35.1

