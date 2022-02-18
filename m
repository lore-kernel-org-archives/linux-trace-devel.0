Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E0BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 22:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbiBRWvV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 17:51:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbiBRWvU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 17:51:20 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 015BB27374F
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 14:51:03 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 86B3B20C27C8;
        Fri, 18 Feb 2022 14:51:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 86B3B20C27C8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645224662;
        bh=Iy12IwHPRI6s5gs9bC9whcNZsFvC+x5IuyzZGG4aAu0=;
        h=From:To:Cc:Subject:Date:From;
        b=J8jzKII4+LvZQVPFO7J7nFnsmyuNGNYwnaj0qm+lWx6ifp/nPykjyw9c1wgkgsJgJ
         Hp0OoXdH6dNIRo9k6DrcEwo/0+O64In1DJA2z8SbcOc0kUC11MNfVtkOZXy0bKhBy/
         2ie5WkNt5DxPIY44bxYEwJzK5w+FpLA9Dolvp7zM=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v1 0/3] libtracefs: Add APIs for user_events to libtracefs
Date:   Fri, 18 Feb 2022 14:50:55 -0800
Message-Id: <20220218225058.12701-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New APIs added:
struct tracefs_user_event_group *tracefs_user_event_group_create(void);

void tracefs_user_event_group_close(struct tracefs_user_event_group *group);

int tracefs_user_event_delete(const char *name);

struct tracefs_user_event *
tracefs_user_event_register(struct tracefs_user_event_group *group,
                            const char *name, enum tracefs_uevent_flags flags,
                            struct tracefs_uevent_item *items);

bool tracefs_user_event_test(struct tracefs_user_event *event);

int tracefs_user_event_write(struct tracefs_user_event *event,
                             struct tracefs_uevent_item *items);

Documentation updates in this series describes the various APIs and the reason
for a group.

Items are described with a struct to better ensure contracts for things like
custom structs or static length strings. Items are allowed to be mixed/different
than what they were when registered. This allows callers the ability to describe
events verbosely, but write out via packed structs in their own code if needed.

Beau Belgrave (3):
  libtracefs: Add user_events to libtracefs sources
  libtracefs: Add documentation and sample code for user_events
  libtracefs: Add unit tests for user_events

 Documentation/libtracefs-userevents.txt | 258 +++++++++++
 Makefile                                |   8 +
 include/tracefs-local.h                 |  24 ++
 include/tracefs.h                       |  60 +++
 samples/Makefile                        |   4 +
 src/Makefile                            |   4 +
 src/tracefs-userevents.c                | 545 ++++++++++++++++++++++++
 utest/tracefs-utest.c                   | 233 ++++++++++
 8 files changed, 1136 insertions(+)
 create mode 100644 Documentation/libtracefs-userevents.txt
 create mode 100644 src/tracefs-userevents.c


base-commit: e579ba38ff6bc07cd2278faf9d3ac08c15d4e9e8
-- 
2.17.1

