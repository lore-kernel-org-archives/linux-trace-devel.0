Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7882BC10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50EEA21850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfDEODk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55136 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbfDEODj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id c1so6816916wml.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tGKuJytLVcw1YTuzzOeDJjOCkflDU6Jx6NAV2czCh4=;
        b=NZMDUIQTaeGjqh6IPwVMQak2XBJeZDOsZeNDdsXcoBUUjq+Y3TNCy8FNL2VujkpxDX
         /jVaYL5oqxcTm44sfMpdKeoyTUTKDmUwCzbRWAMeHtXhJoMdl9cGFmmJS5BvWGArNwia
         nYC8amc9n4Ka9fDF44rRBUm5ZfNuXyhrJ8W0+/sKeiiFI7NAE+j8caQU/zLxQWfeTq5K
         O+bQ3cjWiVeInkfXYt5IdrDy8T5OUnSfINVVyqWuDtMnzuY6TfkxfAo3pxIK8V3vVVWP
         htZhnsobRdvVWtjnaGdgfu3vk2oi351fq9IjCFVyyr/dxSXmumeaEQBp0JuhpXp2VcRI
         gSRg==
X-Gm-Message-State: APjAAAVlIE1oPsIeURQ7HxMrIzh5Fd+GIBZOEDuvyP30A3Hg2QetdcQD
        VJJpcGb7Pkkmfl/Uujsept0=
X-Google-Smtp-Source: APXvYqzkctsGKoFB1MvnOwUynXH2oje34khRn7TEX6Sjcohox6tK1k3lwWzv7y11n90F6tKmiWxSXA==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr8416749wmb.7.1554473018261;
        Fri, 05 Apr 2019 07:03:38 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:37 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/10] tools lib traceevent: Removed unneeded !! and return parenthesis
Date:   Fri,  5 Apr 2019 17:03:25 +0300
Message-Id: <20190405140332.10949-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

As return is not a function we do not need parenthesis around the return
value. Also, a function returning bool does not need to add !!.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164343.817886725%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C420f58a3ff864e3d93b408d6b7853daf%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180235384820&amp;sdata=PTx4BKspBlUxHIPfzZRf2Rj5J8LmfzXxdCIXKdDUtoA%3D&amp;reserved=0
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/event-parse-api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index f2e5d18..fb49d1b 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -88,7 +88,7 @@ void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
-		return (tep->flags & flag);
+		return tep->flags & flag;
 	return false;
 }
 
@@ -367,7 +367,7 @@ int tep_get_parsing_failures(struct tep_handle *tep)
 bool tep_is_old_format(struct tep_handle *tep)
 {
 	if (tep)
-		return !!(tep->old_format);
+		return tep->old_format;
 	return false;
 }
 
-- 
2.20.1

