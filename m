Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF31C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 05:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879C76321A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 05:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhKPFws (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbhKPFwf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 00:52:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19483C0431BE
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 20:46:55 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u1so34949930wru.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 20:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iHD5wB4ewszXsgFSD8UeU1gyAjy4tYh7qRQM0ThN4DQ=;
        b=oGyJwHqqfVnGddM5B35YJzUKsJzfmyQ0DaN4QJg2KP/pgCuYSxIsf/Z8On4y7QIW+/
         EP+PTqzefF5Elnit2uvbMgnULuJkxz13o3kC/8QGp/CrGxoCuNWFioWT90nYQSOoPeNr
         8aDuEbyxWz/LSND09rIHPoWfgJAKNprg4UBSccBNWWq2XF80w0BFqoalmhbFhDDMq0/J
         TtTOrl/69X68vrEGtq+E/R79SLIlFvN8+7yQeJ0YxMjDPevBhtUsUDaePkt7p1Hbqadv
         miWgm0/1wjkivpC24yMYLUx9r5RSbC0lZvn22cpNBZtQx+xXVOpJ4maby2evPI+Fahil
         WtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iHD5wB4ewszXsgFSD8UeU1gyAjy4tYh7qRQM0ThN4DQ=;
        b=TV+uMdodSAQ2EifMXNsQfXBBQfoVjwnmKe6qvZrycHPGRjScio++Tukfpo0XWG6jlG
         UOWghmjFThbVfYav/HYLCaYcb5cypKggufcea0J48Lvj2m0/AOGDlCvtFn1+9W+sINmE
         ht3sQbgD7wWmbBHgdyH9bDAndeJ8QP8YW3jQnl2HQEmslKUB18MfMsC+klUvTBN07fjr
         gtKMsNh42ImtE0KFGyGR5muvdkcCSV4z7eCp0TfrMMSJT0tTej8UiHSqKLJp4dlTNEyW
         IndhYIh7mxBeSzLoxOXOq0Ll8IWmceBLUnxVWehzSxiHYnrorFLe4LWrYwXlFKqtn7sL
         VNrA==
X-Gm-Message-State: AOAM532QhZtc5dxFjL962kRvaNjeKtSUCUHnqj5HFqXhRHfIrnuHxsCq
        dA/LYs4LZaIklBdF7Apup277ZSChUAakBA==
X-Google-Smtp-Source: ABdhPJyEs5nekOxh1EaRku/uKRQDgRIPbbNfaXbNgMUDNOqJ86l1lx8erQEHBBrDXqXQstJ1M9GdXA==
X-Received: by 2002:a5d:4fcc:: with SMTP id h12mr5764445wrw.434.1637038013741;
        Mon, 15 Nov 2021 20:46:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m21sm16355509wrb.2.2021.11.15.20.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 20:46:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, amikhak@wirelessfabric.com
Subject: [PATCH] trace-cmd: Fix sizeof print warnings
Date:   Tue, 16 Nov 2021 06:46:51 +0200
Message-Id: <20211116044651.142224-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The return type of sizeof() operator and strlen() function is size_t,
which is machine specific. When printing these values with printf, a
dedicated 'z' specifier should be used, to avoid compile warnings.

Reported-by: Alan Mikhak <amikhak@wirelessfabric.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index b19ce89a..2408a4ab 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -152,13 +152,13 @@ static void dump_initial_format(int fd)
 
 	/* check initial bytes */
 	if (read_file_bytes(fd, buf, sizeof(magic)))
-		die("cannot read %ld bytes magic", sizeof(magic));
+		die("cannot read %zu bytes magic", sizeof(magic));
 	if (memcmp(buf, magic, sizeof(magic)) != 0)
 		die("wrong file magic");
 
 	/* check initial tracing string */
 	if (read_file_bytes(fd, buf, strlen(TRACING_STR)))
-		die("cannot read %ld bytes tracing string", strlen(TRACING_STR));
+		die("cannot read %zu bytes tracing string", strlen(TRACING_STR));
 	buf[strlen(TRACING_STR)] = 0;
 	if (strncmp(buf, TRACING_STR, strlen(TRACING_STR)) != 0)
 		die("wrong tracing string: %s", buf);
@@ -201,7 +201,7 @@ static void dump_header_page(int fd)
 
 	/* check header string */
 	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_STR) + 1))
-		die("cannot read %ld bytes header string", strlen(HEAD_PAGE_STR));
+		die("cannot read %zu bytes header string", strlen(HEAD_PAGE_STR));
 	if (strncmp(buf, HEAD_PAGE_STR, strlen(HEAD_PAGE_STR)) != 0)
 		die("wrong header string: %s", buf);
 
@@ -222,7 +222,7 @@ static void dump_header_event(int fd)
 
 	/* check header string */
 	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_EVENT) + 1))
-		die("cannot read %ld bytes header string", strlen(HEAD_PAGE_EVENT));
+		die("cannot read %zu bytes header string", strlen(HEAD_PAGE_EVENT));
 	if (strncmp(buf, HEAD_PAGE_EVENT, strlen(HEAD_PAGE_EVENT)) != 0)
 		die("wrong header string: %s", buf);
 
-- 
2.33.1

