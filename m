Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9D0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiBVXXs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 18:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiBVXXr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 18:23:47 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E988D95A03
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 15:23:20 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 77B2B20C31B9;
        Tue, 22 Feb 2022 15:23:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 77B2B20C31B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645572200;
        bh=6L0tx3EHVVitGvtMIV6G2nGlTpIK6Z5lSyv/2ST63To=;
        h=From:To:Cc:Subject:Date:From;
        b=P7Dp62enMBaDltRQmR6CZg/GTrm8QWRmbERS9ZYXC+/GUjRb5dfziZm0LJqm7z9J0
         w4lbgc/OUOjOlccjsxNsZuxCQEp2LSfgMH/6HT8oFFe8La7hbU5gQqJyxdKnOHRgSf
         fgkLnEBDzIClWO2/XGhW534jQrT2luH11pPLA5ck=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v2 0/3] libtracefs: Add APIs for user_events to libtracefs
Date:   Tue, 22 Feb 2022 15:23:13 -0800
Message-Id: <20220222232316.14640-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New APIs added:
struct tracefs_user_event_group *tracefs_user_event_group_open(void);

void tracefs_user_event_group_close(struct tracefs_user_event_group *group);

int tracefs_user_event_delete(const char *name);

struct tracefs_user_event *
tracefs_user_event_register(struct tracefs_user_event_group *group,
                            const char *name, enum tracefs_uevent_flags flags,
                            struct tracefs_uevent_item *items);

bool tracefs_user_event_enabled(struct tracefs_user_event *event);

int tracefs_user_event_record(struct tracefs_user_event *event,
			      struct tracefs_uevent_item *items);

Documentation updates in this series describes the various APIs and the reason
for a group.

Items are described with a struct to better ensure contracts for things like
custom structs or static length strings. Items are allowed to be mixed/different
than what they were when registered. This allows callers the ability to describe
events verbosely, but write out via packed structs in their own code if needed.

V2:
Renamed tracefs_user_event_group_create() to tracefs_user_event_group_open()
Renamed tracefs_user_event_test() to tracefs_user_event_enabled()
Renamed tracefs_user_event_write() to tracefs_user_event_record()
Updated documentation to new function names
Moved to trace_seq vs snprintf for register commands
Split struct tracefs_user_event into external and internal sides for inlining
Changed tracefs_user_event_enabled to inline function
Fixed nits and whitespaces
Keep track of user view size to allow backward / forward compat if needed
Couldn't get variadic helper macro to work well, not including it here for now

Beau Belgrave (3):
  libtracefs: Add user_events to libtracefs sources
  libtracefs: Add documentation and sample code for user_events
  libtracefs: Add unit tests for user_events

 Documentation/libtracefs-userevents.txt | 260 ++++++++++++
 Makefile                                |   8 +
 include/tracefs-local.h                 |  24 ++
 include/tracefs.h                       |  67 +++
 samples/Makefile                        |   4 +
 src/Makefile                            |   4 +
 src/tracefs-userevents.c                | 516 ++++++++++++++++++++++++
 utest/tracefs-utest.c                   | 233 +++++++++++
 8 files changed, 1116 insertions(+)
 create mode 100644 Documentation/libtracefs-userevents.txt
 create mode 100644 src/tracefs-userevents.c


base-commit: e579ba38ff6bc07cd2278faf9d3ac08c15d4e9e8
-- 
2.17.1

