Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442CCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 04:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiDKEMT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 00:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiDKEMS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 00:12:18 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3318D4E
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c7so21202750wrd.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Apr 2022 21:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gfCpegBKlDwY3MwHsgBsKrUwe3aAu9a5fzLls9wxDA=;
        b=PjlAdqrVMscArc62gtR1oykOWhe04tdRZqccN5pD7Evz/mPLnnqksmfTzmDUBI4zBw
         qJiPGX3dB6ykvtssKV3pyF+2Sz1uxuiISet5Cu5Ny+jx+3zH8J+i0Oj6nZBejvxQNqwS
         koPFqPdoc9xdixgXOopa5irXQyyvXhCOaNkNlA3H8zCqEGpoWs7GhOJU8Jdds5kvfOvF
         T2U055mgRd2+rpZZaLimZQ26efLj611aDHP/uw7NSn0jkINSsTNNZpQX+j7lEX5nnPnu
         JsuvOuk8pkVun8HrkEBJ3PQ1fF3td8b1HRBJGWeWCLw8O5YF1RlJW+0zo1+QbcQQkZMF
         HOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gfCpegBKlDwY3MwHsgBsKrUwe3aAu9a5fzLls9wxDA=;
        b=PP2Ws9E0sGIVn81JbIvd58++uz+Dfc2/wPIv3V27y21LMCoifOalAlbtx7U01F4BT4
         P3sUqL2Z9lfxj7gVKBtb1/OFl8M7PITj+BGoYHTicJU6kMLzKaUU/yuHv5akDPWhDfRh
         ol1WDYP1xtA0sIpu11y4XwFWcKwgfLQKgEFwH5xCl9qfuIpOj7b9/cr3cm8KgwycwPfB
         V2SgtBhk2LEz5LOVTgCMS1jL9VoDwGTYRg/lIwxPe2XPXHyZM1przbo4QyCIRpNT/UTA
         zJwHhRZJS2OqyDQVSdgpDqVciYyI2fSiIVqt2ewXr2vBKE8DGbXxL2ZupIekzV8DL2i9
         fWaA==
X-Gm-Message-State: AOAM532JXGUNQXNkqRNZMs8/pPyHOJdxz5kIgyl+ourhOSrOFa4taBq4
        M24uULg/gdMSdgMPpMq38MMnU+VMS+g=
X-Google-Smtp-Source: ABdhPJwPY+pXe6LzLzmaWEPWi9wpPfa9gqrdKX+yJDekuUVJfYZU/G7midiJrq6BzekFDKL0Uf/flA==
X-Received: by 2002:adf:eb88:0:b0:205:e113:dcb5 with SMTP id t8-20020adfeb88000000b00205e113dcb5mr23096407wrn.598.1649650204143;
        Sun, 10 Apr 2022 21:10:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c19c700b0038cc9aac1a3sm18091630wmq.23.2022.04.10.21.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 21:10:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, ycaibb@gmail.com
Subject: [PATCH] trace-cmd: Unlock tsync mutex on thread exit
Date:   Mon, 11 Apr 2022 07:10:02 +0300
Message-Id: <20220411041002.132379-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for synchronising host and guest time stamps uses pthreads and
mutexes. The guest pthread locks a mutex on the beginning of each
synchronization iteration and uses it to wait on a conditional variable.
When the synchronization is done and the thread exists, this mutex
should be unlocked.

fixes: 08b9d507 ("trace-cmd: Basic infrastructure for host - guest timestamp synchronization")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215808
Reported-by: Ryan <ycaibb@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index f8ec15a3..90ffa6d0 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -807,8 +807,10 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 			first = false;
 			pthread_barrier_wait(&tsync->first_sync);
 		}
-		if (end || i < tsync->vcpu_count)
+		if (end || i < tsync->vcpu_count) {
+			pthread_mutex_unlock(&tsync->lock);
 			break;
+		}
 		if (tsync->loop_interval > 0) {
 			get_ts_loop_delay(&timeout, tsync->loop_interval);
 			ret = pthread_cond_timedwait(&tsync->cond, &tsync->lock, &timeout);
-- 
2.35.1

