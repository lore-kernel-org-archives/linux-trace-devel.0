Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF20C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110396109F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhHJUsr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A7FE61076;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hA3-1Q; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/9] libtracefs: APIs to read a trace event hist file
Date:   Tue, 10 Aug 2021 16:48:09 -0400
Message-Id: <20210810204818.880714-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The hist trigger for trace events will create a histogram that can be read
in the trace event's hist file. The file is human readable ASCII format, but
that makes it difficult to process in programs. The tracefs_hist_data*()
functions convert the histogram ASCII format into structures that can be
processed and converted into tables.

This patch series creates an API to read and parse this data into machine
code readable structures that can then be processed. There's a working
program in the man page.

I found the parsing of the hist file to be somewhat trivial where I only
needed to implement flex to do most of the work and was able to avoid using
bison. That said, there are still some histograms that can fail to parse.
Namely, if any key has a comma (,) or a colon (:) in it. This includes exec
names if there's a program name with a comma or colon. This can be fixed with
a bit more clever tricks with the lexer, but I'll add those if this becomes
an issue.

This series is also in my personal github account here:

  https://github.com/rostedt/libtracefs/tree/read-hist

Steven Rostedt (VMware) (9):
  tracefs: Add API tracefs_hist_data_parse()
  libtracefs: Parse comment for hist data information
  libtracefs: Change hist_data_key type to flags
  libtracefs: Add API tracefs_hist_data_read()
  libtracefs: Add API tracefs_list_dup()
  libtracefs: Add APIs tracefs_hist_data_keys/value_names()
  libtracefs: Add API tracefs_hist_data_keys/values() and next_bucket()
  libtracefs: Have tracefs_hist_bucket_key flags save the type
  libtracefs: Add man pages for tracefs_hist_data functions

 Documentation/libtracefs-hist-data-2.txt |  346 +++++++
 Documentation/libtracefs-hist-data.txt   |  294 ++++++
 include/tracefs.h                        |   54 +
 src/Makefile                             |    7 +
 src/tracefs-hist-data.c                  | 1175 ++++++++++++++++++++++
 src/tracefs-utils.c                      |   26 +
 6 files changed, 1902 insertions(+)
 create mode 100644 Documentation/libtracefs-hist-data-2.txt
 create mode 100644 Documentation/libtracefs-hist-data.txt
 create mode 100644 src/tracefs-hist-data.c

-- 
2.30.2

