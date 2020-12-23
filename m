Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4A6C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96962168B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgLWEiZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgLWEiZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:38:25 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC4C0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:37:45 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y17so17311671wrr.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkxACEhkbj67PmSMUWvHsjTIFIrxPLfdCS7sVujNVrc=;
        b=ua42+PHCBKxkOzu3hbq6kScu4SGCfICnEf/fdBUx5XzVSS/fxIKDUwQvwiSx6W+3B3
         hCzZWsPY0orAaTnx3UhaWf2xGVFP5xwf1L52BKPyQhKVM3Uz3sOdTzjFPHawG7gyACZD
         W9HenELbQ4/3JrUwg8BlDxtmACqZb9oscytaOCpUkjX3Q/Rzc5SEPjNC4LbwKpAhTsaE
         QbXL+DjbPZj2D1fUiEdD7IYFAy73pZejq3jP6ErsH6/JzbA7kSLX3jk2Sb6pgEUDL8UU
         khGE24A9IpY4QGgKCV3mn4MO1MT1BCG08xnxGF4B7XylF62r+s83nbzUFsruSHg5cmqU
         lxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YkxACEhkbj67PmSMUWvHsjTIFIrxPLfdCS7sVujNVrc=;
        b=c7Knp1jgV2IpY5cZ3cYi77FJ33bDPIN0MHRNAw9jjVgi51mDrk+7TUQEu2SclKM7r5
         OmEiM06pdEn7zr82/s2dcOxNmeuiGwTw8ajhR+znKyW144zJrdX70OGtdvImFl5YOCTR
         hdMAlslFERHXdqenTRmxGIWZZdMoPonsG3Ocnl7W9EFL0VKwLhkchj7ovUmPDFqbNivS
         MVyLuJiER1Yy3txnQJDBehCyGuVgWx4xqlyEY1iiTalWFIKmNDBE35F/kSmPueslZQDP
         Apz+pFj4b3iUl2gsZsRe1j4ONFqqVxjr4muUnqNtI88dTTgAWosiuXHt/BCnp0aQvTRn
         i/ng==
X-Gm-Message-State: AOAM533WwA2/hUBV2gJk17S4wIrOMgLzO5lqpStwVDRr/ZeD/nkTxPCv
        Ii6tKjMORXC5U2+5Oc5UrvWTkB6NBc83Ymdj
X-Google-Smtp-Source: ABdhPJyzPO1rMUJwJdT0sgS7Z//+7eoBPnSirvx4iCbCIcNGnlwrIghHRJ3y6Mrhu/JC3fYfJoxKKA==
X-Received: by 2002:a5d:6845:: with SMTP id o5mr26964460wrw.421.1608698263910;
        Tue, 22 Dec 2020 20:37:43 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g5sm32763481wro.60.2020.12.22.20.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:37:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Update the RESOURCES section of debug man pages
Date:   Wed, 23 Dec 2020 06:37:42 +0200
Message-Id: <20201223043742.587178-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The traceevent library has a new repo and all its man pages should point
to it. The debug man page still points the old repo, updated it with
  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtraceevent-debug.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-debug.txt b/Documentation/libtraceevent-debug.txt
index a0be84f..3ba573a 100644
--- a/Documentation/libtraceevent-debug.txt
+++ b/Documentation/libtraceevent-debug.txt
@@ -92,4 +92,4 @@ libtraceevent is Free Software licensed under the GNU LGPL 2.1
 
 RESOURCES
 ---------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
-- 
2.28.0

