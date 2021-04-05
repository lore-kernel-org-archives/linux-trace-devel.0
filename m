Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2108C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8720613B6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbhDEOVa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241301AbhDEOVa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C2BC061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h10so12707008edt.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bx0IwbYTflDi7XjK37L93nsygl+2jWgYd7hRljVpQOk=;
        b=obAXnLWI+48QbPyNbM22AaiwXu2zaGz+tmwXwXTT5s6zdAypv4omhEkWAEk/k65WnD
         fWtK/fsSXGwxwXXpUh6yb67DBgfAQMz+6i25ty935LYPe1JvXHpBdWEr9RjxlD20xtU+
         JBqFVilMKC7/elsUWNVn7LmIlhAl7tL2uostKEiNFCVloT7FD/Ff/tMD/F5/p3QASro7
         Fv75pBu+FwsrLovNCLVfYoizuCf7VWsQXXuo2pCWO5U2E64DrGg0NDEwlSnVXy4AiPwd
         tGDGMMTL9weIhIa94gup95xkARL6gnbEgAOSDB4N4AHCHFKdpYCM8qxH/GvOFw2TSYWq
         d8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bx0IwbYTflDi7XjK37L93nsygl+2jWgYd7hRljVpQOk=;
        b=b3QKoxLy64Bi9q+F+yn9lrgWP0zIaFOu03sCWAGsTbiJaU/P2vRzNcODzlDutNBQH5
         ZfOhtDCkKgrWdVb0IO1bNwvx07fcuOEkmT5iQd6up3aeZMpyuS3hKpGdMbjw2YvdWnb3
         C3hVSqtUNIxC/UB7PisqSY5UXOd+abB1sE0nPP9t8VvNV7oPKxaK72JYWOt61188wW4K
         T4BGjWSVeozDr2jr0iz83hm/qMqmhKLR0TEeJQ2rmH0fREIzYapgRezgiirriAafpa4E
         y4kqVpS/urNP8Z/6wrJkyQNJ/ePIbigUO6TVTj0KO1mrq4eiYyIe49iNMWdlSoMjWFdU
         adoQ==
X-Gm-Message-State: AOAM530sAuJioJcCjf6M3mYjrainxQfzhwbL81s+T718Hjq1oDRQ6TbE
        spA81TU8gK/UgaAdIcNjjZ4=
X-Google-Smtp-Source: ABdhPJxHxjcUam15m7TlYvGNPJopxZcYmQNs44eqaWEVnUIwVFxOZyLnh2/kSXk2DV50IqNi0LR9zg==
X-Received: by 2002:aa7:d6ce:: with SMTP id x14mr11971965edr.66.1617632482707;
        Mon, 05 Apr 2021 07:21:22 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/5] libtracefs: Fix issues with tracefs_option_id()
Date:   Mon,  5 Apr 2021 17:21:03 +0300
Message-Id: <20210405142107.507711-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210405142107.507711-1-y.karadz@gmail.com>
References: <20210405142107.507711-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Few mistakes have been made when introducing this API function.
First of all, its declaration is missing from the header file.
In addition to this the argument type is missing "const".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   | 1 +
 src/tracefs-tools.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 05bd0ef..fbd7db5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
+enum tracefs_option_id tracefs_option_id(const char *name);
 
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b..51a7971 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -181,7 +181,7 @@ const char *tracefs_option_name(enum tracefs_option_id id)
  * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
  * unknown option name.
  */
-enum tracefs_option_id tracefs_option_id(char *name)
+enum tracefs_option_id tracefs_option_id(const char *name)
 {
 	int i;
 
-- 
2.27.0

