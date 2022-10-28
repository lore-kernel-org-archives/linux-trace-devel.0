Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4EFECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 00:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiJ1A1s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 20:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiJ1A1r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 20:27:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C16A232C
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Oct 2022 17:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 490D5B82712
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 00:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0409BC433D6;
        Fri, 28 Oct 2022 00:27:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ooDE7-00DoUe-1X;
        Thu, 27 Oct 2022 20:27:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Add more tracefs_cpu*() man pages
Date:   Thu, 27 Oct 2022 20:27:55 -0400
Message-Id: <20221028002758.3285764-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the functions:

  tracefs_cpu_alloc_fd()
  tracefs_cpu_free_fd()
  tracefs_cpu_pipe()

to the man pages.

Steven Rostedt (Google) (3):
  libtracefs: Move tracefs_cpu_open/close into its own man page
  libtracefs: Add man pages for tracefs_cpu_alloc_fd() and
    tracefs_cpu_free_fd()
  libtracefs: Add man pages for tracefs_cpu_pipe()

 Documentation/libtracefs-cpu-open.txt | 100 ++++++++++++++++++++++++++
 Documentation/libtracefs-cpu.txt      |  27 +++----
 Documentation/libtracefs.txt          |   3 +
 3 files changed, 117 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/libtracefs-cpu-open.txt

-- 
2.35.1

