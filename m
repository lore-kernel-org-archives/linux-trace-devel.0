Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4DEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 23:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353440AbiDAXpR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 19:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiDAXpQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 19:45:16 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E619F10A1;
        Fri,  1 Apr 2022 16:43:23 -0700 (PDT)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5F65B20DEEDA;
        Fri,  1 Apr 2022 16:43:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F65B20DEEDA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648856603;
        bh=o3+64FyHzHFGISd3O72rfJhaBDSRw3VyMvr43Q6rw9Q=;
        h=From:To:Cc:Subject:Date:From;
        b=nwnS8u68KgDr+OZ9f4Qu/8BJK7Bn+8NjRTt8KNu/fach/C3ELFciafdvpGwav30wl
         MjwbhzpCwTcUofazZGwUKvB8gz9XMlNjLQ3bPcs9EH5M4c3AfEZBB3kAhcmaofpdGr
         BfU74a3W45oDaeY4FN6Gt8Wn5wjtEjlF+aaxQsPg=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH 0/7] tracing/user_events: Update user_events ABI from
Date:   Fri,  1 Apr 2022 16:43:02 -0700
Message-Id: <20220401234309.21252-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This series covers the changes that were brought up once user_events went into
5.18. The largest change is moving away from byte index to a bit index, as
first suggested by Mathieu Desnoyers.

The other changes are either fixes that have accumulated or found by Mathieu.

NOTE: The sample and self-tests do not build unless you manually install
user_events.h into usr/include/linux.

Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Psuedo code example of typical usage with the new ABI:
struct user_reg reg;

int page_fd = open("user_events_status", O_RDWR);
char *page_data = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, page_fd, 0);
close(page_fd);

int data_fd = open("user_events_data", O_RDWR);

reg.size = sizeof(reg);
reg.name_args = (__u64)"test";

ioctl(data_fd, DIAG_IOCSREG, &reg);
int status_id = reg.status_index;
int status_mask = reg.status_mask;
int write_id = reg.write_index;

struct iovec io[2];
io[0].iov_base = &write_id;
io[0].iov_len = sizeof(write_id);
io[1].iov_base = payload;
io[1].iov_len = sizeof(payload);

if (page_data[status_id] & status_mask)
	writev(data_fd, io, 2);

Beau Belgrave (7):
  tracing/user_events: Fix repeated word in comments
  tracing/user_events: Use NULL for strstr checks
  tracing/user_events: Use WRITE instead of READ for io vector import
  tracing/user_events: Ensure user provided strings are safely formatted
  tracing/user_events: Use refcount instead of atomic for ref tracking
  tracing/user_events: Use bits vs bytes for enabled status page data
  tracing/user_events: Update ABI documentation to align to bits vs
    bytes

 Documentation/trace/user_events.rst           |  46 ++--
 include/linux/user_events.h                   |  19 +-
 kernel/trace/trace_events_user.c              | 213 ++++++++++++------
 samples/user_events/example.c                 |  12 +-
 .../selftests/user_events/ftrace_test.c       |  16 +-
 .../testing/selftests/user_events/perf_test.c |   6 +-
 6 files changed, 187 insertions(+), 125 deletions(-)


base-commit: bfdf01279299f1254561d6c2072f1919e457e23a
-- 
2.25.1

