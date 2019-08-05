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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FECC0650F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 10:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A0B820578
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Aug 2019 10:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="daNeQjnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfHEK06 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 06:26:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41413 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbfHEK06 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 06:26:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so36169370pls.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 03:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5a0d+8RpwXiSrY19a0aDW2ItSnarcmNf3hA69Qx9ww=;
        b=daNeQjnRcGeZ1qPO4aOWJvxI9AY/oC+mLojtAmibj/rS2YZ3VVYTvbLn6E2fryuYtt
         WWtVlQbDmGUP8qDcuWKDwnYfBiV3A3fxSXTGmy7IcA5INWJ4jGdza2rIOG1ZmbDqakqt
         sGBN8fQmy3OhLNZUQ0QIRRe+ri+1BK+vkRHZa8Y3x/qvBpyAQxsyOpzmn9JnOb44Llgl
         LjlZ0UA88bom0GL2/84eZtjkQLtUvvVINVkm2FcLuw3teAAAY0/6+mbr+Hl70HxUIZOl
         zu36z4JzzccSLrtucFHR+AMhy8xYlrJeE9eX5dXZSQ/nbHfG5a2mxif1IUnioUoAUieP
         1Exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H5a0d+8RpwXiSrY19a0aDW2ItSnarcmNf3hA69Qx9ww=;
        b=V8D26kSVhwazvYzMHYJFUZ4p4AcS24nfYqRNtYNYNqthW6tRqlNB0jRqjgZrxOZXg5
         W2iRpreDNeGO7T+QKFB8sem/tFldJG6a+FtR6NXNRuuvmy/PYs2y5Gt0nwOwhkkutjrh
         6dKd71GYLdJHYMKfitbIOdmOL5RALnb+pvqWp4lLu5gZ0iFBn2tUF7GcU5KgMNEWBO1i
         SICYFdWnIqtALK7McMYYjmWVNuVyX4vNB/TYF/L/aR6ii2lS8Ae8gRJB5U2j9WenqBNY
         rj7S+yLGFDb69m1NaLFplM/yv04fuJJGwCGTckr82KFSPlrGLAW9jJax2hdmSCWGqYcS
         W2FQ==
X-Gm-Message-State: APjAAAVyEhaFjzf+9ipvBcO70nYEOfTWfK+n/DCe00R/W4hlHBhsDiwc
        52pOJqQPc2S1EywFxfezZm05KNXN
X-Google-Smtp-Source: APXvYqx21GAGvTihssK+PNExL7JJJbZN9JnFZvQCvKUmqwjSJjho0dwYaLfYtmnxA5oKU76MUC1Lqw==
X-Received: by 2002:a17:902:4324:: with SMTP id i33mr4860909pld.108.1565000817739;
        Mon, 05 Aug 2019 03:26:57 -0700 (PDT)
Received: from localhost.localdomain ([110.70.27.66])
        by smtp.gmail.com with ESMTPSA id x13sm88613482pfn.6.2019.08.05.03.26.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 03:26:57 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 2/2] parse-events: deref pointer for proper sizeof()
Date:   Mon,  5 Aug 2019 19:26:46 +0900
Message-Id: <20190805102646.31142-2-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
References: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
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
index 807fc53..1a25a7d 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -4778,7 +4778,7 @@ int pevent_register_event_handler(struct pevent *pevent,
  not_found:
 	/* Save for later use. */
 	handle = malloc_or_die(sizeof(*handle));
-	memset(handle, 0, sizeof(handle));
+	memset(handle, 0, sizeof(*handle));
 	handle->id = id;
 	if (event_name)
 		handle->event_name = strdup(event_name);
-- 
2.22.0

