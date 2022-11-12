Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47916C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiKLAk6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiKLAk5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249CA76FBA
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75DBEB82878
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Nov 2022 00:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABEFC43470;
        Sat, 12 Nov 2022 00:40:53 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oteaS-009fnK-0D;
        Fri, 11 Nov 2022 19:41:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Add some helpful APIS
Date:   Fri, 11 Nov 2022 19:41:27 -0500
Message-Id: <20221112004130.2305589-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_event_is_enabled() (which supersedes https://lore.kernel.org/all/20221111185318.22e9bca9@rorschach.local.home/)

Also add getting and setting the ring buffer size.

Steven Rostedt (Google) (3):
  libtracefs: Add tracefs_event_is_enabled() API
  libtracefs: Add tracefs_instance_get_buffer_size() API
  libtracefs: Add tracefs_instance_set_buffer_size() API

 Documentation/libtracefs-events.txt          |  33 ++++-
 Documentation/libtracefs-instances-utils.txt |  22 +++-
 Documentation/libtracefs.txt                 |   4 +
 include/tracefs.h                            |  10 ++
 src/tracefs-events.c                         | 128 +++++++++++++++++--
 src/tracefs-instance.c                       |  64 ++++++++++
 6 files changed, 247 insertions(+), 14 deletions(-)

-- 
2.35.1

