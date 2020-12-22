Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F99C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50ECB23122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLVExt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 23:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVExs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 23:53:48 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704D8C0613D3
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:08 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d26so13196506wrb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5RAqzfshRQIRp1tus0ZySowkb15Uyzn8LqjTsDN+l7I=;
        b=TnrJFg0mRfcSySWu7KYDC1egWn1ceY4vTgsGs5u0XTWXNt62oDic+YVFlytqZ9etEm
         g/X/yqNvG6HT0iXvQuVgFcHwEkDwt9ol0wj0RKhplAUl6OpQx7CnXjsUA3kdATKK/ymH
         aUJupdm2SH3OXJruAFZlzGe+G0z80F1L01au7q6OXlm5SV/2cFsTKduPmRq8fdCsjiMV
         bfYjYABLCFkSJ0LIL04Lu/3nOlAoo97JsQRsIX5bTjo4oYycjLMfVY2yO6Iuj5BhEt04
         WFCSN9mKRqKkMw5wQfj3gN+61T8qCZyLsdRwxteCMkeqct9dTolFFUybbIkTWcT4+Ar1
         afog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5RAqzfshRQIRp1tus0ZySowkb15Uyzn8LqjTsDN+l7I=;
        b=aLBbZNm+G2evUlYjDmhvdrJ07DToxFhby5XKGi02+3plgrI7anShP/jGza3E4kPd/m
         J9JEOCDaX/0R/w5JCcDYv2CzfqJg3JBQRBvetnbZY/VDjkqfO6YDgdDy4AjO9UBIM6Ek
         kYRDQoSzbtjNqplYEEAyVmsQna4TJtxSixgl0TZt9lIhaRiGFvP1bob+5TXRI9orif7P
         Oc0zn68CYaCvIgDkh0tgcbqPrE0DiyUSZOUHGhhzzBhKBGsncdn+2MFC5mBCYzruaFj4
         0VhxCO9zXmcVDWWqwaUXasOwK3FiqUXVyUb5hr/UNW5m5QZ4Tbn3f9yEiv5s4eNtpulv
         HGnQ==
X-Gm-Message-State: AOAM532TFjCsOAvEFuARNvYU1N/Oj6CjdebEloDX+gQ8jjwuntwFUeMa
        diuNu6h6+cs5q0GYCQG9cmcGpNUpdfaJVlns
X-Google-Smtp-Source: ABdhPJzW5sTNTAaGV/DOxejHVmF0ENmIFxqzJlISvamItGEBnvn5w048UPl5TJMdnA3XnQPsZYfnXA==
X-Received: by 2002:a5d:4987:: with SMTP id r7mr22530599wrq.352.1608612787112;
        Mon, 21 Dec 2020 20:53:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c7sm32924159wro.16.2020.12.21.20.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 20:53:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/2] libtracefs man pages
Date:   Tue, 22 Dec 2020 06:53:02 +0200
Message-Id: <20201222045304.369175-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of libtracefs man pages.

v3 changes:
 - Removed accpeted patches from the set.
 - Fixed description of the tracing_dir parameter, to be the same
   in all man pages.
 - Removed "<event-parse.h>" includes.

v2 changes:
 - Removed tracefs_find_tracing_dir() API
 - Renamed tracefs_get_tracing_dir() to tracefs_tracing_dir()
 - Removed any references to "#include <event-parse.h>"
 - Rewrote some descriptions, as suggested by Steven.

Tzvetomir Stoyanov (VMware) (2):
  libtracefs man pages: APIs for initializing a tep handler with trace
    events from the local system.
  libtracefs man pages: helper APIs for working with trace file system.

 Documentation/libtracefs-events-tep.txt | 130 ++++++++++++++++++++++++
 Documentation/libtracefs-utils.txt      | 103 +++++++++++++++++++
 2 files changed, 233 insertions(+)
 create mode 100644 Documentation/libtracefs-events-tep.txt
 create mode 100644 Documentation/libtracefs-utils.txt

-- 
2.28.0

