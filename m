Return-Path: <SRS0=cY0P=WB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44911C433FF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 10:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1785120578
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 10:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3whiING"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfHEK0y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 06:26:54 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:35823 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbfHEK0y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 06:26:54 -0400
Received: by mail-pl1-f176.google.com with SMTP id w24so36301068plp.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 03:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaEof87/l2CSH7k/oYAMcB821mdfap6W4g9T3RgxBNg=;
        b=I3whiINGB42OpMPQxOqv1YyMou3cUUYTIeanNf2TP5sU5aKKX4uQNfSV1ZrSWA/a0Z
         1E9IeH9UIEX+E2ooK7PoKQ07ok+8/tHoTmw2k+O6lrtG5n/l9qZ7o4pQcF0J/bfwax1o
         oZaZG+PGSTI97AZ9PR4n1hBgbpfKHdshmbUwn9tqqASvJ0coBI3isxWA5UqbKJsH3C+j
         +mTLi3zU0jg1cDlZYctncmf9mlptJ5f2b0C4cJZ/Hho2aZGRyOB3PHHuL+Ldiv+VhjAg
         W8rhMyIskez+RAqpkVVQTKRGFV6O5PHMzoOGrAjEkxiPlv3yM8GJHKw4N7V/od8wgiPn
         4ksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaEof87/l2CSH7k/oYAMcB821mdfap6W4g9T3RgxBNg=;
        b=FlcwqQV+QRga/9G7e5rdFr6bLZSQxd6CwepcvzuBuOx0uhjeIF8rMij/KyGuk1zH7i
         NiYyn3f5k3HJ0JJhpBYjPcq+9q5dvyXyoYJ6QTIQ/hMHFVWs4ZlI/UIi+0AkviSQKOni
         gsK0ajtYQQ3SwPqTVW1Kx0UW6mLLolq2Em0W+n7fOELoVrkiLXY4XnUZ+TTHb6C83NeE
         sCRdS6bKz3ieQjWVrtSO1HGwsR7LhLAdCBz+5sCsB8JjD8bVtND8UW6wULQa5YvXs/+d
         ovQ7ZmPaIh2ZdgLwuQaljJbNaST7xlBmsV+HNXpTybQzOlFunBiFxvaL7Mnbt+wAKasm
         x/yA==
X-Gm-Message-State: APjAAAW14YoIXLMPjtwMzPkBxRsk7zU4eifpNaFMcJqak+oemmU0M6A4
        +/+zmNRr9pNIbZJQl789TCY=
X-Google-Smtp-Source: APXvYqzQLcw9Gzn9RGbG9HjAXXQyNPCvr9/vQaLP/TK+qvcbc+VHj9aSXxKW8xzBRJy9Y4o7LuDnyw==
X-Received: by 2002:a17:902:4623:: with SMTP id o32mr141251701pld.112.1565000813873;
        Mon, 05 Aug 2019 03:26:53 -0700 (PDT)
Received: from localhost.localdomain ([110.70.27.66])
        by smtp.gmail.com with ESMTPSA id x13sm88613482pfn.6.2019.08.05.03.26.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 03:26:53 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/2] parse-events: deref pointer for proper sizeof()
Date:   Mon,  5 Aug 2019 19:26:45 +0900
Message-Id: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/parse-events.c b/parse-events.c
index 3d59d92..807fc53 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2058,7 +2058,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
+		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
 		field->value = strdup(value);
-- 
2.22.0

