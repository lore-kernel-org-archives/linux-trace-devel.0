Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B601C48BD3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C8A20656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRzfuqO1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfFZKwc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36737 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfFZKwc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so1607230wmm.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3uHta3khUGgot/b829i1ccC9WVHS9A4zW0Z/wolaEKs=;
        b=XRzfuqO1kao8I34Fhuu5FNlUzlVJpdrwM2vF3Vw2AivMhaLdoTF5U3ZnW8qqvHrHnj
         IhRrOO13PKxBdKmYjlj3R3AONjugADpLyTVS2cq+NZ8y3AmNsZCPPc8SH+T7rMTdWqmC
         zJMH0IokrbLhVrbfzuhiO1ozz8n1Le/7pd3P41mNcBdxRsc5OpTUerJuvRN4zgwI/Wl/
         4X/IMymewZmDwbhj6whh5BeDFJQw/RIvgtw0Z3RORsr5zyYA4/hcD9+nsS6ZtpB5q20K
         kwtNypa1QCv0uBxXm2H4hA6DiWkLe44ZWF9Xaa6r31gnq9HB2ww5rUtSeJcCcWssktuE
         Z1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uHta3khUGgot/b829i1ccC9WVHS9A4zW0Z/wolaEKs=;
        b=C7G8inRv+f97fST5cHBA+D3LRS3xRT2d6R8aZF8KOxtL2n8TBldtrMPlYa+4YI3Ypl
         7ydcGc74lTg87pq5q/JohMj6+vE3iLgvzAjtS9dW0tJiWbUa9GZdMK9jRKfZc/2LGNJs
         QCv5fn0gVt9IrCUv9ZudrDVMjxjL/MJyjOwBHjbe32hlgnb1wXKY+cSGi1BShn3Um2j9
         OGVjv4kYbijRMs3rVQ3XJOAhYPZj5EOQ1a1en2ZzQIXKqxXqs2WcdMvAPi1AM9YwivLd
         ScY7qSAw4nehrlx11xwRzVhxzyf2eJ7/QgjejFpuYeYYBuFabZgwC79Kor92rsJGNHzd
         frEQ==
X-Gm-Message-State: APjAAAVV0rxV4PYg3k3PmM4IuTQwKBElsyeoqPYYUV2YYeFsW/qQRQRn
        fJu2NUgLP8Hl2+fK3ohaqA==
X-Google-Smtp-Source: APXvYqyohSlGDj2GjqEMfk3CdZ72KUd+gkva5q6whKi7CMIZMF7OxIjMJ1/rZEYrxSzvlCHyo5xdpA==
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr2359667wmm.96.1561546349690;
        Wed, 26 Jun 2019 03:52:29 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:29 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 13/13] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Wed, 26 Jun 2019 13:52:09 +0300
Message-Id: <20190626105209.13200-14-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Read display name and CID of running VMware Workstation guests on startup so
that users can refer to them by name when recording.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6d5a59e..e844029 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2894,6 +2894,77 @@ next:
 	closedir(dir);
 }
 
+static int load_vmw_guest(const char *vm, char **name, int *cid)
+{
+	size_t line_len = 0;
+	char *line = NULL;
+	char *p;
+	FILE *f;
+
+	f = fopen(vm, "r");
+	if (!f)
+		return -errno;
+
+	*cid = -1;
+	*name = NULL;
+	while (getline(&line, &line_len, f) != -1) {
+		if (strncmp(line, "displayName = ", 14) == 0) {
+			p = strrchr(line, '"');
+			if (p)
+				*p = '\0';
+			*name = strdup(line + 15);
+			if (!*name)
+				die("allocating guest name");
+		} else if (strncmp(line, "vmci0.id = ", 11) == 0) {
+			p = strrchr(line, '"');
+			if (p)
+				*p = '\0';
+			*cid = atoi(line + 12);
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return 0;
+}
+
+static void read_vmw_guests(void)
+{
+	static bool initialized;
+	size_t line_len = 0;
+	char *line = NULL;
+	ssize_t ret;
+	FILE *f;
+
+	if (initialized)
+		return;
+
+	initialized = true;
+
+	f = popen("vmrun list", "r");
+	if (!f)
+		return;
+
+	/* Ignore the first line */
+	ret = getline(&line, &line_len, f);
+	while ((ret = getline(&line, &line_len, f)) != -1) {
+		struct guest guest = {};
+
+		if (ret > 0 && line[ret-1] == '\n')
+			line[ret-1] = '\0';
+		if (load_vmw_guest(line, &guest.name, &guest.cid))
+			continue;
+
+		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
+		if (!guests)
+			die("Can not allocate guest buffer");
+		guests[guests_len++] = guest;
+	}
+
+	free(line);
+	pclose(f);
+}
+
 static char *parse_guest_name(char *guest, int *cid, int *port)
 {
 	size_t i;
@@ -2915,6 +2986,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.20.1

