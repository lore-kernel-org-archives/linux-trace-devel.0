Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D28CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D48760720
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 00:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhHDAl1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhHDAl1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 20:41:27 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D720C06175F
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Aug 2021 17:41:15 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id v15-20020a0ccd8f0000b0290335f005a486so591733qvm.22
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Aug 2021 17:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7gOCWTTACRo9q0rGX/Y2OgY1c+cXT6fyfz/EaWo56SY=;
        b=JPCtTeLZabC37x2WH6HAEQi7qyGEggIsMPCb3mUtHhYa0neDw08Vr1ArOS9VUMfI3+
         pQlADFdbQa/utkMZ73oBIGajOn5vmEZryrIynSCsEiaYZlmRoAqNBI0WAjoh9ewss/li
         b8pWfAhPiVOODG/Zqi7jy1Z3okcmSUS9/QH2WQ7RQgpSAOjx1FDGKdYXctCX49OKBomK
         bF4onuXvmjFYg3iEvBMyP6I1FN31D6Pyz9JUC3OBUEv76G9Vw9Et2olIQlWgOyULMzLO
         v8SYoyvuF/1V/LdGA1FNlobAurtTF15uTl/E9tSISkbtta4H10za4E9hTL7ih1Q2r7OA
         Ju4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7gOCWTTACRo9q0rGX/Y2OgY1c+cXT6fyfz/EaWo56SY=;
        b=l4AE5ZrsR4//SXpYzXbjzaVidaW9fEYe1yd2Rdn969h2Z3ybDElK4OtqgvvujWQuuK
         gHd5+05hyrkLliP9Tn76JRkaPO+RV9wAkHblyMp8tcw+Ih5A62MOf61VM+vkkR7lWLWn
         IDVV3xK2wx/cgrXxNWCkvf2Dbx5ZmhUd1s9Tj0X5ADa4C5QuEvYP7vQP9s7YZFVEx8UU
         +7DPiwhBJuKJ1H9YUSVlKOcwTGHpIOWPehXJ+4uckw42+6TB9Vs9A9as3cv71mme0JOd
         zylPAvd/+XeyEOHoepgL4kHui70duuZQNFk9SL0oEGEj+VLVHB4FskAZj2NNnnM/eSis
         UECA==
X-Gm-Message-State: AOAM532wqyUu5js0gYnijRTwtjpCChh/Dzt53TMOlOIf9S0Z+Zvy/+MD
        v20odY664EtFQnWoEYjPzcT5tShmIyasoFF9AZVjMKfgw0yBuF4z3Xw+deAVRPEM+jm/VQ7oKRo
        RC+1zDir6e0evliBNmBGRLp/cNpg/nN8AUR4DlSD7aHCbaFYnHCS1KQlgUMIRhwcE65hPTbAJb0
        9aKf0=
X-Google-Smtp-Source: ABdhPJzv68OBi81tWrl6rNBRzb7eVk2VIlCyIkbHxXl1J9Vqxp7lanoLlv/Zoq1qt0fNiHfgOOrhN0+XATlN
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:bfcb:f7e3:49a1:c031])
 (user=irogers job=sendgmr) by 2002:a0c:e6cc:: with SMTP id
 l12mr24409911qvn.48.1628037674651; Tue, 03 Aug 2021 17:41:14 -0700 (PDT)
Date:   Tue,  3 Aug 2021 17:41:08 -0700
Message-Id: <20210804004109.1476661-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 1/2] libtracefs: Silence non-literal-null-conversion warning
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On clang the warning looks like:

src/tracefs-utils.c:473:15: error: expression which evaluates to zero treated as a null pointer constant of type 'char *' [-Werror,-Wnon-literal-null-conversion]
        list[size] = '\0';

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 63bb413..a502c2d 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -470,7 +470,7 @@ int tracefs_list_pop(char **list)
 	size--;
 	*list = (char *)size;
 	list++;
-	list[size] = '\0';
+	list[size] = NULL;
 	return 0;
 }
 
-- 
2.32.0.554.ge1b32706d8-goog

