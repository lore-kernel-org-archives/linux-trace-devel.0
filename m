Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A349C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CDDEB8264F
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0403C36AEB;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dE-OO;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 00/10] libtraceevent: Makefile updates fixes and unit tests
Date:   Thu, 16 Dec 2021 16:39:46 -0500
Message-Id: <20211216213956.13934-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtraceevent Makefiles are a result of its several foster homes.
It started at trace-cmd and then went into the kernel, and now lives in
its own repository. The Makefiles were brought over from the previous
homes and modified and tweaked to get them to work. This added a bunch
of unnecessary logic that is not needed for just this library.

The Makefiles were rewritten to be more consistent with libtracefs and
with trace-cmd, which greatly simplified them.

A unit test was added to start testing event parsing and reading to lay
the ground work for more unit tests that will help keep libtraceevent
from having more regressions (like one that slipped in).

The processing of the old dynamic string format (which had just he
offset where the length of the string was simply determined by the size
of the string at the offset) stopped working. It actually worked by
shear luck, but changes to add the rel_loc parsing took away all that
luck. It had to be refactored to be more specific in knowing that the
format is of the old size.

Deprecate tep_print_field() as it does not give the user to pass the in
the size of the data to parse, and since it could be from untrusted
sources, that would make it a security issue.

Add tep_print_field_content() that requires a size also passed in.

Use the size more to verify that only the data gets looked at and does
not rely on the data to stay within bounds.

*** NOTE *** there needs to be an audit of all the code to add checks to
make sure all access are within the data. Even though the size is now
passed in, there are many cases where what is parsed is going to be
within those limits.


Steven Rostedt (VMware) (10):
  libtraceevent: Fix installing of man pages in remote directory
  libtraceevent: Rewrite Makefiles to be like libtracefs
  libtraceevent: Have make tags and TAGS honor O= build directory
  libtraceevent: Move installed headers into their own directory
  libtraceevent: Add unit test framework for library commands
  libtraceveent: Add testing of old dynamic string event layout
  libraceevent: Add unit test to test print_fmt with dynamic strings
  libtraceevent: Account for old dynamic string formats and honor size
  libtraceevent: Replace tep_print_field() with
    tep_print_field_content()
  libtraceevent: Have print_field_raw() handle old data layout

 Documentation/Makefile                      |  16 +-
 Documentation/libtraceevent-field_print.txt |  10 +-
 Documentation/libtraceevent.txt             |   2 +-
 Makefile                                    | 215 +++++++++++---------
 build/Build.include                         | 103 ----------
 build/Makefile.build                        | 162 ---------------
 {src => include/traceevent}/event-parse.h   |   8 +-
 {src => include/traceevent}/event-utils.h   |   0
 {src => include/traceevent}/kbuffer.h       |   0
 {src => include/traceevent}/trace-seq.h     |   0
 plugins/Makefile                            |  63 ++----
 scripts/Makefile.include                    | 135 ------------
 scripts/features.mk                         |  37 ++++
 scripts/utils.mk                            | 174 ++++++++++++++++
 src/Makefile                                |  51 ++++-
 src/event-parse.c                           |  96 ++++++---
 utest/Makefile                              |  38 ++++
 utest/README                                |  17 ++
 utest/trace-utest.c                         |  86 ++++++++
 utest/trace-utest.h                         |  14 ++
 utest/traceevent-utest.c                    | 172 ++++++++++++++++
 21 files changed, 807 insertions(+), 592 deletions(-)
 delete mode 100644 build/Build.include
 delete mode 100644 build/Makefile.build
 rename {src => include/traceevent}/event-parse.h (99%)
 rename {src => include/traceevent}/event-utils.h (100%)
 rename {src => include/traceevent}/kbuffer.h (100%)
 rename {src => include/traceevent}/trace-seq.h (100%)
 delete mode 100644 scripts/Makefile.include
 create mode 100644 scripts/features.mk
 create mode 100644 scripts/utils.mk
 create mode 100644 utest/Makefile
 create mode 100644 utest/README
 create mode 100644 utest/trace-utest.c
 create mode 100644 utest/trace-utest.h
 create mode 100644 utest/traceevent-utest.c

-- 
2.33.0

