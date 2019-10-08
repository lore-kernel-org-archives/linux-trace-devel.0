Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF469C4360C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E2BD20679
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfJHIP7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53382 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730593AbfJHIP7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id i16so2090312wmd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hizewGYgfMJy2Cq6NpUgmJ+Er/mC9TfDMEIm2vqAG84=;
        b=dNRlM9wMipagRDSuwkLehsG4ieN43rshcblYAU6odt5o78rBmAVk+zB+A9v3cKiRyv
         CTzmX9EW5J6wxqgOW5bdgV2+ivJz9LUPH8L/StaPlyZG4MEPsWUl/FKrUtsJ13yd8/rW
         pkqMBrKJeCpO8rSDHsV2PP9KzYQQXAhDv8xDlbO1tXqRowUPraBQU70WzXmyFvBRZ1Vs
         JVarIolD0+ZmUtCRzMRZRedkEbVEQv/0wV9kaA2MTLYDUHomaJ1wBSO117JY5lGm3at6
         JbbMnK220adnBnNeOVt+251DamEMBKVhpTflEw5tmEj2QUApJTyT0j1sl6vKi7iFR+Ug
         UOxQ==
X-Gm-Message-State: APjAAAXMnKTZx6Sx9zOYKCr0L/LhDpuWEJkyEOxcIMNSKepaf7+ZWo3Z
        wOWZP7H2DFzmqPdeQqax0g==
X-Google-Smtp-Source: APXvYqy9FSvNKH32BhOoGugQas3ePjhI8tuEULdo9nXBflZt7wh1VFIP6z1oovuVWCs3QaF6RoqAZg==
X-Received: by 2002:a1c:5f82:: with SMTP id t124mr2876235wmb.114.1570522557283;
        Tue, 08 Oct 2019 01:15:57 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:56 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 13/13] trace-cmd: Add support for tracing VMware Workstation VMs by name
Date:   Tue,  8 Oct 2019 11:15:37 +0300
Message-Id: <20191008081537.11536-14-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Read display name and CID of running VMware Workstation guests on startup so
that users can refer to them by name when recording.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index cd16243..8533b13 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3092,6 +3092,77 @@ next:
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
@@ -3113,6 +3184,7 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
 		*cid = atoi(guest);
 
 	read_qemu_guests();
+	read_vmw_guests();
 	for (i = 0; i < guests_len; i++) {
 		if ((*cid > 0 && *cid == guests[i].cid) ||
 		    strcmp(guest, guests[i].name) == 0) {
-- 
2.20.1

