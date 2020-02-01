Return-Path: <SRS0=6MOi=3V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_DBL_ABUSE_MALW,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB10C33CB3
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 Feb 2020 16:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C5B8206E3
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 Feb 2020 16:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLFBTF/b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgBAQTo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 11:19:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52656 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQTo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 11:19:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so11301774wmc.2;
        Sat, 01 Feb 2020 08:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i97V5nZM9oFzwMaxhJEd80SVB7v4vVuL/a+W4QAU/Yw=;
        b=cLFBTF/by2QxFcaPwtxWeHYpUy8SCb9bUiZBV+igQMRIoKaqc4hSiacqejrAX6akLS
         Kri1+XE6epF1klNBmLoh/opivEOyoMiOR/6rW3UGEPQHRlM8pP8VSIAKshiWikiZjnVe
         iTdFf/L9axwbR606lLgNOrV+iUn+yZ2vwD+W4KKL2byyFTi0oiD0ptzsDUrWbmCZhoS5
         PohpyxQCK4ok6HzihthEiOBV3oAFMxVXHroBu7mD6koXGy0hQ+LXkHyf8Rz2aHeq0bjN
         JcbCxIVt4ez2p6mff/2VAA5lVUxnEsvkvq+2ZxKbNbvJrE41/z4uhJK60h51A3FoAvwT
         fPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i97V5nZM9oFzwMaxhJEd80SVB7v4vVuL/a+W4QAU/Yw=;
        b=ge5vjRgMjtxxWfzJ6fehWH8t3v52S+zyisWlAV8sdS3YVYVQyeNWLZ9EVuM8Z4D74s
         WY+YaYJZ8OeGYHXwej9w3H1vTFf/kQdEBEidBDAtpwpkF5SgPC5PrXQ910qnQLfPMFlC
         umLJL8Y8NRji9sP7uJaBvqfJDHNKRugr+yFhQr4CbGahM8IgyAZdlf0p+fl4Eh7OSFgZ
         fCOcLcLero9qdxA+dlCXh8EG7BmokuQwrncdP6iaZTrYDCrn9AA6UyI2bjyChneDgtT6
         W/uYddmglNBwiHxkl6BO7jg85enwIQ1xRNy0EfbwfLHBhcPg5Hk9SqvTrp26WcPHgmr4
         ScAQ==
X-Gm-Message-State: APjAAAV/HC4LevTQHVcVqrkwdp0BwsD90yOJuh7DBPCwiTm5XC44arWf
        szYSN7GE1c9iyzmPCYbQU4VVYxasHvA=
X-Google-Smtp-Source: APXvYqz2IAwlVsdI7YA9oOZw7h/Hk7zFrPLmwTvAB2vSHZJBC2gWa0kd/FiqWkjwT8zpAKjj+S5I2A==
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr18481728wme.130.1580573982505;
        Sat, 01 Feb 2020 08:19:42 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d5f:200:619d:5ce8:4d82:51eb])
        by smtp.gmail.com with ESMTPSA id n16sm17404611wro.88.2020.02.01.08.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:19:41 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH RFC] MAINTAINERS: add TRACE EVENT LIBRARY section
Date:   Sat,  1 Feb 2020 17:19:31 +0100
Message-Id: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The git history shows that the files under ./tools/lib/traceevent/ are
being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
and are discussed on the linux-trace-devel list.

Add a suitable section in MAINTAINERS for patches to reach them.

This was identified with a small script that finds all files only
belonging to "THE REST" according to the current MAINTAINERS file, and I
acted upon its output.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Ceco, Steven, I added the information based on what I could see from an
outsider view. Please change and more files to the entry if needed.

applies cleanly on current master and next-20200131

Ceco, congrats becoming a kernel maintainer :)

 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1f77fb8cdde3..17eb358c3fda 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16903,6 +16903,13 @@ T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
 S:	Maintained
 F:	drivers/char/tpm/
 
+TRACE EVENT LIBRARY
+M:	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+M:	Steven Rostedt <rostedt@goodmis.org>
+L:	linux-trace-devel@vger.kernel.org
+S:	Maintained
+F:	tools/lib/traceevent/
+
 TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Ingo Molnar <mingo@redhat.com>
-- 
2.17.1

