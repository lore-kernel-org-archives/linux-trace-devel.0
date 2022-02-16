Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8591CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 03:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344088AbiBPDOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:14:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344107AbiBPDOA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 22:14:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481E1D0483
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 19:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF81361838
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5527CC340F0;
        Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nKAlG-00481Y-DH;
        Tue, 15 Feb 2022 22:13:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtraceevent: Clean up printing and man pages
Date:   Tue, 15 Feb 2022 22:13:41 -0500
Message-Id: <20220216031345.984113-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Testing of trace-cmd failed as some formats changed.

One is that info prints that use to go to stdout, now go to stderr.

Add new API to get the number of functions saved in the tep.

Also fix the man pages to make the functions bold and not underscored.

Steven Rostedt (Google) (4):
  libtraceevent: Only add space on log prints if perror is used
  libtraceevent: Have logs only print to stderr on WARNING or higher
  libtraceevent: Add API tep_get_function_count()
  libtraceevent: Make functions bold in man pages

 Documentation/libtraceevent-commands.txt      | 26 +++++------
 Documentation/libtraceevent-cpus.txt          |  8 ++--
 Documentation/libtraceevent-debug.txt         | 12 ++---
 Documentation/libtraceevent-endian_read.txt   |  6 +--
 Documentation/libtraceevent-event_find.txt    |  8 ++--
 Documentation/libtraceevent-event_get.txt     | 14 +++---
 Documentation/libtraceevent-event_list.txt    | 10 ++---
 Documentation/libtraceevent-event_print.txt   |  4 +-
 Documentation/libtraceevent-field_find.txt    | 10 ++---
 Documentation/libtraceevent-field_get_val.txt | 18 ++++----
 Documentation/libtraceevent-field_print.txt   | 18 ++++----
 Documentation/libtraceevent-field_read.txt    |  6 +--
 Documentation/libtraceevent-fields.txt        |  8 ++--
 Documentation/libtraceevent-file_endian.txt   |  8 ++--
 Documentation/libtraceevent-filter.txt        | 44 +++++++++----------
 Documentation/libtraceevent-func_apis.txt     | 35 ++++++++-------
 Documentation/libtraceevent-func_find.txt     | 10 ++---
 Documentation/libtraceevent-handle.txt        | 16 +++----
 Documentation/libtraceevent-header_page.txt   | 14 +++---
 Documentation/libtraceevent-host_endian.txt   | 14 +++---
 Documentation/libtraceevent-log.txt           |  4 +-
 Documentation/libtraceevent-long_size.txt     |  8 ++--
 Documentation/libtraceevent-page_size.txt     |  8 ++--
 Documentation/libtraceevent-parse-files.txt   | 10 ++---
 Documentation/libtraceevent-parse_event.txt   |  8 ++--
 Documentation/libtraceevent-parse_head.txt    |  8 ++--
 Documentation/libtraceevent-plugins.txt       | 30 ++++++-------
 Documentation/libtraceevent-record_parse.txt  | 18 ++++----
 .../libtraceevent-reg_event_handler.txt       | 12 ++---
 .../libtraceevent-reg_print_func.txt          | 20 ++++-----
 Documentation/libtraceevent-set_flag.txt      | 12 ++---
 Documentation/libtraceevent-strerror.txt      |  8 ++--
 Documentation/libtraceevent-tseq.txt          | 28 ++++++------
 Documentation/libtraceevent.txt               |  2 +-
 include/traceevent/event-parse.h              |  2 +
 src/event-parse-api.c                         | 14 ++++++
 src/parse-utils.c                             | 18 +++++---
 37 files changed, 261 insertions(+), 238 deletions(-)

-- 
2.34.1

