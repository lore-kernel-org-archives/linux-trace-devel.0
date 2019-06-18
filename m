Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA31C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3793520B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mA0ezHJl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfFROkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55555 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbfFROkW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so3582318wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PH2N4AFbJRZ/0SmO4j9bcgaibrXsk3kHJYVCHlKxxt8=;
        b=mA0ezHJl+Tj1QC/iciZvUREMWgZ8Nu+hoLXf5UG3eNclZ2ZXbwgLFhCCs2k6go0am2
         EyiDREtIvRoIOb0CJ3JYS5IDmNnuFsMyN/7BE75q2YnQ8k89OmIRgOUiJDgxZ8afm2p6
         5d4iH5/CVjUjvcGWsmmJfgkDI8Qib6Ul1zIhw+s67W6v2PRttypSe8J8NTPTHCGWzzzp
         bviJOXV18/zCV30yuBrgfu2g4W2TLOZN8bGEVj+TL7vNphymJUrD4C2XzDdEMSnQPhbH
         UHfn1Diy2U769EspZWdBYEGXPcygdeFb4KHchYu90q90VTbgIUvo9PE/PCqqTD16NIpc
         w+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PH2N4AFbJRZ/0SmO4j9bcgaibrXsk3kHJYVCHlKxxt8=;
        b=e5fkL+qFiucdcQEfNq/jQ+DBnWTpdUZ345GoGSWIJzlGA89LuRMwJejlHR896ob8xv
         NQxtf3NTgaaeuVcpOkIJr4t6B6iBzqOlwKRV4410Dvnr3x1gHU1f1moUkqZwPVQ9Sgum
         3+0L++K2Y5KH5WK3NSzmQq8WFTw5xqXerrppv5u0Vop+TBwx6wvSLYESD349YFVVgxmG
         ssHLP4iKlP301+f4wUs7rHZXG+Eqs2lnkIQzRgnNE4B6A5hkborRMVoUS1Ey7SbGQEN2
         AZR/kPzwpVeI8txSzKf7Pe3WITYOB5p0KwWRvN6N2g2atUy730W755l/EAzqQCqy1uuT
         tgCw==
X-Gm-Message-State: APjAAAWbKDZAb3iwo0x9q/SHLVUy1edWqPA9MlXbxpEiPiMttx/pmZCo
        XtX08kITd0o4L1+yv/LK6y75WvI=
X-Google-Smtp-Source: APXvYqxjIj8rAxYIhR9wvV+7WpdRQlf5mEZpbc5kXG05eq+XQW9ZmxnL3I/FW3PZdKhp6TIYvyY2iA==
X-Received: by 2002:a1c:7503:: with SMTP id o3mr3937021wmc.170.1560868820883;
        Tue, 18 Jun 2019 07:40:20 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:20 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 13/13] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Tue, 18 Jun 2019 17:39:58 +0300
Message-Id: <20190618143958.2865-14-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
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
Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
---
 tracecmd/trace-record.c | 70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 89e2c52..b242f34 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2892,6 +2892,75 @@ next:
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
@@ -2913,6 +2982,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.20.1

