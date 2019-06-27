Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4461EC48BD7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170602064A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ER6OJzlW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfF0PZI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:25:08 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:53011 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0PZI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:25:08 -0400
Received: by mail-pg1-f202.google.com with SMTP id a13so1466703pgw.19
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fNPbpOxHirk0Y+1N9r1ssPgt+FSdATl608uUX95PuE8=;
        b=ER6OJzlW7cNMCX8B7KowMCQOQPl04gBLT3Acc0Ju/VMrbFGSXHCTbazfVlYIHyN1ul
         zkqpI65l0nkO1ShroCYXZLAvzasHJQk/hLSGO+zajHlJRVgE5AWffoKXSTMxAYcW0/wq
         VoPAF9zj9W5X76bLhKiTgYLn/Ve5GiTuNt9Aa3UF0Tq0issM9nXyHYwUu3c0hnipb+n0
         0tKHwN/kN1mwW9Z2fQ1HW9J32nMFyotwrsHfWHYB8uaFty50F2CMe58hsVfXWMTGjupj
         B+dug6yAro655wbGIUk0I9MDAIlE3G3b6St8RtcjG3CgDU+S/5srwS0Sv/fvLDbxuwDc
         q3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fNPbpOxHirk0Y+1N9r1ssPgt+FSdATl608uUX95PuE8=;
        b=RcoouDcFX7vX6BOXSGbTWYOkxZSFnQKepxfpBVGXtLs+VIhBgkgtdqlzjyU8gfY1iD
         chXGR3fVEpBM7mP9JcWUFsYKwBuNghnP+XVNiEMP/CtXtcr4AXc6WheqpqGf6rpxza8p
         IIXpOj8kt6BI0mutz8+ignu+PH0naWPAzmvTMxwq3OJ3eaUe/cJr8f0tHa8GR3pecU2S
         Y+IBnHCY8ww4nr+EVjgcuIVDh3WyjcSVGb23XKPAsp8l0jeYQCj93WPsaboQUPvG/Ntf
         wYzTFnOiGtgeVCUwOn1S+yzIRTtg76+hr28IFiOuWI3DIaJUcTSYjFlw9I9/6vpFq+hp
         m07Q==
X-Gm-Message-State: APjAAAUv6/Sf2kp/+ZGRzNYuMxL6AQOdQbMVoZkauoJLeDDYhUN/HX84
        IN3uIno1r7nA3sTSvHq3pNU5Nlt+SabL
X-Google-Smtp-Source: APXvYqwxwA1eJ4CXGRouWm5t5OvHcWn51byt3jdcTfIQidLvDoJVrbOwKwr+BiSuM6Jus+pY5v7D3UHpaNW8
X-Received: by 2002:a63:5045:: with SMTP id q5mr3838390pgl.380.1561649107560;
 Thu, 27 Jun 2019 08:25:07 -0700 (PDT)
Date:   Thu, 27 Jun 2019 08:25:02 -0700
Message-Id: <20190627152502.174918-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] trace-cmd: always initialize write_record() len
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

write_record() uses an uninitializedd 'len' when record->size is 0.  I'm
not sure how likely this case is.

To be safe and silence compiler warning, unconditionally initialize len.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 tracecmd/trace-split.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index d27b3c65badc..6c8a774e13d0 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -80,7 +80,7 @@ static int write_record(struct tracecmd_input *handle,
 	unsigned long long diff;
 	struct tep_handle *pevent;
 	void *page;
-	int len;
+	int len = 0;
 	char *ptr;
 	int index = 0;
 	int time;
@@ -106,12 +106,8 @@ static int write_record(struct tracecmd_input *handle,
 		return 0;
 	}
 
-	if (record->size) {
-		if (record->size < 28 * 4)
-			len = record->size / 4;
-		else
-			len = 0;
-	}
+	if (record->size && (record->size < 28 * 4))
+		len = record->size / 4;
 
 	time = (unsigned)diff;
 	time = create_type_len(pevent, time, len);
-- 
2.22.0.410.gd8fdbe21b5-goog

