Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2153DC54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiIVPYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiIVPYN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE68F8C14
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8D90B83856
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083CAC43142;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzkg-1q;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/9] libtraceevent: Add checks for man pages 
Date:   Thu, 22 Sep 2022 11:25:01 -0400
Message-Id: <20220922152510.3335601-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the check code from libtracefs that makes sure every function in
event-parse.h is documented in man pages, and that every man page entry is
listed in the top level libtraceevent man page.

Steven Rostedt (Google) (9):
  libtraceevent: Add check-manpages.sh
  libtraceevent: Update man page to reflect tep_is_pid_registered()
    rename
  libtraceevent: Add printk documentation to libtraceevent man page
  libtraceevent: Add tep_get_function_count() to libtraceevent man page
  libtraceevent: Include meta data functions in libtraceevent man pages
  libtraceevent: Add some missing functions to generic libtraceevent man
    page
  libtraceevent: Add man page for tep_plugin_add_option()
  libtraceevent: Add man page documentation of tep_get_sub_buffer_size()
  libtraceevent: Add tep_print_field() to check-manpages.sh deprecated

 Documentation/libtraceevent-commands.txt  |  2 +-
 Documentation/libtraceevent-page_size.txt | 10 ++++-
 Documentation/libtraceevent-plugins.txt   |  9 +++-
 Documentation/libtraceevent.txt           | 22 +++++++++
 Makefile                                  |  5 ++-
 check-manpages.sh                         | 54 +++++++++++++++++++++++
 6 files changed, 98 insertions(+), 4 deletions(-)
 create mode 100755 check-manpages.sh

-- 
2.35.1

