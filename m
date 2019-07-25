Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE90C7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 08:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE37022BED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 08:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GM4VnWyz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389907AbfGYIx7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 04:53:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33538 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389901AbfGYIx7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 04:53:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so49940513wru.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 01:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6FZk9N+hYlDA6LUvmkuVmSDX8jUHwmPL6hm+uulPjc=;
        b=GM4VnWyz++QRqkOHRhfqlt7Ci6MmqBvCFR1ocY+lWUMA/Sqj/IAaVXi7ErEJqGpGyK
         mVOus7x+cqf7hQmispV+j90x1V3wm+SAp+FTmK6fFF+amRUZSJuTMUX3DAIoO0BjYvPn
         y9Z0zbjU/s1qr0mNocIpKLa8SKI4017hC5KdnwTCBk9sKmcv9PoqBua0lISQ2Sn9Vyp6
         QUqR4GxJNirYyJfzfVCc2W8KH03sp7hFfajVykyFMsfRYXFctRpRQHjOrECbM8agWmpc
         npQDjzsjdXZAJufhVvBouNiCKrDZizoRU4SFBXT8xYEHMJOTrzi0eE1wZxLpe7LlhLLu
         niig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6FZk9N+hYlDA6LUvmkuVmSDX8jUHwmPL6hm+uulPjc=;
        b=bBH8+bT/dJwblS4IW8qbMs477JAStw/ks7s9ShebZJAVhXaQEODEDfakyUFfc/Beq3
         7rZgZKx7kkVtr+bX7qhlpI1w2F+2703TxtdSyv8pwnB5ooO8oxkv8pYDt6LKmkN9xSL8
         twRtAfIqvPegRYptW08Hcl0gxaKoQpZuMbROH6NIsoB5N/mz6RrkvKRNI1bUovWf8kXz
         +MaqpuVnshD9K0c3kptW8yEF3M5/ZsIHuqexqqwvm1zaqQmmaVJD67/U1aNCtwBLlaL7
         jvGUK9pelyFXCkqBZ7C590E1sH3yUXmMZ74vb9eraG12tzT3wTSGNfFRF3gkE9Magfcu
         5o9w==
X-Gm-Message-State: APjAAAWbm/QyiS3blbvYaxvM8m1GVj1TvW7dzcln+ha3zY7WsIzrkI8j
        HFh4iz/adA4QnWnaUuas+pg36Q702cM=
X-Google-Smtp-Source: APXvYqy1PVVF2fiufHoavrQo6fZskLkZqQaJEL6eOkt6HE7rtT7/SxPpPTcWfXz45q2y8BwCUWimfA==
X-Received: by 2002:adf:ab51:: with SMTP id r17mr66682439wrc.95.1564044837562;
        Thu, 25 Jul 2019 01:53:57 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id j17sm74254601wrb.35.2019.07.25.01.53.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 01:53:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Xserver, grant access to user root
Date:   Thu, 25 Jul 2019 11:53:55 +0300
Message-Id: <20190725085355.15921-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

In order to make connections to the X server, users must be in
the X server allow list. As kernelshark may run with root privileges,
the user "root" must be in this list. There is such logic in
kshark-su-record, but it works only for Wayland X server. Some Linux
distributions use other X servers, so the logic must be executed always.
It grants access to user "root" to initiate connections to the X server from
the local machine.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 kernel-shark/bin/kshark-su-record | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
index 8c9fbd0..c14f03d 100755
--- a/kernel-shark/bin/kshark-su-record
+++ b/kernel-shark/bin/kshark-su-record
@@ -1,9 +1,6 @@
 #!/bin/bash
 
-if [ "$XDG_SESSION_TYPE" = "wayland" ]
-then
-    xhost +si:localuser:root &>/dev/null
-fi
+xhost +si:localuser:root &>/dev/null
 
 THIS_DIR=`dirname $0`
 pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
-- 
2.21.0

